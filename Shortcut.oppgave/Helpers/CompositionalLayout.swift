//
//  CompositionalLayout.swift
//  Shortcut.oppgave
//
//  Created by VP on 18/05/2023.
//
import Foundation
import UIKit

enum CompositionalGroupAligment {
    case vertical
    case horizontal
}

struct CompositionalLayout{
    
    static func createItem(width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension, size: CGFloat ) -> NSCollectionLayoutItem{
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height))
        item.contentInsets = NSDirectionalEdgeInsets(top: size, leading:size, bottom: size, trailing: size)
        return item
    }
    
    static func createGroup(aligment: CompositionalGroupAligment, width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension, items:[NSCollectionLayoutItem] )->NSCollectionLayoutGroup{
  
        
        switch aligment{
        case .vertical:
            return NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height), subitems: items)
        case .horizontal:
            return NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height),  subitems: items)
        }
    }
    
    
    static func createGroup(aligment: CompositionalGroupAligment, width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension, item:NSCollectionLayoutItem, count: Int )->NSCollectionLayoutGroup{
  
        
        switch aligment{
        case .vertical:
            return NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height), subitem: item, count: count)
        case .horizontal:
            return NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height),  subitem: item, count: count)
        }
    }
}
