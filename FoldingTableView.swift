// MIT License
//
// Copyright (c) 2019 张_ zfeng0712@gmail.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

open class FoldingTableView: UITableView, FoldingTableHeaderViewDelegate {
    
    public weak var foldingDataSource: FoldingTableViewDataSource?
    public weak var foldingDelegate: FoldingTableViewDelegate?
    
    public var reuseableHeaders = [String: FoldingTableHeaderView]()
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.dataSource = self
        self.delegate = self
    }
    
    // MARK: - FoldingTableHeaderViewDelegate
    
    public func foldingTableHeaderView(_ foldingTableHeaderView: FoldingTableHeaderView, didSelectHeaderInSection section: Int) {
        assert(Thread.current.isMainThread, "Please make usre this method called in main thread.")
        
        let state = foldingTableHeaderView.state
        
        foldingDelegate?.foldingTableView(self, headerWillTransitionInSection: section, forState: state)
        
        var rows: Int
        
        if let dataSource = foldingDataSource {
            rows = dataSource.foldingTableView(self, numberOfRowsInSection: section)
            var indexPaths = [IndexPath]()
            for row in 0..<rows {
                indexPaths.append(IndexPath(row: row, section: section))
            }
            
            if case .expand = state {
                self.insertRows(at: indexPaths, with: .top)
            } else {
                self.deleteRows(at: indexPaths, with: .top)
            }
            
            DispatchQueue.main.async {
                self.foldingDelegate?.foldingTableView(self, headerEndTransitionInSection: section, forState: state)
            }
        }
    }
    
    private func state(for section: Int) -> FoldingTableViewFoldState {
        if let state = foldingDelegate?.foldingTableView(self, foldingStateForHeaderInSection: section) {
            return state
        }
        return .fold
    }
    
    private func indicatorPosition(for section: Int) -> FoldingTableViewIndicatorPosition {
        if let position = foldingDelegate?.foldingTableView(self, indicatorPositionForHeaderInSection: section) {
            return position
        }
        return .leading
    }
    
    private func customView(for section: Int) -> UIView? {
        return foldingDelegate?.foldingTableView(self, customViewForHeaderInSection: section)
    }
    
    private func indicatorImage(for section: Int) -> UIImage? {
        return foldingDelegate?.foldingTableView(self, indicatorImageForHeaderInSection: section)
    }
    
    private func attributedTitleText(for section: Int) -> NSAttributedString? {
        return foldingDelegate?.foldingTableView(self, attributedTitleTextForHeaderInSection: section)
    }
    
    private func attributedDescriptionText(for section: Int) -> NSAttributedString? {
        return foldingDelegate?.foldingTableView(self, attributedDescriptionTextForHeaderInSection: section)
    }
    
    private func backgroundColor(for section: Int) -> UIColor? {
        return foldingDelegate?.foldingTableView(self, backgroundColorForHeaderInSection: section)
    }
    
    private func backgroundImage(for section: Int) -> UIImage? {
        return foldingDelegate?.foldingTableView(self, backgroundImageForHeaderInSection: section)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UITableView Datasource

extension FoldingTableView: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let reuseIdentifier = "folding.header.identifier.\(section)"
        
        if let rows = foldingDataSource?.foldingTableView(self, numberOfRowsInSection: section),
            let header = reuseableHeaders[reuseIdentifier],
            header.state == .expand {
            return rows
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = foldingDataSource?.foldingTableView(self, cellForRowAt: indexPath) {
            return cell
        }
        
        return UITableViewCell(style: .default, reuseIdentifier: "folding.cell.identifier.default")
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = foldingDataSource?.numberOfSections(in: self) {
            return sections
        }
        return numberOfSections
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return foldingDataSource?.foldingTableView(self, titleForHeaderInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return foldingDataSource?.foldingTableView(self, titleForFooterInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let editable = foldingDataSource?.foldingTableView(self, canEditRowAt: indexPath) {
            return editable
        }
        return true
    }
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if let moveable = foldingDataSource?.foldingTableView(self, canMoveRowAt: indexPath) {
            return moveable
        }
        return true
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]?  {
        return foldingDataSource?.sectionIndexTitles(for: self)
    }
    
    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int  {
        if let section = foldingDataSource?.foldingTableView(self, sectionForSectionIndexTitle: title, at: index) {
            return section
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        foldingDataSource?.foldingTableView(self, commit: editingStyle, forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        foldingDataSource?.foldingTableView(self, moveRowAt: sourceIndexPath, to: destinationIndexPath)
    }

}

// MARK: - UITableView Delegates

extension FoldingTableView: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let reuseIdentifier = "folding.header.identifier.\(section)"
        
        var header: FoldingTableHeaderView
        
        if let reuseableHeader = reuseableHeaders[reuseIdentifier] {
            header = reuseableHeader
        } else {
            header = FoldingTableHeaderView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: self.tableView(tableView, heightForHeaderInSection: section)),
                                            state: state(for: section),
                                            indicatorPosition: indicatorPosition(for: section),
                                            section: section,
                                            reuseIdentifier: reuseIdentifier)
            reuseableHeaders[reuseIdentifier] = header
            header.delegate = self
            
            if case .expand = state(for: section), let rows = foldingDataSource?.foldingTableView(self, numberOfRowsInSection: section) {
                var indexPaths = [IndexPath]()
                for row in 0..<rows {
                    indexPaths.append(IndexPath(row: row, section: section))
                }
                self.insertRows(at: indexPaths, with: .top)
            }
        }
        
        header.prepareForReuse()
        
        if let customView = customView(for: section) {
            header.customView = customView
        } else {
            header.descriptionTextLabel.attributedText = attributedDescriptionText(for: section)
            header.titleTextLabel.attributedText = attributedTitleText(for: section)
            header.indicatorImageView.image = indicatorImage(for: section)
        }
        
        if let backgroundColor = backgroundColor(for: section) {
            header.contentView.backgroundColor = backgroundColor
        } else if let image = backgroundImage(for: section) {
            header.contentView.image = image
        } else {
            header.contentView.backgroundColor = UIColor.groupTableViewBackground
            header.contentView.image = nil
        }
        
        header.setupConstraints()
        
        return header
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let height = foldingDelegate?.foldingTableView(self, heightForHeaderInSection: section) {
            return height
        }
        return 30.0
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let height = foldingDelegate?.foldingTableView(self, heightForFooterInSection: section) {
            return height
        }
        return style == .plain ? 0.00 : 0.01
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let view = foldingDelegate?.foldingTableView(self, viewForFooterInSection: section) {
            return view
        }
        return nil
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = foldingDelegate?.foldingTableView(self, heightForRowAt: indexPath) {
            return height
        }
        return estimatedRowHeight
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        foldingDelegate?.foldingTableView(self, didSelectRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        foldingDelegate?.foldingTableView(self, didDeselectRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if let style = foldingDelegate?.foldingTableView(self, editingStyleForRowAt: indexPath) {
            return style
        }
        return .none
    }
    
}
