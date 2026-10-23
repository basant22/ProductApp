//
//  TokenResponse.swift
//  ProductApp
//
//  Created by apple on 09/10/26.
//

import Foundation

struct TokenResponse:Decodable{
    var accessToken:String
    var refreshToken:String
}

struct Product:Decodable,Identifiable{
    var id:Int
    var name:String
    var category:String
}
struct Profile:Decodable{
    var name:String
    var image:String
    var email:String
}
