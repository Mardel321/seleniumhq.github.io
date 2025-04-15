# frozen_string_literal: true

require 'selenium-webdriver'
require 'selenium/webdriver/support/guards'
require_relative '../lib/monkey_patch'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!
  Dir.mktmpdir('tmp')
  config.example_status_persistence_file_path = 'tmp/examples.txt'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before do |example|
    bug_tracker = 'https://github.com/SeleniumHQ/seleniumhq.github.io/issues'
    guards = Selenium::WebDriver::Support::Guards.new(example,
                                                      bug_tracker: bug_tracker)
    guards.add_condition(:platform, Selenium::WebDriver::Platform.os)
    guards.add_condition(:ci, Selenium::WebDriver::Platform.ci)

    results = guards.disposition
    send(*results) if results
  end

  config.after do
    @driver&.quit
    @server&.stop
  end

  def start_session
    @service = Selenium::WebDriver::Service.chrome
    @driver = Selenium::WebDriver.for(:chrome, options: default_chrome_options)
  end

  def default_chrome_options
    options = Selenium::WebDriver::Chrome::Options.new
    options.browser_version = 'stable'
    options.timeouts = {implicit: 1500}
    options.add_argument('disable-search-engine-choice-screen')
    options.add_argument('--no-sandbox') if Selenium::WebDriver::Platform.os == :linux
    options
  end

  def start_bidi_session
    options = default_chrome_options
    options.web_socket_url = true
    @driver = Selenium::WebDriver.for :chrome, options: options
  end

  def start_firefox
    options = Selenium::WebDriver::Options.firefox(timeouts: {implicit: 1500})
    options.browser_version = 'stable'
    @driver = Selenium::WebDriver.for :firefox, options: options
  end

  def start_server
    jar = Selenium::WebDriver::SeleniumManager.binary_paths('--grid')['driver_path']
    log_level = Selenium::WebDriver.logger.level == :debug ? 'FINE' : 'INFO'

    @server = Selenium::Server.new(jar,
                                   background: true,
                                   log_level: log_level,
                                   args: %w[--selenium-manager true --enable-managed-downloads true])
    @server.start
  end

  def grid_url
    @server.webdriver_url
  end
end
