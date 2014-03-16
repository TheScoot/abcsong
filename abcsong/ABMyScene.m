//
//  ABMyScene.m
//  ABCSong
//
//  Created by Scott Bedard on 10/6/13.
//  Copyright (c) 2013 Scott Bedard. All rights reserved.
//

//This was my first XCode project and is a real mess, but it works and my kids love it, so why change now!

#import "ABMyScene.h"
//@import AVFoundation;
//
//@interface ABMyScene ()
//@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;
//@end

@implementation ABMyScene{
    SKLabelNode *welcome;
    NSArray *scenes;
    bool showedWelcome;
    NSArray *letters;
    NSInteger letter;
    float leftRight;
    SKLabelNode *reset;
    bool pastFirstScene;
    SKNode *landscapeNode;
    bool landscapeMoveRight;
}


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        letters = @[@"A",
                   @"B",
                   @"C",
                   @"D",
                   @"E",
                   @"F",
                   @"G",
                   @"H",
                   @"I",
                   @"J",
                   @"K",
                   @"L",
                   @"M",
                   @"N",
                   @"O",
                   @"P",
                   @"Q",
                   @"R",
                   @"S",
                   @"T",
                   @"U",
                   @"V",
                   @"W",
                   @"X",
                   @"Y",
                   @"Z"
                    ];
        letter = 0;
        
        if(arc4random_uniform(2) == 0){
            scenes = @[@"streetscene",
                   @"trainscene",
                   @"winterscene",
                   @"kidsscene"
                   ];
        } else {
            scenes = @[@"abc-cats1",
                   @"abc-cats2",
                   @"abc-dogs1",
                   @"abc-dogscats"
                   ];
        }
        
        landscapeNode  = [SKNode node];
        CGRect landscapeRect;
        int newX;
        unsigned char sceneIndex = arc4random_uniform(scenes.count - 1);
        for(int i=0; i <= scenes.count; i++){
            SKSpriteNode *newScene = [SKSpriteNode spriteNodeWithImageNamed:scenes[sceneIndex]];
            newScene.anchorPoint = CGPointMake(0,0);
            landscapeRect = landscapeNode.calculateAccumulatedFrame;
            if(landscapeRect.size.width != INFINITY){
                newX = landscapeRect.size.width;
            } else {
                newX = 0;
            }
            newScene.position = CGPointMake(newX, 0);
            newScene.scale = self.size.height/newScene.size.height;
            sceneIndex ++;
            if(sceneIndex > scenes.count - 1){
                sceneIndex = 0;
            }
            [landscapeNode addChild:newScene];
        }
        //for(NSString *nextScene in scenes){
        //}
        [self addChild:landscapeNode];
        
        sceneIndex = arc4random_uniform(scenes.count - 1);

        self.backgroundColor = [SKColor colorWithRed:0.25 green:0.25 blue:0.3 alpha:1.0];
        
        [self moveBackground];

        if(!showedWelcome){
            showedWelcome = YES;
            welcome = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
            welcome.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
            welcome.fontSize = 70;
            welcome.fontColor = [SKColor redColor];
            welcome.text = @"Touch Screen to Begin";
            welcome.zPosition = 100;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                welcome.fontSize = 30;
            }
            [self addChild:welcome];
            [welcome runAction:[SKAction sequence:@[[SKAction waitForDuration:2.0], [SKAction fadeAlphaTo:0.0 duration:1.0]]] completion:^{[welcome removeFromParent];}];
        }
        reset = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        reset.position = CGPointMake(65.0, 25.0);
        reset.text = @"Restart";
        reset.name = @"reset";
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            reset.fontSize = 30;
        }
        reset.alpha = 0.25;
        reset.zPosition = 100;
        [self addChild:reset];
        
//        [self runAction: [SKAction playSoundFileNamed:@"abcsong.mp3" waitForCompletion:YES]];
        
    }
    return self;
}

-(void)moveBackground{
    CGSize winSize = self.size;
    float newX;
    float speed;

    CGRect landscapeRect = landscapeNode.calculateAccumulatedFrame;
    
    if(landscapeMoveRight == YES){
        newX = 0;
    } else {
        newX = -(landscapeRect.size.width - winSize.width);
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        speed = (landscapeRect.size.width / 10);
    } else {
        speed = (landscapeRect.size.width / 30);
    }
    
    landscapeMoveRight = !landscapeMoveRight;
    
    SKAction *scrollBackground = [SKAction moveToX:newX duration:speed];
    
    [landscapeNode runAction:scrollBackground completion:^{[self moveBackground];}];
}

