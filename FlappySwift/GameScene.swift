//
//  GameScene.swift
//  FlappySwift
//
//  Created by Mark Price on 7/28/14.
//  Copyright (c) 2014 Verisage. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    //Scenery
    let hillsYPos: CGFloat = 300
    let totalGroundPieces = 5
    var groundPieces = [SKSpriteNode]()
    let groundSpeed: CGFloat = 3.5
    var moveGroundAction: SKAction!
    var moveGroundForeverAction: SKAction!
    let groundResetXCoord: CGFloat = -164

    //Game
    var bird: SKSpriteNode!
    var birdAtlas = SKTextureAtlas(named: "bird")
    var birdFrames = [SKTexture]()
    var startJump = false
    var getTimeStamp = false
    var jumpStartTime: CFTimeInterval = 0.0
    var jumpCurrentTime: CFTimeInterval = 0.0
    var jumpDuration = 0.7

    override func didMoveToView(view: SKView)
    {
        initSetup()
        setupScenery()
        setupBird()
        startGame()
    }

    func initSetup()
    {
        moveGroundAction = SKAction.moveByX(-groundSpeed, y: 0, duration: 0.02)
        moveGroundForeverAction = SKAction.repeatActionForever(SKAction.sequence([moveGroundAction]))
        self.physicsWorld.gravity = CGVectorMake(0.0, -5.0)
        self.physicsWorld.contactDelegate = self
    }

    func setupScenery()
    {
        
        println("Scene Width \(self.view.frame.size.width)")
        /* Setup your scene here */
        
        //Add background sprites
        var bg = SKSpriteNode(imageNamed: "sky")
        bg.position = CGPointMake(bg.size.width / 2, bg.size.height / 2)
        
        self.addChild(bg)
        
        var hills = SKSpriteNode(imageNamed: "hills")
        hills.position = CGPointMake(hills.size.width / 2, hillsYPos)
        
        self.addChild(hills)
        
        //Add ground sprites
        for var x = 0; x < totalGroundPieces; x++
        {
            var sprite = SKSpriteNode(imageNamed: "ground_piece")
            groundPieces.append(sprite)
            
            var wSpacing = sprite.size.width / 2
            var hSpacing = sprite.size.height / 2
            
            if x == 0
            {
                sprite.position = CGPointMake(wSpacing, hSpacing)
            }
            else
            {
                sprite.position = CGPointMake((wSpacing * 2) + groundPieces[x - 1].position.x,groundPieces[x - 1].position.y)
            }
            
            self.addChild(sprite)
        }
    }

    func setupBird()
    {
        //Bird animations
        var totalImgs = birdAtlas.textureNames.count
        
        for var x = 1; x < totalImgs; x++
        {
            var textureName = "bird-0\(x)"
            var texture = birdAtlas.textureNamed(textureName)
            birdFrames.append(texture)
        }
        
        bird = SKSpriteNode(texture: birdFrames[0])
        self.addChild(bird)
        bird.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        bird.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(birdFrames, timePerFrame: 0.2, resize: false, restore: true)))
        
        //Bird physics
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2.0)
        //bird.physicsBody.dynamic = true
        bird.physicsBody.allowsRotation = false
        
    }

    func startGame()
    {
        for sprite in groundPieces
        {
            sprite.runAction(moveGroundForeverAction)
        }
    }

    func updateWithTimeSinceLastUpdate(timeSinceLast: CFTimeInterval)
    {
        jumpCurrentTime += timeSinceLast
        
        if jumpCurrentTime > jumpDuration
        {
            jumpCurrentTime = 0.0
            startJump = false
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        getTimeStamp = true
        startJump = true
        jumpStartTime = NSDate().timeIntervalSince1970
        println(jumpStartTime)
    }

    func groundMovement()
    {
        for var x = 0; x < groundPieces.count; x++
        {
            if groundPieces[x].position.x <= groundResetXCoord
            {
                if x != 0
                {
                    groundPieces[x].position = CGPointMake(groundPieces[x - 1].position.x + groundPieces[x].size.width,groundPieces[x].position.y)
                }
                else
                {
                    groundPieces[x].position = CGPointMake(groundPieces[groundPieces.count - 1].position.x + groundPieces[x].size.width,groundPieces[x].position.y)
                }
            }
        }
    }

    override func update(currentTime: CFTimeInterval)
    {
        //println("Current Time \(currentTime)")
        /* Called before each frame is rendered */
        groundMovement()
        
        if getTimeStamp
        {
            getTimeStamp = false
            jumpStartTime = currentTime
        }
        
        if startJump
        {
            var timeSinceLast = currentTime - jumpStartTime
        }
    }
}
/*
override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    /* Called when a touch begins */
    
    for touch: AnyObject in touches {
        let location = touch.locationInNode(self)
        
        let sprite = SKSpriteNode(imageNamed:"Spaceship")
        
        sprite.xScale = 0.5
        sprite.yScale = 0.5
        sprite.position = location
        
        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        
        sprite.runAction(SKAction.repeatActionForever(action))
        
        self.addChild(sprite)
    }
}
*/













