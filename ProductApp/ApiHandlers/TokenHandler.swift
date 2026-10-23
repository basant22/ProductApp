//
//  TokenHandler.swift
//  ProductApp
//
//  Created by apple on 09/10/26.
//

import Foundation

protocol TokenHandlerProtocol{
    func checkValidity(_ token:String)async ->Bool
    func fetchNewToken(_ refreshToken:String)async throws -> TokenResponse
    func getValidAccessToken()async throws->String?
}

actor TokenHandler:TokenHandlerProtocol{
  
    private let api:NetworkManagerProtocol
    private let reqMaker:GenerateRequestProtocol
    var refreshTask:Task<TokenResponse,Error>?
    init(api:NetworkManagerProtocol,reqMaker:GenerateRequestProtocol){
        self.api = api
        self.reqMaker = reqMaker
    }
    
    func getValidAccessToken()async throws->String?{
        if let token = UserDefaults.standard.value(forKey: "ACCESS") as? String{
            let status = await checkValidity(token)
            if status{
                return token
            }else{
                if let refreshToken = UserDefaults.standard.value(forKey: "REFRESH") as? String{
                    guard let response:TokenResponse = try? await fetchNewToken(refreshToken) else{
                        return nil
                    }
                    return response.accessToken
                }
            }
        }
        return nil
    }
    func fetchNewToken(_ refreshToken: String) async throws -> TokenResponse{
        if let ongoingTask = refreshTask{
           return try await ongoingTask.value
        }
        
        let body = ["refreshToken":"hghgakjhgkjhg.gjhhgkjhgl.hgkhgk"]
        let req = RequestParam(type: .post, path: "/refreshToken", body:body)
        guard let urlReq = try reqMaker.createRequest(req)else {
            throw NetworkErrors.badRequest
        }
        let task = Task<TokenResponse,Error>{
        let tokens:TokenResponse = try await api.startApiCall(urlReq)
       
        UserDefaults.standard.set(tokens.accessToken, forKey:  "ACCESS")
        UserDefaults.standard.set(tokens.refreshToken , forKey: "REFRESH")
        return tokens
        }
        
        self.refreshTask = task
        
        defer{
            self.refreshTask = nil
        }
        
        let result = try await task.value
        return result
    }
    
     func checkValidity(_ token: String)async -> Bool {
         guard let expDate = getExpirationDate(from: token) else{
             return false
         }
         let bufferSeconds:TimeInterval = 60
         return Date().addingTimeInterval(TimeInterval(bufferSeconds))<expDate
    }
    
    private func getExpirationDate(from Jwt:String)->Date?{
        let parts = Jwt.components(separatedBy: ".")
        guard parts.count>=2 else {return nil}
        
        var bas64 = parts[1]
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "-", with: "/")
        
        let length = bas64.count
        if length%4 == 0{
            bas64.append(String(repeating: "=", count: 4 - (length%4)))
        }
        
       guard let data = Data(base64Encoded: bas64),
             let json = try? JSONSerialization.data(withJSONObject: data) as? [String:Any],
             let expDate = json["exp"] as? TimeInterval else {return nil}
        
        return Date(timeIntervalSince1970: expDate)
    }
}
