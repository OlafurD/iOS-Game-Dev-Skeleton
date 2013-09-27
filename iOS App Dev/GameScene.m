//
//  Game.m
//  iOS App Dev
//
//  Created by Sveinn Fannar Kristjansson on 9/17/13.
//  Copyright 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "GameScene.h"
#import "InputLayer.h"
#import "TumbleWeed.h"
#import "ChipmunkAutoGeometry.h"


@implementation GameScene

- (id)init
{
    self = [super init];
    if (self)
    {
        srandom(time(NULL));
        _winSize = [CCDirector sharedDirector].winSize;
        
        
        // Set up a reference to our config property list
        _configuration = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist" ]];
        
        //Create physics world
        _space = [[ChipmunkSpace alloc] init];
        CGFloat gravity = [_configuration[@"gravity"] floatValue];
        _space.gravity = ccp(0.0f, - gravity);
        
        
        
        //Create an input layer
        InputLayer *inputLayer = [[InputLayer alloc] init];
        inputLayer.delegate = self;
        [self addChild:inputLayer];
        
        //set up world
        [self setupGraphicsLandscale];
        
        //Create main character (tumbleWeed)
        NSString *tumbleWeedPositionString = _configuration[@"tumbleWeedPosition"];
        _tumbleWeed = [[TumbleWeed alloc] initWithSpace:_space position:CGPointFromString(tumbleWeedPositionString)];
        _tumbleWeed.scale = 0.1;
        
        [_gameNode addChild:_tumbleWeed];
        
        //apply lateral force to main character (tumbleWeed)
        CGFloat lateralForce = [_configuration[@"lateralForce"] floatValue];
        [_tumbleWeed.chipmunkBody applyForce:cpv(lateralForce, 0) offset:cpvzero];
        
        
        //Create debug node
        CCPhysicsDebugNode *debugNode = [CCPhysicsDebugNode debugNodeForChipmunkSpace:_space];
        debugNode.visible = YES;
        [self addChild:debugNode];
        
        [self scheduleUpdate];
        
    }
    return self;
}

-(void)touchEnded
{
    _isTouching = FALSE;
    //taka force af character
}

-(void)touchBegan
{
    _isTouching = YES;
    //apply vertical force on character
}

- (void)update:(ccTime)delta
{
    
    if(_tumbleWeed.position.x >= (_winSize.width / 2))
        _parallaxNode.position = ccp( - (_tumbleWeed.position.x - (_winSize.width /2)), 0);
    
    CGFloat fixedTimeStep = 1.0f / 240.0f;
    _accumulator += delta;
    while(_accumulator > fixedTimeStep)
    {
        [_space step:fixedTimeStep];
        _accumulator -= fixedTimeStep;
    }
    
    if(_isTouching)
        [self applyImpulseOnTumbleweed];
}

-(void)setupPhysicsLandscape: (cpVect)offs withURL:(NSURL*)url
{
    
    ChipmunkImageSampler *sampler = [ChipmunkImageSampler samplerWithImageFile:url isMask:NO];
    
    ChipmunkPolylineSet *contour = [sampler marchAllWithBorder:NO hard:YES];
    ChipmunkPolyline *line = [contour lineAtIndex:0];
    ChipmunkPolyline *simpleLine = [line simplifyCurves:1];
    
    ChipmunkBody *terrainBody = [ChipmunkBody staticBody];
    NSArray *terrainShapes = [simpleLine asChipmunkSegmentsWithBody:terrainBody radius:0 offset:offs];
    for(ChipmunkShape *shape in terrainShapes)
    {
        [_space addShape:shape];
    }
    
}


- (void)setupGraphicsLandscale
{
    
    CCSprite *background = [CCSprite spriteWithFile:@"Far Background.png"];
    [self scaleSpriteUP:background];
    
    
    [self addChild:background];
    
    
    
    for(NSUInteger i = 0 ; i < 6 ; i++)
    {
        CCSprite *eyes = [CCSprite spriteWithFile:@"Cat's Eyes.png"];
        
        eyes.anchorPoint = ccp(0, 0);
        eyes.position = ccp(CCRANDOM_0_1() * _winSize.width, CCRANDOM_0_1() * _winSize.height);
        eyes.scale = 0.6;
        [self addChild:eyes];
    }
    
    
    CCSprite *near = [CCSprite spriteWithFile:@"Near Background.png"];
    
    [self scaleSpriteUP:near];
    [self addChild:near];
    
    // set up our ground layer
    _groundLayer = [CCLayer node];
    [self addGround];
    
    // set up our sky layer
    _skyLayer = [CCNode node];
    [self addRoots];
    
    _gameNode = [CCNode node];
    
    //set up our parallax node
    _parallaxNode = [CCParallaxNode node];
    [self addChild:_parallaxNode];
    
    [_parallaxNode addChild:_skyLayer z:0 parallaxRatio:ccp(0.5f, 1.0f) positionOffset:CGPointZero];
    [_parallaxNode addChild:_groundLayer z:1 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointZero];
    [_parallaxNode addChild:_gameNode z:2 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointZero];
    
}

- (void) scaleSpriteUP: (CCSprite *) sprite
{
    sprite.position = ccp(_winSize.width / 2 , _winSize.height / 2);
    
    sprite.scaleX = _winSize.width / sprite.contentSize.width;
    sprite.scaleY = _winSize.height / sprite.contentSize.height;

}

- (void) addGround
{
    
    for(NSInteger i = 0 ; i < 30 ; i++)
    {
        CCSprite *ground = [CCSprite spriteWithFile:@"Wall 2 NW.png"];
        ground.anchorPoint = ccp(0, 0);
        ground.position = ccp(2 * i * ground.contentSize.width ,0);
        [_groundLayer addChild:ground];
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"Wall 2 NW" withExtension:@"png"];
        [self setupPhysicsLandscape:cpv(2*i*ground.contentSize.width, -64) withURL:url];
        
        
        CCSprite *ground2 = [CCSprite spriteWithFile:@"Wall 2 NE.png"];
        ground2.anchorPoint = ccp(0, 0);
        ground2.position = ccp((2*i + 1) * ground2.contentSize.width, 0);
        [_groundLayer addChild:ground2];
        
         url = [[NSBundle mainBundle] URLForResource:@"Wall 2 NE" withExtension:@"png"];
        [self setupPhysicsLandscape:cpv((2*i + 1) * ground2.contentSize.width, -64) withURL:url];
        
    }
    
}
- (void) addRoots
{
    for(NSInteger i = 0; i < 60; i++)
    {
        
        CCSprite *roots = [CCSprite spriteWithFile:@"Roots.png"];
        roots.anchorPoint = ccp(0, 0);
        roots.position = ccp(i * roots.contentSize.width, _winSize.height - roots.contentSize.height);
        [_skyLayer addChild:roots];
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"Roots" withExtension:@"png"];
        [self setupPhysicsLandscape:cpv((i)*roots.contentSize.width - 100, 190) withURL:url];
    }
}

-(void) applyImpulseOnTumbleweed
{
    
    CGFloat _impulse = [_configuration[@"impulse"] floatValue];
    [_tumbleWeed moveUpWithImpulse:cpv(0, 5) Impulse:_impulse];
    
}

@end