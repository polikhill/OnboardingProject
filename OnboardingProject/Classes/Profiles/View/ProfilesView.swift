//
//  ProfilesView.swift
//  OnboardingProject
//
//  Created by Polina Hill on 10/9/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import UIKit
import IGListKit
import RxSwift
import RxCocoa

final class ProfilesView: UIView {
  
  let nameSubject = PublishSubject<(Int?, ProfileInfo.Name)>()
  let surnameSubject = PublishSubject<(Int?, ProfileInfo.Surname)>()
  let roomSubject = PublishSubject<(Int?, ProfileInfo.Room)>()
  
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
  fileprivate let addNewCellSubject = PublishSubject<Void>()
  private let disposeBag = DisposeBag()
  private var renderedProps: Props?
  
  private lazy var adapter: ListAdapter = {
    return ListAdapter(updater: ListAdapterUpdater(), viewController: nil)
  }()
  
  struct Props {
    let section: DiffableBox<Section>
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setupIGListAdapter()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    collectionView.backgroundColor = .white
    collectionView.keyboardDismissMode = .onDrag
    
    addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.leftAnchor.constraint(equalTo: leftAnchor),
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.rightAnchor.constraint(equalTo: rightAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
      ])
    
    let collectionLayout = UICollectionViewFlowLayout()
    collectionLayout.scrollDirection = .vertical
    collectionView.collectionViewLayout = collectionLayout
  }
  
  private func setupIGListAdapter() {
    adapter.collectionView = collectionView
    adapter.dataSource = self
  }
  
  func render(props: Props) {
    renderedProps = props
    adapter.performUpdates(animated: true)
  }
}

extension ProfilesView: ListAdapterDataSource {
  func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
    guard let renderedProps = renderedProps else { return [] }
    return [renderedProps.section]
  }
  
  func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
    let profilesController = ProfilesSectionController()
    
    profilesController.rx.addCell
      .bind(to: addNewCellSubject)
      .disposed(by: profilesController.disposeBag)
    
    profilesController.nameSubject
      .bind(to: nameSubject)
      .disposed(by: profilesController.disposeBag)
    
    profilesController.surnameSubject
      .bind(to: surnameSubject)
      .disposed(by: profilesController.disposeBag)
    
    profilesController.roomSubject
      .bind(to: roomSubject)
      .disposed(by: profilesController.disposeBag)
    
    return profilesController
  }
  
  func emptyView(for listAdapter: ListAdapter) -> UIView? {
    return nil
  }
}

extension Reactive where Base: ProfilesView {
  var addNewCell: Observable<Void> {
    return base.addNewCellSubject.asObservable()
  }
}
