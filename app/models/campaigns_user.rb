# frozen_string_literal: true

# Represents the Relation between Campaigns and Users
class CampaignsUser < ApplicationRecord
  belongs_to :campaign
  belongs_to :user
end
