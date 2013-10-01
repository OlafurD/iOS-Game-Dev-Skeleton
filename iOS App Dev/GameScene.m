//
//  Game.m
//  iOS App Dev
//
//  Created by Sveinn Fannar Kristjansson on 9/17/13.
//  Copyright 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "GameScene.h"
#import "InputLayer.h"
#import "JungleParrot.h"
#import "ChipmunkAutoGeometry.h"
#import "cocos2d.h"
#import "WoodenBox.h"
#import "Banana.h"


@implementation GameScene

- (id)init
{
    self = [super init];
    if (self)
    {
        srandom(time(NULL));
        _winSize = [CCDirector sharedDirector].winSize;
        _totalScore = 0;
        _objectScore = 0;
        
        
        // Set up a reference to our config property list
        _configuration = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist" ]];

        
        //Create physics world
        _space = [[ChipmunkSpace alloc] init];
        CGFloat gravity = [_configuration[@"gravity"] floatValue];
        _space.gravity = ccp(0.0f, - gravity);
        
        //Register collision handler
        [_space setDefaultCollisionHandler:self begin:@selector(collisionBegan:space:) preSolve:Nil postSolve:nil separate:nil];

        
        //Create an input layer
        InputLayer *inputLayer = [[InputLayer alloc] init];
        inputLayer.delegate = self;
        [self addChild:inputLayer];
        
        //set up world
        urlGroundTiles = [[NSMutableArray alloc] init];
        [self setupGraphicsLandscape];
        
        //Create main character (JungleParrot)
        NSString *JungleParrotPositionString = _configuration[@"JungleParrotPosition"];
        _jungleParrot = [[JungleParrot alloc] initWithSpace:_space position:CGPointFromString(JungleParrotPositionString)];
        [_gameNode addChild:_jungleParrot];
        
        // setup particle system
        _particles = [CCParticleSystemQuad particleWithFile:@"splash.plist"];
        [_particles stopSystem];
        [_gameNode addChild:_particles];

        
        
        //apply lateral force to main character (JungleParrot)
        _speed = [_configuration[@"lateralForce"] floatValue];
        [_jungleParrot.chipmunkBody applyForce:cpv(_speed, 0) offset:cpvzero];
        
        //Create debug node
        CCPhysicsDebugNode *debugNode = [CCPhysicsDebugNode debugNodeForChipmunkSpace:_space];
        debugNode.visible = NO;
        [self addChild:debugNode];
        
        [self scheduleUpdate];
        
        
    }
    return self;
}



-(bool)collisionBegan:(cpArbiter *)arbiter space:(ChipmunkSpace *)space
{
    
    
    cpBody *firstBody;
    cpBody *secondBody;
    cpArbiterGetBodies(arbiter, &firstBody, &secondBody);
    
    ChipmunkBody *firstChipmunkBody = firstBody->data;
    ChipmunkBody *secondChipmunkBody = secondBody->data;
    
    
        //check if colliding with a box
        for(WoodenBox *box in _boxLayer.children)
        {
            if((firstChipmunkBody == _jungleParrot.chipmunkBody && secondChipmunkBody == box.chipmunkBody) ||
               (firstChipmunkBody == box.chipmunkBody && secondChipmunkBody == _jungleParrot.chipmunkBody))
            {
                _particles.position = box.position;
                [_particles resetSystem];
                _objectScore -= 100;
            }
        }
    
        //check if colliding with a banana
        for(Banana *ban in _bananaLayer.children)
        {
            if((firstChipmunkBody == _jungleParrot.chipmunkBody && secondChipmunkBody == ban.chipmunkBody) ||
               (firstChipmunkBody == ban.chipmunkBody && secondChipmunkBody == _jungleParrot.chipmunkBody))
            {
                _objectScore += 50;
                [[ban parent] removeChild:ban cleanup:YES];
                return NO;
            }
        }

    return YES;
}

-(void) dealloc
{

}

-(void) insertBoxObsticle
{
    
    //Add Box Obsticles
    if ((int)_jungleParrot.position.x % 50 == 0) {

        NSInteger from = 0;
        NSInteger to = 180;
        //random number from "to" to "from"
        NSInteger pos = to + arc4random() % (to-from+1);

        _boxObsticle = [[WoodenBox alloc] initWithSpace:_space position:ccp(_jungleParrot.position.x + pos, 300)];

        [_boxLayer addChild:_boxObsticle];

        
    }
    
}

