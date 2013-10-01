//
//  Banana.m
//  iOS App Dev
//
//  Created by Oli_Hafsteinn on 9/30/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "Banana.h"

@implementation Banana

-(id)initWithSpace:(ChipmunkSpace *)space position:(CGPoint)position
{
    self = [super initWithFile:@"BigBanana.png"];
    if(self)
    {
        _space = space;
        
        _toDelete = [[NSMutableArray alloc] init];
        
        CGSize size = self.textureRect.size;
        cpFloat mass = size.width * size.height;
        
        ChipmunkBody *body = [ChipmunkBody staticBody];

        body.pos = position;

        ChipmunkShape *shape = [ChipmunkCircleShape circleWithBody:body radius:size.width / 2 offset:cpvzero];
        shape.sensor = YES;
        
        //add to space
        [_space addShape:shape];
        
        //add physics to sprite
        body.data = self;
        self.chipmunkBody = body;
        
    }
    return self;
}



@end
