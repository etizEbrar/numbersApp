//
//  LevelOneViewController.swift
//  numbers
//
//  Created by Ebrar Etiz on 3.12.2023.
//

import UIKit

class LevelOneViewController: UIViewController {

    override func viewDidLoad() {
                super.viewDidLoad()
                view.backgroundColor = .white
                setupNumberButtons()
            }

    private func setupNumberButtons() {
            let buttonWidth: CGFloat = 131
            let buttonHeight: CGFloat = 190 // Sabit buton boyutu (dikdörtgen)

            let spacing: CGFloat = 10
            let buttonsPerRow = 3
            var lastButton: UIButton?

            for number in 0..<11 {
                let button = UIButton()
                button.translatesAutoresizingMaskIntoConstraints = false
                button.setImage(UIImage(named: "image\(number)"), for: .normal)
                button.tag = number
                button.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
                view.addSubview(button)

                let row = number / buttonsPerRow
                let column = number % buttonsPerRow
                NSLayoutConstraint.activate([
                    button.widthAnchor.constraint(equalToConstant: buttonWidth),
                    button.heightAnchor.constraint(equalToConstant: buttonHeight),
                    button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(column) * (buttonWidth + spacing)),
                    button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: CGFloat(row) * (buttonHeight + spacing))
                ])

                lastButton = button
            }

            if let lastButton = lastButton {
                NSLayoutConstraint.activate([
                    lastButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -spacing)
                ])
            }
        }

        @objc private func numberButtonTapped(_ sender: UIButton) {
            let arViewController = ARViewController()
                present(arViewController, animated: true, completion: {
                    if sender.tag == 2 {
                        // 1 numaralı buton için "butterfly" modelini yükle
                        arViewController.loadModel(named: "butterfly")
                    } else if sender.tag == 3 {
                        // 2 numaralı buton için "duck" modelini 2 adet yükle
                        arViewController.loadModel(named: "duck")
                    }
                })
        }
    }