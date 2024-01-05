//
//  LevelTwoViewController.swift
//  numbers
//
//  Created by Ebrar Etiz on 29.12.2023.
//

import UIKit

class LevelTwoViewController: UIViewController {
    

    @IBOutlet weak var imageView1: UIImageView!
       @IBOutlet weak var imageView2: UIImageView!
       @IBOutlet weak var imageView3: UIImageView!
       @IBOutlet weak var imageView4: UIImageView!
    
    var imageViews: [UIImageView] {
          [imageView1, imageView2, imageView3, imageView4] // UIImageView IBOutlet'larınızı burada gruplayın.
      }
       
       @IBOutlet weak var scoreLabel: UILabel!
       
    var score = 0 {
           didSet {
               scoreLabel?.text = "Score: \(score)"
           }
       }

       var currentLevel = 0
       var correctGuesses = 0
    var originalBackgroundColor: UIColor? // Arka planın orijinal rengini saklayın

    

       override func viewDidLoad() {
           super.viewDidLoad()
           originalBackgroundColor = view.backgroundColor // Başlangıçta orijinal arka plan rengini kaydet
           setupImagesForLevel(currentLevel)
       }
       
    func setupImagesForLevel(_ level: Int) {
        correctGuesses = 0
        let correctImage = UIImage(named: "number\(level)_correct")
        let wrongImage = UIImage(named: "number\(level)_wrong")
        
        // Tüm imageView'ları sakla
        imageViews.forEach { $0.isHidden = true }
        
        // Doğru ve yanlış rakam sayısını belirle
        let totalImages = imageViews.count
        let correctCount = Int.random(in: 1..<totalImages) // En az 1 doğru olacak şekilde rastgele bir sayı seç
        let wrongCount = totalImages - correctCount
        
        // Doğru rakamları yerleştir
        var positions = Array(0..<totalImages)
        let correctPositions = positions.shuffled().prefix(correctCount)
        correctPositions.forEach { index in
            let imageView = imageViews[index]
            imageView.image = correctImage
            imageView.isUserInteractionEnabled = true
            imageView.tag = 1
            imageView.isHidden = false
            correctGuesses += 1
        }
        
        // Yanlış rakamları yerleştir
        positions = positions.filter { !correctPositions.contains($0) }
        let wrongPositions = positions.shuffled().prefix(wrongCount)
        wrongPositions.forEach { index in
            let imageView = imageViews[index]
            imageView.image = wrongImage
            imageView.isUserInteractionEnabled = true
            imageView.tag = 0
            imageView.isHidden = false
        }
        
        // Her imageView'a UITapGestureRecognizer ekle
        imageViews.forEach { imageView in
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
            imageView.addGestureRecognizer(tapGesture)
        }
    }
       
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
          guard let imageView = sender.view as? UIImageView else { return }
          
          if imageView.tag == 1 {
              // Doğru resim seçildi
              imageView.isHidden = true
              correctGuesses -= 1
              score += 1
              
              if correctGuesses == 0 {
                  // Tüm doğru resimler seçildi, bir sonraki seviyeye geç
                  currentLevel += 1
                  setupImagesForLevel(currentLevel)
              }
          } else {
              // Yanlış resim seçildi, hata bildirimi yap
              flashBackgroundColor()
          }
      }
      
      func flashBackgroundColor() {
          UIView.animate(withDuration: 0.1, animations: {
              self.view.backgroundColor = .red
          }) { [weak self] _ in
              UIView.animate(withDuration: 0.1) {
                  self?.view.backgroundColor = self?.originalBackgroundColor
              }
          }
      }
    
    @IBAction func geriDonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
}
