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


class GestureTestsController < UIViewController
  include ReadonlyFieldDelegate

  def viewDidLoad
    super

    # simple init
    self.title = "Gestures"
    self.view.backgroundColor = UIColor.whiteColor

    scroll = UIScrollView.alloc.initWithFrame self.view.frame
    scroll.accessibilityLabel = "myscrollview"
    scroll.backgroundColor = UIColor.whiteColor
    scroll.opaque = false
    self.view.addSubview scroll

    label = UILabel.alloc.initWithFrame [[0, 0], [160, 26]]
    label.setFont(UIFont.fontWithName("Helvetica-Bold", size:14))
    label.textAlignment = UITextAlignmentCenter
    label.text = "Gestures"
    label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 200)
    scroll.addSubview label

    @name_view = UITextField.alloc.initWithFrame [[0, 0], [160, 26]]
    @name_view.delegate = self
    @name_view.borderStyle = UITextBorderStyleNone;
    @name_view.accessibilityLabel = "gesture_name"
    @name_view.setFont(UIFont.fontWithName("Helvetica", size:12))
    @name_view.textAlignment = UITextAlignmentCenter
    @name_view.text = ""
    @name_view.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 175)
    scroll.addSubview @name_view

    @detail_view = UITextField.alloc.initWithFrame [[0, 0], [160, 26]]
    @detail_view.delegate = self
    @detail_view.borderStyle = UITextBorderStyleNone;
    @detail_view.accessibilityLabel = "gesture_detail"
    @detail_view.setFont(UIFont.fontWithName("Helvetica", size:12))
    @detail_view.textAlignment = UITextAlignmentCenter
    @detail_view.text = ""
    @detail_view.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 150)
    scroll.addSubview @detail_view

    # add gesture control stuffs
    init_swipe_recognizers(scroll)
    scroll.addGestureRecognizer(UIPinchGestureRecognizer.alloc.initWithTarget(self, action:"handle_pinch:"))
    scroll.addGestureRecognizer(UILongPressGestureRecognizer.alloc.initWithTarget(self, action:"handle_longpress:"))
    scroll.addGestureRecognizer(UITapGestureRecognizer.alloc.initWithTarget(self, action:"handle_tap:"))
  end

  def handle_swipe(sender)
    display_gesture("#{direction_name(sender.direction)} swipe", sender.locationInView(self.view))
  end

  def direction_name(direction)
    if direction == UISwipeGestureRecognizerDirectionDown
      "Down"
    elsif direction == UISwipeGestureRecognizerDirectionUp
      "Up"
    elsif direction == UISwipeGestureRecognizerDirectionRight
      "Right"
    elsif direction == UISwipeGestureRecognizerDirectionLeft
      "Left"
    else
      "Unknown"
    end
  end

  def handle_tap(sender)
    display_gesture("Tap", sender.locationInView(self.view))
  end

  def handle_longpress(sender)
    display_gesture("LongPress", sender.locationInView(self.view))
  end

  def handle_pinch(sender)
    @name_view.text = sender.scale >= 1 ? "Zoom" : "Pinch"
    @detail_view.text = "Scale: #{sender.scale}; Velocity: #{sender.velocity}"
  end

  def display_gesture(name, location)
    @name_view.text = "#{name}"
    @detail_view.text = "Location: x:#{location.x}, y:#{location.y}"
  end

  def init_swipe_recognizers(view)
    rightSR = UISwipeGestureRecognizer.alloc.initWithTarget(self, action:"handle_swipe:")
    view.addGestureRecognizer(rightSR)

    leftSR = UISwipeGestureRecognizer.alloc.initWithTarget(self, action:"handle_swipe:")
    leftSR.direction = UISwipeGestureRecognizerDirectionLeft
    view.addGestureRecognizer(leftSR)

    upSR = UISwipeGestureRecognizer.alloc.initWithTarget(self, action:"handle_swipe:")
    upSR.direction = UISwipeGestureRecognizerDirectionUp
    view.addGestureRecognizer(upSR)

    downSR = UISwipeGestureRecognizer.alloc.initWithTarget(self, action:"handle_swipe:")
    downSR.direction = UISwipeGestureRecognizerDirectionDown
    view.addGestureRecognizer(downSR)
  end
end
