module Selenium
  module WebDriver
    module Chrome
      class Driver < Chromium::Driver
        include LocalDriver

        def initialize(options: nil, service: nil, url: nil, **opts)
          caps, url = initialize_local_driver(options, service, url)

          begin
            super(caps: caps, url: url, **opts)
          rescue Selenium::WebDriver::Error::WebDriverError => e
            @service_manager&.stop
            raise
          end
        end
      end
    end
  end
end