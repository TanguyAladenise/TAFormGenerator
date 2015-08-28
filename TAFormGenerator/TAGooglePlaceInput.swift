//
//  TAGooglePlaceInput.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 28/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit

class TAGooglePlaceInput: TADropdownInput, UITableViewDataSource, UITableViewDelegate {

    private let tableView = UITableView()
    
    private var completionData: [String] = []
    
    
    override func setup() {
        super.setup()
        
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CompletionCell")
        isEditable = true
    }
    
    
    // MARK: - Dropdown
    
    
    override func viewForDropdown() -> UIView? {
        return tableView
    }
    
    
    // MARK: - Input protoco
    
    
    override func inputValue() -> AnyObject? {
        return nil
    }
    
    
    // MARK: - Tableview datasource
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("CompletionCell") as! UITableViewCell
        
        cell.selectionStyle  = .None
        cell.textLabel?.text = "completion \(indexPath.row)"
        
        return cell
    }
    
    
    // MARK: - Tableview delegate
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        textField.text = "option selected"
        endEditing(true)
        openMenuBtnPressed()
    }
}
