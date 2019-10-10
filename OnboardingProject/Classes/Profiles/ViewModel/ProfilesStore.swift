//
//  ProfilesStore.swift
//  OnboardingProject
//
//  Created by Polina Hill on 10/10/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import Foundation

extension ProfilesList {
    
    typealias Store = ReduxStore<State, ProfilesAction>
    
    struct State {
        var profiles: [String]
    }
    
    struct AddNewCellTap: ProfilesAction { }
    
    struct AddNewProfile: ProfilesAction {
        let profile: String
    }
    
    struct ValidationaPassed: ProfilesAction { }
    
    struct ValidationFailed: ProfilesAction {
        let index: Int
    }

    static func reduce(state: State, action: ProfilesAction) -> State {
        var newState = state
        
        switch action {
        case let action as AddNewProfile:
            newState.profiles.insert(action.profile, at: 0)
        default:
            break
        }
        
        return newState
    }
}
