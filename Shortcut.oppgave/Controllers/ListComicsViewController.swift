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
        fetchRandomComics()
        collectionView.collectionViewLayout = createLayout()
    }
    
    func fetchRandomComics() {
        dataManager.findLastComicId{ randomArray in
            let group = DispatchGroup()
            for number in randomArray {
                let numberString = String(number)
                let url = "https://xkcd.com/" + numberString + "/info.0.json"
                
                group.enter()
                self.dataManager.getData(url: url) { error, result in
                    if let error = error {
                        let message = error
                        print(message.localizedDescription)
                    }
                    
                    if let safeData = result {
                        self.comicList.append(safeData)
                        self.downloadImage(url:  URL(string: safeData.img)! ) { imageResult in
                            if let image = imageResult {
                                self.comicImgList.append(image)
                            }
                            group.leave()
                        }
                    }else{
                        group.leave()
                    }
                }
            }
            group.notify(queue: .main) {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }

    
    func downloadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                  guard let data = data, error == nil else {
                      completion(nil)
                      return
                  }
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    completion(image)
                    
                } else {
                    completion(nil)
                }
            }
            }.resume()
        }
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
}

extension ListComicsViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("comicList \(comicList.count)")
        print("comicImgList \(comicImgList.count)")
        return comicList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ComicCell
        
        cell.textLabel.text = comicList[indexPath.row].title
        return cell
    }
}





