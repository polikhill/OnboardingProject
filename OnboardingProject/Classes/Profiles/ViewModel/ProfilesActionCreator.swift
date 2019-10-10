//
//  ProfilesActionCreator.swift
//  OnboardingProject
//
//  Created by Polina Hill on 10/10/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import Foundation
import RxSwift

extension ProfilesList {
    
    final class ActionCreator {
        let actions: Observable<ProfilesAction>
        
        init(inputs: ProfilesViewModel.Inputs) {
            let addNewCellAction = inputs.addNewCell
                .map ({ _ -> ProfilesAction in
                    return ProfilesList.AddNewProfile(profile: "")
                })
            
            self.actions = Observable.merge(
                addNewCellAction
            )
        }
    }
}
