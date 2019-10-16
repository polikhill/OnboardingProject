//
//  ProfilesMiddleware.swift
//  OnboardingProject
//
//  Created by Polina Hill on 10/11/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import Foundation

extension ProfilesList {
  static func makeAddNewCellMiddleware() -> Store.Middleware {
    var index = 0
    return Store.makeMiddleware { dispatch, store, next, action in
      next(action)
      let store = store()
      
      guard action is AddNewCellTap, store.availableRooms.count > 0 else {
        return
      }
      
      let selectedRooms = store.profiles.map { $0.room.rawValue }
      let availableRooms = MeetingRooms.rooms.filter { !selectedRooms.contains($0) }
      
      let addProfileAction = ProfilesList.AddNewProfile(
        profile: ProfileInfo(
          name: ProfileInfo.Name(rawValue: "\(index)"),
          surname: ProfileInfo.Surname(rawValue: ""),
          room: ProfileInfo.Room(rawValue: ""),
          diffID: UUID().uuidString),
        availableRooms: availableRooms
      )
      dispatch(addProfileAction)
      
      index += 1
    }
  }
  
  static func makeValidationMiddleware() -> Store.Middleware {
    return Store.makeMiddleware { dispatch, store, next, action in
      next(action)
      let profiles = store().profiles
      
      guard action is AddNewCellTap, !profiles.isEmpty else { 
        return
      }
      
      let validatedCells = profiles.map(HelperFunctions.validate)
      dispatch(ProfilesList.Validate(validatedCells: validatedCells))
    }
  }
}
