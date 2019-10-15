//
//  ProfileCell.swift
//  OnboardingProject
//
//  Created by Polina Hill on 10/10/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import UIKit
import IGListKit
import RxSwift
import RxCocoa

final class ProfileCell: UICollectionViewCell {
  
  @IBOutlet fileprivate var nameTextField: UITextField!
  @IBOutlet fileprivate var surnameTextField: UITextField!
  @IBOutlet fileprivate var roomTextField: UITextField!
  
  private let roomsPickerView = UIPickerView()
  private var rooms = [String]()
  private var disposeBag = DisposeBag()
  
  fileprivate var cellIndex: Int?
  
  static let height: CGFloat = 140
  
  enum ValidationState {
    case valid, invalid, unchecked
  }
  
  struct Props: Equatable, Diffable {
    var diffIdentifier: String
    let name: String
    let surname: String
    let room: String
    let availableRooms: [String]
    let state: ValidationState
    let index: Int
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
  
  private func setupUI() {
    roomTextField.inputView = roomsPickerView
    setupToolBar()
  }
  
  private func setupToolBar() {
    let toolBar = UIToolbar()
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: nil, action: nil)
    doneButton.rx.tap
      .subscribe(onNext: { _ in
        self.roomTextField.text = self.rooms[self.roomsPickerView.selectedRow(inComponent: 0)]
        self.endEditing(true)
      })
    .disposed(by: disposeBag)
    
    toolBar.setItems([flexibleSpace, doneButton], animated: true)
    toolBar.sizeToFit()
    roomTextField.inputAccessoryView = toolBar
  }
  
  private func render(props: Props) {
    nameTextField.text = props.name
    surnameTextField.text = props.surname
    roomTextField.text = props.room
    cellIndex = props.index
    setupRooms(props.availableRooms)
    setupBackground(for: props.state)
  }
  
  private func setupBackground(for state: ValidationState) {
    var color: UIColor {
      switch state {
      case .invalid: return .red
      case .valid: return .green
      case .unchecked: return .white
      }
    }
    backgroundColor = color
  }
  
  private func setupRooms(_ rooms: [String]) {
    self.rooms = rooms
    Observable.just(rooms)
      .bind(to: roomsPickerView.rx.itemTitles) { _, item in
        return item
      }
      .disposed(by: disposeBag)
  }
}

extension ProfileCell: ListBindable {
  func bindViewModel(_ viewModel: Any) {
    guard let viewModel = viewModel as? DiffableBox<Props> else { return }
    render(props: viewModel.value)
  }
}

extension Reactive where Base: ProfileCell {
  var name: Observable<(Int?, String?)> {
    return base.nameTextField.rx.controlEvent(.editingDidEnd)
      .map({(self.base.cellIndex, self.base.nameTextField.text)})
  }

  var surname: Observable<(Int?, String?)> {
    return base.surnameTextField.rx.controlEvent(.editingDidEnd)
    .map({(self.base.cellIndex, self.base.surnameTextField.text)})
  }

  var room: Observable<(Int?, String?)> {
    return base.roomTextField.rx.controlEvent(.editingDidEnd)
    .map({(self.base.cellIndex, self.base.roomTextField.text)})
  }
}
