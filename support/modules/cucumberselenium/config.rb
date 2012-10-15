require 'yaml'

module CucumberSelenium::Config
  def self.load_config
    config_dir = ENV['TEST_CONFIG_DIR']
    config_dir = "."
    @@test_config = YAML.load(File.read("#{config_dir}/test-config.yaml"))
  end
  def test_config
    @@test_config
  end
end

