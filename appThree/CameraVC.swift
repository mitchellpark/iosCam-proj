//
//  CameraVC.swift
//  appThree
//
//  Created by Mitchell Park on 3/17/20.
//  Copyright © 2020 Mitchell Park. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CameraVC: UIViewController {

    var previewView = CameraView()
    let button = UIButton()
    let titleLabel = UILabel()
    let subLabel = UILabel()
    let stackView = UIStackView()
    let captureButton = UIButton()
    
    let deviceOutput = AVCapturePhotoOutput()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLabels()
        configurePrivacy()
    }
    
    public func presentAlert(string: String){
        let alertController = UIAlertController(title: "", message: string, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func configureLabels(){
        view.alpha = 0.9
        
        titleLabel.text = "WElcome to my app!"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .white
        subLabel.text = "We need to access your camera."
        subLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        subLabel.textColor = .white
        
        button.backgroundColor = .blue
        button.setTitle("Go to settings", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(goToSettings), for: .touchUpInside)

        stackView.backgroundColor = .blue
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subLabel)
        stackView.addArrangedSubview(button)
        stackView.axis = .vertical
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: view.frame.width*0.8),
            stackView.heightAnchor.constraint(equalToConstant: view.frame.height*0.7)
        ])
    }
    @objc func goToSettings(){
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:]) { (response) in
            if response{
                print("Yay!")
            }else{
                print("Unable to open.")
            }
        }
    }
    private func configurePrivacy(){
        let Vstatus = AVCaptureDevice.authorizationStatus(for: .video)
        if Vstatus == .notDetermined{
            AVCaptureDevice.requestAccess(for: .video) { [weak self](response) in
                guard let strongSelf = self else{
                    print("here")
                    return
                }
                strongSelf.stackView.removeFromSuperview()
                strongSelf.setUpSession()
                return
            }
        }else if Vstatus == .authorized{
            stackView.removeFromSuperview()
            setUpSession()
        }
        let Astatus = AVCaptureDevice.authorizationStatus(for: .audio)
        if Astatus == .notDetermined{
            AVCaptureDevice.requestAccess(for: .audio) { (response) in
                return
            }
        }
    }
    private func setUpSession(){
        let session = AVCaptureSession()
        session.beginConfiguration()
        configureVideo(session: session)
        configureAudio(session: session)
        session.commitConfiguration()
        session.startRunning()
        configurePreview(session: session)
    }
    
    func configurePreview(session: AVCaptureSession){
        previewView.videoPreviewLayer.session = session
        view = previewView
        previewView.backgroundColor = .purple
        previewView.addSubview(captureButton)
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            captureButton.centerXAnchor.constraint(equalTo: previewView.centerXAnchor),
            captureButton.heightAnchor.constraint(equalToConstant: 100),
            captureButton.widthAnchor.constraint(equalToConstant: 100),
            captureButton.bottomAnchor.constraint(equalTo: previewView.bottomAnchor, constant: -100)
        ])
        captureButton.backgroundColor = .white
        captureButton.layer.borderWidth = 2
        captureButton.layer.cornerRadius = 50
        captureButton.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
    }
    
    @objc
    func capturePhoto(){
        deviceOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    
    private func configureVideo(session: AVCaptureSession){
        let videoDevice: AVCaptureDevice!
        videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        guard let deviceInput = try? AVCaptureDeviceInput(device: videoDevice),
            session.canAddInput(deviceInput) else{
                return
        }
        session.addInput(deviceInput)
        guard session.canAddOutput(deviceOutput)else{
            return
        }
        session.sessionPreset = .photo
        session.addOutput(deviceOutput)
    }
    private func configureAudio(session: AVCaptureSession){
        
    }
    private func configureOutput(output: AVCapturePhotoOutput){
        
    }
    
    fileprivate func configurePhotos(){
        let assetCollection = PHAssetCollection()
        print("ask")
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined{
            PHPhotoLibrary.requestAuthorization { (status) in
                print(status)
            }
        } else if status == .authorized{
            PHPhotoLibrary.shared().performChanges({
                // Request creating an asset from the image.
                let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: UIImage(systemName: "plus")!)
                // Request editing the album.
                guard let addAssetRequest = PHAssetCollectionChangeRequest(for: assetCollection)
                    else { return }
                // Get a placeholder for the new asset and add it to the album editing request.
                addAssetRequest.addAssets([creationRequest.placeholderForCreatedAsset!] as NSArray)
            }, completionHandler: { success, error in
                if !success { NSLog("error creating asset: \(error)") }
            })
        }else{
            print("Can't access.")
        }
    }
    

}
extension CameraVC: AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        print("Will begin capturing")
    }
    func photoOutput(_ output: AVCapturePhotoOutput, didCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        print("did just capture.")
    }
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error{
            presentAlert(string: error.localizedDescription)
        }
        configurePhotos()
    }
}
class CameraView: UIView{
    override class var layerClass: AnyClass{
        return AVCaptureVideoPreviewLayer.self
    }
    var videoPreviewLayer: AVCaptureVideoPreviewLayer{
        return layer as! AVCaptureVideoPreviewLayer
    }
}
