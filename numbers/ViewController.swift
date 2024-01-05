//
//  ViewController.swift
//  numbers
//
//  Created by Ebrar Etiz on 3.12.2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
            super.viewDidLoad()
        view.backgroundColor = .white
                setupLevelButtons()
       
            }

            private func setupLevelButtons() {
                let levels = 1...4
                let buttonHeight: CGFloat = 60
                let buttonWidth: CGFloat = view.bounds.width * 0.8
                var lastButton: UIButton?

                for level in levels {
                    let button = UIButton()
                    button.translatesAutoresizingMaskIntoConstraints = false
                    button.setTitle("Level \(level)", for: .normal)
                    button.backgroundColor = UIColor.systemBlue
                    button.layer.cornerRadius = 10
                    button.tag = level
                    button.addTarget(self, action: #selector(levelButtonTapped(_:)), for: .touchUpInside)
                    view.addSubview(button)

                    // Auto Layout Constraints
                    NSLayoutConstraint.activate([
                        button.heightAnchor.constraint(equalToConstant: buttonHeight),
                        button.widthAnchor.constraint(equalToConstant: buttonWidth),
                        button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
                    ])

                    if let lastButton = lastButton {
                        button.topAnchor.constraint(equalTo: lastButton.bottomAnchor, constant: 20).isActive = true
                    } else {
                        button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 177).isActive = true
                    }

                    lastButton = button
                }
            }

            @objc private func levelButtonTapped(_ sender: UIButton) {
                switch sender.tag {
                case 1:
                    let levelOneVC = LevelOneViewController() // LevelOneViewController'ı burada tanımlayın
                    levelOneVC.modalPresentationStyle = .popover
                    self.present(levelOneVC, animated: true, completion: nil)
                // Diğer seviyeler için ek durumlar ekleyebilirsiniz
                case 2:
                        // LevelTwoViewController'a geçiş yap
                        if let levelTwoVC = storyboard?.instantiateViewController(withIdentifier: "LevelTwoViewController") as? LevelTwoViewController {
                            levelTwoVC.modalPresentationStyle = .fullScreen
                            self.present(levelTwoVC, animated: true, completion: nil)
                        }
                case 3:
                        // LevelTwoViewController'a geçiş yap
                        if let levelThreeVC = storyboard?.instantiateViewController(withIdentifier: "LevelThreeViewController") as? LevelThreeViewController {
                            levelThreeVC.modalPresentationStyle = .fullScreen
                            self.present(levelThreeVC, animated: true, completion: nil)
                        }
                case 4:
                        // LevelTwoViewController'a geçiş yap
                        if let levelFourVC = storyboard?.instantiateViewController(withIdentifier: "LevelFourViewController") as? LevelFourViewController {
                            levelFourVC.modalPresentationStyle = .fullScreen
                            self.present(levelFourVC, animated: true, completion: nil)
                        }
                default:
                    break
                }
            }
        }
