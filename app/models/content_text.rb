# frozen_string_literal: true

class ContentText < ApplicationRecord
  include VisibilityMethods

  belongs_to :hierarchy_element

  validates :content, presence: true
  validates :ordering, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :hierarchy_element, presence: true

  scope :ordered, -> { order(Arel.sql('ordering IS NULL, ordering ASC')) }

  def campaign
    parent.top_hierarchable
  end

  def author?(user)
    parent.author?(user)
  end

  def parent
    hierarchy_element
  end

  def players
    campaign.players
  end
end
