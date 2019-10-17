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
  
  struct AddNewCellTap: ProfilesAction { }
  
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
  
  struct DeleteCell: ProfilesAction {
    let index: Int
  }
  
  static func reduce(state: State, action: ProfilesAction) -> State {
    var newState = state
    
    switch action {
      
    case is AddNewCellTap:
      let selectedRooms = newState.profiles.map { $0.room.rawValue }
      let availableRooms = MeetingRooms.rooms.filter { !selectedRooms.contains($0) }
      let profile = ProfileInfo(
        name: ProfileInfo.Name(rawValue: ""),
        surname: ProfileInfo.Surname(rawValue: ""),
        room: ProfileInfo.Room(rawValue: ""),
        diffID: UUID().uuidString)
      
      newState.profiles.append(profile)
      newState.availableRooms = availableRooms
      newState.validatedCells = newState.profiles.map(HelperFunctions.validate)
      
    case let action as UpdateName:
      guard let index = action.index else { break }
      newState.profiles[index].name = action.name
      
    case let action as UpdateSurname:
      guard let index = action.index else { break }
      newState.profiles[index].surname = action.surname
      
    case let action as UpdateRoom:
      guard let index = action.index else { break }
      newState.profiles[index].room = action.room
      
    case let action as DeleteCell:
      let room = state.profiles[action.index].room.rawValue
      if !room.isEmpty {
        newState.availableRooms.append(room)
      }
      if newState.profiles[action.index] != newState.profiles.last {
        newState.validatedCells.remove(at: action.index)
      }
      newState.profiles.remove(at: action.index)
      
    default:
      break
    }
    
    return newState
  }
}
