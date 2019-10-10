//
//  ProfilesView.swift
//  OnboardingProject
//
//  Created by Polina Hill on 10/9/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import UIKit
import IGListKit

final class ProfilesView: UIView {

    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private var renderedProps: DiffableBox<Props>?
    private lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: nil)
    }()
    
    struct Props: Diffable {
        var addingCellProps: DiffableBox<AddingCell.Props> {
            let props = AddingCell.Props()
            return DiffableBox(value: props, identifier: props.diffIdentifier as NSObjectProtocol, equal: ==)
        }
        var diffIdentifier: String {
            return "\(Date().timeIntervalSince1970)"
        }
        static func == (lhs: ProfilesView.Props, rhs: ProfilesView.Props) -> Bool {
            return lhs.diffIdentifier == rhs.diffIdentifier
        }
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
        renderedProps = DiffableBox(value: props, identifier: props.diffIdentifier as NSObjectProtocol, equal: ==)
        adapter.performUpdates(animated: true)
    }
}

extension ProfilesView: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        guard let renderedProps = renderedProps else { return [] }
        return [renderedProps]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return ProfilesController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
