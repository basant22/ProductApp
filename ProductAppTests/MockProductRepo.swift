//
//  MockProductRepo.swift
//  ProductAppTests
//
//  Created by apple on 12/10/26.
//

import Foundation
@testable import ProductApp

class MockProductRepo:ProductRepoProtocol{
    let api:NetworkManagerProtocol
    init(api:NetworkManagerProtocol = MockApiCaller()){
        self.api = api
    }
    var mockProducts: [Product] = []
    var mockProfile: Profile?
    var shouldReturnError = false
    func getProduct(req: [String : Any]) async throws -> [Product] {
        if shouldReturnError{
            throw NSError(domain: "TestError", code: -1, userInfo: nil)
        }
        guard let url = URL(string: "http://google.com") else {
            throw NSError(domain: "badUrl", code: -1, userInfo: nil)
        }
        return try await api.startApiCall(URLRequest(url: url))
        
    }
    
    func getProfile(req: [String : Any]) async throws -> Profile {
        if shouldReturnError{
            throw NSError(domain: "TestError", code: -1, userInfo: nil)
        }
        guard let profile = mockProfile else {
            throw NSError(domain: "TestError", code: -1, userInfo: nil)
        }
        return profile
    }
}
