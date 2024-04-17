//
//  CameraView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/5/24.
//

import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isShowingCamera: Bool
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
}

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: CameraView
    
    init(picker: CameraView) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        self.picker.selectedImage = selectedImage
        self.picker.isShowingCamera.toggle()
    }
}

#Preview {
    CameraView(selectedImage: .constant(UIImage(contentsOfFile: "default")), isShowingCamera: .constant(false))
}
