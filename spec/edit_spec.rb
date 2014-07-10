# encoding: UTF-8

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


require 'appium_lib'

require 'rspec'

APP_PATH = '../build/iPhoneSimulator-7.1-Development/AppiumDemo.app'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end

def desired_caps
  {
    'platformName' => 'iOS',
    'deviceName' => 'iPhone Retina (4-inch)', # 'iPhone Simulator 4-inch',
    'platformVersion' => '7.1',
    'app' => absolute_app_path
  }
end

def absolute_app_path
    f = File.join(File.dirname(__FILE__), APP_PATH)
    puts f
    f
end

def server_url
  "http://127.0.0.1:4723/wd/hub"
end

describe "AppiumDemo" do
  before(:all) do
    Appium::Driver.new(appium_lib: { server_url: server_url }, caps: desired_caps).start_driver
    Appium.promote_appium_methods RSpec::Core::ExampleGroup
  end

  after(:each) do
    back
  end

  after(:all) do
    driver_quit
  end


  describe "Handling UITextFields" do
    it "should be able to fill in text fields" do
      find_element(:name, "Editing").click

      find_element(:name, "TextField 1").click()
      execute_script 'UIATarget.localTarget().frontMostApp().keyboard().typeString("This is a message");'

      # el = find_element(:name, "TextField 1")
      # el.send_keys("some such")
    end
  end
end
