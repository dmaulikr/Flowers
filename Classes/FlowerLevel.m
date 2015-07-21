//
//  GamePlay.m
//  Flowers
//
//  Created by Ryan Fox on 10/2/10.
//  Copyright 2010 DevTeamName. All rights reserved.
//
#import "GameOver.h"
#import "Flower.h"
#import "SingletonGameState.h"
#import "FlowerLevel.h"
#import "SimpleAudioEngine.h"
#import "YouWin.h"

#define curLevel [SingletonGameState sharedGameStateInstance].level
#define trialTime [SingletonGameState sharedGameStateInstance].trialTime
#define time [SingletonGameState sharedGameStateInstance].time
#define bg1Array [SingletonGameState sharedGameStateInstance].bg1Array
#define bg2Array [SingletonGameState sharedGameStateInstance].bg2Array
#define badArray [SingletonGameState sharedGameStateInstance].badArray
#define goodArray [SingletonGameState sharedGameStateInstance].goodArray
#define isInTrialMode [SingletonGameState sharedGameStateInstance].trialMode
#define _scale [SingletonGameState sharedGameStateInstance]._scale
@implementation FlowerLevel
+(id) scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	FlowerLevel *layer = [FlowerLevel node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
-(void)updateTime:(id)sender {
	//	NSLog(@"Trial time increased.");
	if(time%10 == 0) {
		if(isInTrialMode) {
			for(Flower *flower in flowers) {
				int newX = arc4random()%winWidth;
				int newY = arc4random()%winHeight;
//				NSLog(@"Finna move a bitch.");
				id moveFlower =[CCMoveTo actionWithDuration:0.5 position:ccp(newX,newY)];
				[flower runAction:moveFlower];	
				//			[flower setPosition:ccp(newX, newY)];
			}	
		}
		
	}
	//	NSLog(@"Trial label set.");
	if(changingLevel) {
		time += 35;
		changingLevel = FALSE;
	}
	if(time > 0) {
		time -= 1;
		[timeLabel setString:[NSString stringWithFormat:@"Time: %i", time]];
	}
	else if (time == 0){
		time = -1;	
		[timeLabel setString:@"Time: 0"];
		[[CCDirector sharedDirector] replaceScene:[CCTransitionRadialCW transitionWithDuration:0.5 scene:[GameOver node]]];
		
	}
}
-(id) init
{
	curLevel++;
	//	NSLog(@"Current level: %i", curLevel);
	//	NSLog(@"Attempting to init.");
	gameOver = FALSE;
	//	NSLog(@"Attempting to add one to current level.");
	//	NSLog(@"Current level: %i", ??????);
	flowers = [[NSMutableArray alloc] init];
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		CCSprite *dirt = [CCSprite spriteWithFile:@"patch.png"];
		[dirt setPosition:CGPointMake(240,160)];
		[dirt setScale:_scale / 2];
		[self addChild:dirt];
		winSize = [[CCDirector sharedDirector] winSize];
		winWidth = winSize.width;
		winHeight = winSize.height - (35*(2/_scale));
		newHeight = winHeight - (35*(2/_scale));
		int flowersToDraw = (curLevel-(curLevel/5+1))*5+15;
		// create badFlowers
		for(int x=0;x<flowersToDraw;x++) {
			int badX = (arc4random()%winWidth);
			int badY = (arc4random()%winHeight);
			Flower *badFlower = [Flower spriteWithFile:[badArray objectAtIndex:(curLevel-1) / 5]];
			[badFlower setScale:_scale / 2];
			[badFlower setPosition:ccp(badX, badY)];
			//			NSLog(@"About to set badFlower to bad.");
			badFlower.isGood = NO;
			[self addChild: badFlower];
			[badFlower runAction:[CCRepeatForever actionWithAction:[CCRotateTo actionWithDuration:4 angle:720]]];
			[flowers addObject:badFlower];
			//			NSLog(@"Bad flower added at (%i, %i).", badX, badY);
		}
		// create single good flower
		int goodX = (arc4random()%winWidth);
		int goodY = (arc4random()%winHeight);
		Flower *goodFlower = [Flower spriteWithFile:[goodArray objectAtIndex:(curLevel-1) / 5]];
		[goodFlower setPosition:ccp(goodX, goodY)];
		[goodFlower setScale:_scale / 2];
		goodFlower.isGood = YES;
		[self addChild: goodFlower];
		[goodFlower runAction:[CCRepeatForever actionWithAction:[CCRotateTo actionWithDuration:4 angle:720]]];
		[flowers addObject:goodFlower];
		//		NSLog(@"Good flower added at (%i, %i).", goodX, goodY);
		levelLabel = [CCLabelTTF
					  labelWithString:[NSString stringWithFormat:@"Level: %i", curLevel]
					  fontName:@"Marker Felt"
					  fontSize:16];
		timeLabel = [CCLabelTTF
					 labelWithString:@"Time: 50"
					 fontName:@"Marker Felt"
					 fontSize:16];
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
				if(curLevel == 25)
				{
					[[CCDirector sharedDirector]
					 replaceScene:[CCTransitionFade
								   transitionWithDuration:1
								   scene:[YouWin node]]];
				} 
				else {
					[[CCDirector sharedDirector]
					 replaceScene:[CCTransitionFade
								   transitionWithDuration:1
								   scene:[FlowerLevel node]]];
				}
				changingLevel = TRUE;
			}
			else {
				[self unschedule:@selector(updateTime:)];
				[[CCDirector sharedDirector]
				 replaceScene:[CCTransitionRadialCW
							   transitionWithDuration:1.0
							   scene:[GameOver node]]];
			}
			break;
		}
	}
}
-(void)dealloc {
	[flowers release];
	[super dealloc];
}
@end