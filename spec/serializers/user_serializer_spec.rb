require 'rails_helper'

RSpec.describe UserSerializer do

  let(:user)            { FactoryBot.create(:user) }
  let(:serialized_hash) { UserSerializer.new(user).serializable_hash }

  it "serializes the user" do
    expect(serialized_hash[:id]).to eq(user.id)
  end
end
