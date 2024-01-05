import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {

    var sceneView: ARSCNView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupARSceneView()
        ARWorldTrackingConfiguration()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // AR oturumunu durdurun
        sceneView.session.pause()
    }

    private func setupARSceneView() {
        sceneView = ARSCNView(frame: view.bounds)
        view.addSubview(sceneView)

        sceneView.delegate = self
        sceneView.scene = SCNScene()

        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        
        // Debug seçeneklerini kaldırın veya yorum satırı yapın
        // sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
    }


    func loadModel(named modelName: String) {
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "usdz") else {
            print("\(modelName) model dosyası bulunamadı")
            return
        }

        let modelNode = SCNNode()
        modelNode.loadModel(from: modelURL)
        modelNode.position = SCNVector3(x: 0, y: 0, z: -1) // Modelin pozisyonunu ayarlayın
        modelNode.scale = SCNVector3(2, 2, 2) // Ölçeği ayarlayın

        sceneView.scene.rootNode.addChildNode(modelNode)
    }

}

extension SCNNode {
    func loadModel(from url: URL) {
        guard let objectScene = try? SCNScene(url: url, options: nil) else {
            print("3D model yüklenemedi")
            return
        }
        for child in objectScene.rootNode.childNodes {
            addChildNode(child)
        }
    }
}
