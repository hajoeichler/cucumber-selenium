require 'selenium-webdriver'
require 'erb'

module WebDriverHelper

  # ensure that browser will be closed at the end.
  at_exit { @@browser.quit unless @@browser.nil? }

  def start_browser(proxy_host, proxy_port="3128")
    if proxy_host.nil?
      @@browser = Selenium::WebDriver.for :firefox
    else
      profile = Selenium::WebDriver::Firefox::Profile.new
      proxy = Selenium::WebDriver::Proxy.new(:http => "#{proxy_host}:#{proxy_port}")
      profile.proxy = proxy
      @@browser = Selenium::WebDriver.for :firefox, :profile => profile
    end

    # In general we set the maximum timeout to 10 seconds.
    @@browser.manage.timeouts.implicit_wait = 10

    # maximize window
    @@browser.manage.window.maximize
  end

  # TODO: move javascript into own file
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
