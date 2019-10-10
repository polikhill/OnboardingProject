//
//  ProfileCell.swift
//  OnboardingProject
//
//  Created by Polina Hill on 10/10/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import UIKit
import IGListKit

final class ProfileCell: UICollectionViewCell {

  @IBOutlet fileprivate var nameTextField: UITextField!
  @IBOutlet fileprivate var surnameTextField: UITextField!
  @IBOutlet fileprivate var roomTextField: UITextField!
  
  private let roomsPickerView = UIPickerView()
  private var rooms = MeetingRooms.allCases
  
  static let height: CGFloat = 140
  
  struct Props: Equatable, Diffable {
    var diffIdentifier: String {
      return (name + "\(Date().timeIntervalSince1970)")
    }
    
    let name: String
    let surname: String
    let room: MeetingRooms
  }
  
  override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
  
  private func setupUI() {
    roomsPickerView.dataSource = self
    roomsPickerView.delegate = self
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
    roomTextField.text = props.room.rawValue
  }

}

extension ProfileCell: UIPickerViewDataSource, UIPickerViewDelegate {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return rooms.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return rooms[row].rawValue
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    roomTextField.text = rooms[row].rawValue
  }
}

extension ProfileCell: ListBindable {
  func bindViewModel(_ viewModel: Any) {
    guard let viewModel = viewModel as? DiffableBox<Props> else { return }
    render(props: viewModel.value)
  }
}
