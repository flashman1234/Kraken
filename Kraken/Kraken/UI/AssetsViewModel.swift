//
//  AssetsViewModel.swift
//  Kraken
//
//  Created by Michal Thompson on 01.03.22.
//

import Foundation
import KrakenCore
import Combine

class AssetsViewModel: ObservableObject {
    
    @Published var assetPairs: AssetPairs?
    @Published var isLoading: Bool = true
    
    private var sinks = Set<AnyCancellable>()

    init() {
        getAssetPairs()
    }
}

extension AssetsViewModel {
    
    func getAssetPairs() {
        isLoading = true
        KrakenAPI.requestAssetPairs()
            .mapError({ (error) -> Error in
                print(error)
                return error
            }).sink(receiveCompletion: { _ in },
                  receiveValue: {
                self.assetPairs = $0
                self.isLoading = false
            }).store(in: &sinks)
    }
}
