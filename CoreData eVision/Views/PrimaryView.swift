//
//  PrimaryView.swift
//  CoreData eVision
//
//  Created by Davide Gigante on 02/05/23.
//

import SwiftUI
import AVFoundation
import Vision

struct PrimaryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedTab: Tab = .first
    @State private var showingCameraSheet = false // aggiungi questo stato
    @State private var recognizedText: String?
    
    @FetchRequest(entity: Building.entity(), sortDescriptors: []) var buildings: FetchedResults<Building>
    
    var body: some View {
        VStack {
            switch selectedTab {
            case .first:
                NavigationView {
                    HomeView()
                        .environment(\.managedObjectContext, viewContext)
                }
            case .second:
                NavigationView() {
                    SettingView()
                }
            }
            CustomTabView(selectedTab: $selectedTab, showingCameraSheet: $showingCameraSheet) // passa lo stato a CustomTabView
                .frame(height: 25)
        }
        .sheet(isPresented: $showingCameraSheet) {
//            ImagePicker(sourceType: .camera) { image in
//                recognizeText(image: image)
//                print(recognizedText ?? "NOTHING FOUND")
//                showingCameraSheet.toggle()
//            }
            Text("Miao")
        }
    }
    
    func recognizeText(image: UIImage) {
        // Converte l'immagine in scala di grigi
        guard let grayImage = convertToGrayscale(image) else {
            print("Error converting image to grayscale")
            return
        }

        let requestHandler = VNImageRequestHandler(cgImage: grayImage.cgImage!, options: [:])
        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                print("Error recognizing text: \(error)")
                return
            }
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                print("Unexpected result type from VNRecognizeTextRequest")
                return
            }
            let text = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }.joined(separator: "\n")
            DispatchQueue.main.async {
                recognizedText = text
            }
        }
        request.recognitionLevel = .accurate
        try? requestHandler.perform([request])
    }

    func convertToGrayscale(_ image: UIImage) -> UIImage? {
        // Crea un contesto di grafica in scala di grigi
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        guard let context = CGContext(data: nil, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            return nil
        }

        // Disegna l'immagine nel contesto in scala di grigi
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        context.draw(image.cgImage!, in: rect)

        // Crea un'immagine dal contesto in scala di grigi
        guard let grayImage = context.makeImage() else {
            return nil
        }
        return UIImage(cgImage: grayImage)
    }

}

