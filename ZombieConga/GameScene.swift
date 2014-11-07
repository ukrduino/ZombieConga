//
//  GameScene.swift
//  ZombieConga
//
//  Created by Romaniuk Sergey on 03.11.14.
//  Copyright (c) 2014 Romaniuk Sergey. All rights reserved.
//

import SpriteKit
class GameScene: SKScene {
//A scene is the root node of your content. It is used to display SpriteKit content on an SKView.
//    Called once when the scene is created, do your one-time setup here.
//    A scene is infinitely large, but it has a viewport that is the frame through which you present the content of the scene.
//    The passed in size defines the size of this viewport that you use to present the scene.
//    To display different portions of your scene, move the contents relative to the viewport. One way to do that is to create a SKNode to function as a viewport transformation. That node should have all visible conents parented under it.

// определение констант
    let zombie = SKSpriteNode(imageNamed: "zombie1")
    let zombieMovePointsPerSec: CGFloat = 480.0
    let playableRect: CGRect

// определение переменных
    var velocity = CGPointZero
    var lastUpdateTime: NSTimeInterval = 0
    var dt: NSTimeInterval = 0

    override init(size: CGSize) {
        let maxAspectRatio:CGFloat = 16.0/9.0 // 1
        let playableHeight = size.width / maxAspectRatio // 2
        let playableMargin = (size.height-playableHeight)/2.0 // 3 
        
        playableRect = CGRect(x: 0,
                              y: playableMargin,
                          width: size.width,
                         height: playableHeight) // 4 
        super.init(size: size) // 5
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // 6
    }
    
    func debugDrawPlayableArea() {
                                let shape = SKShapeNode()
                                let path = CGPathCreateMutable()
                                CGPathAddRect(path, nil, playableRect)
                                shape.path = path
                                shape.strokeColor = SKColor.redColor()
                                shape.lineWidth = 4.0
                                addChild(shape)
    }
    
    
//определение и переопределение  методов
    override func didMoveToView(view: SKView) {
        let background = SKSpriteNode(imageNamed: "background1")
        background.zPosition = -1
        addChild(background)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.anchorPoint = CGPointZero
        background.position = CGPointZero
        let mySize = background.size
    println("Size: \(mySize)")

    zombie.position = CGPoint(x: 400, y: 400)
    //zombie.setScale(2.0) // SKNode method
        
    addChild(zombie)
    debugDrawPlayableArea()
    }
    
    override func update(currentTime: NSTimeInterval){
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else { dt = 0
        }
        lastUpdateTime = currentTime
        println("\(dt*1000) milliseconds since last update")
        
        moveSprite(zombie, velocity: velocity)
        boundsCheckZombie()
        rotateSprite(zombie, direction: velocity)
    }
    
    func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) { //принимает параметры (спрайт, скорость)
            let amountToMove = CGPoint(x: velocity.x * CGFloat(dt),
                                       y: velocity.y * CGFloat(dt))
            
            println("Amount to move: \(amountToMove)") // 2
            sprite.position = CGPoint(x: sprite.position.x + amountToMove.x,
                                      y: sprite.position.y + amountToMove.y) }
    
    func moveZombieToward(location: CGPoint) {
        let offset = CGPoint(x: location.x - zombie.position.x,
                             y: location.y - zombie.position.y)
        let length = sqrt(Double(offset.x * offset.x + offset.y * offset.y))
        let direction = CGPoint(x: offset.x / CGFloat(length),
                                y: offset.y / CGFloat(length))
        velocity = CGPoint(x: direction.x * zombieMovePointsPerSec,
                           y: direction.y * zombieMovePointsPerSec)
    }
    
    func sceneTouched(touchLocation:CGPoint) {
        moveZombieToward(touchLocation)
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        let touch = touches.anyObject() as UITouch
        let touchLocation = touch.locationInNode(self)
        sceneTouched(touchLocation)
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        
        let touch = touches.anyObject() as UITouch
        let touchLocation = touch.locationInNode(self)
        sceneTouched(touchLocation)
    }
    
    func boundsCheckZombie() {
            let bottomLeft = CGPoint(x: 0,
                                     y: CGRectGetMinY(playableRect))
            let topRight = CGPoint(x: size.width,
                                   y: CGRectGetMaxY(playableRect))
            
            if zombie.position.x <= bottomLeft.x {
                zombie.position.x = bottomLeft.x
                velocity.x = -velocity.x
            }
            if zombie.position.x >= topRight.x {
                zombie.position.x = topRight.x
                velocity.x = -velocity.x
            }
            if zombie.position.y <= bottomLeft.y {
                zombie.position.y = bottomLeft.y
                velocity.y = -velocity.y
            }
            if zombie.position.y >= topRight.y {
                zombie.position.y = topRight.y
                velocity.y = -velocity.y }
    }
    func rotateSprite(sprite: SKSpriteNode,
                   direction: CGPoint){
        sprite.zRotation = CGFloat(atan2(Double(direction.y),
                                         Double(direction.x)))
    }
}


