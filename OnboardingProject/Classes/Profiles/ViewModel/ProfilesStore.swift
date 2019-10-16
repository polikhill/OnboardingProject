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
    var validatedCells: [ProfileCell.ValidationState]
    var sectionsID: String
  }
  
  struct InialSetup: ProfilesAction {
    let id: String
  }
  
  struct AddNewCellTap: ProfilesAction { }
  
  struct AddNewProfile: ProfilesAction {
    let profile: ProfileInfo
    let availableRooms: [String]
  }
  
  struct UpdateName: ProfilesAction {
    let name: ProfileInfo.Name
    let index: Int?
  }
  
  struct UpdateSurname: ProfilesAction {
    let surname: ProfileInfo.Surname
    let index: Int?
  }
  
  struct UpdateRoom: ProfilesAction {
    let room: ProfileInfo.Room
    let index: Int?
  }
  
  struct Validate: ProfilesAction {
    let validatedCells: [ProfileCell.ValidationState]
  }
  
  struct DeleteCell: ProfilesAction {
    let index: Int
  }
  
  struct UpdateState: ProfilesAction {
    let state: State
  }
  
  static func reduce(state: State, action: ProfilesAction) -> State {
    var newState = state
    
    switch action {
      
    case let action as InialSetup:
      newState.sectionsID = action.id
      
    case let action as AddNewProfile:
      newState.profiles.append(action.profile)
      newState.availableRooms = action.availableRooms
      
    case let action as Validate:
      newState.validatedCells = action.validatedCells
      
    case let action as UpdateName:
      guard let index = action.index else { break }
      newState.profiles[index].name = action.name

    case let action as UpdateSurname:
      guard let index = action.index else { break }
      newState.profiles[index].surname = action.surname

    case let action as UpdateRoom:
      guard let index = action.index else { break }
      newState.profiles[index].room = action.room
      
    case let action as UpdateState:
      newState = action.state
      
    default:
      break
    }
    
    return newState
  }
}
