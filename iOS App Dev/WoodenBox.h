//
//  WoodenBox.h
//  iOS App Dev
//
//  Created by Oli_Hafsteinn on 9/30/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface WoodenBox : CCPhysicsSprite
{
    ChipmunkSpace *_space;
    NSMutableArray *_toDelete;
}

-(id)initWithSpace:(ChipmunkSpace *)space position:(CGPoint) position;


@end
