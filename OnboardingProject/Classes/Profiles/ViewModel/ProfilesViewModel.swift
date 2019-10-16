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
      let nameSubject: Observable<(Int?, ProfileInfo.Name)>
      let surnameSubject: Observable<(Int?, ProfileInfo.Surname)>
      let roomSubject: Observable<(Int?, ProfileInfo.Room)>
      let deleteCell: Observable<Int?>
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
      
      let addCellMiddleware = makeAddNewCellMiddleware()
      let validationMiddleware = makeValidationMiddleware()
      let deleteionMiddleware = makeDeleteCellMiddleware()
      let store = Store(
        initialState: initialState,
        reducer: ProfilesList.reduce,
        middlewares: [addCellMiddleware, validationMiddleware, deleteionMiddleware])
      
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
