//
//  pickerVC.swift
//  appThree
//
//  Created by Mitchell Park on 2/13/20.
//  Copyright © 2020 Mitchell Park. All rights reserved.
//

import UIKit

class pickerVC: UIViewController{
    
    let firstNames = ["John","Cody","Christina","Abigail","Mitchell"]
    let lastNames = ["Jones","Kolodziejzyk","Brown"]
    var textField1 = UITextField()
    var textField2 = UITextField()
    var pickerView = UIPickerView()
    var doneButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        configureTextFields()
        configureButton()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedDone))
        view.addGestureRecognizer(tapGesture)
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    @objc func tappedDone(){
        view.endEditing(true)
    }
    
    func configureTextFields(){
        view.addSubview(textField1)
        textField1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField2)
        textField2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField2.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textField2.widthAnchor.constraint(equalToConstant: 200),
            textField2.heightAnchor.constraint(equalToConstant: 60),
            textField1.widthAnchor.constraint(equalTo: textField2.widthAnchor),
            textField1.heightAnchor.constraint(equalTo: textField2.heightAnchor),
            textField1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField1.bottomAnchor.constraint(equalTo: textField2.topAnchor, constant: -20)
        ])
        textField1.layer.backgroundColor = UIColor.white.cgColor
        textField2.layer.backgroundColor = UIColor.white.cgColor
        textField1.placeholder = "First Name"
        textField2.placeholder = "Last Name"
        textField2.layer.cornerRadius = 20
        textField1.layer.cornerRadius = 20
        textField2.inputView = pickerView
        textField1.inputView = pickerView
    }
    func configureButton(){
        view.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            doneButton.widthAnchor.constraint(equalToConstant: 100),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.topAnchor.constraint(equalTo: textField2.bottomAnchor, constant: 20)
        ])
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.layer.backgroundColor = UIColor.red.cgColor
        doneButton.layer.borderColor = UIColor.darkGray.cgColor
        doneButton.layer.borderWidth = 3
        doneButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        doneButton.layer.shadowRadius = 10
        doneButton.layer.shadowColor = UIColor.darkGray.cgColor
        doneButton.layer.shadowOpacity = 0.7
        doneButton.addTarget(self, action: #selector(doneSelecting), for: .touchUpInside)
    }
    
    @objc func doneSelecting(){
        if textField2.text=="" || textField1.text == ""{
            shakeButton()
        }else{
            let nextVC = nextPickerVC()
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    func shakeButton(){
        let shake = CABasicAnimation(keyPath: "position")
        shake.autoreverses = true
        shake.repeatCount = 2
        shake.duration = 0.1
        shake.fromValue = NSValue(cgPoint: CGPoint(x: doneButton.center.x-8, y: doneButton.center.y))
        shake.toValue = NSValue(cgPoint: CGPoint(x: doneButton.center.x+8, y: doneButton.center.y))
        doneButton.layer.add(shake, forKey: "position")
    }
    
}
extension pickerVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return firstNames.count
        }
        return lastNames.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return firstNames[row]
        }
        return lastNames[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            textField1.text = firstNames[row]
        }else{
            textField2.text = lastNames[row]
        }
    }
}

class nextPickerVC: UIViewController{
    
    var slider = UISlider()
    var stepper = UIStepper()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Thanks for submitting."
        view.backgroundColor = .purple
        configureSlider()
        configureStepper()
    }
    func configureSlider(){
        view.addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            slider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            slider.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            slider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 100),
            slider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -100),
            slider.heightAnchor.constraint(equalToConstant: 100)
        ])
        slider.setValue(20, animated: true)
        slider.maximumValue = 100
        slider.minimumValue = 0
        slider.isContinuous = false
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.thumbTintColor = .gray
        slider.minimumTrackTintColor = .blue
        slider.maximumTrackTintColor = .red
    }
    
    func configureStepper(){
        view.addSubview(stepper)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stepper.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stepper.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: -100),
            stepper.widthAnchor.constraint(equalToConstant: 100),
            stepper.heightAnchor.constraint(equalToConstant: 10)
        ])
    }
    
    @objc func sliderValueChanged(){
        print(Int(slider.value))
    }
    
}
