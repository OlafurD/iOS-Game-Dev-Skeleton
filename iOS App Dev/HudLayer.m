//
//  HudLayer.m
//  iOS App Dev
//
//  Created by Oli_Hafsteinn on 10/1/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "HudLayer.h"

@implementation HudLayer

- (id)initWithConfiguration:(NSDictionary *)configuration
{
    self = [super init];
    if(self != nil)
    {
        _leftHealthBar = [[HealthBar alloc] init];
        _leftHealthBar.position = CGPointFromString(configuration[@"healthBarPosition"]);
    }
    
    
    return self;
}

@end
