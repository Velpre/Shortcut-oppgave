//
//  ViewController.swift
//  Shortcut.oppgave
//
//  Created by VP on 18/05/2023.
//

import UIKit

class ListComicsViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var refreshButton: UIButton!
    
    var comicList = [Comic]()
    var comicImgList = [UIImage]()
    
    var dataManager = DataManager()
    let spinnerVC = LoadingSpinnerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Connecting delegates
        collectionView.dataSource = self
        collectionView.delegate = self
        dataManager.delegateRandomComic = self
        //Adding spinner from Factories
        addSpinner(to: self, spinner: spinnerVC)
        //Hiding button while updating data
        hideShowButton(state: true)
        
        refreshButton.layer.masksToBounds = true
        refreshButton.layer.cornerRadius = refreshButton.bounds.size.width / 2
        //Fetching comics first time
        dataManager.fetchRandomComics()
        collectionView.collectionViewLayout = createLayout()
    }

//MARK: Calling predefinide methods from CompositionalLayout and making Compositionl Layout
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
    
    //Method for hiding and showing btn - used while refreshing data to hide/show refresh button
    func hideShowButton(state:Bool){
        refreshButton.isHidden = state
    }
 
    @IBAction func refreshRandomComicsPressed(_ sender: UIButton) {
        addSpinner(to: self, spinner: spinnerVC) //Adding spinner from Factories
        hideShowButton(state: true)
        comicList.removeAll()
        comicImgList.removeAll()
        collectionView.reloadData()
        //Refreshing data
        dataManager.fetchRandomComics()
    }
    
}

//MARK: Collection view Deletates
extension ListComicsViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comicList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ComicCell
        cell.comicImage.image = comicImgList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let comicVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ComicViewController") as! ComicViewController
        
        //Passing data to ComicViewController
        comicVC.comicImage = comicImgList[indexPath.row]
        comicVC.comic = comicList[indexPath.row]
        //Pushing controller to navigation stack
        navigationController?.pushViewController(comicVC, animated: true)
    }
}

//MARK: Extension for DataManagerDelegate for picking data from DataManager
extension ListComicsViewController: DataManagerDelegate{
    func didFoundError(_ error: String) {
        showAlertWith(message: error)
    }
    
    func didUpdateData(_ comicList: [Comic], _ imageList: [UIImage]) {
        self.comicList = comicList
        self.comicImgList = imageList
        self.collectionView.reloadData()
        self.spinnerVC.view.removeFromSuperview()
        self.hideShowButton(state: false)
    }
}


