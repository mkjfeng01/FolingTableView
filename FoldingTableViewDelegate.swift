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

public protocol FoldingTableViewDelegate: NSObjectProtocol {

    /// When the folding header view was initialized, given a confirm state for one header.
    /// But pay attention, this methods was called ONLY WHEN header was first initialized.
    /// It means it was called once.
    
    func foldingTableView(_ foldingTableView: FoldingTableView, foldingStateForHeaderInSection section: Int) -> FoldingTableViewFoldState
    
    /// You can set the indicator position for one header.
    
    func foldingTableView(_ foldingTableView: FoldingTableView, indicatorPositionForHeaderInSection section: Int) -> FoldingTableViewIndicatorPosition
    
    func foldingTableView(_ foldingTableView: FoldingTableView, attributedTitleTextForHeaderInSection section: Int) -> NSAttributedString? /// An attributed string for header title, Default string is nil
    
    func foldingTableView(_ foldingTableView: FoldingTableView, attributedDescriptionTextForHeaderInSection section: Int) -> NSAttributedString? /// An attributed string for header description, Default string is nil
    
    func foldingTableView(_ foldingTableView: FoldingTableView, backgroundColorForHeaderInSection section: Int) -> UIColor?
    func foldingTableView(_ foldingTableView: FoldingTableView, backgroundImageForHeaderInSection section: Int) -> UIImage?
    
    func foldingTableView(_ foldingTableView: FoldingTableView, customViewForHeaderInSection section: Int) -> UIView?
    
    func foldingTableView(_ foldingTableView: FoldingTableView, indicatorImageForHeaderInSection section: Int) -> UIImage?
    
    /// When folding header will insert OR delete rows in one section, this method was excuted.
    /// If you set a custome header view for folding tableView, You should implementation this method to make your own transition animation.
    
    @available(iOS 2.0, *)
    func foldingTableView(_ foldingTableView: FoldingTableView, headerWillTransitionInSection section: Int, forState state: FoldingTableViewFoldState)
    
    /// When folding header end insert OR delete rows in one section, this method was excuted.
    /// If you set a custome header view for folding tableView, You should implementation this method to make your own transition animation.
    /// Excuted in main thread.
    
    @available(iOS 2.0, *)
    func foldingTableView(_ foldingTableView: FoldingTableView, headerEndTransitionInSection section: Int, forState state: FoldingTableViewFoldState)
    
    @available(iOS 2.0, *)
    func foldingTableView(_ foldingTableView: FoldingTableView, heightForHeaderInSection section: Int) -> CGFloat
    
    @available(iOS 2.0, *)
    func foldingTableView(_ foldingTableView: FoldingTableView, heightForFooterInSection section: Int) -> CGFloat
    
    @available(iOS 2.0, *)
    func foldingTableView(_ foldingTableView: FoldingTableView, viewForFooterInSection section: Int) -> UIView?
    
    @available(iOS 2.0, *)
    func foldingTableView(_ foldingTableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    
    @available(iOS 2.0, *)
    func foldingTableView(_ foldingTableView: UITableView, didSelectRowAt indexPath: IndexPath)
    
    @available(iOS 3.0, *)
    func foldingTableView(_ foldingTableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    
    @available(iOS 2.0, *)
    func foldingTableView(_ foldingTableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle
    
}

extension FoldingTableViewDelegate {
    
    func foldingTableView(_ foldingTableView: FoldingTableView, foldingStateForHeaderInSection section: Int) -> FoldingTableViewFoldState {
        return .fold
    }
    
    func foldingTableView(_ foldingTableView: FoldingTableView, indicatorPositionForHeaderInSection section: Int) -> FoldingTableViewIndicatorPosition {
        return .leading
    }
    
    func foldingTableView(_ foldingTableView: FoldingTableView, attributedTitleTextForHeaderInSection section: Int) -> NSAttributedString? {
        return nil
    }
    
    func foldingTableView(_ foldingTableView: FoldingTableView, attributedDescriptionTextForHeaderInSection section: Int) -> NSAttributedString? {
        return nil
    }
    
    func foldingTableView(_ foldingTableView: FoldingTableView, backgroundColorForHeaderInSection section: Int) -> UIColor? {
        return nil
    }
    func foldingTableView(_ foldingTableView: FoldingTableView, backgroundImageForHeaderInSection section: Int) -> UIImage? {
        return nil
    }
    
    func foldingTableView(_ foldingTableView: FoldingTableView, customViewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func foldingTableView(_ foldingTableView: FoldingTableView, indicatorImageForHeaderInSection section: Int) -> UIImage? {
        return nil
    }
    
    func foldingTableView(_ foldingTableView: FoldingTableView, headerWillTransitionInSection section: Int, forState state: FoldingTableViewFoldState) {}
    
    func foldingTableView(_ foldingTableView: FoldingTableView, headerEndTransitionInSection section: Int, forState state: FoldingTableViewFoldState) {}
    
    @available(iOS 2.0, *)
    func foldingTableView(_ foldingTableView: FoldingTableView, heightForHeaderInSection section: Int) -> CGFloat {
        return foldingTableView.sectionHeaderHeight
    }
    
    @available(iOS 2.0, *)
    func foldingTableView(_ foldingTableView: FoldingTableView, heightForFooterInSection section: Int) -> CGFloat {
        return foldingTableView.style == .plain ? 0.00 : 0.01
    }
    
    @available(iOS 2.0, *)
    func foldingTableView(_ foldingTableView: FoldingTableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    @available(iOS 2.0, *)
    func foldingTableView(_ foldingTableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return foldingTableView.estimatedRowHeight
    }
    
    @available(iOS 2.0, *)
    func foldingTableView(_ foldingTableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
    @available(iOS 3.0, *)
    func foldingTableView(_ foldingTableView: UITableView, didDeselectRowAt indexPath: IndexPath) {}
    
    @available(iOS 2.0, *)
    func foldingTableView(_ foldingTableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
}
