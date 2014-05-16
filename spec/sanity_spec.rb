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

APP_PATH = '../build/iPhoneSimulator-7.0-Development/AppiumDemo.app'

def desired_caps
  {
      'platformName' => 'iOS',
      'deviceName' => 'iPhone Retina (4-inch)', # 'iPhone Simulator 4-inch',
      'platformVersion' => '6.1',
      'app' => absolute_app_path
  }
end

def absolute_app_path
    File.join(File.dirname(__FILE__), APP_PATH)
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
    reset
  end

  after(:all) do
    driver_quit
  end

  # describe "Navigating about" do
  #   it "should be able to click an element" do
  #     find_element(:name, "Editing").click
  #   end
  # end

  describe "Handling UITextFields" do
    it "should be able to fill in text fields" do
      find_element(:name, "Editing").click

      sum_el = find_element(:name, "Sum")
      sum_el.text.should eq ""

      add_btn = find_element(:name, "Add")
      add_btn.enabled?.should be_false

      el = find_element(:name, "TextField 1")
      el.send_keys("4")

      sum_el.text.should eq ""
      add_btn.enabled?.should be_false

      el = find_element(:name, "TextField 2")
      el.send_keys("6")

      sum_el.text.should eq ""
      add_btn.enabled?.should be_true

      add_btn.click

      sum_el.text.should eq "10"
    end
  end

  # describe "Scrolling" do
  #   it "should be able to scroll a tableview" do
  #     find_element(:name, "Scrolling").click
  #     swipe(start_y: 400, end_y: -100)
  #     sleep(10)
  #   end
  # end

  # describe "simple actions" do
  #   it "should press on an element" do
  #     el = find_element(:name, "Gesture Tests")
  #     (Appium::TouchAction.new).press(:element => el).perform

  #     sleep(1)
  #     expect { find_element(:name => "Editing") }.to raise_exception
  #   end
  # end

  describe "Swipe actions" do
    it "should swipe right" do
      el = find_element(:name, "Gestures -- Schematic")
      action = Appium::TouchAction.new
      action.press(element: el).release.perform

      name = find_element(:name, "gesture_name")
      name.text.should eq ""

      el = find_element(:name, "myscrollview")
      action = Appium::TouchAction.new
      action.press(element: el).release.perform
      name.text.should eq "Tap"

      swipe(start_x: 100, start_y: 400, end_x: 200, end_y: 0)
      name.text.should eq "Right swipe"
    end

    it "should swipe left" do
      el = find_element(:name, "Gestures -- Schematic")
      action = Appium::TouchAction.new
      action.press(element: el).release.perform

      name = find_element(:name, "gesture_name")
      name.text.should eq ""

      el = find_element(:name, "myscrollview")

      swipe(start_x: 300, start_y: 400, end_x: -200, end_y: 0)
      name.text.should eq "Left swipe"
    end

    it "should swipe up" do
      el = find_element(:name, "Gestures -- Schematic")
      action = Appium::TouchAction.new
      action.press(element: el).release.perform

      name = find_element(:name, "gesture_name")
      name.text.should eq ""

      el = find_element(:name, "myscrollview")

      swipe(start_x: 200, start_y: 400, end_x: 0, end_y: -200)
      name.text.should eq "Up swipe"
    end

    it "should swipe down" do
      el = find_element(:name, "Gestures -- Schematic")
      action = Appium::TouchAction.new
      action.press(element: el).release.perform

      name = find_element(:name, "gesture_name")
      name.text.should eq ""

      el = find_element(:name, "myscrollview")

      swipe(start_x: 200, start_y: 100, end_x: 0, end_y: 200)
      name.text.should eq "Down swipe"
    end
  end
end
