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
    var profiles: [ProfileInfo]
    var availableRooms: [String]
    var invalidProfiles: [Int]
  }
  
  struct InialSetup: ProfilesAction { }
  
  struct AddNewCellTap: ProfilesAction { }
  
  struct AddNewProfile: ProfilesAction {
    let profile: ProfileInfo
  }
  
  struct ValidationaPassed: ProfilesAction { }
  
  struct ValidationFailed: ProfilesAction {
    let indexes: [Int]
  }
  
  static func reduce(state: State, action: ProfilesAction) -> State {
    var newState = state
    
    switch action {
    case is AddNewCellTap:
      guard let lastProfile = newState.profiles.first, let index = newState.availableRooms.firstIndex(of: lastProfile.room) else { break }
      newState.availableRooms.remove(at: index)
    case let action as AddNewProfile:
      newState.profiles.insert(action.profile, at: 0)
    default:
      break
    }
    
    return newState
  }
}
