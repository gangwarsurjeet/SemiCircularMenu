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
        
/* Update small semi circular nob */
//        circularMenu.nobImage = UIImage(named: "nobImage-1")

/* Update to increase item spacing todisplay less/more item at once */
        circularMenu.itemSpacing = 30

/* Update items to display as menu */
        circularMenu.itemArray = ["Test 1", "Test 2", "Test 3","Test 4", "Test 5", "Test 6", "Test 7", "Test 8", "Test 9", "Test 10", "Test 11", "Test 12"]

/* Call this function at the end of customization of component  */
        circularMenu.updateMenu()
    }
}
