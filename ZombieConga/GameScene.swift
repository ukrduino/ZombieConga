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
    let zombieRotateRadiansPerSec:CGFloat = 4.0 * π
    let playableRect: CGRect


// определение переменных
    var velocity = CGPointZero // вектор скорости (куда должен попасть зомби за секунду)
    var lastUpdateTime: NSTimeInterval = 0 //последние обновление картинки
    var dt: NSTimeInterval = 0 // время с последнего обновления картинки в мс
    var lastTouchLocation = CGPointZero // вектор места последнего касания

    override init(size: CGSize) {
        let maxAspectRatio:CGFloat = 16.0/9.0 // максимальное соотношение сторон 1,77
        let playableHeight = size.width / maxAspectRatio // расчет высоты игровой области
        let playableMargin = (size.height-playableHeight)/2.0 // слепая зона игры
        
        playableRect = CGRect(x: 0, // игровая зона гарантированно видимая на всех устройствах
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
        let background = SKSpriteNode(imageNamed: "background1") // определение фона
        background.zPosition = -1 // фон -  самый первый слой
        addChild(background) // добавлени фона к сцене
//        background.position = CGPoint(x: size.width/2, y: size.height/2) // установка центра фона в центр экрана
        background.anchorPoint = CGPointZero // якорь фона нижний левый угол
        background.position = CGPointZero // совмещение нижнего левого угла фона с нижним левым углом экрана
        let mySize = background.size // размер фона
//    println("Size: \(mySize)")

    zombie.position = CGPoint(x: 400, y: 400) // установка зомби в начале игры
    //zombie.setScale(2.0) // SKNode method - масштабирование зомби
        
    addChild(zombie) //добавление зомби к сцене
    debugDrawPlayableArea() // рисование красного квадрата игровой зоны
    }
    
    override func update(currentTime: NSTimeInterval){ //функция обновлени кадров в игре
        
        //функция для вычисления dt (время с последнего обновления картинки в мс)

        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        }
        else {
            dt = 0
        }
        lastUpdateTime = currentTime
      
        let distanceToStop = (lastTouchLocation-zombie.position).length() //расстояние до остановки зомби
        if distanceToStop > 0 {
        
        println("distanceToStop: \(distanceToStop)")
        }
        // если растояние до точки остановки зомби меньше растояния которое зомби должен пройти в этом кадре то зомби ставим в точку где он должен остановиться и устанавливаем вектор скорости  = 0
        if (distanceToStop<=(zombieMovePointsPerSec * CGFloat(dt))){
            zombie.position = lastTouchLocation
            velocity = CGPointZero
        
        }
        // если нет то двигаем зомби и вращаем если нужно
        else {
            
            moveSprite(zombie, velocity: velocity)
            rotateSprite(zombie, velocity: velocity, rotateRadiansPerSec: zombieRotateRadiansPerSec)
        }
        
        boundsCheckZombie()
    }
   
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        
        let touch = touches.anyObject() as UITouch
        let touchLocation = touch.locationInNode(self)
        sceneTouched(touchLocation)
        println("touchesMoved touchLocation: \(touchLocation)")
    }  
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        let touch = touches.anyObject() as UITouch
        let touchLocation = touch.locationInNode(self)
        sceneTouched(touchLocation)
        println("touchesBegan touchLocation: \(touchLocation)")
    }
    
    func sceneTouched(touchLocation:CGPoint) {
        moveZombieToward(touchLocation)
        lastTouchLocation = touchLocation
    }
    
   
    func moveZombieToward(location: CGPoint) {
        
        let offset = location - zombie.position // вектор растояния между ветором положения зомби и вектором координат прикосновения
        println("offset: \(offset)")
        
        let direction = offset.normalized() // вектор направления - нормализованный ветор расстояния

        velocity = direction * zombieMovePointsPerSec //обновленный ветор скорости т.е. зомби идет на расстояние zombieMovePointsPerSec (за одну секунду) в напралении direction
        println("velocity: \(velocity)")
    }    
    
    func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) { //принимает параметры (спрайт, вектор скорости)
        
        // в этом кадре зомби пройдет расстояние которое он должен пройти за секунду умноженное на долю секунды с момента обновления кадра.
        let pointsToMoveInFrame = velocity * CGFloat(dt)

        sprite.position += pointsToMoveInFrame
        
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
                   velocity: CGPoint,
         rotateRadiansPerSec: CGFloat){
            
        let shortest = shortestAngleBetween(zombie.zRotation, velocity.angleRad)
        
        let amtToRotate = min(rotateRadiansPerSec * CGFloat(dt), abs(shortest))
            
            
        sprite.zRotation += amtToRotate * shortest.sign()

        

    }
}


