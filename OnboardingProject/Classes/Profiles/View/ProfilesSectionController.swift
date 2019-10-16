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
  let nameSubject = PublishSubject<(Int?, ProfileInfo.Name)>()
  let surnameSubject = PublishSubject<(Int?, ProfileInfo.Surname)>()
  let roomSubject = PublishSubject<(Int?, ProfileInfo.Room)>()
  
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
        
      cell.rx.name
        .bind(to: nameSubject)
        .disposed(by: cell.disposeBag)
      cell.rx.surname
        .bind(to: surnameSubject)
        .disposed(by: cell.disposeBag)
      cell.rx.room
        .bind(to: roomSubject)
        .disposed(by: cell.disposeBag)
      
      print("=== pr index \(index)")
      
      return cell
      
    case is DiffableBox<AddingCell.Props>:
      guard let cell = collectionContext?.cell(type: AddingCell.self, index: index, for: self) else { fatalError() }
      
      cell.rx.addTap
        .bind(to: addNewCellSubject)
        .disposed(by: cell.disposeBag)
      
      print("=== bt index \(index)")
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

extension Reactive where Base: ProfilesSectionController {
  var addCell: Observable<Void> {
    return base.addNewCellSubject.asObservable()
  }
}
