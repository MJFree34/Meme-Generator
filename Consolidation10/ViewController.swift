//
//  ViewController.swift
//  Consolidation10
//
//  Created by Matt Free on 3/21/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import UIKit

enum TextArea {
    case top, bottom
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: Properties
    var imageView: UIImageView!
    
    var currentImage: UIImage?
    
    var hasTopText = false
    var hasBottomText = false
    
    var imageWithTopText: UIImage?
    var imageWithBottomText: UIImage?
    
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
        
        // reseting generator
        currentImage = image
        imageView.image = currentImage
        hasBottomText = false
        hasTopText = false
        imageWithTopText = nil
        imageWithBottomText = nil
        
        assert(currentImage != nil, "image picker gave back nil image")
    }
    
    // MARK: Meming Image
    @objc func addTopText() {
        let ac = UIAlertController(title: "Enter Top Text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Add", style: .default) {
            [weak self, weak ac] _ in
            guard let text = ac?.textFields?[0].text else { return }
            self?.addToPictureText(text.uppercased(), to: .top)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @objc func addBottomText() {
        let ac = UIAlertController(title: "Enter Bottom Text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Add", style: .default) {
            [weak self, weak ac] _ in
            guard let text = ac?.textFields?[0].text else { return }
            self?.addToPictureText(text.uppercased(), to: .bottom)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func addToPictureText(_ text: String, to area: TextArea) {
        var image: UIImage
        
        if area == .top && hasTopText {
            if let imageWithBottomText = imageWithBottomText {
                image = imageWithBottomText
            } else { return }
        } else if area == .bottom && hasBottomText {
            if let imageWithTopText = imageWithTopText {
                image = imageWithTopText
            } else { return }
        } else {
            if let currentImage = currentImage {
                image = currentImage
            } else { return }
        }
        
        let render = UIGraphicsImageRenderer(size: CGSize(width: image.size.width, height: image.size.height))
        
        let newImage = render.image { (context) in
            image.draw(at: CGPoint(x: 0, y: 0))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.init(name: "Impact", size: 100)!,
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.white
            ]
            
            let attributedString = NSMutableAttributedString(string: text, attributes: attributes)
            
            if area == .top {
                attributedString.draw(with: CGRect(x: image.size.width / 20, y: image.size.width / 20, width: image.size.width * 0.9, height: image.size.height / 3), options: .usesLineFragmentOrigin, context: nil)
            } else {
                attributedString.draw(with: CGRect(x: image.size.width / 20, y: image.size.width / 10 + 2 * image.size.height / 3, width: image.size.width * 0.9, height: image.size.height / 3), options: .usesLineFragmentOrigin, context: nil)
            }
        }
        
        imageView.image = newImage
        currentImage = newImage
        
        if area == .top && hasTopText {
            if let imageWithBottomText = imageWithBottomText {
                image = imageWithBottomText
            } else { return }
        } else if area == .bottom && hasBottomText {
            if let imageWithTopText = imageWithTopText {
                image = imageWithTopText
            } else { return }
        }
    }
    
    // MARK: Share Image
    @objc func shareMeme() {
        guard let image = currentImage else { return }
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            fatalError("image was not able to be compressed")
        }
        
        let vc = UIActivityViewController(activityItems: [imageData], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}

