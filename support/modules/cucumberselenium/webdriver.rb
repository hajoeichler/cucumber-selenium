require 'selenium-webdriver'
require 'base64'

module CucumberSelenium::WebDriverHelper
  def start_browser(user_agent_string="automated webtest", assume_untrusted_certificate_issuer=true)
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile["general.useragent.override"] = user_agent_string

    if assume_untrusted_certificate_issuer
      profile.assume_untrusted_certificate_issuer = false # tells firefox to trust production ssl certificates on staging system
    end

    if test_config['basic_auth']
      load_and_config_headertool profile
    end

    if test_config['proxy']
      proxy = Selenium::WebDriver::Proxy.new({
        :http => "#{test_config['proxy']['host']}:#{test_config['proxy']['port']}",
        :ssl => "#{test_config['proxy']['host']}:#{test_config['proxy']['port']}",
      })
      profile.proxy = proxy
    end
    @@browser = Selenium::WebDriver.for :firefox, :profile => profile

    config_browser
  end

  def load_and_config_headertool(profile)
      profile["extensions.headertool.preferencies.onoff"] = true
      enc = Base64.encode64 "#{test_config['basic_auth']['username']}:#{test_config['basic_auth']['password']}"
      profile["extensions.headertool.preferencies.editor"] = "Authorization : Basic #{enc}"
      profile.add_extension "#{test_config['firefox']['addon_dir']}/ht_0.5.1.xpi"
  end

  def start_sauce_labs_browser(caps)
    @@browser = Selenium::WebDriver.for(
      :remote,
      :url => "http://#{test_config['saucelabs']['username']}:#{test_config['saucelabs']['access_key']}@ondemand.saucelabs.com:80/wd/hub",
      :desired_capabilities => caps)

    config_browser
  end

  def set_saucelabs_test_status(job_id, scenario_status)
    http = Net::HTTP.new "saucelabs.com"
    req = Net::HTTP::Put.new "/rest/v1/#{test_config['saucelabs']['username']}/jobs/#{job_id}"
    req.basic_auth test_config['saucelabs']['username'], test_config['saucelabs']['access_key']
    req.body = "{\"passed\": \"#{scenario_status}\"}"
    response = http.request req
    response.value
  end

  def config_browser
    # In general we set the maximum timeout to 10 seconds.
    @@browser.manage.timeouts.implicit_wait = 10

    # maximize window
    begin
      @@browser.manage.window.maximize
    rescue Selenium::WebDriver::Error::WebDriverError
      # eg IE9 does not like maximize and in headless mode it doesn't work - so we go with a fixed sizes
      @@browser.manage.window.resize_to 1280, 1024
    end
  end

  def stop_browser
    if defined?(@@browser)
      begin
        @@browser.quit
      rescue Selenium::WebDriver::Error::WebDriverError
        # we ignore exceptions on shutdown
      end
    end
  end
  module_function :stop_browser
  # ensure that browser will be closed at the end anyway.
  at_exit { CucumberSelenium::WebDriverHelper.stop_browser }

  def add_jquery
    load_javascript "https://ajax.googleapis.com/ajax/libs/jquery/1.8.1/jquery.min.js"
  end

  def load_javascript(javascript_url)
    js = File.read(File.join(File.dirname(__FILE__), 'load_javascript.js'))
    @@browser.execute_script js, javascript_url
  end

  def add_javascript(script)
    js = File.read(File.join(File.dirname(__FILE__), 'add_javascript.js'))
    @@browser.execute_script js, script
  end

  def browser
    @@browser
  end
end
