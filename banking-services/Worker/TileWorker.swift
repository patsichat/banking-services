//
//  TileWorker.swift
//  banking-services
//
//  Created by Patsicha Tongteeka on 9/17/19.
//  Copyright (c) 2019 Patsicha Tongteeka. All rights reserved.
//

import UIKit

protocol TileStoreProtocol {
  func getTiles(_ completion: @escaping (Result<[Tile]>) -> Void)
}

class TileWorker {

  var store: TileStoreProtocol

  init(store: TileStoreProtocol) {
    self.store = store
  }

  // MARK: - Business Logic

  func getTiles(_ completion: @escaping (UserResult<[Tile]>) -> Void)  {
    store.getTiles { (result) in
        completion(result.userResult())
    }
  }
}
