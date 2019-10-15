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
  private var renderedProps: Props?
  private var rooms = [String]()
  var disposeBag = DisposeBag()
  
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
    let backgroundColor: UIColor
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
    if props.name != renderedProps?.name {
      nameTextField.text = props.name
    }
    if props.surname != renderedProps?.surname {
      surnameTextField.text = props.surname
    }
    if props.room != renderedProps?.room {
      roomTextField.text = props.room
    }
    if props.index != renderedProps?.index {
      cellIndex = props.index
    }
    if props.backgroundColor != renderedProps?.backgroundColor {
      backgroundColor = props.backgroundColor
    }
    setupRooms(props.availableRooms)
    renderedProps = props
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
  var name: Observable<(Int?, ProfileInfo.Name)> {
    return base.nameTextField.rx.controlEvent(.editingDidEnd)
      .map({(self.base.cellIndex, ProfileInfo.Name(rawValue: self.base.nameTextField.text ?? ""))})
  }
  
  var surname: Observable<(Int?, ProfileInfo.Surname)> {
    return base.surnameTextField.rx.controlEvent(.editingDidEnd)
      .map({(self.base.cellIndex, ProfileInfo.Surname(rawValue: self.base.surnameTextField.text ?? ""))})
  }
  
  var room: Observable<(Int?, ProfileInfo.Room)> {
    return base.roomTextField.rx.controlEvent(.editingDidEnd)
      .map({(self.base.cellIndex, ProfileInfo.Room(rawValue: self.base.roomTextField.text ?? ""))})
  }
}
