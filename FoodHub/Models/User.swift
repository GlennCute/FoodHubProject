//
//  User.swift
//  FoodHub
//
//  Created by OPSolutions on 2/6/22.
//

import Foundation

struct roomName: Codable {
    
    var names: String = ""

}

struct UserInfo {
    
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var password: String = ""
    var houseNumber:String = ""
    var streetNumber:String = ""
    var streetName:String = ""
    var district:String = ""
    var city:String = ""
    var postalCode:String = ""
    var longitude: Double = 0
    var latitude: Double = 0
}



