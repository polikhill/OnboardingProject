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
    if profile.name.rawValue.isEmpty, profile.room.rawValue.isEmpty, profile.surname.rawValue.isEmpty {
      return .unchecked
    }
    if profile.name.rawValue.count > 3 && profile.surname.rawValue.count > 3 && !profile.room.rawValue.isEmpty {
      return .valid
    }
    return .invalid
  }
}
