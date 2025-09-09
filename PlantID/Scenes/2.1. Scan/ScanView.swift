//
//  ScanView.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 24.06.25.
//


import UIKit
import AVFoundation

final class ScannerView: BaseViewWithNavigationBar {
    
    var thumbnails: [UIImage] = []
    
    var enableScanning: Bool? {
        didSet {
            guard let enableScanning else { return }
            indicator.isHidden = enableScanning
            enableScanning == false ? indicator.startAnimating() : indicator.stopAnimating()
            preview.enableScanning = enableScanning
        }
    }
    
    var needToHideIndicztor: Bool = false {
        didSet {
            if needToHideIndicztor == true {
                indicator.stopAnimating()
                indicator.isHidden = true
            }
        }
    }

    enum ActionChild {
        case gallery
        case createPhoto
        case add
    }
    var actionHandlerChild: (ActionChild) -> Void = { _ in }

    private lazy var preview: PreView = {
        let view = PreView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.photoCapturedHandler = { [weak self] image in
            self?.addThumbnail(image)
        }
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var galleryButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "scan_galeryy"), for: .normal)
        view.imageView?.contentMode = .scaleAspectFit
        view.widthAnchor ~= 50
        view.heightAnchor ~= 50
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    self?.actionHandlerChild(.gallery)
                }
            ),
            for: .touchUpInside
        )
        return view
    }()
    
    private lazy var captureButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "scan_create_photo"), for: .normal)
        view.imageView?.contentMode = .scaleAspectFit
        view.widthAnchor ~= 105
        view.heightAnchor ~= 105
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    self?.animateScanThenCapture()
                }
            ),
            for: .touchUpInside
        )
        return view
    }()
    
    private lazy var addButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "scan_addd"), for: .normal)
        view.imageView?.contentMode = .scaleAspectFit
        view.widthAnchor ~= 50
        view.heightAnchor ~= 50
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    self?.actionHandlerChild(.add)
                }
            ),
            for: .touchUpInside
        )
        return view
    }()

    private let scannerImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "scan_scanner")
        view.widthAnchor ~= 328
        view.heightAnchor ~= 344
        return view
    }()
    
    /// Вьюшка, которая «шторкой» сканирует
    private let scanOverlay: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        // полупрозрачный белый
        v.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        return v
    }()
    
    private lazy var whiteView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "scan_white_view")
        view.heightAnchor ~= 95
        view.widthAnchor ~= 370
        return view
    }()
    
    private lazy var thumbsStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 12
        view.alignment = .center
        view.backgroundColor = .clear
