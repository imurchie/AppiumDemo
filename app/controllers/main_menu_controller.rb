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


class MainMenuController < UITableViewController
  def viewDidLoad
    super

    # simple init
    navigationItem.title = "Appium Demo"
    self.view.backgroundColor = UIColor.whiteColor
    self.view.dataSource = self.view.delegate = self
  end

  def tableView(tableView, numberOfRowsInSection:section)
    data.count
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    @reuseIdentifier ||= "CELL_IDENTIFIER"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier)
    cell ||= UITableViewCell.alloc.initWithStyle(
      UITableViewCellStyleDefault,
      reuseIdentifier:@reuseIdentifier
    )
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator

    # add data
    cell.textLabel.text = data[indexPath.row]
    cell.accessibilityLabel = data[indexPath.row]

    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    if data[indexPath.row] == 'Scrolling'
      controller = ScrollingController.alloc.init
    elsif data[indexPath.row] == 'Editing'
      controller = EditingController.alloc.init
    elsif data[indexPath.row] == 'Gestures'
      controller = GesturesController.alloc.init
    end


    self.navigationController.pushViewController(controller, animated:true) if controller
  end

  def data
    @data ||= [
      'Editing',
      'Scrolling',
      'Gestures'
    ]
  end
end
