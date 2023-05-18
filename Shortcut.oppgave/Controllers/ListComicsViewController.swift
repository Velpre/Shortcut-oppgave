//
//  ViewController.swift
//  Shortcut.oppgave
//
//  Created by VP on 18/05/2023.
//

import UIKit

class ListComicsViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var comicList = [Comic]()
    var comicImgList = [UIImage]()
    var dataManager = DataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        dataManager.delegate = self
        
        dataManager.fetchRandomComics()
        collectionView.collectionViewLayout = createLayout()
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout{
        //Item
        let item = CompositionalLayout.createItem(width: .fractionalWidth(0.5), height: .fractionalHeight(1), size: 2.5)

        let fullItem = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), size: 2.5)

        let itemHalfScreen = CompositionalLayout.createItem(width: .fractionalWidth(0.5), height: .fractionalHeight(1), size: 2.5)


        //MARK: small horizontal group

        let horizontalGroupSmall = CompositionalLayout.createGroup(aligment: .horizontal, width: .fractionalWidth(1), height: .absolute(150), items: [item, item])

        //MARK: big horizontal group
        let verticalGroupBig = CompositionalLayout.createGroup(aligment: .vertical, width: .fractionalWidth(0.5), height: .fractionalHeight(1), item: fullItem, count: 2)

        let horizontalGroupBig = CompositionalLayout.createGroup(aligment: .horizontal, width: .fractionalWidth(1), height: .absolute(300), items: [itemHalfScreen, verticalGroupBig])


        //MARK: final group with all nested groups
        let mainGroup = CompositionalLayout.createGroup(aligment: .vertical, width: .fractionalWidth(1), height: .absolute(600), items: [horizontalGroupSmall,  horizontalGroupBig])


        //Section
        let section = NSCollectionLayoutSection(group: mainGroup)
        //return
        return UICollectionViewCompositionalLayout(section: section)
    }
    
 
    @IBAction func refreshRandomComicsPressed(_ sender: UIButton) {
        comicList.removeAll()
        comicImgList.removeAll()
        collectionView.reloadData()
        dataManager.fetchRandomComics()
    }
    
}

extension ListComicsViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("comicList \(comicList.count)")
        print("comicImgList \(comicImgList.count)")
        return comicList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ComicCell
        cell.comicImage.image = comicImgList[indexPath.row]
        return cell
    }
}


extension ListComicsViewController: DataManagerDelegate{
    func didUpdateData(_ comicList: [Comic], _ imageList: [UIImage]) {
        self.comicList = comicList
        self.comicImgList = imageList
        self.collectionView.reloadData()
    }
}


