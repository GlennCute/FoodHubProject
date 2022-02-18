//
//  api Model.swift
//  FoodHub
//
//  Created by OPSolutions on 2/10/22.
//

import Foundation
struct MealsList:Codable {

    var meals: [MealsData]

}

struct MealsData: Codable {
    
    var idMeal: String
    var strMeal: String
    var strMealThumb: String

}

