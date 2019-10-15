//
//  ProfileInfo.swift
//  OnboardingProject
//
//  Created by Polina Hill on 10/10/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import Foundation

struct ProfileInfo: Equatable {
  var name: Name
  var surname: Surname
  var room: Room
  var diffID: String
  
  typealias Name = Tagged<ProfileInfo, String>
  enum SurnameTag {}
  typealias Surname = Tagged<SurnameTag, String>
  enum RoomTag {}
  typealias Room = Tagged<RoomTag, String>
}
