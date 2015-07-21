//
//  GameOver.m
//  Flowers
//
//  Created by Ryan Fox on 10/2/10.
//  Copyright 2010 DevTeamName. All rights reserved.
//

#import "GameOver.h"
#import "FlowerLevel.h"
#import "HelloWorldScene.h"
#import "SimpleAudioEngine.h"
#import "SingletonGameState.h"

#define _scale [SingletonGameState sharedGameStateInstance]._scale

@implementation GameOver
+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameOver *layer = [GameOver node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		[[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
		[SingletonGameState sharedGameStateInstance].time = 90;
		CCSprite *background = [CCSprite spriteWithFile:@"overbg.png"];
		[background setPosition:ccp(240,160)];
		[background setScale:_scale / 2];
		CCSprite *sign = [CCSprite spriteWithFile:@"gameOverSign.png"];
		[sign setPosition:ccp(240,480)];
		[sign setScale:_scale / 2];
		CCMenuItem *restartButton = [CCMenuItemImage itemFromNormalImage:@"restart.png"
														   selectedImage:@"restart_push.png"
																  target:self
																selector:@selector(restart:)];
		[restartButton setScale:_scale/2];
		CCMenuItem *mainMenuButton = [CCMenuItemImage itemFromNormalImage:@"mainmenu.png"
															selectedImage:@"mainmenu_push.png"
																   target:self
																 selector:@selector(mainmenu:)];
		[mainMenuButton setScale:_scale/2];
		CCMenu *mainMenu = [CCMenu menuWithItems:restartButton,mainMenuButton,nil];
		[mainMenu alignItemsVertically];
		if([SingletonGameState sharedGameStateInstance].trialMode) {
			if([SingletonGameState sharedGameStateInstance].level > [[NSUserDefaults standardUserDefaults] integerForKey:@"bestHard"]) {
				[[NSUserDefaults standardUserDefaults] setInteger:[SingletonGameState sharedGameStateInstance].level forKey:@"bestHard"];
				[[NSUserDefaults standardUserDefaults] synchronize];
				levelLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"New Hard high score! You got to Level %i", [[NSUserDefaults standardUserDefaults] integerForKey:@"bestHard"]] fontName:@"Marker Felt" fontSize:20];
				[[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"beatLevels"];
			}
			else {
				levelLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"You got to Hard Level %i",[SingletonGameState sharedGameStateInstance].level] fontName:@"Marker Felt" fontSize:20];
			}
		}
		else if([SingletonGameState sharedGameStateInstance].level > [[NSUserDefaults standardUserDefaults] integerForKey:@"bestLevel"]) {
			[[NSUserDefaults standardUserDefaults] setInteger:[SingletonGameState sharedGameStateInstance].level forKey:@"bestLevel"];
			[[NSUserDefaults standardUserDefaults] synchronize];
			levelLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"New high score! You got to Level %i", [[NSUserDefaults standardUserDefaults] integerForKey:@"bestLevel"]] fontName:@"Marker Felt" fontSize:20];
			if([SingletonGameState sharedGameStateInstance].level == 25) {
				[[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"beatLevels"];
			}
		}
		else {
			levelLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"You got to Level %i", [SingletonGameState sharedGameStateInstance].level] fontName:@"Marker Felt" fontSize:20];	
		}
	levelLabel.position = ccp(240,30);
	mainMenu.position = ccp(240,-100);
	[self addChild:background];		
	id signDrop =[CCMoveTo actionWithDuration:2.0 position:ccp(240,250)];
	[[SimpleAudioEngine sharedEngine] playEffect:@"curtainlong.caf"];
	[sign runAction:signDrop];		
	[self addChild:sign];
	id menuPush =[CCMoveTo actionWithDuration:1.0 position:ccp(240,100)];
	[mainMenu runAction:menuPush];
	[self addChild:mainMenu];
	[self addChild:levelLabel];
	[SingletonGameState sharedGameStateInstance].level = 0;
	[SingletonGameState sharedGameStateInstance].trialTime = 0;
	
}
return self;
}
-(void)mainmenu:(id)sender {
	[[SimpleAudioEngine sharedEngine]resumeBackgroundMusic];
	[[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[MainMenu node]]];
}
-(void)restart:(id)sender {	
	[SingletonGameState sharedGameStateInstance].trialTime = 0;
	[SingletonGameState sharedGameStateInstance].time = 90;
	[[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];
	[[SimpleAudioEngine sharedEngine]resumeBackgroundMusic];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[FlowerLevel node]]];
	
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end