//
//  SingletonGameState.m
//  Flowers
//
//  Created by Ryan Fox on 10/2/10.
//  Copyright 2010 DevTeamName. All rights reserved.
//

#import "SingletonGameState.h"
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "Multiplayer.h"


@implementation SingletonGameState
@synthesize level, time, trialTime, beatGame, trialMode, _scale, _size, bg1Array, bg2Array, badArray, goodArray, timeInit, mainInit, multOn, currentSession, myPicker, multGO, curOppLevel;

+ (SingletonGameState*)sharedGameStateInstance {
	
	static SingletonGameState *sharedGameStateInstance;
	
	@synchronized(self) {
		if(!sharedGameStateInstance) {
			sharedGameStateInstance = [[SingletonGameState alloc] init];
		}
	}
	
	return sharedGameStateInstance;
}

- (void)dealloc {
	[super dealloc];
}
- (void) sendCurrentLevel:(id)sender
{
    if (currentSession)  {
		NSString *curLevelString = [NSString stringWithFormat:@"%i",level];
		NSData *curLevelData = [curLevelString dataUsingEncoding:NSUTF8StringEncoding];	
		[self.currentSession sendDataToAllPeers:curLevelData 
                                   withDataMode:GKSendDataUnreliable 
                                          error:nil];  
	}
}

-(void)connect:(id)sender {
	myPicker = [[GKPeerPickerController alloc] init];
	myPicker.delegate = self;
	myPicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;      
	[myPicker show];    
}
- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context {
	NSLog(@"Received data.");
	NSString *decodedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"decodedString = %@", decodedString);
	int oppLevel = [decodedString intValue];
	NSLog(@"String --> opponent's level: %i", oppLevel);
	if (oppLevel > 25) {
		[SingletonGameState sharedGameStateInstance].multGO = YES;
		timeInit = 0;
		[[SingletonGameState sharedGameStateInstance].currentSession disconnectFromAllPeers];
		[[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1 scene:[Multiplayer node]]];	
		UIAlertView *lostAlert = [[UIAlertView alloc] initWithTitle:@"You lost!"
															message:@"Sorry, your opponent finished the 25 levels before you did. Better luck next time? :("
														   delegate:nil
												  cancelButtonTitle:@"Ok..."
												  otherButtonTitles:nil];
		[lostAlert show];
		[lostAlert release];
	}
	else {
		curOppLevel = oppLevel;
	}
	
}
- (void)peerPickerController:(GKPeerPickerController *)picker 
			  didConnectPeer:(NSString *)peerID 
				   toSession:(GKSession *) session {
    self.currentSession = session;
    session.delegate = self;
    [session setDataReceiveHandler:self withContext:nil];
	picker.delegate = nil;
	
    [picker dismiss];
    [picker autorelease];	
}
- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
	picker.delegate = nil;
	[picker autorelease];
}


- (void)session:(GKSession *)session  peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
	if(state == GKPeerStateConnected) {
		NSLog(@"connected");
		[[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1 scene:[Multiplayer node]]];
		[SingletonGameState sharedGameStateInstance].multGO = NO;
	}
	else {
			timeInit = 0;
			[self.currentSession release];
			currentSession = nil;
			NSLog(@"disconnected");
		if(![SingletonGameState sharedGameStateInstance].multGO) {
			[[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1 scene:[Multiplayer node]]];	
			UIAlertView *disconnectedAlert = [[UIAlertView alloc] initWithTitle:@"Game Disconnected"
																		message:@"Sorry, but the connection has been lost. This could mean your opponent quit or you are out of playing range."
																	   delegate:nil
															  cancelButtonTitle:@"Ok"
															  otherButtonTitles:nil];
			[disconnectedAlert show];
			[disconnectedAlert release];
		}
		}
	}



@end
