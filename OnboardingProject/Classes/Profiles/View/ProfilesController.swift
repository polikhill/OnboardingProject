//
//  ProfileController.swift
//  OnboardingProject
//
//  Created by Polina Hill on 10/9/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import Foundation
import IGListKit

final class ProfilesController: ListBindingSectionController<DiffableBox<ProfilesView.Props>>, ListBindingSectionControllerDataSource {

    override init() {
        super.init()
        dataSource = self
    }
}

extension ProfilesController {
    func sectionController(
        _ sectionController: ListBindingSectionController<ListDiffable>,
        viewModelsFor object: Any
        ) -> [ListDiffable] {
        guard let object = object as? DiffableBox<ProfilesView.Props> else { return [] }
        return [object.value.addingCellProps]
    }

    func sectionController(
        _ sectionController: ListBindingSectionController<ListDiffable>,
        cellForViewModel viewModel: Any, at index: Int
        ) -> UICollectionViewCell & ListBindable {

        guard let cell = collectionContext?.cell(type: AddingCell.self, index: index, for: self) else { fatalError() }
        return cell
    }

    func sectionController(
        _ sectionController: ListBindingSectionController<ListDiffable>,
        sizeForViewModel viewModel: Any, at index: Int
        ) -> CGSize {

        guard let width = collectionContext?.containerSize.width else { fatalError() }
        return CGSize(width: width, height: AddingCell.height)
    }
}
