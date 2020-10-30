# frozen_string_literal: true

# Serializer for Campaigns
class CampaignSerializer < ActiveModel::Serializer
  attributes :id, :name, :is_public, :description, :short_description

  with_options if: :signed_in? do
    attribute :user_id
  end

  def signed_in?
    !current_user.nil?
  end
end
