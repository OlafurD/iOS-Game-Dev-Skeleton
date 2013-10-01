//
//  TumbleWeed.m
//  iOS App Dev
//
//  Created by Oli_Hafsteinn on 9/27/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "JungleParrot.h"

@implementation JungleParrot

-(id)initWithSpace:(ChipmunkSpace *)space position:(CGPoint)position
{
    self = [super initWithFile:@"Empty.png"];
    if(self)
    {
        _space = space;
        
        CGSize size = self.textureRect.size;
        size.height *= 0.5;
        size.width *= 0.8;
        cpFloat mass = size.width * size.height;
    
        
        ChipmunkBody *body = [ChipmunkBody bodyWithMass:mass andMoment:INFINITY];
        body.pos = position;
        ChipmunkShape *shape = [ChipmunkPolyShape boxWithBody:body width:size.width height:size.height];
        
        
        //add to space
        [_space addBody:body];
        [_space addShape:shape];
        
        //add physics to sprite
        body.data = self;
        self.chipmunkBody = body;
        
        
        [self setUpBird];
    }
    return self;
}

-(void)moveUpWithImpulse: (cpVect)vector Impulse:(cpFloat)Impulse
{
    cpVect impulseVector = cpv(0, Impulse);
    [self.chipmunkBody applyImpulse:impulseVector offset:cpvzero];
}

-(void)setUpBird
{
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"parrot.plist"];
    
    CCSpriteBatchNode *parrotSheet = [CCSpriteBatchNode batchNodeWithFile:@"parrot.png"];
    
    [self addChild:parrotSheet];
    
    NSMutableArray *flyAnimFrames = [NSMutableArray array];
    
    for(int i = 1; i <= 3; ++i) {
        
        [flyAnimFrames addObject:
         
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          
          [NSString stringWithFormat:@"parrot%d.png", i]]];
        
    }
    
    CCAnimation *flyAnim = [CCAnimation animationWithFrames:flyAnimFrames delay:0.1f];
    
    CCSprite *theParrot = [CCSprite spriteWithSpriteFrameName:@"parrot1.png"];
    
    theParrot.anchorPoint = ccp(0,0);
    
    CCAction *flyAction = [CCRepeatForever actionWithAction:
                           
    [CCAnimate actionWithAnimation:flyAnim restoreOriginalFrame:NO]];
    
    [theParrot runAction:flyAction];
    
    [parrotSheet addChild:theParrot];
    
}




@end
