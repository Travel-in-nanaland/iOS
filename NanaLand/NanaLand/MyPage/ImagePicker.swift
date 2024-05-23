//
//  ImagePicker.swift
//  NanaLand
//
//  Created by jun on 5/20/24.
//

import UIKit
import SwiftUI
// 사진 라이브러리 불러오기
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.sourceType = .photoLibrary
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator(parent: self)
        // 애플리케이션의 루트 뷰 컨트롤러를 가져옵니다.
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            coordinator.presentingViewController = rootViewController
        }
        return coordinator
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        var presentingViewController: UIViewController?

        init(parent: ImagePicker) {
            self.parent = parent
       
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                parent.selectedImage = selectedImage
               
            }
            presentingViewController!.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentingViewController?.dismiss(animated: true)
        }
    }
}
