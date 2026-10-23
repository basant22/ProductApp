//
//  ApiHandler.swift
//  ProductApp
//
//  Created by apple on 09/10/26.
//

import Foundation

enum NetworkErrors:Error,LocalizedError{
    case badUrl
    case badRequest
    case unauthorized
    case responseError
    case invlidToken
    
    var errorDescription: String?{
        switch self {
        case .badUrl:
            return "This not a valid url"
        case .badRequest:
            return "Please create a valid request"
        case .unauthorized:
            return "You are an anauthorize user"
        case .responseError:
            return "There is some issue in json formating"
        case .invlidToken:
            return "Youe access token is expired"
        }
    }
}

protocol NetworkManagerProtocol{
    func startApiCall<T:Decodable>(_ request:URLRequest)async throws ->T
}

class NetworkManager:NetworkManagerProtocol{
    
    
    func startApiCall<T:Decodable>(_ request: URLRequest) async throws-> T{
          
//        guard let accessToken = try? await tokenManager.getValidAccessToken() else{
//            throw NetworkErrors.invlidToken
//        }
//        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let (data,response) = try await URLSession.shared.data(for: request)
        
        guard let respo = response as? HTTPURLResponse else {throw NetworkErrors.badRequest}
        
        switch respo.statusCode{
        case 200..<300:
            do {
                let responseData = try JSONDecoder().decode(T.self, from: data)
                return responseData
            } catch  {
                throw NetworkErrors.responseError
            }
        case 401:
            throw NetworkErrors.unauthorized
            
        default:
            throw NetworkErrors.responseError
        }
    }
}
