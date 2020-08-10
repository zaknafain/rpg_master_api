# frozen_string_literal: true

class HierarchyElementSerializer < ActiveModel::Serializer
  attributes :id, :name, :visibility, :description, :hierarchable_type, :hierarchable_id
end
