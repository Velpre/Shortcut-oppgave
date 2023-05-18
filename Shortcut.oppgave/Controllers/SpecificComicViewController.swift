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
    let spinnerVC = LoadingSpinnerViewController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.delegateSpecificComic = self
        hideAllDinamicOutlets()
    }
    
    func hideAllDinamicOutlets(){
        comicTitle.isHidden = true
        comicImage.isHidden = true
        dateAdded.isHidden = true
    }

    @IBAction func searchButtonPressed(_ sender: UIButton) {
        if let textFieldData = textField.text{
            if textFieldData.count == 0{
                showAlertWith(message: "You must write a number")
            }else{
                addSpinner(to: self, spinner: spinnerVC)
                hideAllDinamicOutlets()
                dataManager.fetchSpecificComics(id: textFieldData)
            }
        }else{
            print("nooot")
        }
    }
}

extension SpecificComicViewController: DataManagerDelegateSpecificComic{
    func didUpdateData(_ comic: Comic, _ image: UIImage) {
        self.comicImage.image = image
        self.dateAdded.text = "Date Added: " + comic.day + "." + comic.month + "." + comic.year
        self.comicTitle.text = "Title: " + comic.title
        self.textField.text = ""
        comicTitle.isHidden = false
        comicImage.isHidden = false
        dateAdded.isHidden = false
        self.spinnerVC.view.removeFromSuperview()
        
    }
    
    func didFoundError(_ error: String) {
        self.spinnerVC.view.removeFromSuperview()
        showAlertWith(message: error)
    }
}
