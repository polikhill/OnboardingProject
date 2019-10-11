//
//  ProfilesProps.swift
//  OnboardingProject
//
//  Created by Polina Hill on 10/10/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import Foundation

extension ProfilesList {
  
  static func makeProfileViewProps(from state: State) -> DiffableBox<ProfilesView.Props> {
    
    let addCellProps = AddingCell.Props()
    let props = ProfilesView.Props(
      addingCellProps: DiffableBox(value: addCellProps, identifier: addCellProps.diffIdentifier as NSObjectProtocol, equal: ==),
      profileCellProps: makeProfileCellProps(from: state.profiles, rooms: state.availableRooms, invalidInds: state.invalidProfiles)
    )
    return DiffableBox(value: props, identifier: props.diffIdentifier as NSObjectProtocol, equal: ==)
  }
  
  static private func makeProfileCellProps(from profiles: [ProfileInfo], rooms: [String], invalidInds: [Int]) -> [DiffableBox<ProfileCell.Props>] {
    
    var diffableProps = [DiffableBox<ProfileCell.Props>]()
    for index in 0..<profiles.count {
      
      let props = ProfileCell.Props(
        name: profiles[index].name,
        surname: profiles[index].surname,
        room: profiles[index].room,
        availableRooms: rooms,
        isValid: invalidInds.contains(index))
      diffableProps.append(DiffableBox(value: props, identifier: props.diffIdentifier as NSObjectProtocol, equal: ==))
    }
    
    return diffableProps
  }
  
}