-(void) insertBanana
{
    //Add Box Obsticles
    if ((int)_jungleParrot.position.x % 50 == 0) {
        
        //random number for x-axis
        NSInteger fromx = _jungleParrot.position.x;
        NSInteger tox = fromx + 400;
        NSInteger posx = tox + arc4random() % (tox-fromx+1);
        
        //random number for y-axis
        NSInteger fromy = 0;
        NSInteger toy = _winSize.height - 200;
        NSInteger posy = toy + arc4random() % (toy-fromy+1);
        
        _banana = [[Banana alloc] initWithSpace:_space position:ccp(posx, posy)];
        [_bananaLayer addChild:_banana];
    }
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
    if(_jungleParrot.chipmunkBody.vel.x > 150)
        _jungleParrot.chipmunkBody.vel = cpv(150, _jungleParrot.chipmunkBody.vel.y);
    
    
    [self insertBoxObsticle];
    [self insertBanana];
    
    for(WoodenBox *box in _boxLayer.children)
    {
        
        if(box.position.x < _jungleParrot.position.x - 250)
        {
    
            [_space smartRemove:box.chipmunkBody];
            for(ChipmunkShape *shape in box.chipmunkBody.shapes)
            {
                [_space smartRemove: shape];
            }
            
            [[box parent] removeChild:box cleanup:YES];
        }
    }
    
    for(Banana *nana in _bananaLayer.children)
    {
        if(nana.position.x < _jungleParrot.position.x - 250)
        {
            
            [[nana parent] removeChild:nana cleanup:YES];
        }
        
    }
    
    if(_jungleParrot.position.x >= (_winSize.width / 4))
        _parallaxNode.position = ccp( - (_jungleParrot.position.x - (_winSize.width /4)), 0);
    
    _totalScore = ceil(_jungleParrot.position.x * 0.1);
    _label.string = [NSString stringWithFormat:@"%d", _totalScore + _objectScore];

    
    [self swapGrounds];
    
    CGFloat fixedTimeStep = 1.0f / 240.0f;
    _accumulator += delta;
    while(_accumulator > fixedTimeStep)
    {
        [_space step:fixedTimeStep];
        _accumulator -= fixedTimeStep;
    }
    
    if(_isTouching)
        [self applyImpulseOnJungleParrot];
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
        shape.elasticity = 1;
        [_space addShape:shape];
    }
}


- (void)setupGraphicsLandscape
{
    
    CCSprite *background = [CCSprite spriteWithFile:@"Far Background.png"];
    [self scaleSpriteUP:background];
    
    
    [self addChild:background];
    
    
    //Add misterious cat eyes at random locations in the background
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
    
    // set up our layers
    _groundLayer = [CCLayer node];
    [self addGround];
    
    _skyLayer = [CCNode node];
    [self addRoots];
    
    _gameNode = [CCNode node];
    
    _boxLayer = [CCLayer node];
    
    _bananaLayer = [CCLayer node];

    _textLayer = [CCLayer node];
    
    _label = [CCLabelTTF labelWithString:@"0" fontName:@"Times new roman" fontSize:20 ];
    _label.position = ccp(_winSize.width - 50, 70);
    
    [self addChild:_label];
    
    //set up our parallax node
    _parallaxNode = [CCParallaxNode node];
    [self addChild:_parallaxNode];
    
    [_parallaxNode addChild:_skyLayer z:0 parallaxRatio:ccp(0.5f, 1.0f) positionOffset:CGPointZero];
    [_parallaxNode addChild:_groundLayer z:1 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointZero];
    [_parallaxNode addChild:_gameNode z:2 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointZero];
    [_parallaxNode addChild:_boxLayer z:3 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointZero];
    [_parallaxNode addChild:_bananaLayer z:4 parallaxRatio:ccp(1.0f, 1.0f)positionOffset:CGPointZero];
    
}

- (void) scaleSpriteUP: (CCSprite *) sprite
{
    sprite.position = ccp(_winSize.width / 2 , _winSize.height / 2);
    sprite.scaleX = _winSize.width / sprite.contentSize.width;
    sprite.scaleY = _winSize.height / sprite.contentSize.height;
    
}

- (void) addGround
{
    
    for (NSInteger i = 0; i < 10; ++i)
    {
        CCSprite *ground = [CCSprite spriteWithFile:@"Wall 2 NW.png"];
        ground.anchorPoint = ccp(0, 0);
        ground.position = ccp(2 * i * ground.contentSize.width ,0);
        [_groundLayer addChild:ground];
        
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"Wall 2 NW" withExtension:@"png"];
        [self setupPhysicsLandscape:cpv(2*i*ground.contentSize.width, -64) withURL:url];
        
        
        CCSprite *ground2 = [CCSprite spriteWithFile:@"Wall 2 NE.png"];
        ground2.anchorPoint = ccp(0, 0);
        ground2.position = ccp((2*i+ 1) * ground2.contentSize.width, 0);
        [_groundLayer addChild:ground2];
        
        NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"Wall 2 NE" withExtension:@"png"];
        [self setupPhysicsLandscape:cpv((2*i + 1) * ground2.contentSize.width, -64) withURL:url2];
        
        
    }
    
}

-(void) swapGrounds
{
    
    for (GameScene *oneGround in _groundLayer.children)
    {
        
        if(oneGround.position.x < _jungleParrot.position.x - 512)
        {
            
            oneGround.position = ccp(oneGround.position.x + 1280, 0);
            
            NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"Wall 2 NE" withExtension:@"png"];
            [self setupPhysicsLandscape:cpv(oneGround.position.x + 127, -64) withURL:url2];
            
            
        }
        
    }
    
}



- (void) addRoots
{
    for(NSInteger i = 0; i < 30; ++i)
    {

        
        CCSprite *roots = [CCSprite spriteWithFile:@"Roots.png"];
        roots.anchorPoint = ccp(0, 0);
        roots.position = ccp(i * roots.contentSize.width, _winSize.height - 80);
        [_skyLayer addChild:roots];
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"Roots" withExtension:@"png"];
        [self setupPhysicsLandscape:cpv((i)*roots.contentSize.width - 100, 230) withURL:url];
        
    }
}

-(void) applyImpulseOnJungleParrot
{
    CGFloat _impulse = [_configuration[@"impulse"] floatValue];
    [_jungleParrot moveUpWithImpulse:cpv(0, 5) Impulse:_impulse];
    
}



@end
