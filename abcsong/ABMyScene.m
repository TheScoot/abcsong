//
//  ABMyScene.m
//  ABCSong
//
//  Created by Scott Bedard on 10/6/13.
//  Copyright (c) 2013 Scott Bedard. All rights reserved.
//

#import "ABMyScene.h"
//@import AVFoundation;
//
//@interface ABMyScene ()
//@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;
//@end

@implementation ABMyScene


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
        
        self.backgroundColor = [SKColor colorWithRed:0.25 green:0.25 blue:0.3 alpha:1.0];
        if(!showedWelcome){
            showedWelcome = YES;
            SKLabelNode *welcome = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
            welcome.position = CGPointMake(CGRectGetMidX(self.frame),
                                           CGRectGetMidY(self.frame));
            welcome.fontSize = 70;
            welcome.text = @"Touch Screen to Begin";
            welcome.zPosition = 100;
            [self addChild:welcome];
            [welcome runAction:[SKAction sequence:@[[SKAction waitForDuration:2.0], [SKAction fadeAlphaTo:0.0 duration:1.0]]] completion:^{[welcome removeFromParent];}];
        }
        reset = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        reset.position = CGPointMake(65.0, 25.0);
        reset.text = @"Restart";
        reset.name = @"reset";
        reset.zPosition = 100;
        [self addChild:reset];
        
//        [self runAction: [SKAction playSoundFileNamed:@"abcsong.mp3" waitForCompletion:YES]];
        
    }
    return self;
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
    
    for (UITouch *touch in touches) {
        BOOL showLetter = YES;
        
        CGPoint location = [touch locationInNode:self];

        SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:[touch locationInNode:self]];
        
        if([[touchedNode name] isEqualToString:@"reset"]) {
            letter = 0;
            showLetter = NO;
            [self clearScreen];
            EXIT_SUCCESS;
        }
        
        if(showLetter){
        
        SKLabelNode *newLabel = [SKLabelNode labelNodeWithFontNamed:@"Guakala"];
        
        newLabel.text = letters[letter];
        newLabel.fontSize = 70;
        float red = (float)arc4random_uniform(255)/255;
        float blue = (float)arc4random_uniform(255)/255;
        float green = (float)arc4random_uniform(255)/255;
        newLabel.fontColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        newLabel.name = @"letter";
        newLabel.position = CGPointMake(location.x, location.y);
        //make sure this stays on the bottom
        newLabel.zPosition = 0;
        if(leftRight<0.0){ leftRight = 0.5; } else { leftRight = -0.5; }
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
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end