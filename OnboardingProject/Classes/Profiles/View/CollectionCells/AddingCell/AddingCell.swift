//
//  AddingCell.swift
//  OnboardingProject
//
//  Created by Polina Hill on 10/10/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import UIKit
import IGListKit
import RxSwift
import RxCocoa

final class AddingCell: UICollectionViewCell {
  
  @IBOutlet fileprivate var plusButton: UIButton!
  
  var disposeBag = DisposeBag()
  
  static let height: CGFloat = 100
  
  struct Props: Equatable, Diffable {
    var diffIdentifier: String {
      return "AddCell"
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    plusButton.setTitle(nil, for: .normal)
    plusButton.setImage(#imageLiteral(resourceName: "plusButton"), for: .normal)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
}

extension AddingCell: ListBindable {
  func bindViewModel(_ viewModel: Any) { }
}

extension Reactive where Base: AddingCell {
  var addTap: Observable<Void> {
    return base.plusButton.rx.tap.asObservable()
  }
}
