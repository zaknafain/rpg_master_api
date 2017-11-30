class HierarchyElement < ApplicationRecord
  include VisibilityMethods

  belongs_to :hierarchable, polymorphic: true
  has_many :hierarchy_elements, as: :hierarchable, dependent: :destroy

  has_many :content_texts, dependent: :destroy

  validates :name, presence: true

  scope :of_campaigns, ->{ where hierarchable_type: "Campaign" }
  scope :alphabetically_ordered, ->{ order(name: :asc) }
  scope :all_included, ->{ includes(:players_visible_for, :hierarchable) }

  def top_hierarchable
    elem = self

    while elem.hierarchable_type == "HierarchyElement"
       elem = elem.hierarchable
    end

    elem.hierarchable
  end

  def is_author?(user)
    top_hierarchable.user == user
  end

  def players
    top_hierarchable.players
  end

  def parent
    self.hierarchable
  end
end
