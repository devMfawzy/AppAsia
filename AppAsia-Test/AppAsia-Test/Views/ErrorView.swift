//
//  ErrorView.swift
//  AppAsia-Test
//
//  Created by Mohamed Fawzy on 26/10/2022.
//

import UIKit

final class ErrorView: UIView {
    
    private let label = UILabel()
    private let button = UIButton(type: .system)
    private var retryHandler: (() -> Void)?
    private var didSetupContrainsts = false
    
    init() {
        super.init(frame: .zero)
        addSubviews()
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show(message: String) {
        label.text = message
    }
    
    func onRetryButtonClick(handler: @escaping () -> Void) {
        retryHandler = handler
    }
    
    // MARK: - Private methods
    
    private func addSubviews() {
        [label, button].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        updateConstraintsIfNeeded()
    }
    
    private func setUpViews() {
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = .zero
        label.textColor = .systemPink
        
        button.setTitle("Retry", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.addTarget(self, action: #selector(retry), for: .touchUpInside)
        backgroundColor = .init(white: 0.85, alpha: 1)
    }
    
    @objc private func retry() {
        retryHandler?()
    }

    // MARK: - Auto layout

    override func updateConstraints() {
        if !didSetupContrainsts {
            let buttonWidthConstraint =  button.widthAnchor.constraint(equalToConstant: 32)
            buttonWidthConstraint.priority = .defaultHigh
            
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: topAnchor, constant: 8),
                label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
                label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
                label.trailingAnchor.constraint(greaterThanOrEqualTo: button.leadingAnchor, constant: -4),

                button.topAnchor.constraint(equalTo: topAnchor, constant: 8),
                button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
                button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
                buttonWidthConstraint
            ])
            
            didSetupContrainsts = true
        }
        super.updateConstraints()
    }
    
}
