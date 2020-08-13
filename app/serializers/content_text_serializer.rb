# frozen_string_literal: true

class ContentTextSerializer < ActiveModel::Serializer
  attributes :id, :content, :visibility, :ordering, :hierarchy_element_id
end
