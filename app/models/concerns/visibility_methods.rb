# frozen_string_literal: true

module VisibilityMethods
  extend ActiveSupport::Concern

  included do
    enum visibility: {
      author_only: 0,
      for_all_players: 1,
      for_everyone: 3,
      for_some: 4
    }

    validates :visibility, inclusion: { in: ContentText.visibilities.keys }

    has_many :"#{model_name.route_key}_users"
    has_many :players_visible_for, through: :"#{model_name.route_key}_users",
                                   source: :user,
                                   dependent: :destroy
  end

  def visible_to(user = nil)
    parent.visible_to(user) &&
      (
        for_everyone? ||
        author?(user) ||
        visible_to_player?(user) ||
        visible_for_some?(user) ||
        user&.admin? == true
      )
  end

  def visible_to_player?(player)
    for_all_players? && players.include?(player)
  end

  def visible_for_some?(player)
    for_some? &&
      players.include?(player) &&
      players_visible_for.include?(player)
  end

  def author?(_user)
    raise NotImplementedError
  end

  def parent
    raise NotImplementedError
  end

  def players
    raise NotImplementedError
  end
end
