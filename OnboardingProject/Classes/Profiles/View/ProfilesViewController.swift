//
//  ProfilesViewController.swift
//  OnboardingProject
//
//  Created by Polina Hill on 10/9/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import UIKit
import RxSwift

final class ProfilesViewController: UIViewController {

    private let contentView = ProfilesView()
    private let disposeBag = DisposeBag()
    
    struct Props {
        let contentViewProps: ProfilesView.Props
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.render(props: ProfilesView.Props())
    }
}
