//
//  BankingServicesViewController.swift
//  banking-services
//
//  Created by Patsicha Tongteeka on 9/18/19.
//  Copyright (c) 2019 Patsicha Tongteeka. All rights reserved.
//

import UIKit

protocol BankingServicesViewControllerInterface: class {
  func displaySomething(viewModel: BankingServices.Something.ViewModel)
}

class BankingServicesViewController: UIViewController, BankingServicesViewControllerInterface {
  var interactor: BankingServicesInteractorInterface!
  var router: BankingServicesRouter!

  // MARK: - Object lifecycle

  override func awakeFromNib() {
    super.awakeFromNib()
    configure(viewController: self)
  }

  // MARK: - Configuration

  private func configure(viewController: BankingServicesViewController) {
    let router = BankingServicesRouter()
    router.viewController = viewController

    let presenter = BankingServicesPresenter()
    presenter.viewController = viewController

    let interactor = BankingServicesInteractor()
    interactor.presenter = presenter
    interactor.worker = TileWorker(store: TileJsonStore())

    viewController.interactor = interactor
    viewController.router = router
  }

  // MARK: - View lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    doSomethingOnLoad()
  }

  // MARK: - Event handling

  func doSomethingOnLoad() {
    // NOTE: Ask the Interactor to do some work

    let request = BankingServices.Something.Request()
    interactor.doSomething(request: request)
  }

  // MARK: - Display logic

  func displaySomething(viewModel: BankingServices.Something.ViewModel) {
    // NOTE: Display the result from the Presenter

    // nameTextField.text = viewModel.name
  }

  // MARK: - Router

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    router.passDataToNextScene(segue: segue)
  }

  @IBAction func unwindToBankingServicesViewController(from segue: UIStoryboardSegue) {
    print("unwind...")
    router.passDataToNextScene(segue: segue)
  }
}
