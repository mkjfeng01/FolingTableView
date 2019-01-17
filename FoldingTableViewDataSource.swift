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

public protocol FoldingTableViewDataSource: NSObjectProtocol {
    
    @available(iOS 2.0, *)
    func foldingTableView(_ foldingTableView: UITableView, numberOfRowsInSection section: Int) -> Int
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    func foldingTableView(_ foldingTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    
    
    @available(iOS 2.0, *)
    func numberOfSections(in foldingTableView: UITableView) -> Int // Default is 1 if not implemented
    
    
    @available(iOS 2.0, *)
    func foldingTableView(_ foldingTableView: UITableView, titleForHeaderInSection section: Int) -> String? // fixed font style. use custom view (UILabel) if you want something different
    
    @available(iOS 2.0, *)
    func foldingTableView(_ foldingTableView: UITableView, titleForFooterInSection section: Int) -> String?
    
    
    // Editing
    
    // Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
    @available(iOS 2.0, *)
    func foldingTableView(_ foldingTableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    
    
    // Moving/reordering
    
    // Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -foldingTableView:moveRowAtIndexPath:toIndexPath:
    @available(iOS 2.0, *)
    func foldingTableView(_ foldingTableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    
    
    // Index
    
    @available(iOS 2.0, *)
    func sectionIndexTitles(for foldingTableView: UITableView) -> [String]? // return list of section titles to display in section index view (e.g. "ABCD...Z#")
    
    @available(iOS 2.0, *)
    func foldingTableView(_ foldingTableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int // tell table which section corresponds to section title/index (e.g. "B",1))
    
    
    // Data manipulation - insert and delete support
    
    // After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
    // Not called for edit actions using UITableViewRowAction - the action's handler will be invoked instead
    @available(iOS 2.0, *)
    func foldingTableView(_ foldingTableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    
    
    // Data manipulation - reorder / moving support
    
    @available(iOS 2.0, *)
    func foldingTableView(_ foldingTableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    
}

extension FoldingTableViewDataSource {
    
    @available(iOS 2.0, *)
    func numberOfSections(in foldingTableView: UITableView) -> Int {
        
        return 0
    }
    
    
    @available(iOS 2.0, *)
    func foldingTableView(_ foldingTableView: UITableView, titleForHeaderInSection section: Int) -> String?  {
        
        return nil
    }
    
    @available(iOS 2.0, *)
    func foldingTableView(_ foldingTableView: UITableView, titleForFooterInSection section: Int) -> String?  {
        
        return nil
    }
    
    
    // Editing
    
    // Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
    @available(iOS 2.0, *)
    func foldingTableView(_ foldingTableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool  {
        
        return false
    }
    
    
    // Moving/reordering
    
    // Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -foldingTableView:moveRowAtIndexPath:toIndexPath:
    @available(iOS 2.0, *)
    func foldingTableView(_ foldingTableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool  {
        
        return false
    }
    
    
    // Index
    
    @available(iOS 2.0, *)
    func sectionIndexTitles(for foldingTableView: UITableView) -> [String]?   {
        
        return nil
    }
    
    @available(iOS 2.0, *)
    func foldingTableView(_ foldingTableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int   {
        
        return 0
    }
    
    
    // Data manipulation - insert and delete support
    
    // After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
    // Not called for edit actions using UITableViewRowAction - the action's handler will be invoked instead
    @available(iOS 2.0, *)
    func foldingTableView(_ foldingTableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {}
    
    
    // Data manipulation - reorder / moving support
    
    @available(iOS 2.0, *)
    func foldingTableView(_ foldingTableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {}
    
}
