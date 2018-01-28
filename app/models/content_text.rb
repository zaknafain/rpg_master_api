class ContentText < ApplicationRecord
  include VisibilityMethods

  belongs_to :hierarchy_element

  validates :content, presence: true
  validates :hierarchy_element, presence: true

  scope :ordered, ->{ order('ordering IS NULL, ordering ASC') }

  def campaign
    parent.top_hierarchable
  end

  def is_author?(user)
    parent.is_author?(user)
  end

  def parent
    hierarchy_element
  end

  def players
    campaign.players
  end
end
