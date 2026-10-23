//
//  Request.swift
//  ProductApp
//
//  Created by apple on 09/10/26.
//

import Foundation
struct ApiUrl{
    static let baseUrl = ""
}

enum RequestType:String{
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
struct RequestParam{
    var type:RequestType
    var path:String
    var body:[String:Any]?
    var queryString:[String:Any]?
    var header:[String:Any]?
}
protocol GenerateRequestProtocol{
    func createRequest(_ params:RequestParam)throws->URLRequest?
}

class GenerateRequest:GenerateRequestProtocol{
    private let baseUrl:String
    init(baseUrl:String){
        self.baseUrl = baseUrl
    }
    func createRequest(_ params: RequestParam) throws -> URLRequest? {
        let fullPath = baseUrl + params.path
        guard var completeUrl = URLComponents(string: fullPath) else{
            throw NetworkErrors.badUrl
        }
        if let qString = params.queryString , !qString.isEmpty{
            completeUrl.queryItems = qString.map { key,value in
                URLQueryItem(name: key, value: "\(value)")
            }
        }
        guard let url = completeUrl.url else {throw NetworkErrors.badUrl}
        
        var urlRequest:URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = params.type.rawValue
        if let body = params.body,!body.isEmpty{
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
        }
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let headers = params.header,!headers.isEmpty{
//            headers.map{key,value in
//                urlRequest.setValue("\(value)", forHTTPHeaderField: key)
//            }
            for (key,value) in headers{
                urlRequest.setValue("\(value)", forHTTPHeaderField: key)
            }
        }
        
        return urlRequest
    }
}
