//
//  GameScene.swift
//  ZombieConga
//
//  Created by Romaniuk Sergey on 03.11.14.
//  Copyright (c) 2014 Romaniuk Sergey. All rights reserved.
//

import SpriteKit
class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
    let background = SKSpriteNode(imageNamed: "background1")
    background.zPosition = -1
    addChild(background)
    background.position = CGPoint(x: size.width/2, y: size.height/2)
    background.anchorPoint = CGPointZero
    background.position = CGPointZero
    let mySize = background.size
    println("Size: \(mySize)")
    let zombie = SKSpriteNode(imageNamed: "zombie1")
    zombie.position = CGPoint(x: 400, y: 400)
    addChild(zombie)
    
    }
}

