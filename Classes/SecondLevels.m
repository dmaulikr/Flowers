//
//  GamePlay.m
//  Flowers
//
//  Created by Ryan Fox on 10/2/10.
//  Copyright 2010 DevTeamName. All rights reserved.
//

#import "GameOver.h"
#import "FirstLevels.h"
#import "Flower.h"
#import "SingletonGameState.h"
#import "ThirdLevels.h"
#import "SecondLevels.h"

@implementation SecondLevels
+(id) scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SecondLevels *layer = [SecondLevels node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
-(void)updateTime:(id)sender {
	[SingletonGameState sharedGameStateInstance].trialTime++;
	if([SingletonGameState sharedGameStateInstance].trialMode) {
		[trialLabel setString:[NSString stringWithFormat:@"Time Trial: %i", [SingletonGameState sharedGameStateInstance].trialTime]];
	}
		if(changingLevel) {
			[SingletonGameState sharedGameStateInstance].time += 25;
			changingLevel = FALSE;
		}
		if([SingletonGameState sharedGameStateInstance].time >0) {
			[SingletonGameState sharedGameStateInstance].time -= 1;
			[timeLabel setString:[NSString stringWithFormat:@"Time: %i", [SingletonGameState sharedGameStateInstance].time]];
		}
		else if ([SingletonGameState sharedGameStateInstance].time == 0){
			[SingletonGameState sharedGameStateInstance].time = -1;			[timeLabel setString:@"Time: 0"];
		[[CCDirector sharedDirector] replaceScene:[CCTransitionRotoZoom transitionWithDuration:1 scene:[GameOver node]]];	}
}
-(id) init
{
	[self schedule: @selector(updateTime:) interval:0.1];	
	[SingletonGameState sharedGameStateInstance].level++;
//	NSLog(@"Current level: %i", [SingletonGameState sharedGameStateInstance].level);
	flowers = [[NSMutableArray alloc] init];
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		CCSprite *bg1 = [CCSprite spriteWithFile:@"bg11.png"];
		[bg1 setPosition:CGPointMake(240, 240)];
		[self addChild:bg1];
		CCSprite *bg2 = [CCSprite spriteWithFile:@"bg12.png"];
		[bg2 setPosition:CGPointMake(240, 60)];
		[self addChild:bg2];
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		int winWidth = winSize.width - 15;
		int winHeight = winSize.height - 15;
		int flowersToDraw = ([SingletonGameState sharedGameStateInstance].level-4)*5+15;
		for(int x=0;x<flowersToDraw;x++) {
			int badX = (arc4random()%winWidth) +15;
			int badY = (arc4random()%winHeight) +15;
			Flower* badFlower = [Flower spriteWithFile: @"badFlower.png"];
			[badFlower setPosition:ccp(badX, badY)];
			//			NSLog(@"About to set badFlower to bad.");
			badFlower.isGood = NO;
			[self addChild: badFlower];
			[flowers addObject:badFlower];
			//			NSLog(@"Bad flower added at (%i, %i).", badX, badY);
		}

		// create single good flower
		int goodX = (arc4random()%winWidth) +15;
		int goodY = (arc4random()%winHeight) +15;
		Flower* goodFlower = [Flower spriteWithFile: @"flower.png"];
		[goodFlower setPosition:ccp(goodX, goodY)];
		goodFlower.isGood = YES;
		[self addChild: goodFlower];
		[flowers addObject:goodFlower];
		//		NSLog(@"Good flower added at (%i, %i).", goodX, goodY);
		if(	[SingletonGameState sharedGameStateInstance].trialMode) {
			//			NSLog(@"Trial mode detected. TrialLabel created.");
			trialLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Time Trial: %i", [SingletonGameState sharedGameStateInstance].trialTime] fontName:@"Marker Felt" fontSize:16];
			trialLabel.position = ccp(256,308);
			[self addChild:trialLabel];
		}
		levelLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Level: %i", [SingletonGameState sharedGameStateInstance].level] fontName:@"Marker Felt" fontSize:16];
		timeLabel = [CCLabelTTF labelWithString:@"Time: 50" fontName:@"Marker Felt" fontSize:16];
		levelLabel.position = ccp(34,308);
		timeLabel.position = ccp(446, 308);
		[self addChild:levelLabel];
		[self addChild:timeLabel];
		self.isTouchEnabled = YES;
		[self schedule: @selector(updateTime:) interval:0.1];	
	}
		return self;
}
- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Code to handle touches goes here
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:[touch view]];
	CGPoint convertedPoint = [[CCDirector sharedDirector] convertToGL:point]; 
	for(Flower *flower in [flowers reverseObjectEnumerator]) {
        if (CGRectContainsPoint([flower boundingBox], convertedPoint)) {
			if(flower.isGood == YES) {
				if([SingletonGameState sharedGameStateInstance].level >= 10) {
					[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[ThirdLevels node]]];	
				}
				else {
					[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[SecondLevels node]]];
				}
				changingLevel = TRUE;
			}
			else {
		[[CCDirector sharedDirector] replaceScene:[CCTransitionRotoZoom transitionWithDuration:1 scene:[GameOver node]]];
			}
			break;
		}
	}
//	NSLog(@"Touched at (%f, %f).", convertedPoint.x, convertedPoint.y);
}

@end