//
//  MainMenuScene.swift
//  ZombieConga
//
//  Created by Romaniuk Sergey on 20.11.14.
//  Copyright (c) 2014 Romaniuk Sergey. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    

    override func didMoveToView(view: SKView) {
        var background = SKSpriteNode(imageNamed: "MainMenu")
            background.position = CGPoint(x: self.size.width/2,
                                          y: self.size.height/2)
        self.addChild(background)
            } // проверено
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent){
        
        sceneTapped()

    }  // проверено
    
    func sceneTapped() {
        let mainScene = GameScene(size: self.size)
        mainScene.scaleMode = self.scaleMode
        let transition = SKTransition.doorwayWithDuration(1.5)
        self.view?.presentScene(mainScene, transition: transition)
 
    }  // проверено

    
    
}
