//
//  GameScene.swift
//  ZombieConga
//
//  Created by Romaniuk Sergey on 03.11.14.
//  Copyright (c) 2014 Romaniuk Sergey. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
//A scene class is the root node of your content. It is used to display SpriteKit content on an SKView.
//    Called once when the scene is created, do your one-time setup here.
//    A scene is infinitely large, but it has a viewport that is the frame through which you present the content of the scene.
//    The passed in size defines the size of this viewport that you use to present the scene.
//    To display different portions of your scene, move the contents relative to the viewport. One way to do that is to create a SKNode to function as a viewport transformation. That node should have all visible conents parented under it.

// определение констант
    let zombie = SKSpriteNode(imageNamed: "zombie1")
    let zombieMovePointsPerSec: CGFloat = 860.0
    let zombieRotateRadiansPerSec:CGFloat = 4.0 * π
    let playableRect: CGRect
    let zombieAnimation: SKAction
    let catCollisionSound: SKAction = SKAction.playSoundFileNamed("hitCat.wav", waitForCompletion: false)
    let enemyCollisionSound: SKAction = SKAction.playSoundFileNamed("hitCatLady.wav", waitForCompletion: false)
    let catMovePointsPerSec: CGFloat = 480.0
    
    
    
// определение переменных
    var velocity = CGPointZero // вектор скорости (куда должен попасть зомби за секунду)
    var lastUpdateTime: NSTimeInterval = 0 //последние обновление картинки
    var dt: NSTimeInterval = 0 // время с последнего обновления картинки в мс
    var lastTouchLocation: CGPoint? // вектор места последнего касания
    var zombieIsInvincible = false
    var lives = 5
    var gameOver = false    
    

    override init(size: CGSize) {
        let maxAspectRatio:CGFloat = 16.0/9.0 // максимальное соотношение сторон 1,77
        let playableHeight = size.width / maxAspectRatio // расчет высоты игровой области
        let playableMargin = (size.height-playableHeight)/2.0 // слепая зона игры
        var textures:[SKTexture] = []
        
        
        playableRect = CGRect(x: 0, // игровая зона гарантированно видимая на всех устройствах
                              y: playableMargin,
                          width: size.width,
                         height: playableHeight) // 4 
        
        for i in 1...4 {textures.append(SKTexture(imageNamed: "zombie\(i)"))
        }
        // 3
        textures.append(textures[2])
        textures.append(textures[1])
        // 4
        zombieAnimation = SKAction.repeatActionForever(
            SKAction.animateWithTextures(textures, timePerFrame: 0.1))
        
        
        
        
        super.init(size: size) // 5
    } // проверено
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // 6
    } // проверено
    
    func debugDrawPlayableArea() {
                                let shape = SKShapeNode()
                                let path = CGPathCreateMutable()
                                CGPathAddRect(path, nil, playableRect)
                                shape.path = path
                                shape.strokeColor = SKColor.redColor()
                                shape.lineWidth = 4.0
                                addChild(shape)
    } // проверено
    
    
//определение и переопределение  методов
    override func didMoveToView(view: SKView) {
        playBackgroundMusic("backgroundMusic.mp3")
        let background = SKSpriteNode(imageNamed: "background1") // определение фона
        background.zPosition = -1 // фон -  самый первый слой
        addChild(background) // добавлени фона к сцене
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        background.anchorPoint = CGPointZero // якорь фона нижний левый угол
//        background.position = CGPointZero // совмещение нижнего левого угла фона с нижним левым углом экрана

        zombie.position = CGPoint(x: 400, y: 400) // установка зомби в начале игры
        zombie.zPosition = 100

        
        addChild(zombie) //добавление зомби к сцене
    
// spawnEnemy
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(spawnEnemy),
                                                                  SKAction.waitForDuration(2.0)])))
    // spawnCat
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(spawnCat),
                                                                  SKAction.waitForDuration(1.0)])))
    
        
                                    
//    debugDrawPlayableArea() // рисование красного квадрата игровой зоны
        
    } // проверено
    
    override func update(currentTime: NSTimeInterval){ //функция обновлени кадров в игре
        
        //функция для вычисления dt (время с последнего обновления картинки в мс)

        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        }
        else {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        if let lastTouch = lastTouchLocation {
            let distanceToStop = (lastTouch-zombie.position).length() //расстояние до остановки зомби

            // если растояние до точки остановки зомби меньше растояния которое зомби должен пройти в этом кадре то зомби ставим в точку где он должен остановиться и устанавливаем вектор скорости  = 0
            if (distanceToStop<=(zombieMovePointsPerSec * CGFloat(dt))){
                zombie.position = lastTouch
                velocity = CGPointZero
                stopZombieAnimation()
        
            }
        // если нет то двигаем зомби и вращаем если нужно
            else {
            
                moveSprite(zombie, velocity: velocity)
                rotateSprite(zombie, velocity: velocity, rotateRadiansPerSec: zombieRotateRadiansPerSec)
            }
        
        boundsCheckZombie()
        moveTrain()
        if lives <= 0 && !gameOver {
            gameOver = true
            println("You lose!")
            backgroundMusicPlayer.stop()
            // 1
            let gameOverScene = GameOverScene(size: size, won: false)
            gameOverScene.scaleMode = scaleMode
            // 2
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            // 3
            view?.presentScene(gameOverScene, transition: reveal)
        }
        }

    } // проверено
   
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        
        let touch = touches.anyObject() as UITouch
        let touchLocation = touch.locationInNode(self)
        sceneTouched(touchLocation)
