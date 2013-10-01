//
//  HudLayer.h
//  iOS App Dev
//
//  Created by Oli_Hafsteinn on 10/1/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "HealthBar.h"

@interface HudLayer : CCLayer


@property (retain) HealthBar *leftHealthBar;
@property (retain) HealthBar *rightHealthBar;

- (id) initWithConfiguration:(NSDictionary *) configuration;

@end
