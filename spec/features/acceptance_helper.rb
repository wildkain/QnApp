require 'rails_helper'
require 'capybara/email/rspec'

RSpec.configure do |config|

  Capybara.javascript_driver = :webkit
  Capybara.server = :puma

  config.use_transactional_fixtures = false

  config.include AcceptanceMacros, type: :feature

  config.include(OmniauthMacros)

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each, :sphinx => true) do
    # For tests tagged with Sphinx, use deletion (or truncation)
    DatabaseCleaner.strategy = :deletion
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  OmniAuth.config.test_mode = true
  OmniAuth.config.logger    = Rails.logger

end
