# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContentTextSerializer do
  let(:serialized_element) do
    described_class.new(content_text)
  end
  let(:content_text) { FactoryBot.create(:content_text) }

  it 'does not throw an error' do
    expect { serialized_element.serializable_hash }.not_to raise_error
  end
end
