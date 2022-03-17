//
//  GNBRatesFetcher.swift
//  GNB-trades
//
//  Created by Christian Polo on 12/3/22.
//

import Foundation

protocol RatesFetcher {
    func fetch(response: @escaping (NewRateList?) -> Void)
}

struct GNBRatesFetcher: RatesFetcher {
    
    let networking: Networking
    
    init(networking: Networking) {
        self.networking = networking
    }

    func fetch(response: @escaping (NewRateList?) -> Void) {
        networking.request(from: ServiceEndpoints.rates) { data, error in
            if let error = error {
                print("Error received requesting Rates: \(error.localizedDescription)")
                response(nil)
            }
            
            let decoded = self.decodeJSON(type: Rates.self, from: (data as! Data))
            if let decoded = decoded {
                response(ratesMatrix(array: decoded))
            }
        }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from,
              let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
    
    private func ratesMatrix(array: Rates) -> NewRateList {
        
        var rateList = NewRateList()
        for i in array{
            if rateList.isEmpty{
                let value = RateList()
                value.from = i.from
                value.conversion.append(.init(to: i.to, rate: i.rate))
                rateList.append(value)
            } else {
                let result = rateList.filter({$0.from == i.from})
                if result.isEmpty {
                    let value = RateList()
                    value.from = i.from
                    value.conversion.append(.init(to: i.to, rate: i.rate))
                    rateList.append(value)
                } else {
                    let indice = rateList.firstIndex(where: {$0.from == i.from})
                    rateList[indice ?? 0].conversion.append(.init(to: i.to, rate: i.rate))
                }
            }
        }
        return fillRatesMatrix(matrixToFill: rateList)
    }
    
    private func fillRatesMatrix(matrixToFill: NewRateList) -> NewRateList {
        //Rellenando los valores que no tengo para formar mi matriz NxN
        let rateList = matrixToFill
        for i in rateList {
            if (rateList.count - i.conversion.count) == 2{
                
                let toList = i.conversion.map({$0.to})
                let fromList = rateList.filter({$0.from != i.from}).map({$0.from})
                let valToEvaluate = fromList.difference(from: toList)[0]
                let listToEvaluate = rateList.filter({$0.from == valToEvaluate})[0].conversion[0]
                let x = Double(i.conversion.filter({$0.to == listToEvaluate.to})[0].rate)!
                let transform = x / Double(listToEvaluate.rate)!
                let value = RateList.Conversion(to: valToEvaluate, rate: String(transform))
                i.conversion.append(value)
                
                let valueToInsert = RateList.Conversion(to: i.from, rate: String(1/transform))
                rateList.filter({$0.from == valToEvaluate})[0].conversion.append(valueToInsert)
            }
        }
        return rateList
    }
}
