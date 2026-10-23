//
//  ProductView.swift
//  ProductApp
//
//  Created by apple on 21/10/26.
//

import SwiftUI

struct ProductView: View {
    @StateObject var vieModel:ProductViewModel = ProductViewModel()
    var body: some View {
        Group{
            switch vieModel.status{
            case .started,.notStarted:
                VStack(spacing: 12) {
                                    ProgressView()
                                    Text("Loading products…")
                                }
            case .completed:
                if let prod = vieModel.products, let _ =  prod.isEmpty{
                    VStack(spacing: 12) {
                        ProgressView()
                        Text("Loading products…")
                    }
                }else{
                    ForEach(vieModel.products ?? []){ prod in
                        Text(prod.name)
                    }
                }
            case .failed(let err):
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundStyle(.red)
                    Text(err)
                        .multilineTextAlignment(.center)
                    Button("Retry") {
                        Task { await vieModel.getAllProducts(request: [:]) }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
        }
        .task {
            
                await vieModel.getAllProducts(request: ["":""])
            
        }
    }
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductView()
    }
}
