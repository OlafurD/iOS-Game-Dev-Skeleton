//
//  TumbleWeed.m
//  iOS App Dev
//
//  Created by Oli_Hafsteinn on 9/27/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "TumbleWeed.h"

@implementation TumbleWeed

-(id)initWithSpace:(ChipmunkSpace *)space position:(CGPoint)position
{
    self = [super initWithFile:@"tumbleweed.png"];
    if(self)
    {
        _space = space;
        
        CGSize size = self.textureRect.size;
        size.height *= 0.1;
        size.width *= 0.1;
        cpFloat mass = size.width * size.height;
        cpFloat moment = cpMomentForBox(mass, size.width,size.height);
    
        
        ChipmunkBody *body = [ChipmunkBody bodyWithMass:mass andMoment:moment];
        body.pos = position;
        ChipmunkShape *shape = [ChipmunkCircleShape circleWithBody:body radius:size.width / 2 offset:CGPointZero];
        //ChipmunkShape *shape = [ChipmunkPolyShape boxWithBody:body width:size.width height:size.height];
        //add to space
        [_space addBody:body];
        [_space addShape:shape];
        
        //add physics to sprite
        self.chipmunkBody = body;
    }
    return self;
}

-(void)moveUpWithImpulse: (cpVect)vector Impulse:(cpFloat)Impulse
{
    NSLog(@"touching - in moveUpWithImpulse");
    cpVect impulseVector = cpv(0, Impulse);
    [self.chipmunkBody applyImpulse:impulseVector offset:cpvzero];
}

@end
