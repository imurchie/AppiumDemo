class GesturesVisualizerController < UIViewController
  include ReadonlyFieldDelegate

  def viewDidLoad
    super

    # simple init
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

    # @mainImage = UIScrollView.alloc.initWithFrame self.view.frame
    # @mainImage.accessibilityLabel = "myscrollview"
    # @mainImage.backgroundColor = UIColor.whiteColor
    # @mainImage.opaque = false
    # self.view.addSubview @mainImage

    label = UILabel.alloc.initWithFrame [[0, 0], [160, 26]]
    label.setFont(UIFont.fontWithName("Helvetica-Bold", size:14))
    label.textAlignment = UITextAlignmentCenter
    label.text = "Gestures"
    label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 200)
    @mainImage.addSubview label

    @name_view = UITextField.alloc.initWithFrame [[0, 0], [160, 26]]
    @name_view.delegate = self
    @name_view.borderStyle = UITextBorderStyleNone;
    @name_view.accessibilityLabel = "gesture_name"
    @name_view.setFont(UIFont.fontWithName("Helvetica", size:12))
    @name_view.textAlignment = UITextAlignmentCenter
    @name_view.text = ""
    @name_view.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 175)
    @mainImage.addSubview @name_view

    # @detail_view = UITextField.alloc.initWithFrame [[0, 0], [160, 26]]
    # @detail_view.delegate = self
    # @detail_view.borderStyle = UITextBorderStyleNone;
    # @detail_view.accessibilityLabel = "gesture_detail"
    # @detail_view.setFont(UIFont.fontWithName("Helvetica", size:12))
    # @detail_view.textAlignment = UITextAlignmentCenter
    # @detail_view.text = ""
    # @detail_view.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 150)
    # @mainImage.addSubview @detail_view

    # add gesture control stuffs
    # init_swipe_recognizers(@mainImage)
    # scroll.addGestureRecognizer(UIPinchGestureRecognizer.alloc.initWithTarget(self, action:"handle_pinch:"))
    # scroll.addGestureRecognizer(UILongPressGestureRecognizer.alloc.initWithTarget(self, action:"handle_longpress:"))
    # scroll.addGestureRecognizer(UITapGestureRecognizer.alloc.initWithTarget(self, action:"handle_tap:"))


    def @mainImage.touchesBegan(touches, withEvent:event)
      self.subviews.first.text = "began"

      @mouseSwiped = false
      touch = touches.anyObject
      @lastPoint = touch.locationInView self
    end

    def @mainImage.touchesMoved(touches, withEvent:event)
      @mouseSwiped = true
      touch = touches.anyObject
      currentPoint = touch.locationInView self

      self.subviews.first.text = "moved"

      UIGraphicsBeginImageContext(self.frame.size)
      self.image.drawInRect(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
      CGContextMoveToPoint(UIGraphicsGetCurrentContext(), @lastPoint.x, @lastPoint.y)
      CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y)
      CGContextSetLineCap(UIGraphicsGetCurrentContext(), KCGLineCapRound)
      CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 1.0)
      CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0/255.0, 0.0/255.0, 0.0/255.0, 1.0)
      CGContextSetBlendMode(UIGraphicsGetCurrentContext(), KCGBlendModeNormal)
      CGContextStrokePath(UIGraphicsGetCurrentContext())
      self.image = UIGraphicsGetImageFromCurrentImageContext()
      self.setAlpha(1.0)
      UIGraphicsEndImageContext()

      @lastPoint = currentPoint
    end

    def @mainImage.touchesEnded(touches, withEvent:event)
      self.subviews.first.text = "ended"

      if(!@mouseSwiped)
        UIGraphicsBeginImageContext(self.frame.size)
        self.image.drawInRect(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), @lastPoint.x, @lastPoint.y)
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), @lastPoint.x, @lastPoint.y)
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), KCGLineCapRound)
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 1.0)
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0/255.0, 0.0/255.0, 0.0/255.0, 1.0)
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), KCGBlendModeNormal)
        CGContextStrokePath(UIGraphicsGetCurrentContext())
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        self.setAlpha(1.0)
        UIGraphicsEndImageContext()
      end
    end
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
    # @detail_view.text = "Scale: #{sender.scale}; Velocity: #{sender.velocity}"
  end

  def display_gesture(name, location)
    @name_view.text = "#{name}"
    # @detail_view.text = "Location: x:#{location.x}, y:#{location.y}"
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

  def gestureRecognizer(gestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer)
    return true
  end
end
