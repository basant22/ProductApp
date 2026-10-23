//
//  ProfileViewModelTest.swift
//  ProductAppTests
//
//  Created by apple on 12/10/26.
//

import XCTest
@testable import ProductApp

class ProfileViewModelTest: XCTestCase {
    var sut:ProfileViewModel!
    var mockRepo:MockProductRepo!
    override func setUp() {
        super.setUp()
        mockRepo = MockProductRepo()
        sut = ProfileViewModel(prodRepo: mockRepo)
    }
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
       
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        mockRepo = nil
       try super.tearDownWithError()
    }
    func testGetAllProduct_Success() async throws {
        //Given
        let expectedProd = Product(id: 1, name: "TubeLight", category: "Electrical")
        mockRepo.mockProducts = [expectedProd]
        //When
        try await sut.getAllProduct()
        
        //Then
        XCTAssertEqual(sut.myProduct.count, 1)
        XCTAssertEqual(sut.myProduct.first?.id, expectedProd.id)
        
    }
    
    func testProduct_Failure() async throws{
        mockRepo.shouldReturnError = true
        
        do {
            try await sut.getAllProduct()
            XCTFail("Expected error to be thrown,but function succeed")
        } catch  {
            XCTAssertNotNil(error)
        }
    }
    

}
