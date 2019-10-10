//
//  ProfilesProps.swift
//  OnboardingProject
//
//  Created by Polina Hill on 10/10/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import Foundation

extension ProfilesList {
  
  struct ProfileProps: Equatable, Diffable {
    var diffIdentifier: String {
      return (name + "\(Date().timeIntervalSince1970)")
    }
    
    let name: String
    let surname: String
    let room: String
  }
  static func makeProfileViewProps(from state: State) -> DiffableBox<ProfilesView.Props> {
    
    let addCellProps = AddingCell.Props()
    let props = ProfilesView.Props(
      addingCellProps: DiffableBox(value: addCellProps, identifier: addCellProps.diffIdentifier as NSObjectProtocol, equal: ==),
      profileCellProps: state.profiles.map(makeProfileCellProps)
    )
    return DiffableBox(value: props, identifier: props.diffIdentifier as NSObjectProtocol, equal: ==)
  }
  
  static private func makeProfileCellProps(from profile: ProfileInfo) -> DiffableBox<ProfileProps> {
    let props = ProfileProps(name: profile.name, surname: profile.surname, room: profile.room)
    return DiffableBox(value: props, identifier: props.diffIdentifier as NSObjectProtocol, equal: ==)
  }
}
