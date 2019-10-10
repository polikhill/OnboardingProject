//
//  IGListKitExtensions.swift
//  OnboardingProject
//
//  Created by Polina Hill on 10/10/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import UIKit
import IGListKit

extension ListCollectionContext {
    func cell<T: UICollectionViewCell>(type: T.Type, index: Int, for controller: ListSectionController) -> T? {
        guard let cell = dequeueReusableCell(
            withNibName: "\(type)",
            bundle: nil,
            for: controller,
            at: index) as? T else {
                return nil
        }
        return cell
    }
}
