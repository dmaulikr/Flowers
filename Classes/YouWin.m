//
//  HelloWorldLayer.m
//  Flowers
//
//  Created by Ryan Fox on 10/2/10.
//  Copyright DevTeamName 2010. All rights reserved.
//

// Import the interfaces
#import "SingletonGameState.h"
#import "HelloWorldScene.h"
#import "SimpleAudioEngine.h"
#import	"Multiplayer.h"
#import "FlowerLevel.h"
#import "YouWin.h"

#define curLevel [SingletonGameState sharedGameStateInstance].level
#define trialTime [SingletonGameState sharedGameStateInstance].trialTime
#define time [SingletonGameState sharedGameStateInstance].time
#define isInTrialMode [SingletonGameState sharedGameStateInstance].trialMode
#define _scale [SingletonGameState sharedGameStateInstance]._scale
#define isInMultiplayer [SingletonGameState sharedGameStateInstance].multOn

// HelloWorld implementation
@implementation YouWin

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
	NSLog(@"YouWin initialized.");
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		[[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
		[[SimpleAudioEngine sharedEngine] playEffect:@"win.caf"];
		CCSprite *background = [CCSprite spriteWithFile:@"win.png"];
		[background setPosition:ccp(240,160)];
		[background setScale:_scale / 2];
		CCMenuItem *mainmenuButton = [CCMenuItemImage
									  itemFromNormalImage:@"mainmenu.png"
									  selectedImage:@"mainmenu_push.png"
									  target:self
									  selector:@selector(mainmenu:)]; 
		[mainmenuButton setScale:_scale / 2];
		CCMenu *mainMenu = [CCMenu menuWithItems:mainmenuButton,
							nil];
		[mainMenu alignItemsVertically];
		
		// if user was playing normal mode...
		if(!isInTrialMode && !isInMultiplayer) {
			NSLog(@"User was playing normal mode.");
			if([[NSUserDefaults standardUserDefaults] boolForKey:@"beatLevels"]) {
				winMessage = [CCLabelTTF labelWithString:@"You win again... but not on Hard!"
												fontName:@"Marker Felt"
												fontSize:16];
				
			}
			else {
				winMessage = [CCLabelTTF labelWithString:@"You've unlocked Hard Mode!"
												fontName:@"Marker Felt"
												fontSize:16];
				[[NSUserDefaults standardUserDefaults] setBool:TRUE
														forKey:@"beatLevels"];	
			}
		}
		
		// if user was playing Hard Mode...	
		else if (isInTrialMode && !isInMultiplayer) {
			NSLog(@"User played hard mode.");

				[[NSUserDefaults standardUserDefaults] setInteger:curLevel forKey:@"bestHard"];
				[[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"beatHard"];
				winMessage = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"You beat Flowers!", curLevel]
												fontName:@"Marker Felt"
												fontSize:16];
		}
		
		// if user was playing Multiplayer...
		else {
			NSLog(@"User was playing multiplayer.");
			winMessage = [CCLabelTTF
						  labelWithString:[NSString stringWithFormat:@"You win!", curLevel]
						  fontName:@"Marker Felt"
						  fontSize:16];	
		}
		winMessage.position = ccp(370,30);
		[self addChild:background];
		[mainMenu setPosition:ccp(240,120)];
		[self addChild:mainMenu];
		[self addChild:winMessage];
		
	}
	curLevel = 0;
	time = 90;
	trialTime = 0;
	[SingletonGameState sharedGameStateInstance].multOn = NO;
	return self;
}
-(void)mainmenu:(id)sender {
	[[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];
	if(isInMultiplayer) {
			[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[Multiplayer node]]];
	}
	else {
			[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[MainMenu node]]];
	}
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
