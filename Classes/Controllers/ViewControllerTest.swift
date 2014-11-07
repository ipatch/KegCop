//
//  ViewControllerTest.swift
//  KegCop
//
//  Created by capin on 11/7/14.
//
//

import UIKit

class ViewControllerTest: UIViewController {
    
    @IBOutlet weak var btnDone: UIButton!
    
    @IBAction func dismissScene(sender:
        AnyObject) {
            if((self.presentingViewController) != nil) {
                self.dismissViewControllerAnimated(false, completion: nil)
                println("done btn pressed")
            }
    }
    
}