//
//  ProfilesProps.swift
//  OnboardingProject
//
//  Created by Polina Hill on 10/10/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import UIKit

extension ProfilesList {
  
  static func makeProfileViewProps(from state: State) -> ProfilesView.Props {
    return ProfilesView.Props(
      section: DiffableBox(
        value: Section(
          addingCellProps: DiffableBox(value: AddingCell.Props()),
          profileCellProps: makeProfileCellProps(from: state.profiles, rooms: state.availableRooms, validatedCells: state.validatedCells)
        )
      )
    )
  }
  
  static private func makeProfileCellProps(
    from profiles: [ProfileInfo],
    rooms: [String],
    validatedCells: [ProfileCell.ValidationState]
    ) -> [DiffableBox<ProfileCell.Props>] {
    
    var diffableProps = [DiffableBox<ProfileCell.Props>]()
    for index in 0..<profiles.count {
      var state: ProfileCell.ValidationState {
        return profiles[index] == profiles.last ? .unchecked : validatedCells[index]
      }
      
      let props = ProfileCell.Props(
        diffIdentifier: profiles[index].diffID,
        name: profiles[index].name.rawValue,
        surname: profiles[index].surname.rawValue,
        room: profiles[index].room.rawValue,
        availableRooms: rooms,
        backgroundColor: makeColor(from: state),
        index: index
      )
      diffableProps.append(DiffableBox(value: props))
    }
    
    return diffableProps
  }
  
  static private func makeColor(from state: ProfileCell.ValidationState) -> UIColor {
    switch state {
    case .invalid: return .red
    case .valid: return .green
    case .unchecked: return .white
    }
  }
}
