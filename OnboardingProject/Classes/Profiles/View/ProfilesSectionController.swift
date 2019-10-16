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

final class ProfilesSectionController: ListBindingSectionController<DiffableBox<Section>> {
  
  fileprivate let addNewCellSubject = PublishSubject<Void>()
  
  let disposeBag = DisposeBag()
  
  override init() {
    super.init()
    dataSource = self
  }
}

extension ProfilesSectionController: ListBindingSectionControllerDataSource {
  func sectionController(
    _ sectionController: ListBindingSectionController<ListDiffable>,
    viewModelsFor object: Any
    ) -> [ListDiffable] {
    guard let object = object as? DiffableBox<Section> else { return [] }
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
        .disposed(by: cell.disposeBag)
      
      return cell
    default: fatalError() 
    }
  }
  
  func sectionController(
    _ sectionController: ListBindingSectionController<ListDiffable>,
    sizeForViewModel viewModel: Any, at index: Int
    ) -> CGSize {
    
    guard let width = collectionContext?.containerSize.width else { fatalError() }
    
    switch viewModel {
    case is DiffableBox<ProfileCell.Props>: return CGSize(width: width + 70, height: ProfileCell.height)
    case is DiffableBox<AddingCell.Props>: return CGSize(width: width, height:  AddingCell.height)
    default: return .zero
    }
  }
}

extension Reactive where Base: ProfilesSectionController {
  var addCell: Observable<Void> {
    return base.addNewCellSubject.asObservable()
  }
}
