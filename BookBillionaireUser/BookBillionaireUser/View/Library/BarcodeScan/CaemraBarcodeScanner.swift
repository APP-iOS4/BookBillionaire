//
//  CaemraBarcodeScanner.swift
//  temp40_barcodeReader
//
//  Created by Seungjae Yu on 4/23/24.
//

import SwiftUI
import AVFoundation

struct CameraBarcodeScanner: UIViewControllerRepresentable {
    @Binding var barcodeValue: String?
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = BarcodeScannerViewController()
        viewController.delegate = context.coordinator
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: CameraBarcodeScanner

        init(_ parent: CameraBarcodeScanner) {
            self.parent = parent
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
                if let stringValue = metadataObject.stringValue {
                    parent.barcodeValue = stringValue
                    parent.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}
