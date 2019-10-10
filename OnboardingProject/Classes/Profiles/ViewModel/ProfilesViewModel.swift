//
//  ProfilesViewModel.swift
//  OnboardingProject
//
//  Created by Polina Hill on 10/10/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import Foundation
import RxSwift

extension ProfilesList {
    
    final class ProfilesViewModel {
        
        struct Inputs {
            let viewWillAppear: Observable<Void>
            let addNewCell: Observable<Void>
        }
        
        struct Outputs {
            let props: Observable<DiffableBox<ProfilesView.Props>>
            let stateChanged: Observable<Void>
        }
        
        func makeOutputs(from inputs: Inputs) -> Outputs {
            let initialState = State(
                profiles: []
            )
            
            let store = Store(initialState: initialState, reducer: ProfilesList.reduce, middlewares: [])
            
            let props = store.state
                .map(ProfilesList.makeProfileViewProps)
            
            let actionCreator = ActionCreator(inputs: inputs)
            
            let stateChanges = actionCreator.actions
                .do(onNext: store.dispatch)
                .voidValues()

            return Outputs(
                props: props,
                stateChanged: stateChanges
            )
        }
    }
}
