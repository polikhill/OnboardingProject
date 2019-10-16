//
//  ProfilesViewController.swift
//  OnboardingProject
//
//  Created by Polina Hill on 10/9/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfilesViewController: UIViewController {

    let contentView = ProfilesView()
    let disposeBag = DisposeBag()
    let viewModel: ProfilesList.ProfilesViewModel
  
    init() {
        viewModel = ProfilesList.ProfilesViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    private func setupBindings() {
      
        let inputs = ProfilesList.ProfilesViewModel.Inputs(
            viewWillAppear: rx.methodInvoked(#selector(viewWillAppear(_:))).voidValues(),
            addNewCell: contentView.rx.addNewCell,
            nameSubject: contentView.nameSubject,
            surnameSubject: contentView.surnameSubject,
            roomSubject: contentView.roomSubject
        )
      
      let outputs = viewModel.makeOutputs(from: inputs)
      
      outputs.props
        .observeForUI()
        .subscribe(onNext: { [unowned self ] props in
          self.contentView.render(props: props)
        })
        .disposed(by: disposeBag)
      
      outputs.stateChanged
        .subscribe()
        .disposed(by: disposeBag)
  }
}
