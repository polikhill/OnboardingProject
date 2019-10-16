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
  @IBOutlet fileprivate var deleteButton: UIButton!
  
  private var isEditing = false
  private let roomsPickerView = UIPickerView()
  private var viewModel: DiffableBox<Props>?
  private var renderedProps: Props?
  private var rooms = [String]()
  private let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: nil, action: nil)
  var disposeBag = DisposeBag()
  
  static let height: CGFloat = 140
  
  enum ValidationState {
    case valid, invalid, unchecked
  }
  
  struct Props: Diffable {
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
    setupSwipeLeftGesture()
    setupSwipeRightGesture()
    setupBindings()
  }
  
  override func setNeedsDisplay() {
    super.setNeedsDisplay()
    swipeToDelte()
    swipeToInitialPosition()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
    setupBindings()
    isEditing = false
  }
  
  private func setupBindings() {
    doneButton.rx.tap
      .subscribe(onNext: { _ in
        self.roomTextField.text = self.rooms[self.roomsPickerView.selectedRow(inComponent: 0)]
        self.endEditing(true)
      })
      .disposed(by: disposeBag)
    
    nameTextField.rx.controlEvent(.allEditingEvents)
      .subscribe(onNext: { _ in
        guard let props = self.renderedProps, let dispatch = self.viewModel?.dispatch else {
          return
        }
        self.swipeToInitialPosition()
        dispatch(ProfilesList.UpdateName(name: ProfileInfo.Name(rawValue: self.nameTextField.text ?? ""), index: props.index))
      })
    .disposed(by: disposeBag)
    
    surnameTextField.rx.controlEvent(.allEditingEvents)
      .subscribe(onNext: { _ in
        guard let props = self.renderedProps, let dispatch = self.viewModel?.dispatch else {
          return
        }
        self.swipeToInitialPosition()
        dispatch(ProfilesList.UpdateSurname(surname: ProfileInfo.Surname(rawValue: self.surnameTextField.text ?? ""), index: props.index))
      })
      .disposed(by: disposeBag)
    
    roomTextField.rx.controlEvent(.allEditingEvents)
      .subscribe(onNext: { _ in
        guard let props = self.renderedProps, let dispatch = self.viewModel?.dispatch else {
          return
        }
        self.swipeToInitialPosition()
        dispatch(ProfilesList.UpdateRoom(room: ProfileInfo.Room(rawValue: self.roomTextField.text ?? ""), index: props.index))
      })
      .disposed(by: disposeBag)
    
    deleteButton.rx.tap
      .subscribe(onNext: { _ in
        guard let props = self.renderedProps, let dispatch = self.viewModel?.dispatch else {
          return
        }
        dispatch(ProfilesList.DeleteCell(index: props.index))
      })
      .disposed(by: disposeBag)
  }
  
  private func setupUI() {
    roomTextField.inputView = roomsPickerView
    deleteButton.setTitle(nil, for: .normal)
    deleteButton.setImage(#imageLiteral(resourceName: "trasher").withRenderingMode(.alwaysTemplate), for: .normal)
    deleteButton.tintColor = .red
    setupToolBar()
  }
  
  private func setupToolBar() {
    let toolBar = UIToolbar()
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
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
    if props.backgroundColor != renderedProps?.backgroundColor {
      backgroundColor = props.backgroundColor
    }
    isEditing = false
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
  
  private func setupSwipeLeftGesture() {
    let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeToDelte))
    swipe.direction = .left
    addGestureRecognizer(swipe)
  }

  @objc func swipeToDelte() {
    if !isEditing {
      isEditing.toggle()
      UIView.animate(withDuration: 0.1) {
        self.frame.origin.x -= 70
      }
    }
  }

  private func setupSwipeRightGesture() {
    let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeToInitialPosition))
    swipe.direction = .right
    addGestureRecognizer(swipe)
  }

  @objc func swipeToInitialPosition() {
    if isEditing {
      isEditing.toggle()
      UIView.animate(withDuration: 0.1) {
        self.frame.origin.x += 70
      }
    }
  }
}

extension ProfileCell: ListBindable {
  func bindViewModel(_ viewModel: Any) {
    guard let viewModel = viewModel as? DiffableBox<Props> else { return }
    render(props: viewModel.value)
    self.viewModel = viewModel
  }
}
