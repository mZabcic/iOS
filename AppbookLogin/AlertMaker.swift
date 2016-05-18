//
//  AlertMaker.swift
//  AppbookLogin
//
//  Created by User on 01/04/16.
//  Copyright © 2016 IN2 iOS team. All rights reserved.
//

import UIKit

class AlertMaker {
    
    
    let alert: UIAlertController
   
    
    init(title: String, message: String, style: UIAlertControllerStyle)
    {
        alert = UIAlertController(title: title, message: message, preferredStyle: style)
       
    }
    
    init(title: String, message: String, style: UIAlertControllerStyle,  actions: UIAlertAction...){
        
        alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        for action in actions {
            alert.addAction(action)
        }
    }
    
    func addAction(action: UIAlertAction){
        alert.addAction(action)
    }
    
    func addAction(title : String, style: UIAlertActionStyle, handler: ((UIAlertAction) -> Void)){
                alert.addAction(UIAlertAction(title: title, style: style, handler:handler ))
    }
    
   func getAlert() -> UIAlertController {
        return self.alert
    }
    
    
    
}