//
//  ProfilesActionCreator.swift
//  OnboardingProject
//
//  Created by Polina Hill on 10/10/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import Foundation
import RxSwift

extension ProfilesList {
  
  final class ActionCreator {
    let actions: Observable<ProfilesAction>
    
    init(inputs: ProfilesViewModel.Inputs) {
      
      let initalSetupActions = inputs.viewWillAppear
        .map({ _ -> ProfilesAction in
          return ProfilesList.InialSetup(id: UUID().uuidString)
        })
      
      let addNewCellAction = inputs.addNewCell
        .map ({ _ -> ProfilesAction in
          return ProfilesList.AddNewCellTap()
        })
      
      let updateName = inputs.nameSubject
        .map ({ index, name -> ProfilesAction in
          return ProfilesList.UpdateName(name: name, index: index)
        })
      
      let updateSurname = inputs.surnameSubject
        .map ({ index, surname -> ProfilesAction in
          return ProfilesList.UpdateSurname(surname: surname, index: index)
        })
      
      let updateRoom = inputs.roomSubject
        .map ({ index, room -> ProfilesAction in
          return ProfilesList.UpdateRoom(room: room, index: index)
        })
      
      let deleteCell = inputs.deleteCell
      .map ({ index -> ProfilesAction in
        return ProfilesList.DeleteCell(index: index)
      })
      
      self.actions = Observable.merge(
        initalSetupActions,
        addNewCellAction,
        updateName,
        updateSurname,
        updateRoom,
        deleteCell
      )
    }
  }
}
