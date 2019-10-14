//
//  HelperFunctions.swift
//  OnboardingProject
//
//  Created by Polina Hill on 10/11/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import Foundation

final class HelperFunctions {
  static func validate(profile: ProfileInfo) -> ProfileCell.ValidationState {
    if profile.name.isEmpty, profile.room.isEmpty, profile.surname.isEmpty {
      return .unchecked
    }
    if profile.name.count > 3, profile.surname.count > 3 {
      return .valid
    }
    return .invalid
  }
}
