RSpec.configure do |config|

  # Let shoulda-matchers know we are using rails & rspec
  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end

end