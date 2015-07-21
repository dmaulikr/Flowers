//
//  HelloWorldLayer.m
//  Flowers
//
//  Created by Ryan Fox on 10/2/10.
//  Copyright DevTeamName 2010. All rights reserved.
//

// Import the interfaces
#import "HelloWorldScene.h"
#import "InstructionsPage.h"
#import "SimpleAudioEngine.h"
#import "SingletonGameState.h"

#define _scale [SingletonGameState sharedGameStateInstance]._scale

// HelloWorld implementation
@implementation InstructionsPage

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
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		CCSprite *background = [CCSprite spriteWithFile:@"instrucbg.png"];
		[background setPosition:ccp(240,160)];
		[background setScale:_scale / 2];
		CCMenuItem *mainmenuButton = [CCMenuItemImage itemFromNormalImage:@"mainmenu.png"
															selectedImage:@"mainmenu_push.png"
																   target:self
																 selector:@selector(mainmenu:)];
		[mainmenuButton setScale:_scale / 2];
		CCMenu *mainMenu = [CCMenu menuWithItems:mainmenuButton,nil];
		[mainMenu alignItemsVertically];
		[mainMenu setPosition:ccp(100,30)];
		[self addChild:background];
		[self addChild:mainMenu];
	}
	return self;
}
-(void)mainmenu:(id)sender {
	[[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:1 scene:[MainMenu node]]];
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
