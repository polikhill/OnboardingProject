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
      let nameSubject: PublishSubject<(Int?, ProfileInfo.Name)>
      let surnameSubject: PublishSubject<(Int?, ProfileInfo.Surname)>
      let roomSubject: PublishSubject<(Int?, ProfileInfo.Room)>
    }

    struct Outputs {
      let props: Observable<ProfilesView.Props>
      let stateChanged: Observable<Void>
    }
    
    func makeOutputs(from inputs: Inputs) -> Outputs {
      let initialState = State(
        profiles: [],
        availableRooms: MeetingRooms.rooms,
        validatedCells: [],
        sectionsID: ""
      )
      
      let addCellMiddleware = ProfilesList.makeAddNewCellMiddleware()
      let validationMiddleware = ProfilesList.makeValidationMiddleware()
      let store = Store(initialState: initialState, reducer: ProfilesList.reduce, middlewares: [addCellMiddleware, validationMiddleware])
      
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
