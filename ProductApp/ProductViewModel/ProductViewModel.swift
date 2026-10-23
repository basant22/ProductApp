//
//  ProductViewModel.swift
//  ProductApp
//
//  Created by apple on 09/10/26.
//

import Foundation

enum ProductStatus{
    case notStarted
    case started
    case completed
    case failed(String)
}
protocol ProductViewModelProtocol{
    func getAllProducts(request:[String:Any])async
}

class ProductViewModel:ProductViewModelProtocol,ObservableObject{
    var repo:ProductRepoProtocol
    @Published var status:ProductStatus = .notStarted
    @Published var products:[Product]?
    init(repo:ProductRepoProtocol = ProductRepo.defaultRepo){
        self.repo = repo
    }
    func getAllProducts(request:[String:Any])async {
        do{
            DispatchQueue.main.async {[weak self] in
                self?.status = .started
            }
            let prod = try await repo.getProduct(req: request)
            
            DispatchQueue.main.async {[weak self] in
                self?.status = .completed
                self?.products = prod
            }
        }catch{
            status = .failed(error.localizedDescription)
        }
        
    }
}
