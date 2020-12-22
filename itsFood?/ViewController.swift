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
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }

    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

