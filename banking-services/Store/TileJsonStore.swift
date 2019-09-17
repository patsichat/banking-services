//
//  TileJsonStore.swift
//  banking-services
//
//  Created by Patsicha Tongteeka on 9/17/19.
//  Copyright (c) 2019 Patsicha Tongteeka. All rights reserved.
//

import Foundation

/*
 
 The TileJsonStore class implements the TileStoreProtocol.
 
 The source for the data could be a database, cache, or a web service.
 
 You may remove these comments from the file.
 
 */

class TileJsonStore: TileStoreProtocol {
    func getTiles(_ completion: @escaping (Result<[Tile]>) -> Void) {
        completion(loadJsonFrom(filename: "tiles", for: [Tile].self))
    }
    
    private func loadJsonFrom<T: Codable>(filename: String, for type: T.Type) -> Result<T> {
        if let path = Bundle.main.path(forResource: filename, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let result = try JSONDecoder().decode(type, from: data)
                return .success(result: result)
            } catch let error {
                print(error)
                return .failure(error: error)
            }
        }
        return .failure(error: ReturnError.invalidJSON)
    }
}
