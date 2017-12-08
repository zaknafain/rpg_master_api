require 'rails_helper'

RSpec.describe UserSerializer do
  
  let(:user)       { FactoryBot.create(:user, email: "foo@bar.com", password: "secret pee", password_confirmation: "secret pee") }
  let(:serializer) { UserSerializer.new(user) }

  describe "attributes" do
    it 'serializes the id attribute' do
      expect(serializer.serializable_hash[:id]).to eq(user.id)
    end
    
    it 'serializes the name attribute' do
      expect(serializer.serializable_hash[:name]).to eq(user.name)
    end
    
    it 'serializes the email attribute' do
      expect(serializer.serializable_hash[:email]).to eq(user.email)
    end
    
    it 'serializes the updated_at attribute' do
      expect(serializer.serializable_hash[:updated_at]).to eq(user.updated_at)
    end
    
    it 'serializes the created_at attribute' do
      expect(serializer.serializable_hash[:created_at]).to eq(user.created_at)
    end
    
    it 'serializes the admin attribute' do
      expect(serializer.serializable_hash[:admin]).to eq(user.admin)
    end
    
    it 'serializes the locale attribute' do
      expect(serializer.serializable_hash[:locale]).to eq(user.locale)
    end
  end
end
