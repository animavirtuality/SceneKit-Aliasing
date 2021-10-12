//
//  ViewController.swift
//  SceneKit Aliasing
//
//  Created by Grant Jarvis on 10/12/21.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.autoenablesDefaultLighting = true
        
        SceneKitAssetLoader.loadAssetFromFile(named: "Solar Panels", arView: sceneView){ object in
            self.sceneView.scene.rootNode.addChildNode(object)
            
            //Place the object 1m in front and 1m below where the camera was when the session began.
            object.position = .init(0,-1,-1)
        }
        
        sceneView.antialiasingMode = .multisampling4X
        
        sceneView.isJitteringEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

}
