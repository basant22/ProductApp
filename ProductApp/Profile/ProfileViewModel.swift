//
//  ProfileViewModel.swift
//  ProductApp
//
//  Created by apple on 12/10/26.
//

import Foundation

class ProfileViewModel:ObservableObject{
    private let prodRepo:ProductRepoProtocol
    @Published var myProduct:[Product] = []
    @Published var myProfile:Profile?
    @Published var isLoading:Bool = false
    @Published var isError:String = ""
    init(prodRepo:ProductRepoProtocol){
        self.prodRepo = prodRepo
    }
  
    func getAllProduct() async throws{
        let req = ["numProd":20]
        let prod = try await prodRepo.getProduct(req: req)
        myProduct = prod
    }
    func getProfileData() async throws{
        let req = ["numProd":20]
        let prof = try await prodRepo.getProfile(req: req)
        myProfile = prof
    }
    
    func getProductAndProfile()async throws{
        async let product:Void = getAllProduct()
        async let profile:Void = getProfileData()
        let _ = try await (product,profile)
    }
    func getProductAndProfile1()async throws{
        async let product = try await prodRepo.getProduct(req: ["numProd":20])
        async let profile = try await prodRepo.getProfile(req: ["id":2])
        let (prod,prof) = try await (product,profile)
        self.myProduct = prod
        self.myProfile = prof
    }
    func getProductAndProfile3()async throws{
       try await withThrowingTaskGroup(of:Void.self){ group in
            group.addTask {
                try await self.getAllProduct()
            }
            group.addTask {
                try await self.getProfileData()
            }
            try await group.waitForAll()
        }
    }
}
