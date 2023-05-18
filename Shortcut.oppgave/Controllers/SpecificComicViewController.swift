//
//  SpecificComicViewController.swift
//  Shortcut.oppgave
//
//  Created by VP on 18/05/2023.
//

import UIKit

class SpecificComicViewController: UIViewController {

    @IBOutlet weak var comicTitle: UILabel!
    @IBOutlet weak var comicImage: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var dateAdded: UILabel!
    var dataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.delegateSpecificComic = self
    }

    @IBAction func searchButtonPressed(_ sender: UIButton) {
        if let textFieldData = textField.text{
            if textFieldData.count == 0{
                showAlertWith(message: "You must write a number")
            }else{
                dataManager.fetchSpecificComics(id: textFieldData)
            }
        }else{
            print("nooot")
        }
    }
}

extension SpecificComicViewController: DataManagerDelegateSpecificComic{
    func didUpdateData(_ comic: Comic, _ image: UIImage) {

        print(image)
    }
    
    func didFoundError(_ error: String) {
        showAlertWith(message: error)
    }
    
    
}
