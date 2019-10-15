//
//  ProfilesMiddleware.swift
//  OnboardingProject
//
//  Created by Polina Hill on 10/11/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ProfilesList {
  static func makeAddNewCellMiddleware() -> Store.Middleware {
    let disposeBag = DisposeBag()
    var i = 0
    return Store.makeMiddleware { dispatch, store, next, action in
      next(action)
      let store = store()
      
      guard action is AddNewCellTap, store.availableRooms.count > 0 else {
        return
      }
      
      let selectedRooms = store.profiles.map { $0.room }
      let availableRooms = MeetingRooms.rooms.filter { !selectedRooms.contains($0) }
      
      Observable.just(())
        .map({ _ -> ProfilesAction in
          return ProfilesList.AddNewProfile(profile: ProfileInfo(name: "\(i)", surname: "", room: ""), availableRooms: availableRooms)
        })
        .subscribe(onNext: dispatch)
        .disposed(by: disposeBag)
      i += 1
    }
  }
  
  static func makeValidationMiddleware() -> Store.Middleware {
    let disposeBag = DisposeBag()
    
    return Store.makeMiddleware { dispatch, store, next, action in
      next(action)
      let profiles = store().profiles
      
      guard action is AddNewCellTap, !profiles.isEmpty else { 
        return
      }
      
      Observable.just(())
        .map({ _ -> ProfilesAction in
          let validatedCells = profiles.map(HelperFunctions.validate)
          return ProfilesList.Validate(validatedCells: validatedCells)
        })
        .subscribe(onNext: dispatch)
        .disposed(by: disposeBag)
    }
  }
}
