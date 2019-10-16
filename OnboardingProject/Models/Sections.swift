//
//  Sections.swift
//  OnboardingProject
//
//  Created by Polina Hill on 10/15/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import Foundation

struct Section: Equatable, Diffable {
 
  let addingCellProps: DiffableBox<AddingCell.Props>
  let profileCellProps: [DiffableBox<ProfileCell.Props>]
  
  let diffIdentifier: String
  
  static func == (lhs: Section, rhs: Section) -> Bool {
    return lhs.diffIdentifier == rhs.diffIdentifier
  }
}