//        println("touchesMoved touchLocation: \(touchLocation)")
    }  // проверено
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        let touch = touches.anyObject() as UITouch
        let touchLocation = touch.locationInNode(self)
        sceneTouched(touchLocation)
//        println("touchesBegan touchLocation: \(touchLocation)")
    }  // проверено
    
    func sceneTouched(touchLocation:CGPoint) {
        moveZombieToward(touchLocation)
        lastTouchLocation = touchLocation
    }  // проверено
    
    func moveZombieToward(location: CGPoint) {
        
        
        startZombieAnimation()
        
        let offset = location - zombie.position // вектор растояния между ветором положения зомби и вектором координат прикосновения

        
        let direction = offset.normalized() // вектор направления - нормализованный ветор расстояния

        velocity = direction * zombieMovePointsPerSec //обновленный ветор скорости т.е. зомби идет на расстояние zombieMovePointsPerSec (за одну секунду) в напралении direction

    }    // проверено
    
    func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {
            //принимает параметры (спрайт, вектор скорости)
        
        // в этом кадре зомби пройдет расстояние которое он должен пройти за секунду умноженное на долю секунды с момента обновления кадра.
        let amountToMove = velocity * CGFloat(dt)

        sprite.position += amountToMove
        
    }  // проверено
    
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
    }  // проверено
    
    func rotateSprite(sprite: SKSpriteNode,
                    velocity: CGPoint,
         rotateRadiansPerSec: CGFloat){
            
        let shortest = shortestAngleBetween(zombie.zRotation, velocity.angleRad)
        
        let amtToRotate = min(rotateRadiansPerSec * CGFloat(dt), abs(shortest))
            
        sprite.zRotation += amtToRotate * shortest.sign()

        }  // проверено
    
