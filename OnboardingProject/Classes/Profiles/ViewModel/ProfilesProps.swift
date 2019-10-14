//
//  ProfilesProps.swift
//  OnboardingProject
//
//  Created by Polina Hill on 10/10/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import Foundation

extension ProfilesList {
  
  static func makeProfileViewProps(
    from state: State
    ) -> DiffableBox<ProfilesView.Props> {
    
    let addCellProps = AddingCell.Props()
    let props = ProfilesView.Props(
      addingCellProps: DiffableBox(value: addCellProps, identifier: addCellProps.diffIdentifier as NSObjectProtocol, equal: ==),
      profileCellProps: makeProfileCellProps(
        from: state.profiles,
        rooms: state.availableRooms,
        validatedCells: state.validatedCells,
        difIDs: state.difID
      )
    )
    return DiffableBox(value: props, identifier: props.diffIdentifier as NSObjectProtocol, equal: ==)
  }
  
  static private func makeProfileCellProps(
    from profiles: [ProfileInfo],
    rooms: [String],
    validatedCells: [ProfileCell.ValidationState],
    difIDs: [String]
    ) -> [DiffableBox<ProfileCell.Props>] {
    
    var diffableProps = [DiffableBox<ProfileCell.Props>]()
    for index in 0..<profiles.count {
      var state: ProfileCell.ValidationState {
        return profiles[index] == profiles.last ? .unchecked : validatedCells[index]
      }
      
      let props = ProfileCell.Props(
        diffIdentifier: difIDs[index],
        name: profiles[index].name,
        surname: profiles[index].surname,
        room: profiles[index].room,
        availableRooms: rooms,
        state: state,
        index: index
      )
      diffableProps.append(DiffableBox(value: props, identifier: props.diffIdentifier as NSObjectProtocol, equal: ==))
    }
    
    return diffableProps
  }
  
}
