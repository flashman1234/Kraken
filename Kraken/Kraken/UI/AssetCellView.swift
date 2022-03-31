//
//  AssetCellView.swift
//  Kraken
//
//  Created by Michal Thompson on 01.03.22.
//

import SwiftUI
import KrakenCore

struct AssetCellView: View {
    
    @ObservedObject var viewModel: AssetCellViewModel
    
    var body: some View {
        
        LazyVStack(alignment: .leading) {
            Text("\(viewModel.assetPairDetails.altname ?? "")").font(.headline)
            Text("Last Trade: \(tradeDetailDateAsString() ?? "")").font(.subheadline)
            Text("Volume: \(tradeVolumeAsString() ?? "")").font(.subheadline)
        }
        .onAppear {
            if let assetName = viewModel.assetPairDetails.altname {
                viewModel.getTrades(pair: assetName)
            }
        }
    }
    
// TODO: move to viewmodel
    private func tradeVolumeAsString() -> String? {
        
        let oneDayAgo = Calendar.current.date(
          byAdding: .day,
          value: -1,
          to: Date())
             
        // get all trades one day ago
        let filtered = viewModel.trades?.result.tradeDetails.filter { tradeDetails in
            return tradeDetails.time ?? 0 > oneDayAgo?.timeIntervalSince1970 ?? 0
        }
        
        // sum of all trades
        let total = filtered?.reduce(0, {
            $0 + (Double($1.volume ?? "") ?? 0)
        })
        if let tot = total {
            return String(tot)
        }
        
        return nil
    }
    
    // TODO: move to viewmodel
    private func tradeDetailDateAsString() -> String? {
        
        // trades are returned as newest is last, so we have to reverse, then take the first
        if let something = viewModel.trades?.result.tradeDetails.reversed().first?.time {
            let myDate = Date(timeIntervalSince1970: something)
            return Date.myFormatter.string(from: myDate)
        }
        return nil
    }
}

// if this formatter was to be used elsewhere, I would move into separate file.
extension Date {
   static var myFormatter: DateFormatter = {
       let formatter = DateFormatter()
       formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
       return formatter
   }()
}
