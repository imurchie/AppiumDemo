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


class ScrollingController < UIViewController
  def viewDidLoad
    super

    # simple init
    self.title = "Scrolling"

    # table view
    @table = UITableView.alloc.initWithFrame(self.view.bounds)
    @table.autoresizingMask = UIViewAutoresizingFlexibleHeight
    @table.backgroundColor = UIColor.whiteColor
    @table.dataSource = @table.delegate = self
    self.view.addSubview(@table)

    @data = ('A'..'Z').to_a
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @data.count
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= "CELL_IDENTIFIER"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier)
    cell ||= UITableViewCell.alloc.initWithStyle(
      UITableViewCellStyleDefault,
      reuseIdentifier:@reuseIdentifier
    )

    # add data
    cell.textLabel.text = @data[indexPath.row]
    cell.accessibilityLabel = @data[indexPath.row]

    cell
  end

  def sections
    @data.sort
  end

  def sectionIndexTitlesForTableView(tableView)
    sections
  end

  def tableView(tableView, sectionForSectionIndexTitle: title, atIndex: index)
    sections.index title
  end
end
