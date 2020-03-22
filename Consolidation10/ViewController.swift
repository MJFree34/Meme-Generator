//
//  ViewController.swift
//  Consolidation10
//
//  Created by Matt Free on 3/21/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: Properties
    var imageView: UIImageView!
    var currentBaseImage: UIImage?
    var memedImage: UIImage?
    
    // MARK: UI Setup
    override func loadView() {
        // setup view
        view = UIView()
        view.backgroundColor = .white
        
        // setup imageView
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        // setup topTextButton
        let topTextButton = UIButton(type: .system)
        topTextButton.translatesAutoresizingMaskIntoConstraints = false
        topTextButton.setTitle("TOP TEXT", for: .normal)
        topTextButton.addTarget(self, action: #selector(addTopText), for: .touchUpInside)
        view.addSubview(topTextButton)
        
        // setup bottomTextButton
        let bottomTextButton = UIButton(type: .system)
        bottomTextButton.translatesAutoresizingMaskIntoConstraints = false
        bottomTextButton.setTitle("BOTTOM TEXT", for: .normal)
        bottomTextButton.addTarget(self, action: #selector(addBottomText), for: .touchUpInside)
        view.addSubview(bottomTextButton)
        
        // activating all constraints
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -50),
            
            topTextButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            topTextButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            topTextButton.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            topTextButton.heightAnchor.constraint(equalToConstant: 44),
            
            bottomTextButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            bottomTextButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            bottomTextButton.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            bottomTextButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Meme Maker"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareMeme))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
    }
    
    // MARK: Picker Setup
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        // setting imageView's image and the current base image
        currentBaseImage = image
        imageView.image = currentBaseImage
        
        // replace old memed image if there was one with nil
        memedImage = nil
        
        assert(currentBaseImage != nil, "image picker gave back nil image")
    }
    
    @objc func addTopText() {
        
    }
    
    @objc func addBottomText() {
        
    }
    
    // MARK: Share Image
    @objc func shareMeme() {
        guard let image = imageView.image else { return }
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            fatalError("image was not able to be compressed")
        }
        
        let vc = UIActivityViewController(activityItems: [imageData], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}

