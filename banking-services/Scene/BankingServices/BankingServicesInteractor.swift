//
//  BankingServicesInteractor.swift
//  banking-services
//
//  Created by Patsicha Tongteeka on 9/18/19.
//  Copyright (c) 2019 Patsicha Tongteeka. All rights reserved.
//

import UIKit

protocol BankingServicesInteractorInterface {
  func doSomething(request: BankingServices.Something.Request)
}

class BankingServicesInteractor: BankingServicesInteractorInterface {
  var presenter: BankingServicesPresenterInterface!
  var worker: TileWorker?

  // MARK: - Business logic

  func doSomething(request: BankingServices.Something.Request) {
    
  }
}
