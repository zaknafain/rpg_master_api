# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSerializer do
  let(:serialized_user) do
    described_class.new(user, scope: user, scope_name: :current_user)
  end
  let(:user) { FactoryBot.create(:user) }

  it 'does not throw an error' do
    expect { serialized_user.serializable_hash }.not_to raise_error
  end
end
