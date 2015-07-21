//
//  FlowersAppDelegate.m
//  Flowers
//
//  Created by Ryan Fox on 10/2/10.
//  Copyright DevTeamName 2010. All rights reserved.
//
#import "cocos2d.h"
#import "SingletonGameState.h"
#import "FlowersAppDelegate.h"
#import "GameConfig.h"
#import "Appirater.h"
#import "HelloWorldScene.h"
#import "RootViewController.h"
#import "SimpleAudioEngine.h"

#define _scale [SingletonGameState sharedGameStateInstance]._scale
#define _size [SingletonGameState sharedGameStateInstance]._size

@implementation FlowersAppDelegate

@synthesize window;

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	[Appirater appLaunched:YES];
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	SingletonGameState *sharedGameState = [SingletonGameState sharedGameStateInstance];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
							preserveBackbuffer:NO];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
	// To enable Hi-Red mode (iPhone4)
	//	[director setContentScaleFactor:2];
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:NO];

	// init game state
	sharedGameState = [SingletonGameState sharedGameStateInstance];
	[SingletonGameState sharedGameStateInstance].level = 0;
	[SingletonGameState sharedGameStateInstance].time = 90;
	[SingletonGameState sharedGameStateInstance].trialTime = 0;
	if([[UIScreen mainScreen] respondsToSelector:NSSelectorFromString(@"scale")])
	{
		if ([[UIScreen mainScreen] scale] < 1.1){
			NSLog(@"Standard Resolution Device");
			[director setContentScaleFactor:1];
			_scale=1;
			
		}
		
		if ([[UIScreen mainScreen] scale] > 1.9){
			NSLog(@"High Resolution Device:");
			[director setContentScaleFactor:2];
			_scale=2;
		}
	} else{
		//this means we run on iOS<4.0 and only low-res is valid
			_scale = 1;
	}
	_size = [[CCDirector sharedDirector] winSize];
	_size = CGSizeMake(_size.width/_scale, _size.height/_scale);
	NSLog(@"_scale: %i", _scale);
	_size = [[CCDirector sharedDirector] winSize];
	_size = CGSizeMake(_size.width/_scale, _size.height/_scale);
	
	
	// start music
	[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bgmusic.mp3"];

	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// init images array
	NSArray *tempbadArray = [NSArray arrayWithObjects:
							 @"bLPurple.png",
							 @"bRed.png",
							 @"bPurple.png",
							 @"bOrange.png",
							 @"bGreen.png",
							 nil];
	NSArray *tempgoodArray = [NSArray arrayWithObjects:
							  @"gLPurple.png",
							  @"gRed.png",
							  @"gPurple.png",
							  @"gOrange.png",
							  @"gGreen.png",
							 nil];
	[SingletonGameState sharedGameStateInstance].badArray = [[NSArray alloc] initWithArray:tempbadArray];
	[SingletonGameState sharedGameStateInstance].goodArray = [[NSArray alloc] initWithArray:tempgoodArray];
	[SingletonGameState sharedGameStateInstance].trialMode = NO;
	[SingletonGameState sharedGameStateInstance].multOn = NO;
	[SingletonGameState sharedGameStateInstance].multGO = YES;
	[SingletonGameState sharedGameStateInstance].timeInit = 0;
	[SingletonGameState sharedGameStateInstance].curOppLevel = 1;
	[SingletonGameState sharedGameStateInstance].mainInit = 0;
	
	// to spoof the user winning the 25 levels, uncomment the following line:
//		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"beatLevels"];
	
	
	// make the View Controller a child of the main window
	[window addSubview: viewController.view];
	
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	
	// Run the intro Scene
	[[CCDirector sharedDirector] runWithScene: [MainMenu scene]];	
}
- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[Appirater appEnteredForeground:YES];
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

@end
