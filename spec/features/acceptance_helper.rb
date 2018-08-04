require 'rails_helper'
require 'capybara/email/rspec'

RSpec.configure do |config|

  Capybara.javascript_driver = :webkit
  Capybara.server = :puma

  config.use_transactional_fixtures = false

  config.include AcceptanceMacros, type: :feature

  config.include(OmniauthMacros)

  config.include SphinxHelpers, type: :feature

=begin
  config.before(:suite, :sphinx => true ) do
    # Ensure sphinx directories exist for the test environment
    ThinkingSphinx::Test.init
    # Configure and start Sphinx, and automatically
    # stop Sphinx at the end of the test suite.
    ThinkingSphinx::Test.start_with_autostop
  end
=end

=begin
  config.before(:each) do
    # Index data when running an acceptance spec.
    index if example.metadata[:js]
  end
=end

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
