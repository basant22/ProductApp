//
//  MockApiCaller.swift
//  ProductAppTests
//
//  Created by apple on 12/10/26.
//

import Foundation
@testable import ProductApp

class MockApiCaller:NetworkManagerProtocol{
    func startApiCall<T>(_ request: URLRequest) async throws -> T where T : Decodable {
        let bundel = Bundle.main
        guard let url = bundel.url(forResource: "prod", withExtension: "json") else{
            throw NSError(domain: "ApiError", code: -3, userInfo: ["":""])
        }
        
        let jsonObj = try Data(contentsOf: url)
        
        let json = try JSONDecoder().decode(T.self, from: jsonObj)
        return json
    }
    
}
