module CucumberSelenium::Tools
  def verb(msg)
    puts msg if $test_options[:verbose]
  end
end

