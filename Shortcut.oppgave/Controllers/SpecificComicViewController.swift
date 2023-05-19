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
        //Default hiding outlets before updating
        hideShowAllDinamicOutlets(state: true)
    }
    
    //Dinamicly hiding and showing outlets
    func hideShowAllDinamicOutlets(state:Bool){
        comicTitle.isHidden = state
        comicImage.isHidden = state
        dateAdded.isHidden = state
    }

    @IBAction func searchButtonPressed(_ sender: UIButton) {
        if let textFieldData = textField.text{
            if textFieldData.count == 0{
                showAlertWith(message: "You must write a id")
            }else if !textFieldData.isNumber{
                showAlertWith(message: "You cant write characters")
            }else{
                addSpinner(to: self, spinner: spinnerVC)
                //Hiding outlets while updating
                hideShowAllDinamicOutlets(state: true)
                dataManager.fetchSpecificComics(id: textFieldData)
            }
        }
    }
}

//MARK: Extension for DataManagerDelegate for picking data from DataManager
extension SpecificComicViewController: DataManagerDelegateSpecificComic{
    func didUpdateData(_ comic: Comic, _ image: UIImage) {
        self.comicImage.image = image
        self.dateAdded.text = "Date Added: " + comic.day + "." + comic.month + "." + comic.year
        self.comicTitle.text = "Title: " + comic.title
        self.textField.text = ""
        //Showing outlets after updating
        hideShowAllDinamicOutlets(state: false)
        self.spinnerVC.view.removeFromSuperview()
    }
    
    func didFoundError(_ error: String) {
        self.spinnerVC.view.removeFromSuperview()
        showAlertWith(message: error)
    }
}
