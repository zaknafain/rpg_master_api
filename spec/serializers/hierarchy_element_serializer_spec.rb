# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HierarchyElementSerializer do
  let(:serialized_element) do
    described_class.new(element)
  end
  let(:element) { FactoryBot.create(:hierarchy_element) }

  it 'does not throw an error' do
    expect { serialized_element.serializable_hash }.not_to raise_error
  end
end
