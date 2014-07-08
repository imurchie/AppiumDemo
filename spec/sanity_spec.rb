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

  it "should be able to shake" do
    shake
    find_element(:accessibility_id, 'Hello World!')
  end

  it "should be able to shake" do
    # find_element(:accessibility_id, "Editing")
    shake
    # find_element(:accessibility_id, 'Hello World!')
  end

  describe "Handling UITextFields" do
    it "should be able to fill in text fields" do
      rnd = Random.new
      n1 = rnd.rand(100)
      n2 = rnd.rand(100)

      find_element(:name, "Editing").click

      sum_el = find_element(:name, "Sum")
      sum_el.text.should eq ""

      add_btn = find_element(:name, "Add")
      add_btn.should_not be_enabled

      el = find_element(:name, "TextField 1")
      el.send_keys("#{n1}")

      sum_el.text.should eq ""
      add_btn.should_not be_enabled

      el = find_element(:name, "TextField 2")
      el.send_keys("#{n2}")

      sum_el.text.should eq ""
      add_btn.should be_enabled

      add_btn.click

      sum_el.text.should eq "#{n1 + n2}"

      sleep(2)
    end
  end

  describe "Schematic gestures" do
    describe "Tap action" do
      it "should tap on the right place" do
        find_element(:name, "Gestures -- Schematic").click
        sleep(1)

        name = find_element(:name, "gesture_name")
        name.text.should eq ""

        el = find_element(:name, "myscrollview")
        action = Appium::TouchAction.new
        action.tap(x: 100, y: 100, duration: 100).perform

        name.text.should eq "LongPress"

        sleep(1)
      end
    end

    describe "Swipe actions" do
      it "should swipe right" do
        find_element(:name, "Gestures -- Schematic").click
        sleep(1)

        name = find_element(:name, "gesture_name")
        name.text.should eq ""

        a = Appium::TouchAction.new
        a.swipe(start_x: 100, start_y: 400, end_x: 200, end_y: 0).perform
        name.text.should eq "Right swipe"

        sleep(1)
      end

      it "should swipe left" do
        find_element(:name, "Gestures -- Schematic").click
        sleep(1)

        name = find_element(:name, "gesture_name")
        name.text.should eq ""

        swipe(start_x: 300, start_y: 400, end_x: -200, end_y: 0)
        name.text.should eq "Left swipe"

        sleep(1)
      end

      it "should swipe up" do
        find_element(:name, "Gestures -- Schematic").click
        sleep(1)

        name = find_element(:name, "gesture_name")
        name.text.should eq ""

        el = find_element(:name, "myscrollview")

        swipe(start_x: 200, start_y: 400, end_x: 0, end_y: -200)
        name.text.should eq "Up swipe"

        sleep(1)
      end

      it "should swipe down" do
        find_element(:name, "Gestures -- Schematic").click
        sleep(1)

        name = find_element(:name, "gesture_name")
        name.text.should eq ""

        el = find_element(:name, "myscrollview")

        swipe(start_x: 200, start_y: 100, end_x: 0, end_y: 200)
        name.text.should eq "Down swipe"

        sleep(1)
      end
    end

    describe "Pinch actions" do
      it "should zoom" do
        find_element(:name, "Gestures -- Schematic").click
        sleep(1)

        name = find_element(:name, "gesture_name")
        name.text.should eq ""

        el = find_element(:name, "myscrollview")

        # zoom
        top = Appium::TouchAction.new
        top.swipe(start_x: 200, start_y: 400, end_x: 100, end_y: 0)
        bottom = Appium::TouchAction.new
        bottom.swipe(start_x: 200, start_y: 400, end_x: -100, end_y: 0)

        zoom = Appium::MultiTouch.new
        zoom.add top
        zoom.add bottom
        zoom.perform

        name.text.should eq "Zoom"

        sleep(4)
      end

      it "should pinch" do
        find_element(:name, "Gestures -- Schematic").click
        sleep(1)

        name = find_element(:name, "gesture_name")
        name.text.should eq ""

        el = find_element(:name, "myscrollview")

        # zoom
        top = Appium::TouchAction.new
        top.swipe(start_x: 100, start_y: 400, end_x: 100, end_y: 0)
        bottom = Appium::TouchAction.new
        bottom.swipe(start_x: 300, start_y: 400, end_x: -100, end_y: 0)

        zoom = Appium::MultiTouch.new
        zoom.add top
        zoom.add bottom
        zoom.perform
        sleep(1)

        name.text.should eq "Pinch"

        sleep(4)
      end
    end
  end

  describe "Visualizing complex gestures" do
    it "should write out 'Appium rocks" do
      find_element(:name, "Gestures -- Visual").click

      sleep(1)

      a = Appium::TouchAction.new
      a.
        press(x: 10, y: 200).
        move_to(x: 25, y: -100).
        move_to(x: 25, y: 100).
        move_to(x: -13, y: -50).
        move_to(x: -24, y: 0).
        release.
        perform

      p = Appium::TouchAction.new
      p.
        press(x: 70, y: 200).
        move_to(x: 0, y: -100).
        move_to(x: 40, y: 0).
        move_to(x: 0, y: 50).
        move_to(x: -40, y: 0).
        release.
        perform

      p = Appium::TouchAction.new
      p.
        press(x: 120, y: 200).
        move_to(x: 0, y: -100).
        move_to(x: 40, y: 0).
        move_to(x: 0, y: 50).
        move_to(x: -40, y: 0).
        release.
        perform

      i = Appium::TouchAction.new
      i.
        press(x: 170, y: 200).
        move_to(x: 0, y: -100).
        release.
        perform

      u = Appium::TouchAction.new
      u.
        press(x: 180, y: 100).
        move_to(x: 0, y: 100).
        move_to(x: 40, y: 0).
        move_to(x: 0, y: -100).
        release.
        perform

      m = Appium::TouchAction.new
      m.
        press(x: 230, y: 200).
        move_to(x: 15, y: -100).
        move_to(x: 15, y: 50).
        move_to(x: 15, y: -50).
        move_to(x: 15, y: 100).
        release.
        perform

      r = Appium::TouchAction.new
      r.
        press(x: 20, y: 310).
        move_to(x: 0, y: -100).
        move_to(x: 40, y: 0).
        move_to(x: 0, y: 50).
        move_to(x: -40, y: 0).
        move_to(x: 40, y: 50).
        release.
        perform

      o = Appium::TouchAction.new
      o.
        press(x: 70, y: 310).
        move_to(x: 0, y: -100).
        move_to(x: 40, y: 0).
        move_to(x: 0, y: 100).
        move_to(x: -40, y: 0).
        release.
        perform

      c = Appium::TouchAction.new
      c.
        press(x: 160, y: 310).
        move_to(x: -40, y: 0).
        move_to(x: 0, y: -100).
        move_to(x: 40, y: 0).
        release.
        perform

      k = Appium::TouchAction.new
      k.
        press(x: 170, y: 310).
        move_to(x: 0, y: -100).
        move_to(x: 0, y: 60).
        move_to(x: 40, y: -60).
        move_to(x: -34, y: 50).
        move_to(x: 34, y: 50).
        release.
        perform

      s = Appium::TouchAction.new
      s.
        press(x: 220, y: 310).
        move_to(x: 40, y: 0).
        move_to(x: 0, y: -50).
        move_to(x: -40, y: 0).
        move_to(x: 0, y: -50).
        move_to(x: 40, y: 0).
        release.
        perform

      sleep(10)
    end
  end
end
