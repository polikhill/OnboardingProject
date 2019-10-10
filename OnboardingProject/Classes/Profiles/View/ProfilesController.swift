//
//  ProfileController.swift
//  OnboardingProject
//
//  Created by Polina Hill on 10/9/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import Foundation
import IGListKit
import RxSwift
import RxCocoa

final class ProfilesController: ListBindingSectionController<DiffableBox<ProfilesView.Props>> {
  
  fileprivate let addNewCellSubject = PublishSubject<Void>()
  fileprivate let disposeBag = DisposeBag()
  
  override init() {
    super.init()
    dataSource = self
  }
}

extension ProfilesController: ListBindingSectionControllerDataSource {
  func sectionController(
    _ sectionController: ListBindingSectionController<ListDiffable>,
    viewModelsFor object: Any
    ) -> [ListDiffable] {
    guard let object = object as? DiffableBox<ProfilesView.Props> else { return [] }
    return object.value.profileCellProps + [object.value.addingCellProps]
  }
  
  func sectionController(
    _ sectionController: ListBindingSectionController<ListDiffable>,
    cellForViewModel viewModel: Any, at index: Int
    ) -> UICollectionViewCell & ListBindable {
    
    switch viewModel {
    case is DiffableBox<ProfileCell.Props>:
      guard let cell = collectionContext?.cell(type: ProfileCell.self, index: index, for: self) else { fatalError() }
      return cell
    case is DiffableBox<AddingCell.Props>:
      guard let cell = collectionContext?.cell(type: AddingCell.self, index: index, for: self) else { fatalError() }
      
      cell.rx.addTap
        .bind(to: addNewCellSubject)
        .disposed(by: disposeBag)
      return cell
    default: fatalError() 
    }
  }
  
  func sectionController(
    _ sectionController: ListBindingSectionController<ListDiffable>,
    sizeForViewModel viewModel: Any, at index: Int
    ) -> CGSize {
    
    guard let width = collectionContext?.containerSize.width else { fatalError() }
    
    var height: CGFloat {
      switch viewModel {
      case is DiffableBox<ProfileCell.Props>: return ProfileCell.height
      case is DiffableBox<AddingCell.Props>: return AddingCell.height
      default: return 0
      }
    }
    
    return CGSize(width: width, height: height)
  }
}

extension Reactive where Base: ProfilesController {
  var addCell: Observable<Void> {
    return base.addNewCellSubject.asObservable()
  }
}
