//
//  api.swift
//  FoodHub
//
//  Created by OPSolutions on 2/10/22.
//

import Foundation

struct CategoryList:Codable {

    var categories: [Categories]

}

struct Categories: Codable {
    
    var idCategory: String
    var strCategory: String
    var strCategoryThumb: String
    var strCategoryDescription: String
       
   }
