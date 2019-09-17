//
//  BankingServicesPresenter.swift
//  banking-services
//
//  Created by Patsicha Tongteeka on 9/18/19.
//  Copyright (c) 2019 Patsicha Tongteeka. All rights reserved.
//

import UIKit

protocol BankingServicesPresenterInterface {
  func presentSomething(response: BankingServices.Something.Response)
}

class BankingServicesPresenter: BankingServicesPresenterInterface {
  weak var viewController: BankingServicesViewControllerInterface!

  // MARK: - Presentation logic

  func presentSomething(response: BankingServices.Something.Response) {
    // NOTE: Format the response from the Interactor and pass the result back to the View Controller. The resulting view model should be using only primitive types. Eg: the view should not need to involve converting date object into a formatted string. The formatting is done here.

    let viewModel = BankingServices.Something.ViewModel()
    viewController.displaySomething(viewModel: viewModel)
  }
}
