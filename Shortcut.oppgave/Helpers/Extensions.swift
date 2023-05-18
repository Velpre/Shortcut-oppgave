//
//  Extensions.swift
//  Shortcut.oppgave
//
//  Created by VP on 18/05/2023.
//

import Foundation
import UIKit

extension UIViewController {
    
    //Alert Message showing errors to user
    func showAlertWith(message: String , style: UIAlertController.Style = .alert, title:String = "Error") {
        DispatchQueue.main.async {
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
            let action = UIAlertAction(title: "Ok", style: .default)
            alertController.view?.tintColor = UIColor(named:"HH-red")
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
