//
//  Multiplayer.m
//  Flowers
//
//  Created by Ryan Fox on 10/27/10.
//  Copyright 2010 DevTeamName. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "GameOver.h"
#import "Flower.h"
#import "SingletonGameState.h"
#import "Multiplayer.h"
#import "SimpleAudioEngine.h"
#import "YouWin.h"

#define curLevel [SingletonGameState sharedGameStateInstance].level
#define trialTime [SingletonGameState sharedGameStateInstance].trialTime
#define time [SingletonGameState sharedGameStateInstance].time
#define bg1Array [SingletonGameState sharedGameStateInstance].bg1Array
#define bg2Array [SingletonGameState sharedGameStateInstance].bg2Array
#define badArray [SingletonGameState sharedGameStateInstance].badArray
#define goodArray [SingletonGameState sharedGameStateInstance].goodArray
#define timeInit [SingletonGameState sharedGameStateInstance].timeInit
#define isInTrialMode [SingletonGameState sharedGameStateInstance].trialMode
#define _scale [SingletonGameState sharedGameStateInstance]._scale
@implementation Multiplayer
@synthesize oppLevelLabel;
-(void)updateTime:(id)sender {
	//	NSLog(@"Trial time increased.");
	for(Flower *flower in flowers) {
		int newX = arc4random()%winWidth;
		int newY = arc4random()%winHeight;
		//				NSLog(@"Finna move a bitch.");
		id moveFlower =[CCMoveTo actionWithDuration:0.5 position:ccp(newX,newY)];
		[flower runAction:moveFlower];	
		//			[flower setPosition:ccp(newX, newY)];
	}
}

-(id) init {
	[SingletonGameState sharedGameStateInstance].multOn = YES;
	//	NSLog(@"Current level: %i", curLevel);
	//	NSLog(@"Attempting to init.");
	//	NSLog(@"Attempting to add one to current level.");
	//	NSLog(@"Current level: %i", ??????);
	flowers = [[NSMutableArray alloc] init];
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		if (timeInit == 0) {
			firstGo = TRUE;
			NSLog(@"Entered if tree.");
			//			[[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
			CCSprite *background = [CCSprite spriteWithFile:@"btmp.png"];
			[background setPosition:ccp(240,160)];
			[background setScale:_scale / 2];
			[self addChild:background];

			CCMenuItem *connect = [CCMenuItemImage
								   itemFromNormalImage:@"ok.png"
								   selectedImage:@"ok_push.png"
								   target:self
								   selector:@selector(connect:)]; 
			CCMenuItem *back = [CCMenuItemImage
								itemFromNormalImage:@"back.png"
								selectedImage:@"back_push.png"
								target:self
								selector:@selector(mainmenu:)]; 
			[connect setScale:_scale / 2];
			[back setScale:_scale / 2];
			CCMenu *connectMenu = [CCMenu menuWithItems:connect,nil];
			CCMenu *backMenu = [CCMenu menuWithItems:back,nil];
			connectMenu.position = ccp(268,102);
			backMenu.position = ccp(201,102);
			[self addChild:connectMenu];
			[self addChild:backMenu];
			timeInit++;
			NSLog(@"Incremented timeInit.");
		}
		else {
			if(firstGo) {
				oppLevelLabel = [CCLabelTTF
							  labelWithString:@"Opponent Level: 1"
							  fontName:@"Marker Felt"
							  fontSize:16];
				oppLevelLabel.position = ccp(400,308);
				firstGo = FALSE;
			}
			else {
			oppLevelLabel = [CCLabelTTF
							 labelWithString:[NSString stringWithFormat:@"Opponent Level: %i", [SingletonGameState sharedGameStateInstance].curOppLevel]
							 fontName:@"Marker Felt"
							 fontSize:16];
			oppLevelLabel.position = ccp(400,308);
			}
			curLevel++;
			[[SingletonGameState sharedGameStateInstance] sendCurrentLevel:self];
			levelLabel = [CCLabelTTF
							 labelWithString:[NSString stringWithFormat:@"Level: %i", [SingletonGameState sharedGameStateInstance].level]
							 fontName:@"Marker Felt"
							 fontSize:16];
			levelLabel.position = ccp(34,308);
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
			[self addChild:levelLabel];
			[self addChild:oppLevelLabel];
			//		NSLog(@"Good flower added at (%i, %i).", goodX, goodY);

			self.isTouchEnabled = YES;
			[self schedule: @selector(updateTime:) interval:4];	
			[self schedule: @selector(checkOtherScore:) interval:1.5];	
		}
	}
	return self;
}
-(void)checkOtherScore:(id)sender {
	[[SingletonGameState sharedGameStateInstance] sendCurrentLevel:self];
	[self removeChild:oppLevelLabel cleanup:YES];
	oppLevelLabel = [CCLabelTTF
					 labelWithString:[NSString stringWithFormat:@"Opponent Level: %i", [SingletonGameState sharedGameStateInstance].curOppLevel]
					 fontName:@"Marker Felt"
					 fontSize:16];
	oppLevelLabel.position = ccp(400,308);
	[self addChild:oppLevelLabel];
}
- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Code to handle touches goes here
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:[touch view]];
	CGPoint convertedPoint = [[CCDirector sharedDirector] convertToGL:point];
	for(Flower *flower in [flowers reverseObjectEnumerator]) {
		if (CGRectContainsPoint([flower boundingBox], convertedPoint )) {
			if(flower.isGood == YES) {
				if(curLevel == 25)	{
					curLevel++;
					[SingletonGameState sharedGameStateInstance].multGO = TRUE;
					[[SingletonGameState sharedGameStateInstance] sendCurrentLevel:self];
					[[CCDirector sharedDirector]
					 replaceScene:[CCTransitionFade
								   transitionWithDuration:1
								   scene:[YouWin node]]];
				} 
				else {
					[[CCDirector sharedDirector]
					 replaceScene:[CCTransitionFade
								   transitionWithDuration:1
								   scene:[Multiplayer node]]];
				}	
			}
			else {
				if(curLevel >1) {
					curLevel -= 2;
				[[CCDirector sharedDirector]
				 replaceScene:[CCTransitionFade
							   transitionWithDuration:1
							   scene:[Multiplayer node]]];
				}
			}
		}
	}
}

-(void)mainmenu:(id)sender {
	timeInit = 0;
	[SingletonGameState sharedGameStateInstance].multOn = NO;
	[[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[MainMenu node]]];
}
-(void)connect:(id)sender {
	[[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];
	[[SingletonGameState sharedGameStateInstance] connect:self];
}


+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainMenu *layer = [MainMenu node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(void)dealloc {
	[super dealloc];
}

@end

