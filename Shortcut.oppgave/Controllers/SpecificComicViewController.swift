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
    let spinner = LoadingSpinnerViewController()

    
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
    
    func addSpinner(){
        hideAllDinamicOutlets()
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }

    @IBAction func searchButtonPressed(_ sender: UIButton) {

        
        if let textFieldData = textField.text{
            if textFieldData.count == 0{
                showAlertWith(message: "You must write a number")
            }else{
                addSpinner()
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
        self.title = "Title: " + comic.title
        comicTitle.isHidden = false
        comicImage.isHidden = false
        dateAdded.isHidden = false
        self.spinner.view.removeFromSuperview()
        
    }
    
    func didFoundError(_ error: String) {
        showAlertWith(message: error)
    }
}
