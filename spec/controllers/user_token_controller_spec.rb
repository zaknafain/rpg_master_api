# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserTokenController do
  let(:user) do
    FactoryBot.create(
      :user,
      email: 'foo@bar.com',
      password: 'secret pee',
      password_confirmation: 'secret pee'
    )
  end

  describe 'POST user_token' do
    it 'responds successfully' do
      post :create, params: {
        auth: { email: user.email, password: 'secret pee' }
      }

      expect(response.status).to eq(201)
    end

    it 'responds with 404 on failures' do
      post :create, params: {
        auth: { email: 'wrong@mail.com', password: 'testtest' }
      }

      expect(response.status).to eq(404)
    end

    it 'responds with a jwt' do
      post :create, params: {
        auth: { email: user.email, password: 'secret pee' }
      }

      expect(response.body).to include('jwt')
    end

    it 'responds with a sub that equals the id' do
      post :create, params: {
        auth: { email: user.email, password: 'secret pee' }
      }

      body = JSON.parse(response.body)
      jwt = body['jwt']
      decoded_jwt = JWT.decode(
        jwt,
        Rails.application.secrets.secret_key_base,
        true,
        algorithm: 'HS256'
      )

      expect(decoded_jwt[0]).to include('sub' => user.id)
    end

    it 'responds with a user name and id' do
      post :create, params: {
        auth: { email: user.email, password: 'secret pee' }
      }

      body = JSON.parse(response.body)
      jwt = body['jwt']
      decoded_jwt = JWT.decode(
        jwt,
        Rails.application.secrets.secret_key_base,
        true,
        algorithm: 'HS256'
      )

      expect(decoded_jwt[0]).to include('name' => user.name)
    end
  end
end
