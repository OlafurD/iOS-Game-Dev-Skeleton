//
//  TumbleWeed.h
//  iOS App Dev
//
//  Created by Oli_Hafsteinn on 9/27/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface TumbleWeed : CCPhysicsSprite
{
    ChipmunkSpace *_space;
}

-(id)initWithSpace:(ChipmunkSpace *)space position:(CGPoint) position;
-(void)moveUpWithImpulse:(cpVect)vector Impulse:(cpFloat)Impulse;

@end
