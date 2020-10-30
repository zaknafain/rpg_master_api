# frozen_string_literal: true

# Serializer for Tree elements
class HierarchyElementSerializer < ActiveModel::Serializer
  attributes :id, :name, :visibility, :description, :hierarchable_type, :hierarchable_id
end
