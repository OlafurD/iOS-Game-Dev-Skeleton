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
#import "HudLayer.h"

@class JungleParrot;
@class WoodenBox;
@class Banana;
@interface GameScene : CCScene<InputLayerDelegate>
{

    CGSize _winSize;
    
    CCNode *_gameNode;
    
    CCParallaxNode *_parallaxNode;
    
    WoodenBox *_boxObsticle;
    
    Banana *_banana;
    
    float _speed;
    
    NSMutableArray *_boxes;
    NSMutableArray *_bananas;
    NSMutableArray *groundTiles;
    NSMutableArray *urlGroundTiles;
    NSMutableArray *roofRoots;
    
    int _objectScore;
    
    NSInteger _totalScore;
    
    NSDictionary *_configuration;
    
    CCLayer *_groundLayer;
    CCLayer *_skyLayer;
    CCLayer *_backgroundLayer;
    CCLayer *_boxLayer;
    CCLayer *_bananaLayer;
    CCLayer *_textLayer;
    
    CCLabelTTF *_label;
    
    CCParticleSystemQuad *_particles;
    
    JungleParrot *_jungleParrot;
    
    ChipmunkSpace *_space;
    
    ccTime _accumulator;
    
    bool _isTouching;
}



@end
