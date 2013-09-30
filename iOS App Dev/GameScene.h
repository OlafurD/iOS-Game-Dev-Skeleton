//
//  Game.h
//  iOS App Dev
//
//  Created by Sveinn Fannar Kristjansson on 9/17/13.
//  Copyright 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "InputLayer.h"

@class JungleParrot;
@interface GameScene : CCScene<InputLayerDelegate>
{
    CGSize _winSize;
    NSDictionary *_configuration;
    CCParallaxNode *_parallaxNode;
    CCLayer *_skyLayer;
    CCLayer *_groundLayer;
    CCLayer *_backgroundLayer;
    
    NSMutableArray *groundTiles;
    NSMutableArray *roofRoots;
    
    CCNode *_gameNode;
    
    JungleParrot *_jungleParrot;
    
    //Chipmunk related objects
    ChipmunkSpace *_space;
    ccTime _accumulator;
    
    bool _isTouching;
}



@end
