//
//  SelectCityView.swift
//  Weather4Cast
//
//  Created by Kushal on 03/01/20.
//  Copyright © 2020 Kushal. All rights reserved.
//

import UIKit

class SelectCityView: UIView {
    
    var cityTextField: UITextField!
    var currentLocationButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cityTextField = UITextField()
        cityTextField.placeholder = "Enter city"
        cityTextField.layer.masksToBounds = false
        
        cityTextField.borderStyle = .none
//        cityTextField.layer.backgroundColor = UIColor.white.cgColor
        cityTextField.layer.shadowColor = UIColor.gray.cgColor
        cityTextField.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        cityTextField.layer.shadowOpacity = 1.0
        cityTextField.layer.shadowRadius = 0.0
        
        self.addSubview(cityTextField)
        
        currentLocationButton = UIButton(type: .system)
        self.addSubview(currentLocationButton)
        currentLocationButton.setTitle("Use my current location", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        cityTextField.translatesAutoresizingMaskIntoConstraints = false
               
       NSLayoutConstraint.activate([
           
           cityTextField.topAnchor.constraint(equalToSystemSpacingBelow: self.safeAreaLayoutGuide.topAnchor, multiplier: 10),
           cityTextField.centerXAnchor.constraint(equalToSystemSpacingAfter: self.safeAreaLayoutGuide.centerXAnchor, multiplier: 1),
           cityTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9)
       ])
        
        currentLocationButton.translatesAutoresizingMaskIntoConstraints = false
               
           NSLayoutConstraint.activate([
               
               currentLocationButton.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 20),
               currentLocationButton.centerXAnchor.constraint(equalToSystemSpacingAfter: self.centerXAnchor, multiplier: 1)
               
           ])
    }

}
