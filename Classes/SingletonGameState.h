//
//  SingletonGameState.h
//  Flowers
//
//  Created by Ryan Fox on 10/2/10.
//  Copyright 2010 DevTeamName. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface SingletonGameState : NSObject <GKPeerPickerControllerDelegate, GKSessionDelegate> {
	GKPeerPickerController *myPicker;
	GKSession *currentSession;
	NSArray *bg1Array;
	NSArray *bg2Array;
	NSArray *goodArray;
	NSArray *badArray;
	int level;
	int curOppLevel;
	int timeInit;
	NSUInteger time;
	NSUInteger trialTime;
	bool beatGame;
	bool multGO;
	bool trialMode;
	bool multOn;
	float _scale;
	CGSize _size;
 }
@property (nonatomic, retain) GKSession *currentSession;
@property (nonatomic, retain) GKPeerPickerController *myPicker;
@property (nonatomic, retain) NSArray *bg1Array;
@property (nonatomic, retain) NSArray *bg2Array;
@property (nonatomic, retain) NSArray *goodArray;
@property (nonatomic, retain) NSArray *badArray;
@property (readwrite) int level;
@property (readwrite) int curOppLevel;
@property (readwrite) NSUInteger time;
@property (readwrite) NSUInteger trialTime;
@property (readwrite) bool beatGame;
@property (readwrite) bool multOn;
@property (readwrite) bool multGO;
@property (readwrite) float _scale;
@property (readwrite) int timeInit;
@property (readwrite) int mainInit;
@property (readwrite) CGSize _size;
@property (readwrite) bool trialMode;
+ (SingletonGameState*)sharedGameStateInstance;
-(void)connect:(id)sender;
-(void)sendCurrentLevel:(id)sender;

@end
