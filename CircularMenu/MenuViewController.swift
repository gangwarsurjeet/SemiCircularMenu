//
//  MenuViewController.swift
//  ImageTextOverlay
//
//  Created by Surjeet on 30/04/20.
//  Copyright © 2020 Surjeet. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var circularMenu: CircularMenuView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
/* Update color of semi circular arc*/
//        circularMenu.arcBackgroundColor = UIColor.blue
        
/* Update  text color of items passed in itemArray */
//        circularMenu.itemsTextColor = UIColor.yellow

/* Update  text color of selected item in center */
//        circularMenu.selectorTextColor = UIColor.red
        
/* Update to allow auto scroll like paging. Default is true  */
//        circularMenu.shouldScrollToNearest = false
        
/* Update small semi circular nob */
        circularMenu.nobImage = UIImage(named: "circle")

/* Update Selector cone image */
        circularMenu.selectorImage = UIImage(named: "selection_bg_without_cone")
        
/* Update to increase item spacing todisplay less/more item at once */
        circularMenu.itemSpacing = 30

/* Update to change nob title */
        circularMenu.nobTitle = "GO!"
        
/* Update to change nob title font */
        circularMenu.nobTitleFont = UIFont.boldSystemFont(ofSize: 26)

/* Update to change items font passes in itemArray */
        circularMenu.itemFont = UIFont.systemFont(ofSize: 16)
                
/* Update items to display as menu */
        circularMenu.itemArray = ["Test 1", "Test 2", "Test 3","Test 4", "Test 5", "Test 6", "Test 7", "Test 8", "Test 9", "Test 10", "Test 11", "Test 12"]

/* Call this function at the end of customization of component  */
        circularMenu.updateMenu()
      
/* Call back to receive selcted index*/
        circularMenu.callBack = {[weak self] (index: Int, item: String) in
            print("Index: \(index) Item: \(item)")
        }
    }
}
