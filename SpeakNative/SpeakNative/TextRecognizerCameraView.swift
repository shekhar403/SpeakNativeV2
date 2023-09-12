//
//  TextRecognizerCameraView.swift
//  SpeakNative
//
//  Created by Shekhar.Dora on 20/08/23.
//

#if os(iOS)
import SwiftUI
import AVFoundation
import TipKit

class CameraViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var capturedImage: CGImage?
    @Published var recognizedText: String?
    var updateTranslationText: ((String) -> Void)?
    
    var captureSession = AVCaptureSession()
    private var captureQueue = DispatchQueue(label: "com.yourapp.captureQueue")
    
    override init() {
        super.init()
        setupCaptureSession()
    }
    
    private func setupCaptureSession() {
        captureQueue.async {
            guard let captureDevice = AVCaptureDevice.default(for: .video),
                  let input = try? AVCaptureDeviceInput(device: captureDevice) else {
                return
            }
            
            let photoOutput = AVCapturePhotoOutput()
            if self.captureSession.canAddInput(input) && self.captureSession.canAddOutput(photoOutput) {
                self.captureSession.addInput(input)
                self.captureSession.addOutput(photoOutput)
                self.captureSession.startRunning()
            }
        }
    }
    
    func capturePhoto() {
        captureQueue.async {
            guard let photoOutput = self.captureSession.outputs.first as? AVCapturePhotoOutput else {
                return
            }
            
            let photoSettings = AVCapturePhotoSettings()
            photoOutput.capturePhoto(with: photoSettings, delegate: self)
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(), let uiImage = UIImage(data: imageData) {
            TextOCRVisionHandler.recognizeText(image: uiImage.cgImage) { [weak self] text in
                self?.recognizedText = text
                self?.captureSession.stopRunning()
                self?.capturedImage = nil
            }
            self.capturedImage = uiImage.cgImage
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }
        
        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }
    
    let session: AVCaptureSession
    var orientation = UIDeviceOrientation.unknown
    
    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        view.backgroundColor = .black
        view.videoPreviewLayer.cornerRadius = 0
        view.videoPreviewLayer.session = session
        
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        
        return view
    }
    
    func updateUIView(_ uiView: VideoPreviewView, context: Context) {
        switch orientation {
        case .unknown:
            break
        case .portrait:
            uiView.videoPreviewLayer.connection?.videoOrientation = .portrait
        case .portraitUpsideDown:
            uiView.videoPreviewLayer.connection?.videoOrientation = .portraitUpsideDown
        case .landscapeLeft:
            uiView.videoPreviewLayer.connection?.videoOrientation = .landscapeRight
        case .landscapeRight:
            uiView.videoPreviewLayer.connection?.videoOrientation = .landscapeLeft
        case .faceUp:
            break
        case .faceDown:
            break
        @unknown default:
            break
        }
    }
}

struct TextRecognizerCameraView: View {
    @Binding var translationText: [MessageModel]
    @StateObject private var viewModel = CameraViewModel()
    @State private var orientation = UIDeviceOrientation.unknown
    var language: String = ""
    
    var body: some View {
        ZStack(content: {
            Color("darkBlack").ignoresSafeArea(.all, edges: .all)
            
            if let image = viewModel.capturedImage {
                Image(decorative: image, scale: 1.0, orientation: orientation.isLandscape ? .up : .right)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                CameraPreview(session: viewModel.captureSession, orientation: orientation)
                    .onRotate { o in
                        orientation = o
                    }
            }
            
            VStack {
                Spacer()
                HStack {
                    if #available(macOS 14.0, iOS 17.0, *) {
                        Button(action: { self.viewModel.capturePhoto() }) {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65, height: 65, alignment: .center)
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: 75, height: 75, alignment: .center)
                            }
                            
                        }
                        .accessibilityShowsLargeContentViewer({
                            VStack {
                                Text("Capture")
                            }
                        })
                        .accessibilityLabel("Cpature")
#if os(iOS)
                        .popoverTip(ShowButtonTip(idValue: "Capture_tip", titleValue: "Capture", messageValue: "·Capture an image that contains text and go back to view the recognized text and translated text."), arrowEdge: .bottom)
                        #endif
                    }
                    else {
                        Button(action: { self.viewModel.capturePhoto() }) {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65, height: 65, alignment: .center)
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: 75, height: 75, alignment: .center)
                            }
                        }
                        .accessibilityShowsLargeContentViewer({
                            VStack {
                                Text("Capture")
                            }
                        })
                    }
                }
            }
        })
        .onDisappear {
            if let text = viewModel.recognizedText {
                
                // setting default recognized Language
                var recognizedLanguage = "en"
                let gTranslator = SwiftGoogleTranslate.shared
                
                if let languageDict = (gTranslator.supportedLanguages.filter { $0.name == language }).first {
                    let languageCode = languageDict.language
                    
                    // Detecting original language
                    gTranslator.detect(text) { (detections, error) in
                        if let detections = detections {
                            for detection in detections {
                                if detection.confidence > 0.6 {
                                    recognizedLanguage = detection.language
                                }
                            }
                        }
                    }
                    
                    translationText.append(MessageModel(language: recognizedLanguage, message: text))
                    
                    // translating to target language
                    gTranslator.translate(text, languageCode, recognizedLanguage) { (text, error) in
                        if let t = text {
                            translationText.append(MessageModel(language: languageCode, message: t))
                        }
                    }
                    
                    
                    //                        Libretranslate Api - backup trasnlator service
                    //                        LibreTranslationService.translate(text, targetLanguageCode: languageCode) { t in
                    //                            translationText += "Language: \(language)"
                    //                            translationText += "\r\n"
                    //                            translationText += t
                    //                            translationText += "\r\n\r\n"
                    //                        }
                }
            }
        }
    }
}
#endif