//        view.widthAnchor ~= 300
        view.heightAnchor ~= 90
        view.distribution = .fillEqually
        return view
    }()
    
    private lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.color = .white
        view.isHidden = true
        return view
    }()

    override func setupContent() {
        super.setupContent()
        
        backgroundColor = #colorLiteral(red: 0.9484557509, green: 0.9733623862, blue: 0.9513770938, alpha: 1)
        addSubview(preview)
        addSubview(whiteView)
        addSubview(galleryButton)
        addSubview(captureButton)
        addSubview(addButton)
        addSubview(scannerImage)
        addSubview(scanOverlay)
        addSubview(thumbsStack)
        addSubview(indicator)
        preview.configureSession()
    }

    override func setupLayout() {
        super.setupLayout()
        
        whiteView.centerXAnchor ~= centerXAnchor
        whiteView.bottomAnchor ~= bottomAnchor - 30
        
        galleryButton.centerYAnchor ~= whiteView.centerYAnchor
        galleryButton.leftAnchor ~= whiteView.leftAnchor + 45
        
        captureButton.centerXAnchor ~= whiteView.centerXAnchor
        captureButton.centerYAnchor ~= whiteView.centerYAnchor - 30
        
        addButton.centerYAnchor ~= whiteView.centerYAnchor
        addButton.rightAnchor ~= whiteView.rightAnchor - 45
        
        preview.topAnchor ~= topAnchor
        preview.leftAnchor ~= leftAnchor
        preview.rightAnchor ~= rightAnchor
        preview.bottomAnchor ~= captureButton.topAnchor - 100
        
        scannerImage.centerYAnchor ~= preview.centerYAnchor + 25
        scannerImage.centerXAnchor ~= preview.centerXAnchor
        
        scanOverlay.topAnchor ~= scannerImage.topAnchor
        scanOverlay.leftAnchor ~= scannerImage.leftAnchor
        scanOverlay.rightAnchor ~= scannerImage.rightAnchor
        scanOverlay.heightAnchor ~= 180
        
        thumbsStack.topAnchor ~= preview.bottomAnchor + 10
        thumbsStack.centerXAnchor ~= centerXAnchor
        
        indicator.centerXAnchor ~= centerXAnchor
        indicator.centerYAnchor ~= centerYAnchor
        
        addNavbarButtons(preview)
    }
    
    private func animateScanThenCapture() {
        // вынесем рамки в local
        layoutIfNeeded()
        let startY = scannerImage.frame.minY
        let endY   = scannerImage.frame.maxY - scanOverlay.frame.height
        
        // позиционируем шторку в старт
        scanOverlay.frame.origin.y = startY
        
        // делаем keyframe-анимацию: 50% времени вниз, 50% — обратно
        UIView.animateKeyframes(
            withDuration: 1.0,
            delay: 0,
            options: [],
            animations: {
                // первая половина: опускаем
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                    self.scanOverlay.frame.origin.y = endY
                }
                // вторая половина: поднимаем обратно
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                    self.scanOverlay.frame.origin.y = startY
                }
            },
            completion: { _ in
                // а здесь уже настоящий снимок
                self.preview.capturePhoto()
            }
        )
    }
    
    func addThumbnail(_ image: UIImage) {
        
        thumbnails.append(image)
        
        if thumbnails.count > 6 {
            thumbnails.removeFirst()
        }
        
        // Если уже 3 превью, удаляем первое из stack (не трогаем массив!)
        if thumbsStack.arrangedSubviews.count == 3 {
            let firstView = thumbsStack.arrangedSubviews.first!
            thumbsStack.removeArrangedSubview(firstView)
            firstView.removeFromSuperview()
        }
        
        let thumbView = UIView()
        thumbView.translatesAutoresizingMaskIntoConstraints = false
        thumbView.widthAnchor ~= 80
        thumbView.heightAnchor ~= 80
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.layer.borderWidth = 2
        iv.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        thumbView.addSubview(iv)
        iv.pinToSuperview()
        
        // кнопка удаления
        let btn = UIButton()
        btn.setImage(UIImage(named: "delete.small"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        thumbView.addSubview(btn)
        
        btn.topAnchor ~= thumbView.topAnchor - 4
        btn.rightAnchor ~= thumbView.rightAnchor - 4
        btn.widthAnchor ~= 20
        btn.heightAnchor ~= 20
        
        btn.addAction(UIAction { [weak self, weak thumbView] _ in
            guard let self,
                  let tv = thumbView,
                  let idx = self.thumbsStack.arrangedSubviews.firstIndex(of: tv) else { return }
            self.thumbnails.remove(at: idx)
            tv.removeFromSuperview()
        }, for: .touchUpInside)
        
        thumbsStack.addArrangedSubview(thumbView)
    }
    
    func refresh() {
        thumbsStack.arrangedSubviews.forEach { thumbView in
            thumbsStack.removeArrangedSubview(thumbView)
            thumbView.removeFromSuperview()
        }
        thumbnails.removeAll()
    }
}

// -------------------------------------------------
// MARK: - PreView
// -------------------------------------------------

private class PreView: UIView {
//    private let captureSession = AVCaptureSession()
    
    private let captureSession: AVCaptureSession = {
        let c = AVCaptureSession()
        DispatchQueue.global(qos: .background).async {
            c.startRunning()
        }
        return c
    }()
    private let photoOutput = AVCapturePhotoOutput()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var isSessionConfigured = false
    
    var photoCapturedHandler: ((UIImage) -> Void)?

    var enableScanning: Bool = false {
        didSet {
            if enableScanning {
                DispatchQueue.global(qos: .background).async { [weak self] in
                    guard let self else { return }
                    self.captureSession.startRunning()
                }
            } else {
                captureSession.stopRunning()
            }
        }
    }

    var actionHandler: (String) -> Void = { _ in }

    func configureSession() {
            guard !isSessionConfigured else { return }
            isSessionConfigured = true

            // 1. Ввод
            guard let device = AVCaptureDevice.default(for: .video),
                  let input  = try? AVCaptureDeviceInput(device: device),
                  captureSession.canAddInput(input) else {
                print("❤️ Failed to add video input")
                return
            }
            captureSession.beginConfiguration()
            captureSession.addInput(input)

            // 2. Вывод
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }
            captureSession.commitConfiguration()

            // 3. Превью-слой
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            layer.addSublayer(previewLayer)
            self.videoPreviewLayer = previewLayer
        }

    override func layoutSubviews() {
        super.layoutSubviews()
//        captureSession.startRunning()
        
        print("Доступ к камере", AVCaptureDevice.authorizationStatus(for: .video).rawValue)
        videoPreviewLayer?.frame = bounds
    }
    
    func capturePhoto() {
        guard let connection = photoOutput.connection(with: .video), connection.isEnabled else {
            print("❌ Нет активного видео-соединения для photoOutput")
            return
        }
        
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
}

extension PreView: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput,
                      didFinishProcessingPhoto photo: AVCapturePhoto,
                      error: Error?) {
         guard
             let data = photo.fileDataRepresentation(),
             let image = UIImage(data: data)
         else { return }
         DispatchQueue.main.async {
             self.photoCapturedHandler?(image)
         }
     }
}

