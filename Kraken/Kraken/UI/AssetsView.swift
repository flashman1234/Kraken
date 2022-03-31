//
//  AssetsView.swift
//  Kraken
//
//  Created by Michal Thompson on 01.03.22.
//

import SwiftUI

struct AssetsView: View {
    
    @ObservedObject var viewModel: AssetsViewModel
//    This is the timer that 'works, but in the time I had, I couldn't work out a
//    neat way of pausing/restarting it.
    @State private var timer = Timer.publish(every: 6, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        let assetPairs = viewModel.assetPairs?.result.sorted { $0.key < $1.key }
        let keys = assetPairs?.map{$0.key}
        let values = assetPairs?.map {$0.value}
        NavigationView {
            VStack {
                List {
                    ForEach(0..<(keys?.count ?? 0), id: \.self) { index in
                        
                        if let ass = values?[index] {
                            let assetDetailViewModel = AssetDetailViewModel(assetPairDetails: ass)
                            
                            NavigationLink(destination: AssetDetailView(viewModel: assetDetailViewModel)) {
                                let assvm = AssetCellViewModel(assetPairDetails: ass)
                                AssetCellView(viewModel: assvm)
                                    
                            }
                        }
                    }
                }
//                .onReceive(timer) { time in
//                    print("refreshed at \(time)")
//                    viewModel.assetPairs = nil
//
//                    viewModel.getAssetPairs()
//                }
                .refreshable {  // yay for ios 15, even if refreshable is a bit buggy
                    
                    viewModel.assetPairs = nil
                    viewModel.getAssetPairs()
                }.navigationBarTitle(LocalizedStringKey("Trading pairs")) //todo: localize
                    .overlay(ProgressView()
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 10)
                                .opacity(viewModel.isLoading ? 1 : 0))
            }
        }.navigationViewStyle(.stack)
    }

}

struct AssetsView_Previews: PreviewProvider {
    static var previews: some View {
        AssetsView(viewModel: AssetsViewModel())
    }
}
