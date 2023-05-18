//
//  DataManager.swift
//  Shortcut.oppgave
//
//  Created by VP on 18/05/2023.
//

import Foundation


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
