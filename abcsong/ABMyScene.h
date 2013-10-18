//
//  ABMyScene.h
//  ABCSong
//

//  Copyright (c) 2013 Scott Bedard. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

static BOOL showedWelcome;

@interface ABMyScene : SKScene{
    NSArray *letters;
    NSInteger letter;
    float leftRight;
    SKLabelNode *reset;
}

@end
