# frozen_string_literal: true

class CampaignsUser < ApplicationRecord
  belongs_to :campaign
  belongs_to :user
end
