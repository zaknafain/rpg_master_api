# frozen_string_literal: true

class ContentTextsUser < ApplicationRecord
  belongs_to :user
  belongs_to :content_text

  validates :user_id, uniqueness: { scope: :content_text_id }
  validates :user, :content_text, presence: true
end
