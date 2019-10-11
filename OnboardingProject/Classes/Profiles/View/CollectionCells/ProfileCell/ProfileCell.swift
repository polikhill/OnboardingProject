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
  
  static let height: CGFloat = 140
  
  var cellIndex: Int?
  
  struct Props: Equatable, Diffable {
    var diffIdentifier: String {
      return (name + "\(Date().timeIntervalSince1970)")
    }
    
    let name: String
    let surname: String
    let room: String
    let availableRooms: [String]
    let isValid: Bool
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
    setupBindings()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
  
  private func setupBindings() {
    roomsPickerView.rx.itemSelected
      .subscribe(onNext: { item in
        self.roomTextField.text = self.rooms[item.row]
      })
      .disposed(by: disposeBag)
    
  }
  private func setupUI() {
    roomTextField.inputView = roomsPickerView
    setupToolBar()
  }
  
  private func setupToolBar() {
    let toolBar = UIToolbar()
    let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: nil, action: nil)
    toolBar.setItems([doneButton], animated: true)
    roomTextField.inputAccessoryView = toolBar
  }
  
  private func render(props: Props) {
    nameTextField.text = props.name
    surnameTextField.text = props.surname
    roomTextField.text = props.room
    
    rooms = props.availableRooms
    Observable.just(props.availableRooms)
      .bind(to: roomsPickerView.rx.itemTitles) { _, item in
        return item
      }
      .disposed(by: disposeBag)
    
    backgroundColor = props.isValid ? .green : .red
  }
}

extension ProfileCell: ListBindable {
  func bindViewModel(_ viewModel: Any) {
    guard let viewModel = viewModel as? DiffableBox<Props> else { return }
    render(props: viewModel.value)
  }
}

extension Reactive where Base: ProfileCell {
  var name: Observable<(Int, String)> {
    guard let index = base.cellIndex, let text = base.nameTextField.text else { return Observable.empty() }
    return base.nameTextField.rx.controlEvent(.editingDidEnd).withLatestFrom(Observable.just((index, text)))
  }
  
  var surname: Observable<(Int, String)> {
    guard let index = base.cellIndex, let text = base.surnameTextField.text else { return Observable.empty() }
    return base.surnameTextField.rx.controlEvent(.editingDidEnd).withLatestFrom(Observable.just((index, text)))
  }
  
  var room: Observable<(Int, String)> {
    guard let index = base.cellIndex, let text = base.roomTextField.text else { return Observable.empty() }
    return base.roomTextField.rx.controlEvent(.editingDidEnd).withLatestFrom(Observable.just((index, text)))
  }
}
