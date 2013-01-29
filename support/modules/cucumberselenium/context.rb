module CucumberSelenium::TestContext
  def self.create_test_context
    @@test_context = {}
  end
  def ctx
    @@test_context
  end
  def test_context
    @@test_context
  end
end

