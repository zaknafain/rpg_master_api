# frozen_string_literal: true

class CampaignSerializer < ActiveModel::Serializer
  attributes :id, :name, :is_public, :description, :short_description
end
