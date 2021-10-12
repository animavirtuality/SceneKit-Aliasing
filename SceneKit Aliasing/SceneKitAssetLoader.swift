//
//  SceneKitAssetLoader.swift
//  SceneKitAssetLoader
//
//  Created by Grant Jarvis on 8/5/21.
//

import SceneKit
import ARKit


let assetLoadingQueue = DispatchQueue(label: "SceneKitAssetLoader.Processing.DispatchQueue", qos: .userInitiated)



struct SceneKitAssetLoader {
    
    ///Load the 3D asset from the main bundle.
    static func loadAssetFromFile(url: URL, arView: ARSCNView, completionHandler: @escaping ((_ preparedAsset: SCNNode) -> Void)){
        //Load on a background thread to avoid dropping frames when loading the 3D asset.
        assetLoadingQueue.async {
            do {
                print("loading from:", url)
                let scene = try SCNScene(url: url, options: [.checkConsistency: true])
                self.prepareAsset(scene: scene, arView: arView) { asset in
                    //Call completion asynchronously on the main thread to avoid dropping frames when loading the 3D asset.
                    DispatchQueue.main.async {
                        completionHandler(asset)
                    }
                }
            } catch {
                print("Error while atempting to load scene")
                print(error.localizedDescription)
            }
        }
}
    
    
    
    ///Load the 3D asset from the main bundle.
    static func loadAssetFromFile(named name: String, withExtension ext: String = "usdz", arView: ARSCNView, completionHandler: @escaping ((_ preparedAsset: SCNNode) -> Void)){
            guard let urlPath = Bundle.main.url(forResource: name, withExtension: ext) else {
                print("Error while atempting to load scene from main bundle.")
                return
            }

        self.loadAssetFromFile(url: urlPath, arView: arView, completionHandler: completionHandler)
    }

    
    ///This uses asynchronous asset preparation to avoid dropping frames when loading the 3D asset.
    /// - Parameters:
    ///   - name: The name of the asset to load, exactly as it is spelled in the hierarchy.
    ///   - scene: The SCNScene to extract the assets from.
    ///   - completionHandler: This passes the prepared asset as a parameter. Access the prepared asset here.
    static func prepareAsset(named name: String = "", scene: SCNScene, arView: ARSCNView, completionHandler: @escaping ((_ preparedAsset: SCNNode) -> Void)){
        if let assetNode = scene.rootNode.childNodes.first {
            //Load on a background thread to avoid dropping frames when loading the 3D asset.

                arView.prepare([assetNode]){success in
                    if success == true {
                        assetNode.name = name
                        completionHandler(assetNode)
                    } else {
                        print("Unable to prepare asset for rendering")
                    }
                }
            } else {
                print("No child found in hierarchy.")
            }
    }
}
