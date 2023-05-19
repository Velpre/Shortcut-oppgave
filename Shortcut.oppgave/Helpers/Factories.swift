//
//  Factories.swift
//  Shortcut.oppgave
//
//  Created by VP on 18/05/2023.
//

import Foundation
import UIKit

//Method for adding spinner
func addSpinner(to viewController: UIViewController, spinner: UIViewController) {
    viewController.addChild(spinner)
    spinner.view.frame = viewController.view.frame
    viewController.view.addSubview(spinner.view)
    spinner.didMove(toParent: viewController)
}
