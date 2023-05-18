//
//  Comic.swift
//  Shortcut.oppgave
//
//  Created by VP on 18/05/2023.
//

import Foundation

struct Comic:Codable{
    var num:Int
    var title: String
    var img:String
    var day: String
    var month:String
    var year: String
    var link: String
    var news: String
    var transcript: String
}
