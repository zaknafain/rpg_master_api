require 'rails_helper'

RSpec.describe UserSerializer do

  let(:user) { FactoryBot.create(:user) }

  subject{ UserSerializer.new(user, scope: user, scope_name: :current_user) }

  it "does not throw an error" do
    expect{ subject.serializable_hash }.to_not raise_error
  end
end
