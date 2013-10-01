//
//  WoodenBox.m
//  iOS App Dev
//
//  Created by Oli_Hafsteinn on 9/30/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "WoodenBox.h"

@implementation WoodenBox


-(id)initWithSpace:(ChipmunkSpace *)space position:(CGPoint)position
{
    self = [super initWithFile:@"woodBox.png"];
    if(self)
    {
        _space = space;
        
        
        CGSize size = self.textureRect.size;
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
        
    }
    return self;
}



@end
