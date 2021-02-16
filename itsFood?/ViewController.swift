//
//  ViewController.swift
//  itsFood?
//
//  Created by Muhammad Ilham Ashiddiq Tresnawan on 22/12/20.
//

import UIKit
import CoreML
import Vision


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var videoImageView: UIImageView!
    var classificationResults : [VNClassificationObservation] = []
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera //.photoLibrary
        
    }
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Model Failed")
        }
        
        let requestML = VNCoreMLRequest(model: model) { (request, error) in
            guard let result = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed process image.")
            }
//            print(result)
            if let firstResult = result.first {
                // result.first is the most precentage of match with image model
                if firstResult.identifier.contains("hotdog"){
                    DispatchQueue.main.async {
                        self.navigationItem.title = "HotDog"
                        print("its a hotdog")
                    }
                }else{
                    DispatchQueue.main.async {
                        self.navigationItem.title = "Not HotDog"
                        print("its not a hotdog")
                    }
                }
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)
        
        do{
            try handler.perform([requestML])
        }catch{
            print(error)
        }
        
    }

    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
//        if let userPikedImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
        if let userPikedImage = info[.originalImage] as? UIImage {
            videoImageView.image = userPikedImage
            imagePicker.dismiss(animated: true, completion: nil)
//            let ciimage = CIImage(image: userPikedImage)
            guard let ciimage = CIImage(image: userPikedImage) else {
                fatalError("Could not convert into CIImage")
            }
            detect(image: ciimage)
        }
        
//        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
        // here the imagePicker will take you into camera capture
    }
    
}

