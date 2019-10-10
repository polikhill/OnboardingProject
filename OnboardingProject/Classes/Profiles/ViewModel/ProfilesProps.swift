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
            profileCellProps: ["", "", "", "", ""]
        )
        return DiffableBox(value: props, identifier: props.diffIdentifier as NSObjectProtocol, equal: ==)
    }
}
