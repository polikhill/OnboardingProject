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
    
    return Store.makeMiddleware { dispatch, store, next, action in
      next(action)
      let store = store()
      
      guard action is AddNewCellTap, store.availableRooms.count > 0 else {
        return
      }
      
      Observable.just(())
        .map({ _ -> ProfilesAction in
          
          return ProfilesList.AddNewProfile(profile: ProfileInfo(name: "", surname: "", room: ""))
        })
        .subscribe(onNext: dispatch)
        .disposed(by: disposeBag)
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
          var invalidInds: [Int] {
            return profiles.compactMap({ profile -> Int? in
              if HelperFunctions.validate(profile: profile) {
                guard let index = profiles.firstIndex(of: profile) else { return nil }
                return index
              }
              return nil
            })
          }
          
          return ProfilesList.ValidationFailed(indexes: invalidInds)
        })
        .subscribe(onNext: dispatch)
        .disposed(by: disposeBag)
    }
  }
}
