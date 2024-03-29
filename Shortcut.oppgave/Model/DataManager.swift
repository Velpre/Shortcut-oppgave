//
//  DataManager.swift
//  Shortcut.oppgave
//
//  Created by VP on 18/05/2023.
//

import Foundation
import UIKit

//Protocol delegate for returning random comic
protocol DataManagerDelegate{
    func didUpdateData(_ comicList: [Comic], _ imageList: [UIImage])
    func didFoundError(_ error: String)
}
//Protocol delegate for returning specific comic
protocol DataManagerDelegateSpecificComic{
    func didUpdateData(_ comic: Comic, _ image: UIImage)
    func didFoundError(_ error: String)
}

class DataManager{
    var delegateRandomComic: DataManagerDelegate?
    var delegateSpecificComic: DataManagerDelegateSpecificComic?
    
    //Finding last comic id and calling array of random numbers
    func findLastComicId(completion: @escaping ([Int]) -> Void) {
        let lastComicUrl = "https://xkcd.com/info.0.json"
        
        getData(url: lastComicUrl) { error, result in
            var randomNumbers = [Int]()
            
            if let error = error {
                self.delegateRandomComic?.didFoundError(error.localizedDescription)
            }
            
            if let safeData = result {
                randomNumbers = self.arrayOfRandomNumbers(lastComicId: safeData.num)
            } else {
                randomNumbers = self.arrayOfRandomNumbers(lastComicId: 2000)
            }
            completion(randomNumbers)
        }
    }
    //Returning array with random numbers - it is only ID numbers of real comic
    func arrayOfRandomNumbers(lastComicId:Int) -> [Int]{
        var randomNumbers = [Int]()
        for _ in 0...19{
              let randomNumber = Int.random(in: 1...lastComicId)
              randomNumbers.append(randomNumber)
          }
        return randomNumbers
    }
    //fetch data
    func getData(url:String, completion: @escaping (Error?, Comic?) -> Void) {
        if let url = URL(string: url) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegateRandomComic?.didFoundError(error!.localizedDescription)
                    completion(error, nil)
                    return
                }
                
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do  {
                        let results = try decoder.decode(Comic.self, from: safeData)
                        completion(nil, results)
                    } catch {
                        completion(error, nil)
                    }
                }
            }.resume()
        }
    }
    
    //Calling get data & downloadImage several times - append data to array - pass data to delegate to send to controller
    func fetchRandomComics() {
        findLastComicId{ randomArray in
            let group = DispatchGroup()
            
            var comicList = [Comic]()
            var comicImgList = [UIImage]()
            
            for number in randomArray {
                let numberString = String(number)
                let url = "https://xkcd.com/" + numberString + "/info.0.json"

                group.enter()
                self.getData(url: url) { error, result in
                    if let error = error {
                        self.delegateRandomComic?.didFoundError(error.localizedDescription)
                        group.leave()
                    }

                    if let safeData = result {
                        comicList.append(safeData)
                        group.enter()
                        self.downloadImage(url:  URL(string: safeData.img)! ) { imageResult in
                            if let image = imageResult {
                                comicImgList.append(image)
                                group.leave()
                            }
                        }
                    group.leave()
                    }else{
                        group.leave()
                    }
                }
            }
            group.notify(queue: .main) {
                self.delegateRandomComic?.didUpdateData(comicList, comicImgList)
            }
        }
    }
    //Calling get data & downloadImage - pass data to delegate to send to controller
    func fetchSpecificComics(id:String){
        let url = "https://xkcd.com/" + id + "/info.0.json"
        let group = DispatchGroup()
        
        var comic:Comic?
        var comicImage: UIImage?

        group.enter()
        getData(url: url) { error, result in
            if let error = error {
                self.delegateRandomComic?.didFoundError(error.localizedDescription)
                group.leave()
                return
            }

            if let safeData = result {
                comic = safeData
                group.enter()
                self.downloadImage(url:  URL(string: safeData.img)! ) { imageResult in
                    if let image = imageResult {
                        comicImage = image
                        group.leave()
                    }
                }
            group.leave()
            }else{
                self.delegateRandomComic?.didFoundError("error.localizedDescription")
                group.leave()
                return
            }
        }
        group.notify(queue: .main) {
            if let comic = comic{
                self.delegateSpecificComic?.didUpdateData(comic, comicImage!)
            }else{
                self.delegateSpecificComic?.didFoundError("Error with data fetching")
            }
        }
    }
    
    func downloadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                  guard let data = data, error == nil else {
                      completion(nil)
                      return
                  }
                if let image = UIImage(data: data) {
                    completion(image)
                    
                } else {
                    completion(nil)
                }
            }.resume()
    }
}

