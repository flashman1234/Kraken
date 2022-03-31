//
//  AssetDetailViewModel.swift
//  Kraken
//
//  Created by Michal Thompson on 01.03.22.
//

import Foundation
import Combine
import KrakenCore

class AssetDetailViewModel: ObservableObject {
    var cancellationToken: AnyCancellable?
    @Published public var assetPairDetails: AssetPairDetails
    
    @Published public var assetDetails: AssetDetails?
    
    init(assetPairDetails: AssetPairDetails) {
        self.assetPairDetails = assetPairDetails
        getAssetDetails()
    }
}

extension AssetDetailViewModel {
    
    func getAssetDetails() {
        guard let wsName = assetPairDetails.wsname,
              let firstName = wsName.components(separatedBy: "/").first,
              let secondName = wsName.components(separatedBy: "/").last else { return }
        cancellationToken = KrakenAPI.requestAssetDetails(firstAsset: firstName, secondAsset: secondName)
            .mapError({ (error) -> Error in
                print(error)
                return error
            }).receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: {
                self.assetDetails = $0
            })
    }
}