-(void)clearScreen{
    float holdUp = 0.1;
    
    SKAction *fadeAway = [SKAction fadeOutWithDuration:.5];
    SKAction *remove = [SKAction removeFromParent];

    for(SKNode *node in self.children){
        if([[node name] isEqualToString:@"letter"]) {
            SKAction *wait = [SKAction waitForDuration:holdUp];
            SKAction *delayFade = [SKAction sequence:@[wait, fadeAway, remove]];
            [node runAction:delayFade];
            holdUp = holdUp + 0.05;
        }
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    if(welcome.parent){
        [welcome runAction:[SKAction sequence:@[[SKAction fadeAlphaTo:0.0 duration:0.5]]]];
    }
    
    for (UITouch *touch in touches) {
        BOOL showLetter = YES;
        
        CGPoint location = [touch locationInNode:self];

        SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:[touch locationInNode:self]];
        
        if([[touchedNode name] isEqualToString:@"reset"]) {
            letter = 0;
            showLetter = NO;
            SKAction *bright = [SKAction fadeAlphaTo:1.0 duration:0.5];
            SKAction *wait = [SKAction waitForDuration:0.5];
            SKAction *dim = [SKAction fadeAlphaTo:0.25 duration:0.5];
            [touchedNode runAction:[SKAction sequence:@[bright, wait, dim]]];
            [self clearScreen];
            EXIT_SUCCESS;
        }
        
        if(showLetter){
        
        SKLabelNode *newLabel = [SKLabelNode labelNodeWithFontNamed:@"Guakala"];
        
        newLabel.text = letters[letter];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            newLabel.fontSize = (float)arc4random_uniform(25)+30;
        } else {
            newLabel.fontSize = (float)arc4random_uniform(25)+60;
        }
        float red = (float)arc4random_uniform(255)/255;
        float blue = (float)arc4random_uniform(255)/255;
        float green = (float)arc4random_uniform(255)/255;
        newLabel.fontColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        newLabel.name = @"letter";
        newLabel.position = CGPointMake(location.x, location.y);
        //make sure this stays on the bottom
        newLabel.zPosition = 1000;
        if(leftRight<0.0){ leftRight = 0.15; } else { leftRight = -0.15; }
        SKAction *spin = [SKAction rotateByAngle:M_PI*leftRight duration:4];
        SKAction *wait = [SKAction waitForDuration:3];
        SKAction *fadeAway = [SKAction fadeOutWithDuration:1];
        SKAction *remove = [SKAction removeFromParent];
        SKAction *scaleup = [SKAction scaleBy:4.0 duration:4];
        SKAction *spinZoom = [SKAction group:@[spin, scaleup]];
        SKAction *delayFade = [SKAction sequence:@[wait, fadeAway, remove]];
        NSString *wavFile;
        //if(letter < 26){
            //NSString *wav = [letters[letter] uppercaseString];
            wavFile = [NSString stringWithFormat:@"%@.wav", [letters[letter] uppercaseString]];
            
        //}else {
        //    wavFile = [NSString stringWithFormat:@"%@.mp3", letters[letter]];
            
        //}
        SKAction *playSound = [SKAction playSoundFileNamed:wavFile waitForCompletion:NO];
            
        //add a particle effect
        NSString *myParticlePath = [[NSBundle mainBundle] pathForResource:@"MyParticle" ofType:@"sks"];
        SKEmitterNode *myParticle = [NSKeyedUnarchiver unarchiveObjectWithFile:myParticlePath];
        myParticle.particlePosition = CGPointMake(location.x, location.y);
        myParticle.particleBirthRate = 5;
        //myParticle.particleColorBlueRange = [];
        myParticle.particleColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        myParticle.name = @"letter";
            
        //[self runAction: [SKAction playSoundFileNamed:@"abcsong.mp3" waitForCompletion:YES]];
       
        [newLabel runAction:[SKAction group:@[playSound,spinZoom,delayFade]]];
        [myParticle runAction:[SKAction group:@[delayFade]]];
    
        [self addChild:newLabel];
        [self addChild:myParticle];
        
        letter++;
        if(letter > letters.count-1){
            letter = 0;
        }
        }
        //get out after one touch
        return;
    }
}


@end
