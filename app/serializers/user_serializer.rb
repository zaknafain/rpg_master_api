# frozen_string_literal: true

# Serializer for user model
class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :admin

  with_options if: :owner_or_admin? do
    attribute :email
    attribute :locale
    attribute :created_at
  end

  attribute :updated_at, if: :admin?

  delegate :admin?, to: :current_user

  def owner_or_admin?
    admin? || object.id == current_user.id
  end
end
