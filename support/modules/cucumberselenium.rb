$:.unshift File.dirname(__FILE__)

module CucumberSelenium
end

require 'cucumberselenium/config'
require 'cucumberselenium/context'
require 'cucumberselenium/tools'
require 'cucumberselenium/gmail'
require 'cucumberselenium/headless'
require 'cucumberselenium/webdriver'
