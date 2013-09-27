//
//  InputLayer.h
//  iOS App Dev
//
//  Created by Oli_Hafsteinn on 9/27/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@protocol InputLayerDelegate <NSObject>

-(void)touchEnded;
-(void)touchBegan;

@end

@interface InputLayer : CCLayer

@property (nonatomic, weak) id<InputLayerDelegate> delegate;

@end
