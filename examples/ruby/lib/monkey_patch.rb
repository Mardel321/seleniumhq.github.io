# frozen_string_literal: true

module Selenium
  module WebDriver
    module Chrome
      class Driver < Chromium::Driver
        include LocalDriver

        def initialize(options: nil, service: nil, url: nil, **opts)
          caps, url = initialize_local_driver(options, service, url)

          begin
            super(caps: caps, url: url, **opts)
          rescue Selenium::WebDriver::Error::WebDriverError
            @service_manager&.stop
            raise
          end
        end
      end
    end
  end
end

module Selenium
  module WebDriver
    module Support
      class Guards
        def add_condition(name, condition = nil, &)
          condition = false if condition.nil?
          @guard_conditions << GuardCondition.new(name, condition, &)
          WebDriver.logger.info "Running with Guard '#{name}' set to: #{condition}"
        end
      end
    end
  end
end
