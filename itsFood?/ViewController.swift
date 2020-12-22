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
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera //.photoLibrary
        
    }
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let userPikedImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
            videoImageView.image = userPikedImage
            
//            let ciimage = CIImage(image: userPikedImage)
            guard let ciimage = CIImage(image: userPikedImage) else {
                fatalError("Could not convert into CIImage")
            }
            detect(image: ciimage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage){
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Model Failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let result = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed process image.")
            }
//            print(result)
            if let firstResult = result.first {
                if firstResult.identifier.contains("hotdog"){
                    self.navigationItem.title = "HotDog"
                }else{
                    self.navigationItem.title = "Not HotDog"
                }
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)
        
        do{
            try handler.perform([request])
        }catch{
            print(error)
        }
        
    }

    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

