//
//  DataManager.swift
//  Shortcut.oppgave
//
//  Created by VP on 18/05/2023.
//

import Foundation


struct DataManager{
    
    func findLastComicId(completion: @escaping ([Int]) -> Void) {
        let lastComicUrl = "https://xkcd.com/info.0.json"
        
        getData(url: lastComicUrl) { error, result in
            var randomNumbers = [Int]()
            
            if let error = error {
                let message = error
                print(message)
            }
            
            if let safeData = result {
                randomNumbers = arrayOfRandomNumbers(lastComicId: safeData.num)
            } else {
                randomNumbers = arrayOfRandomNumbers(lastComicId: 2000)
            }
            completion(randomNumbers)
        }
    }
    
    
    func arrayOfRandomNumbers(lastComicId:Int) -> [Int]{
        var randomNumbers = [Int]()
        for _ in 0...99{
              let randomNumber = Int.random(in: 1...lastComicId)
              randomNumbers.append(randomNumber)
          }
        print(randomNumbers)
        return randomNumbers
    }
    
    
    func getData(url:String, completion: @escaping (Error?, Comic?) -> Void) {
        if let url = URL(string: url) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
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
    
    
}

