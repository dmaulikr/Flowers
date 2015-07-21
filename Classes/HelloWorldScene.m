//
//  HelloWorldLayer.m
//  Flowers
//
//  Created by Ryan Fox on 10/2/10.
//  Copyright DevTeamName 2010. All rights reserved.
//

// Import the interfaces

#import "Multiplayer.h"
#import "InstructionsPage.h"
#import "SimpleAudioEngine.h"
#import "HelloWorldScene.h"
#import "FlowerLevel.h"
#import "AboutPage.h"
#import "SingletonGameState.h"
#import "YouWin.h"

#define _scale [SingletonGameState sharedGameStateInstance]._scale
#define _size [SingletonGameState sharedGameStateInstance]._size
#define mainInit [SingletonGameState sharedGameStateInstance].mainInit

// HelloWorld implementation
@implementation MainMenu

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

// on "init" you need to initialize your instance
-(id) init
{
	
	//////////////////////////////////////
	
	
	//	[[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"beatLevels"];
	
	
	//////////////////////////////////////
	
	
	
	[SingletonGameState sharedGameStateInstance].level = 0;
	[SingletonGameState sharedGameStateInstance].time = 90;
	CCSprite *background = [CCSprite spriteWithFile:@"background.png"];
	[background setPosition:ccp(240,160)];
	[background setScale:_scale / 2];
	CCSprite *sign = [CCSprite spriteWithFile:@"sign.png"];
	[sign setPosition:ccp(240,480)];
	[sign setScale:_scale / 2];
	//	[[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"beatLevels"];
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {

		CCMenuItem *startButton = [CCMenuItemImage itemFromNormalImage:@"start.png"
														 selectedImage:@"start_push2.png"
																target:self
															  selector:@selector(start:)];
		[startButton setScale:_scale / 2];
		CCMenuItem *multButton = [CCMenuItemImage itemFromNormalImage:@"multib.png"
														 selectedImage:@"multib_push.png"
																target:self
															  selector:@selector(multiplayer:)];
		[multButton setScale:_scale / 2];
		CCMenuItem *instructionsButton = [CCMenuItemImage itemFromNormalImage:@"helpsign.png"
																selectedImage:@"helpsign_push.png"
																	   target:self
																	 selector:@selector(instructions:)];
		[instructionsButton setScale:_scale / 2];
		CCMenuItem *aboutButton = [CCMenuItemImage itemFromNormalImage:@"aboutsign.png"
														 selectedImage:@"aboutsign_push.png"
																target:self
															  selector:@selector(about:)];
		[aboutButton  setScale:_scale / 2];
		CCMenu *instrucMenu = [CCMenu menuWithItems:instructionsButton,nil];
		instrucMenu.position = ccp(420,60);
		CCMenu *aboutMenu = [CCMenu menuWithItems:aboutButton,nil];
		aboutMenu.position = ccp(60,60);
		CCMenu *startMenu = [CCMenu menuWithItems:startButton,nil];
		startMenu.position = ccp(240,130);
		CCMenu *multMenu = [CCMenu menuWithItems:multButton,nil];
		multMenu.position = ccp(240,74);
		if([[NSUserDefaults standardUserDefaults] boolForKey:@"beatLevels"]) {
			if ([[NSUserDefaults standardUserDefaults] boolForKey:@"beatHard"]) {
				highLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Wow, you beat Flowers! ... for now. :)", [[NSUserDefaults standardUserDefaults] integerForKey:@"bestHard"]]
											   fontName:@"Marker Felt"
											   fontSize:16];
			}
			else if([[NSUserDefaults standardUserDefaults] integerForKey:@"bestHard"] != 0) {
				highLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Hard Mode High Score: %i", [[NSUserDefaults standardUserDefaults] integerForKey:@"bestHard"]]
											   fontName:@"Marker Felt"
											   fontSize:16];
			}
			else {
				highLabel = [CCLabelTTF labelWithString:@"You beat the game! Now try to beat it in the new Hard Mode!"
											   fontName:@"Marker Felt"
											   fontSize:16];
			}
		}
		else if([[NSUserDefaults standardUserDefaults] integerForKey:@"bestLevel"] != 0) {
			highLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"High Score: Level %i", [[NSUserDefaults standardUserDefaults] integerForKey:@"bestLevel"]]
										   fontName:@"Marker Felt"
										   fontSize:16];
			
		}
		else {
			highLabel = [CCLabelTTF labelWithString:@"Welcome to Flowers!"
										   fontName:@"Marker Felt"
										   fontSize:16];
		}
		highLabel.position = ccp(240,190);
		if(mainInit == 0) {
			[self addChild:background];		
			id signDrop =[CCMoveTo actionWithDuration:1.0 position:ccp(240,200)];
			[[SimpleAudioEngine sharedEngine] playEffect:@"curtain.caf"];
			[sign runAction:signDrop];		
			[self addChild:sign];
			mainInit++;
		}
		else {
			[sign setPosition:ccp(240,200)];
			[self addChild:background];
			[self addChild:sign];
		}
		[self addChild:highLabel];
		[self addChild:startMenu];
		[self addChild:multMenu];
		[self addChild:instrucMenu];
		[self addChild:aboutMenu];
		[SingletonGameState sharedGameStateInstance].multOn = NO;
	}
	return self;
}
-(void)instructions:(id)sender {
	[[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:1 scene:[InstructionsPage node]]];	
}
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	// the user clicked one of the OK/Cancel buttons
	NSLog(@"%i", buttonIndex);
	if (buttonIndex == 1)
	{
		NSLog(@"Easy");
		[SingletonGameState sharedGameStateInstance].trialMode = FALSE;
		[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[FlowerLevel node]]];
	}
	if (buttonIndex == 2) {
		NSLog(@"Hard");
		[SingletonGameState sharedGameStateInstance].trialMode = TRUE;
		[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[FlowerLevel node]]];
	}
	else
	{
		NSLog(@"Cancel");
	}
}
-(void)start:(id)sender {
	//////////////
	
	//	[SingletonGameState sharedGameStateInstance].level = 24;	
	
	//////////////
	mainInit = 0;
	
	
	
	[[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];
	if([[NSUserDefaults standardUserDefaults] boolForKey:@"beatLevels"]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mode Select"
														message:@"Which mode would you like to play?"
													   delegate:self
											  cancelButtonTitle:@"Nevermind"
											  otherButtonTitles:@"Normal", @"Hard", nil];
		[alert show];
		[alert release];
	}
	else {
		[SingletonGameState sharedGameStateInstance].trialMode = FALSE;
		[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[FlowerLevel node]]];
	}
}
-(void)multiplayer:(id)sender {
	[[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[Multiplayer node]]];
}
-(void)about:(id)sender {
	[[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:1 scene:[AboutPage node]]];
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
