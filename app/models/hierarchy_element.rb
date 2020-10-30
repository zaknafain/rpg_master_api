# frozen_string_literal: true

# Represents a tree structure containig the real content.
class HierarchyElement < ApplicationRecord
  include VisibilityMethods

  belongs_to :hierarchable, polymorphic: true
  has_many :hierarchy_elements, as: :hierarchable, dependent: :destroy

  has_many :content_texts, dependent: :destroy

  validates :name, presence: true

  scope :of_campaigns, -> { where hierarchable_type: 'Campaign' }
  scope :alphabetically_ordered, -> { order(name: :asc) }
  scope :all_included, -> { includes(:players_visible_for, :hierarchable) }

  delegate :players, to: :top_hierarchable

  def top_hierarchable
    elem = self

    elem = elem.hierarchable while elem.hierarchable_type == 'HierarchyElement'

    elem.hierarchable
  end

  def author?(user)
    top_hierarchable.user == user
  end

  def parent
    hierarchable
  end
end
