//
//  ViewController.swift
//  SolarSystem
//
//  Created by Aishvi Vivek Shah on 28/8/18.
//  Copyright © 2018 Aishvi Vivek Shah. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    //var sceneView: ARSCNView!
    
    @IBOutlet var sceneView: ARSCNView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        //sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        sceneView.autoenablesDefaultLighting = true
        
        let sun = SCNSphere(radius: 0.35)
        let sunMaterial = SCNMaterial()
        sunMaterial.diffuse.contents = UIImage(named: "art.scnassets/2k_sun.jpg")
        sun.materials = [sunMaterial]
        
        let sunNode = SCNNode()
        sunNode.geometry = sun
        sunNode.position = SCNVector3(0,0,-1)
        
        let earthParent = SCNNode()
        earthParent.position = SCNVector3(0,0,-1)
        
        let venusParent = SCNNode()
        venusParent.position = SCNVector3(0,0,-1)
        
        let earthMoonParent = SCNNode()
        earthMoonParent.position = SCNVector3(1.2,0,0)
        
        sceneView.scene.rootNode.addChildNode(sunNode)
        sceneView.scene.rootNode.addChildNode(earthParent)
        sceneView.scene.rootNode.addChildNode(venusParent)
        
        let earth = addPlanet(radius: 0.2, diffuse: "art.scnassets/2k_earth_daymap.jpg", specular: "art.scnassets/2k_earth_specular_map.tif", emission: "art.scnassets/2k_earth_clouds.jpg" , normal: "art.scnassets/2k_earth_normal_map.tif", position: SCNVector3(1.2,0,0))
        
        let venus = addPlanet(radius: 0.1, diffuse: "art.scnassets/2k_venus_surface.jpg", specular: nil, emission: "art/scnassets/2k_venus_atmosphere.jpg", normal: nil, position: SCNVector3(0.7,0,0))
        
        let earthMoon = addPlanet(radius: 0.05, diffuse: "art.scnassets/2k_moon.jpg", specular: nil, emission: nil, normal: nil, position: SCNVector3(0,0,-0.3))
        
//        let venusMoon = addPlanet(radius: 0.05, diffuse: "art.scnassets/2k_moon.jpg", specular: nil, emission: nil, normal: nil, position: SCNVector3(0,0,-0.3))
//        let earth = SCNSphere(radius: 0.2)
//        let earthMaterial = SCNMaterial()
//        earthMaterial.diffuse.contents = UIImage(named: "art.scnassets/2k_earth_daymap.jpg")
//        earthMaterial.specular.contents = UIImage(named: "art.scnassets/2k_earth_specular_map.tif")
//        earthMaterial.emission.contents = UIImage(named: "art.scnassets/2k_earth_clouds.jpg")
//        earthMaterial.normal.contents = UIImage(named: "art.scnassets/2k_earth_normal_map.tif")
//        earth.materials = [earthMaterial]
//
//        let earthNode = SCNNode()
//        earthNode.geometry = earth
//        earthNode.position = SCNVector3(1.2,0,0)
        
//        let sunAction = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi * 2) , z: 0, duration: 8)
//        let forever = SCNAction.repeatForever(sunAction)
//        sunNode.runAction(forever)
//
//        let earthParentRotation = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi * 2), z:0 , duration: 14)
//        let foreverEarth = SCNAction.repeatForever(earthParentRotation)
//        earthParent.runAction(foreverEarth)
//
//        let venusParentRotation = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi * 2), z:0 , duration: 10)
//        let foreverVenus = SCNAction.repeatForever(venusParentRotation)
//        venusParent.runAction(foreverVenus)
//
//        let earthRotation = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi * 2), z:0 , duration: 8)
//        let foreverMoonEarth = SCNAction.repeatForever(earthRotation)
//        earth.runAction(foreverMoonEarth)
//
//        let venusRotation = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi * 2), z:0 , duration: 8)
//        let foreverMoonVenus = SCNAction.repeatForever(venusRotation)
//        venus.runAction(foreverMoonVenus)
        
        let sunAction = planetRotation(time: 8)
        sunNode.runAction(sunAction)
        let earthParentRotation = planetRotation(time: 14)
        earthParent.runAction(earthParentRotation)
        let venusParentRotation = planetRotation(time: 10)
        venusParent.runAction(venusParentRotation)
        let earthRotation = planetRotation(time: 8)
        earth.runAction(earthRotation)
//        let venusRotation = planetRotation(time: 8)
//        venus.runAction(venusRotation)
        let earthMoonRotation = planetRotation(time: 5)
        earthMoonParent.runAction(earthMoonRotation)
        
//        sunNode.addChildNode(earth)
//        sunNode.addChildNode(venus)
        
        earthParent.addChildNode(earth)
        earthParent.addChildNode(earthMoonParent)
        venusParent.addChildNode(venus)
        //earth.addChildNode(earthMoon)
//        venus.addChildNode(venusMoon)
        earthMoonParent.addChildNode(earthMoon)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    func planetRotation(time: TimeInterval) -> SCNAction
    {
        let rotation = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi*2), z: 0, duration: time)
        let foreverRotation = SCNAction.repeatForever(rotation)
        return foreverRotation
    }
    //func addPlanet(radius: CGFloat ,geometry: SCNGeometry, diffuse: UIImage, specular: UIImage, emission: UIImage, normal:UIImage, position: SCNVector3) -> SCNNode
    func addPlanet(radius: CGFloat, diffuse: String, specular: String?, emission: String?, normal:String?, position: SCNVector3) -> SCNNode
    {
        
        let planet = SCNSphere(radius: radius)
        let planetMaterial = SCNMaterial()
        planetMaterial.diffuse.contents = UIImage(named: diffuse)
        if let specularValue = specular
        {
            planetMaterial.specular.contents = UIImage(named: specularValue)
        }
        if let emissionValue = emission
        {
            planetMaterial.emission.contents = UIImage(named: emissionValue)
        }
        if let normalValue = normal
        {
            planetMaterial.normal.contents = UIImage(named: normalValue)
        }
        planet.materials = [planetMaterial]
        
        let planetNode = SCNNode()
        planetNode.geometry = planet
        planetNode.position = position
        
        return planetNode
    }
}
