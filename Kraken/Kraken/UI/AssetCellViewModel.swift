//
//  AssetCellViewModel.swift
//  Kraken
//
//  Created by Michal Thompson on 01.03.22.
//

import Foundation
import KrakenCore
import Combine

class AssetCellViewModel: ObservableObject {
    
    @Published var trades: Trades?
    var assetPairDetails: AssetPairDetails
    
    private var sinks = Set<AnyCancellable>()
    
    init(assetPairDetails: AssetPairDetails) {
        self.assetPairDetails = assetPairDetails
    }
}

extension AssetCellViewModel {
    
    func getTrades(pair: String) {
        KrakenAPI.requestTrades(pair: pair)
            .mapError({ (error) -> Error in
                print(error)
                return error
            }).receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: {
                    self.trades = $0
            }).store(in: &sinks)
    }
}
