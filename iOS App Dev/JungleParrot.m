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
        cpFloat moment = cpMomentForBox(mass, size.width,size.height);
    
        
        ChipmunkBody *body = [ChipmunkBody bodyWithMass:mass andMoment:INFINITY];
        body.pos = position;
        ChipmunkShape *shape = [ChipmunkPolyShape boxWithBody:body width:size.width height:size.height];
        
        
        //add to space
        [_space addBody:body];
        [_space addShape:shape];
        
        //add physics to sprite
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
    
    //add the frames and coordinates to the cache
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"parrot.plist"];
    
    //load the sprite sheet into a CCSpriteBatchNode object. If you're adding a new sprite
    
    //to your scene, and the image exists in this sprite sheet you should add the sprite
    
    //as a child of the same CCSpriteBatchNode object otherwise you could get an error.
    
    CCSpriteBatchNode *parrotSheet = [CCSpriteBatchNode batchNodeWithFile:@"parrot.png"];
    
    //add the CCSpriteBatchNode to your scene
    
    [self addChild:parrotSheet];
    
    //load each frame included in the sprite sheet into an array for use with the CCAnimation object below
    
    NSMutableArray *flyAnimFrames = [NSMutableArray array];
    
    for(int i = 1; i <= 3; ++i) {
        
        [flyAnimFrames addObject:
         
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          
          [NSString stringWithFormat:@"parrot%d.png", i]]];
        
    }
    
    //Create the animation from the frame flyAnimFrames array
    
    CCAnimation *flyAnim = [CCAnimation animationWithFrames:flyAnimFrames delay:0.1f];
    
    //create a sprite and set it to be the first image in the sprite sheet
    
    CCSprite *theParrot = [CCSprite spriteWithSpriteFrameName:@"parrot1.png"];
    
    theParrot.anchorPoint = ccp(0,0);
    
    //create a looping action using the animation created above. This just continuosly
    
    //loops through each frame in the CCAnimation object
    
    CCAction *flyAction = [CCRepeatForever actionWithAction:
                           
    [CCAnimate actionWithAnimation:flyAnim restoreOriginalFrame:NO]];
    
    //start the action
    
    [theParrot runAction:flyAction];
    
    //add the sprite to the CCSpriteBatchNode object
    
    [parrotSheet addChild:theParrot];
    
    
    
}


@end