////  Chapter 3: Actions
    
    
    func spawnEnemy() {
        
        let enemy = SKSpriteNode(imageNamed: "enemy")
        
        enemy.name = "enemy"

// You create a sprite and position it at the randome vertical position of the screen, just out of view to the right.
        enemy.position = CGPoint(x: size.width + enemy.size.width/2,
                                 y: CGFloat.random(min: CGRectGetMinY(playableRect) + enemy.size.height/2,
                                                   max: CGRectGetMaxY(playableRect) - enemy.size.height/2))
        
        addChild(enemy)
        
        let actionMove = SKAction.moveToX(-enemy.size.width/2, duration: 2.0)
        let actionRemove = SKAction.removeFromParent()
        enemy.runAction(SKAction.sequence([actionMove, actionRemove]))
    }  // проверено
    
    func startZombieAnimation() {
        if zombie.actionForKey("animation") == nil {
        zombie.runAction(SKAction.repeatActionForever(zombieAnimation), withKey: "animation")
        }
    } // проверено
    
    func stopZombieAnimation() {
        zombie.removeActionForKey("animation")
    }  // проверено
    
    func spawnCat() {
     
            let cat = SKSpriteNode(imageNamed: "cat")
            
            cat.name = "cat"
            
            cat.position = CGPoint(x: CGFloat.random(min: CGRectGetMinX(playableRect),
                                                     max: CGRectGetMaxX(playableRect)),
            
                                   y: CGFloat.random(min: CGRectGetMinY(playableRect),
                                                     max: CGRectGetMaxY(playableRect)))
            cat.setScale(0)
            addChild(cat)
     
            let appear = SKAction.scaleTo(1.0, duration: 0.5)
        
            cat.zRotation = -π / 16.0
            let leftWiggle = SKAction.rotateByAngle(π/8.0, duration: 0.5)
            let rightWiggle = leftWiggle.reversedAction()
            let fullWiggle = SKAction.sequence([leftWiggle, rightWiggle])
        
            let scaleUp = SKAction.scaleBy(1.2, duration: 0.25)
            let scaleDown = scaleUp.reversedAction()
            let fullScale = SKAction.sequence(
                [scaleUp, scaleDown, scaleUp, scaleDown])
            let group = SKAction.group([fullScale, fullWiggle])
            let groupWait = SKAction.repeatAction(group, count: 10)

            let disappear = SKAction.scaleTo(0, duration: 0.5)
            let removeFromParent = SKAction.removeFromParent()
            let actions = [appear, groupWait, disappear, removeFromParent]
            cat.runAction(SKAction.sequence(actions))
    }  // проверено
    
    func zombieHitCat(cat: SKSpriteNode) {
            runAction(catCollisionSound)
            
            cat.name = "train"
            cat.removeAllActions()
            cat.setScale(1)
            cat.zRotation = 0
            cat.runAction(SKAction.colorizeWithColor(SKColor.greenColor(), colorBlendFactor: 0.5, duration:0.2))
        }  // проверено
    
    func zombieHitEnemy(enemy: SKSpriteNode) {
        runAction(enemyCollisionSound)
        loseCats()
        lives--
                
        self.zombieIsInvincible = true
        let blinkTimes = 10.0 // моргнуть 10 раз
        let duration = 3.0 // за 3 секунды
        let blinkAction = SKAction.customActionWithDuration(duration) {node, elapsedTime in
            let slice = duration / blinkTimes // 0,3 секунды один блинк
            let remainder = Double(elapsedTime) % slice // "выхлоп" с остатком от деления прошедшего времени на длительность блинка т.е. сколько нового блинка уже прошло
            node.hidden = remainder > slice / 2 // если сейчас вторая половина периода блинка (0,3 сек) то нода спрятана.
        }
        let setHidden = SKAction.runBlock() {
                self.zombie.hidden = false
                self.zombieIsInvincible = false
        }
        zombie.runAction(SKAction.sequence([blinkAction, setHidden]))

    }  // проверено
   
    func checkCollisions() {
            
            var hitCats: [SKSpriteNode] = []
        
//НЕПОНЯТНАЯ ТЕМА с enumerateChildNodesWithName !!!!!!!!
            enumerateChildNodesWithName("cat") { node, _ in
                let cat = node as SKSpriteNode
                if CGRectIntersectsRect(cat.frame, self.zombie.frame) {
                    hitCats.append(cat)
//                    println("chitCats.append: \(cat)")
                }
            }
            for cat in hitCats {
                zombieHitCat(cat)
            }
            if zombieIsInvincible {
                return
            }
            
            var hitEnemies: [SKSpriteNode] = []
            
            enumerateChildNodesWithName("enemy") { node, _ in
                let enemy = node as SKSpriteNode
                if CGRectIntersectsRect(CGRectInset(node.frame, 20, 20), self.zombie.frame) {
                    hitEnemies.append(enemy)
//                    println("hitEnemies.append: \(enemy)")
                }
            }
            for enemy in hitEnemies {
                zombieHitEnemy(enemy)
            }
    } // проверено
   
////    The Sprite Kit game loop, round 2
    
    override func didEvaluateActions() {
        checkCollisions()
    }  // проверено
    

        
/// Challenge 3: The conga train
        
    func moveTrain() {
            var targetPosition = zombie.position
            var targetzRotation = zombie.zRotation
            var trainCount = 0
    
            enumerateChildNodesWithName("train") {node, stop in
                trainCount++
                if !node.hasActions() {

                    let actionDuration = 0.3
                    let offset = targetPosition - node.position // вектор растояния между ветором положения предидущего кота (или зомби с самого начала) и тек положением тек ноды в массиве нод с названием "train"
                    let direction = offset.normalized()
                    let amountToMovePerSec = direction * self.catMovePointsPerSec  //
                    let amountToMove = amountToMovePerSec *  CGFloat(actionDuration) // d
                    let moveAction = SKAction.moveByX(amountToMove.x, y:amountToMove.y, duration:actionDuration)// e
                    node.runAction(moveAction)
                }
            targetPosition = node.position
            targetzRotation = node.zRotation
            
                
            }
            if trainCount >= 30 && !gameOver {
                gameOver = true
                println("You win!")
                backgroundMusicPlayer.stop()
                let gameOverScene = GameOverScene(size: size, won: true)
                gameOverScene.scaleMode = scaleMode
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                view?.presentScene(gameOverScene, transition: reveal)
            }
        }   // проверено
    
// Chapter 4: Scenes  - Win and lose conditions
    
    
    func loseCats() {
        // 1
        var loseCount = 0
        enumerateChildNodesWithName("train") { node, stop in
            // 2
            var randomSpot = node.position
            randomSpot.x += CGFloat.random(min: -100, max: 100)
            randomSpot.y += CGFloat.random(min: -100, max: 100)
            // 3
            node.name = ""
            node.runAction(SKAction.sequence(
                                            [SKAction.group([SKAction.rotateByAngle(π*4, duration: 1.0),
                                                              SKAction.moveTo(randomSpot, duration: 1.0),
                                                              SKAction.scaleTo(0, duration: 1.0)]),
                                             SKAction.removeFromParent()]))
            // 4
            loseCount++
            if loseCount >= 2 {
                stop.memory = true
            }
        }
    }
    
    
 // the last
    
}


