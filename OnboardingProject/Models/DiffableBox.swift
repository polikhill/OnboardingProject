//
//  DiffableBox.swift
//  OnboardingProject
//
//  Created by Polina Hill on 10/10/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import Foundation
import IGListKit

public protocol Diffable: Equatable {
  var diffIdentifier: String { get }
}

final class DiffableBox<T: Diffable>: ListDiffable {
  
  let value: T
  let identifier: NSObjectProtocol
  let dispatch: ReduxStore<ProfilesList.State, ProfilesAction>.Dispatch?
  let equal: (T, T) -> Bool
  
  init(
    value: T,
    identifier: NSObjectProtocol,
    equal: @escaping(T, T) -> Bool,
    dispatch: ReduxStore<ProfilesList.State, ProfilesAction>.Dispatch? = nil
    ) {
    self.value = value
    self.identifier = identifier
    self.equal = equal
    self.dispatch = dispatch
  }
  
  convenience init(value: T, dispatch: ReduxStore<ProfilesList.State, ProfilesAction>.Dispatch? = nil) {
    self.init(value: value, identifier: value.diffIdentifier as NSObjectProtocol, equal: ==, dispatch: dispatch)
  }
  
  // IGListDiffable
  
  func diffIdentifier() -> NSObjectProtocol {
    return identifier
  }
  
  func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    if let other = object as? DiffableBox<T> {
      return equal(value, other.value)
    }
    return false
  }
}
