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


class EditingController < UIViewController
  def viewDidLoad
    super

    # simple init
    self.title = "Editing"
    self.view.backgroundColor = UIColor.whiteColor

    @text_field1 = UITextField.alloc.initWithFrame [[0, 0], [160, 26]]
    @text_field1.accessibilityLabel = "TextField 1"
    @text_field1.placeholder = "123"
    @text_field1.textAlignment = UITextAlignmentCenter
    @text_field1.autocapitalizationType = UITextAutocapitalizationTypeNone
    @text_field1.borderStyle = UITextBorderStyleRoundedRect
    @text_field1.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2 - 150)
    @text_field1.delegate = self
    self.view.addSubview @text_field1

    @text_field2 = UITextField.alloc.initWithFrame [[0, 0], [160, 26]]
    @text_field2.accessibilityLabel = "TextField 2"
    @text_field2.placeholder = "456"
    @text_field2.textAlignment = UITextAlignmentCenter
    @text_field2.autocapitalizationType = UITextAutocapitalizationTypeNone
    @text_field2.borderStyle = UITextBorderStyleRoundedRect
    @text_field2.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2 - 100)
    @text_field2.delegate = self
    self.view.addSubview @text_field2

    @text_view = UITextView.alloc.initWithFrame [[0, 0], [160, 26]]
    @text_view.accessibilityLabel = "Sum"
    @text_view.textAlignment = UITextAlignmentCenter
    @text_view.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2 - 50)
    self.view.addSubview @text_view

    @add = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @add.setTitle("Add", forState:UIControlStateNormal)
    @add.enabled = false
    @add.sizeToFit
    @add.center = CGPointMake(self.view.frame.size.width / 2, @text_field1.center.y + 140)
    @add.addTarget(self,
      action:"add_fields",
      forControlEvents:UIControlEventTouchUpInside
    )
    self.view.addSubview @add
  end

  def add_fields
    begin
      # try out integers
      sum = (Integer(@text_field1.text) + Integer(@text_field2.text)).to_s
    rescue ArgumentError
      begin
        # try out floats
        sum = (Float(@text_field1.text) + Float(@text_field2.text)).to_s
      rescue ArgumentError
        # finally, just add them as strings
        sum = @text_field1.text + @text_field2.text
      end
    end
    @text_view.text = sum
  end

  def textField(textField, shouldChangeCharactersInRange:range, replacementString:string)
    return false if string == "\n"

    if textField == @text_field1
      t1 = @text_field1.text
      t2 = @text_field2.text
    else
      t1 = @text_field2.text
      t2 = @text_field1.text
    end

    if (t1.length - range.length + string.length) > 0 && t2.length > 0
      @add.enabled = true
    else
      @add.enabled = false
    end

    true
  end
end
