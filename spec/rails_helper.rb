# frozen_string_literal: true

require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../config/environment', __dir__)

if Rails.env.production?
  abort('The Rails environment is running in production mode!')
end

require 'rspec/rails'
require 'database_cleaner'

# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

RSpec::Matchers.define :be_of_correct_schema do |schema, owned_id, as_admin|
  match do |actual|
    parsed_response = JSON.parse(actual)
    parsed_response = [parsed_response] unless parsed_response.is_a?(Array)

    validations = parsed_response.map do |single|
      schema = load_schema_file(single, schema, owned_id, as_admin)

      collect_schema_validations(single, schema)
    end

    validations.flatten.all? { |v| v == true }
  end

  failure_message { |a| "expected that #{a} would be of schema #{schema}" }

  def load_schema_file(parsed_item, schema, owned_id, as_admin)
    if as_admin
      schema = "#{schema}_admin"
    elsif owned_id == parsed_item['id']
      schema = "#{schema}_owner"
    end

    File.read("spec/fixtures/schemas/#{schema}.json")
  end

  def collect_schema_validations(parsed_response, schema)
    expected_schema = JSON.parse(schema)['properties']
    keys = (expected_schema.keys + parsed_response.keys).uniq

    keys.map do |key|
      types = expected_schema.dig(key, 'types') ||
              [expected_schema.dig(key, 'type')]

      types.any? { |t| t == parsed_response[key].class.to_s }
    end
  end
end

def auth_header(user)
  token = Knock::AuthToken.new(payload: { sub: user.id, name: user.name }).token

  { 'Authorization' => "Bearer #{token}" }
end
