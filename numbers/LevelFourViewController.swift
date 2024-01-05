import UIKit
import AVFoundation

class LevelFourViewController: UIViewController {
    
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
    
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageViews()
        setupAudioSession()
    }

    func setupImageViews() {
        let imageViews = [imageView0, imageView1, imageView2, imageView3, imageView4, imageView5, imageView6, imageView7, imageView8, imageView9]
        for (index, imageView) in imageViews.enumerated() {
            imageView?.isUserInteractionEnabled = true
            imageView?.tag = index
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            imageView?.addGestureRecognizer(tapGesture)
        }
    }
    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("An error occurred setting the audio session category: \(error)")
        }
    }

    func playSound(for number: Int) {
        let fileName = "Yeni Kayıt \(number + 1)" // Dosya adı 1'den başlıyor
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "m4a") else {
            print("Audio file not found: \(fileName)")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Audio playback error: \(error)")
        }
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        if let tag = sender.view?.tag {
            playSound(for: tag)
        }
    }
    
    @IBAction func geriDonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
}
