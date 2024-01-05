//
//  LevelThreeViewController.swift
//  numbers
//
//  Created by Ebrar Etiz on 29.12.2023.
//

import UIKit
import AVFoundation

class LevelThreeViewController: UIViewController {
    
    @IBOutlet weak var imageView0: UIImageView!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var imageView5: UIImageView!
    @IBOutlet weak var imageView6: UIImageView!
    @IBOutlet weak var imageView7: UIImageView!
    @IBOutlet weak var imageView8: UIImageView!
    @IBOutlet weak var imageView9: UIImageView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var numberImageViews: [UIImageView] {
        [imageView0, imageView1, imageView2, imageView3, imageView4, imageView5, imageView6, imageView7, imageView8, imageView9]
    }
    
    var applausePlayer: AVAudioPlayer?
    var audioPlayer: AVAudioPlayer?
    var correctNumberToFind: Int = 0
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
            if score == 15 {
                finishGame()
            }
        }
    }
    var gameTimer: Timer?
    var secondsElapsed = 0
    
    var originalBackgroundColor: UIColor? // Arka planın orijinal rengini saklayın

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudioSession()
        setupNumberImageViews()
        promptUserToFindNumber()
        startGame()
    }
    
    func setupNumberImageViews() {
        numberImageViews.enumerated().forEach { (index, imageView) in
            imageView.image = UIImage(named: "number\(index)_correct")
            imageView.tag = index
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:))))
        }
    }
    
    func startGame() {
        secondsElapsed = 0
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        promptUserToFindNumber()
    }
    
    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("An error occurred setting the audio session category: \(error)")
        }
    }

    func promptUserToFindNumber() {
        correctNumberToFind = Int.random(in: 0...9)
        playSound(for: correctNumberToFind)
    }
    
    
    
    func playSound(for number: Int) {
        let fileName = "\(number)"
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "m4a") else {
            print("Audio file not found for number \(number)")
            return
        }

        if audioPlayer != nil {
            audioPlayer?.stop() // Önceki ses çalma işlemini durdur
            audioPlayer = nil
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay() // Ses dosyasını hazırla
            audioPlayer?.play() // Ses dosyasını çal
        } catch {
            print("Audio playback error: \(error)")
        }
    }
    
    func playApplause() {
        guard let url = Bundle.main.url(forResource: "alkiss", withExtension: "mp3") else {
            print("Alkış ses dosyası bulunamadı.")
            return
        }

        do {
            applausePlayer = try AVAudioPlayer(contentsOf: url)
            applausePlayer?.prepareToPlay()
            applausePlayer?.play()

            // Alkış sesinin bitiminden sonra yeni bir rakam sor
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                self?.applausePlayer?.stop()
                self?.correctNumberToFind = Int.random(in: 0...9) // Yeni bir rakam seç
                self?.playSound(for: self?.correctNumberToFind ?? 0)
            }
        } catch {
            print("Alkış sesi oynatılırken bir hata oluştu: \(error)")
        }
    }




    
    @objc func updateTimer() {
        secondsElapsed += 1
    }
    
    func finishGame() {
        gameTimer?.invalidate()
        showAlertWithTime()
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedImageView = sender.view as? UIImageView else { return }
        
        numberImageViews.forEach { $0.layer.borderWidth = 0 }  // Diğer tüm çerçeveleri sıfırla
        
        if tappedImageView.tag == correctNumberToFind {
            tappedImageView.layer.borderColor = UIColor.green.cgColor
            tappedImageView.layer.borderWidth = 3.0
            score += 1
            scoreLabel.text = "Score: \(score)"
            playApplause()
        } else {
            tappedImageView.layer.borderColor = UIColor.red.cgColor
            tappedImageView.layer.borderWidth = 3.0
            playSound(for: correctNumberToFind)  // Aynı numarayı tekrar çal
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
        func showAlertWithTime() {
            let alert = UIAlertController(title: "Congratulations", message: "You finished the game in \(secondsElapsed) seconds!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    @IBAction func geriDonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
}

