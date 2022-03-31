//
//  AssetDetailView.swift
//  Kraken
//
//  Created by Michal Thompson on 01.03.22.
//

import SwiftUI

struct AssetDetailView: View {
    
    @ObservedObject var viewModel: AssetDetailViewModel
    
    var body: some View {
        
        VStack {
            Text("Altname: \(viewModel.assetPairDetails.altname ?? "")")
            Text("WSName: \(viewModel.assetPairDetails.wsname ?? "")")
            Text("Base: \(viewModel.assetPairDetails.base ?? "")")
            Text("Quote: \(viewModel.assetPairDetails.quote ?? "")")
            Text("Lot: \(viewModel.assetPairDetails.lot ?? "")")
            Text("Minimum Order: \(viewModel.assetPairDetails.ordermin ?? "")")
        }.navigationBarTitle(viewModel.assetPairDetails.altname ?? "Trading Pair")
        
        if let assetDetails = viewModel.assetDetails?.asset {
            
            let keys = assetDetails.map{$0.key}
            let values = assetDetails.map {$0.value}

            List {
                ForEach(keys.indices) {index in
                    Section {
                        let assetDetails = values[index]
                        Text("\(assetDetails.altname ?? "")")
                        VStack(alignment: .leading) {
                            Text("aClass: \(assetDetails.aclass  ?? "")")
                            Text("Decimals: \(String(values[index].decimals ?? 0))")
                            Text("Display Decimals: \(String(values[index].displayDecimals ?? 0))")
                        }
                    }
                }
            }
        }
    }
}
