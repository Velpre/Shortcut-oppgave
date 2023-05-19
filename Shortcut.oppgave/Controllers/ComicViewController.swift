//
//  ComicViewController.swift
//  Shortcut.oppgave
//
//  Created by VP on 18/05/2023.
//

import UIKit

class ComicViewController: UIViewController {

    @IBOutlet weak var comicImageView: UIImageView!
    @IBOutlet weak var comicId: UILabel!
    @IBOutlet weak var comicTitle: UILabel!
    @IBOutlet weak var dateAdded: UILabel!
    
    //This values are passed/updated inside ListComicsViewController when user click on cell
    var comic:Comic?
    var comicImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addingValues()
    }
    
    func addingValues(){
        if let comic = comic{
            comicImageView.image = comicImage
            comicId.text = "ID: " + String(comic.num)
            comicTitle.text = comic.title
            dateAdded.text = "Date Added: " + comic.day + "." + comic.month + "." + comic.year
        }
    }
}
