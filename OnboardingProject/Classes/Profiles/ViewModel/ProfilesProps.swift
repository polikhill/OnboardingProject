//
//  ProfilesProps.swift
//  OnboardingProject
//
//  Created by Polina Hill on 10/10/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import UIKit

extension ProfilesList {
  
  static func makeProfileViewProps(from state: State, dispatch: @escaping ReduxStore<ProfilesList.State, ProfilesAction>.Dispatch) -> ProfilesView.Props {
    return ProfilesView.Props(
      section: DiffableBox(
        value: Section(
          addingCellProps: DiffableBox(value: AddingCell.Props()),
          profileCellProps: makeProfileCellProps(from: state, dispatch: dispatch), diffIdentifier: state.sectionsID
        )
      )
    )
  }
  
  static private func makeProfileCellProps(from state: State, dispatch: @escaping ReduxStore<ProfilesList.State, ProfilesAction>.Dispatch) -> [DiffableBox<ProfileCell.Props>] {
    
    var diffableProps = [DiffableBox<ProfileCell.Props>]()
    for index in 0..<state.profiles.count {
      var cellState: ProfileCell.ValidationState {
        return state.profiles[index] == state.profiles.last ? .unchecked : state.validatedCells[index]
      }
      
      let props = ProfileCell.Props(
        diffIdentifier: state.profiles[index].diffID,
        name: state.profiles[index].name.rawValue,
        surname: state.profiles[index].surname.rawValue,
        room: state.profiles[index].room.rawValue,
        availableRooms: state.availableRooms,
        backgroundColor: makeColor(from: cellState),
        index: index,
        dispatch: dispatch
      )
      diffableProps.append(DiffableBox(value: props))
    }
    
    return diffableProps
  }
  
  static private func makeColor(from state: ProfileCell.ValidationState) -> UIColor {
    switch state {
    case .invalid: return .lightishRed
    case .valid: return .freshGreen
    case .unchecked: return .white
    }
  }
}
