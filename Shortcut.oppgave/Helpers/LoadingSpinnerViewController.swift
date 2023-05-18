//
//  LoadingSpinnerViewController.swift
//  Shortcut.oppgave
//
//  Created by VP on 18/05/2023.
//

import UIKit

class LoadingSpinnerViewController: UIViewController {
    
    var spinner = UIActivityIndicatorView(style: .large)
    
    override func loadView() {
        view = UIView()
        //view.backgroundColor = UIColor(named: "HH-offwhite")

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        spinner.color = .white
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

}
