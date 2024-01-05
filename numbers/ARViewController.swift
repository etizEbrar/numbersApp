import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {
    var sceneView: ARSCNView!
    
    let modelProperties: [String: (scale: SCNVector3, position: SCNVector3)] = [
            "Butterfly": (scale: SCNVector3(0.0022, 0.0022, 0.0022), position: SCNVector3(0, 0, -0.5)), // kelebek
            "Duck": (scale: SCNVector3(0.1, 0.1, 0.1), position: SCNVector3(0, -0.5, -0.5)), // ördek
            "Zebra": (scale: SCNVector3(0.04, 0.04, 0.4), position: SCNVector3(0, 0, 0)), // örnek
            "Pigeons": (scale: SCNVector3(0.2, 0.2, 0.2), position: SCNVector3(0, 0.5, -0.5)), // örnek
            "Great_White_Shark": (scale: SCNVector3(0.2, 0.2, 0.2), position: SCNVector3(0, 0.5, -0.5)) // örnek
        ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupARSceneView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // ARKit konfigürasyonunu başlatın
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause() // AR oturumunu durdurun
    }

    private func setupARSceneView() {
        sceneView = ARSCNView(frame: view.bounds)
        view.addSubview(sceneView)

        sceneView.delegate = self
        sceneView.scene = SCNScene()
    }
    
    func loadModel(named modelName: String, positionOffset: Float = 0) {
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "usdz"),
              let properties = modelProperties[modelName] else {
            print("\(modelName) model dosyası bulunamadı veya model özellikleri tanımlanmamış.")
            return
        }

        let modelNode = SCNNode()
        modelNode.loadModel(from: modelURL)
        modelNode.scale = properties.scale
        // Pozisyonu hafifçe değiştirerek birden fazla modeli yan yana yerleştirin
        modelNode.position = SCNVector3(properties.position.x + positionOffset,
                                        properties.position.y,
                                        properties.position.z)
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
