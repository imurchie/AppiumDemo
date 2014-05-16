class PinchController < UIViewController
  def viewDidLoad
    super

    # simple init
    self.title = "Pinching"

    @pinchRecognizer = UIPinchGestureRecognizer.alloc.initWithTarget(self, action: :"pinchGestureRecognizer:")
  end

  def pinchGestureRecognizer(recognizer)
    puts "A pinch!"
  end
end
