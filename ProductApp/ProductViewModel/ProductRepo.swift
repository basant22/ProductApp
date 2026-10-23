//
//  ProductRepo.swift
//  ProductApp
//
//  Created by apple on 09/10/26.
//

import Foundation
protocol ProductRepoProtocol{
    func getProduct(req:[String:Any])async throws ->[Product]
    func getProfile(req:[String:Any])async throws ->Profile 
}
class ProductRepo:ProductRepoProtocol{
    let api:NetworkManagerProtocol
    let reqMaker:GenerateRequestProtocol
    let tokenManager:TokenHandlerProtocol
    
    init(api:NetworkManagerProtocol,reqMaker:GenerateRequestProtocol,tokeManager:TokenHandlerProtocol){
        self.api = api
        self.reqMaker = reqMaker
        self.tokenManager = tokeManager
    }
    static let defaultRepo:ProductRepoProtocol = {
        let network = NetworkManager()
        let request = GenerateRequest(baseUrl: ApiUrl.baseUrl)
        let tokenH = TokenHandler(api: network, reqMaker: request)
        
        return ProductRepo(
            api:network,
            reqMaker:request,
            tokeManager:tokenH
        )
    }()
    
    func getProduct(req:[String:Any])async throws ->[Product] {
        guard let acceccToken = try await tokenManager.getValidAccessToken() else{
            throw NetworkErrors.invlidToken
        }
        let reqParam = RequestParam(
            type:.get,
            path: "/allProducts",
            body: req,
            header:["Authorization":acceccToken]
        )
        
        guard let urlReq = try? reqMaker.createRequest(reqParam) else{
            throw NetworkErrors.badRequest
        }
        return try await api.startApiCall(urlReq)
    }
    func getProfile(req:[String:Any])async throws ->Profile {
        guard let acceccToken = try await tokenManager.getValidAccessToken() else{
            throw NetworkErrors.invlidToken
        }
        let reqParam = RequestParam(
            type:.get,
            path: "/profile",
            body: req,
            header:["Authorization":acceccToken]
        )
        
        guard let urlReq = try? reqMaker.createRequest(reqParam) else{
            throw NetworkErrors.badRequest
        }
        return try await api.startApiCall(urlReq)
    }
}
