//
//  QRScannerViewController.swift
//  TOTPly-ios
//
//  Created by Matthew on 30.03.2026.
//

import UIKit
import AVFoundation

final class QRScannerViewController: UIViewController {
    private let completion: (String) -> Void
    private var captureSession: AVCaptureSession?

    init(completion: @escaping (String) -> Void) {
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = "Сканировать QR"

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Закрыть",
            style: .plain,
            target: self,
            action: #selector(didTapClose)
        )
        navigationItem.leftBarButtonItem?.tintColor = .white

        #if targetEnvironment(simulator)
        setupSimulatorFallback()
        #else
        setupCamera()
        #endif
    }

    #if !targetEnvironment(simulator)
    private func setupCamera() {
        let session = AVCaptureSession()

        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else {
            showError("Камера недоступна")
            return
        }

        guard session.canAddInput(input) else {
            showError("Не удалось подключить камеру")
            return
        }
        session.addInput(input)

        let output = AVCaptureMetadataOutput()
        guard session.canAddOutput(output) else {
            showError("Не удалось настроить сканер")
            return
        }
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: .main)
        output.metadataObjectTypes = [.qr]

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.insertSublayer(previewLayer, at: 0)

        captureSession = session
        DispatchQueue.global(qos: .userInitiated).async {
            session.startRunning()
        }
    }
    #endif

    private func setupSimulatorFallback() {
        let label = UILabel()
        label.text = "Камера недоступна на симуляторе"
        label.apply(.headline)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        let testButton = DSButton(style: .primary, title: "Использовать тестовый QR")
        testButton.addTarget(self, action: #selector(didTapTestQR), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [label, testButton])
        stack.axis = .vertical
        stack.spacing = DS.Spacing.xl
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DS.Spacing.xl),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DS.Spacing.xl),
        ])
    }

    @objc private func didTapTestQR() {
        let testURI = "otpauth://totp/GitHub:user@example.com?secret=JBSWY3DPEHPK3PXP&issuer=GitHub&algorithm=SHA1&digits=6&period=30"
        handleScannedCode(testURI)
    }

    private func handleScannedCode(_ code: String) {
        captureSession?.stopRunning()
        dismiss(animated: true) { [completion] in
            completion(code)
        }
    }

    private func showError(_ message: String) {
        let label = UILabel()
        label.text = message
        label.apply(.headline)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    @objc private func didTapClose() {
        captureSession?.stopRunning()
        dismiss(animated: true)
    }
}

#if !targetEnvironment(simulator)
extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard let metadata = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              metadata.type == .qr,
              let code = metadata.stringValue else {
            return
        }
        handleScannedCode(code)
    }
}
#endif
