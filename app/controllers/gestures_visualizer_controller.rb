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


class GesturesVisualizerController < UIViewController
  include ReadonlyFieldDelegate

  def viewDidLoad
    super

    self.title = "Gestures -- Visual"
    self.view.backgroundColor = UIColor.whiteColor

    @mainImage = UIImageView.alloc.initWithFrame self.view.frame
    @mainImage.backgroundColor = UIColor.whiteColor
    @mainImage.opaque = false
    @mainImage.userInteractionEnabled = true
    @mainImage.multipleTouchEnabled = true
    image = UIImage.imageNamed('white.png')
    image.accessibilityLabel = "whiteBackground"
    @mainImage.setImage(image)
    @mainImage.accessibilityLabel = "paintCanvas"
    self.view.addSubview @mainImage

    @detail_view = UITextField.alloc.initWithFrame [[0, 0], [160, 26]]
    @detail_view.delegate = self
    @detail_view.borderStyle = UITextBorderStyleNone;
    @detail_view.accessibilityLabel = "gesture_detail"
    @detail_view.setFont(UIFont.fontWithName("Helvetica", size:12))
    @detail_view.textAlignment = UITextAlignmentCenter
    @detail_view.text = "some details here"
    @detail_view.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 10)
    @mainImage.addSubview @detail_view

    def @mainImage.touchesBegan(touches, withEvent:event)
      @mouseSwiped = false
      touch = touches.anyObject
      @lastPoint = touch.locationInView self

      self.subviews.last.text = "x: #{@lastPoint.x}, y: #{@lastPoint.y}"
    end

    def @mainImage.touchesMoved(touches, withEvent:event)
      @mouseSwiped = true
      touch = touches.anyObject
      currentPoint = touch.locationInView self

      UIGraphicsBeginImageContext(self.frame.size)
      self.image.drawInRect(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
      CGContextMoveToPoint(UIGraphicsGetCurrentContext(), @lastPoint.x, @lastPoint.y)
      CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y)
      CGContextSetLineCap(UIGraphicsGetCurrentContext(), KCGLineCapRound)
      CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0)
      CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0/255.0, 0.0/255.0, 0.0/255.0, 1.0)
      CGContextSetBlendMode(UIGraphicsGetCurrentContext(), KCGBlendModeNormal)
      CGContextStrokePath(UIGraphicsGetCurrentContext())
      self.image = UIGraphicsGetImageFromCurrentImageContext()
      self.setAlpha(1.0)
      UIGraphicsEndImageContext()

      @lastPoint = currentPoint

      self.subviews.last.text = "x: #{@lastPoint.x}, y: #{@lastPoint.y}"
    end

    def @mainImage.touchesEnded(touches, withEvent:event)
      if(!@mouseSwiped)
        UIGraphicsBeginImageContext(self.frame.size)
        self.image.drawInRect(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), @lastPoint.x, @lastPoint.y)
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), @lastPoint.x, @lastPoint.y)
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), KCGLineCapRound)
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0)
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0/255.0, 0.0/255.0, 0.0/255.0, 1.0)
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), KCGBlendModeNormal)
        CGContextStrokePath(UIGraphicsGetCurrentContext())
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        self.setAlpha(1.0)
        UIGraphicsEndImageContext()
      end

      self.subviews.last.text = "x: #{@lastPoint.x}, y: #{@lastPoint.y}"
    end
  end

  def gestureRecognizer(gestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer)
    return true
  end
end
