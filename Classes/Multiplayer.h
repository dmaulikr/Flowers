//
//  Multiplayer.h
//  Flowers
//
//  Created by Ryan Fox on 10/27/10.
//  Copyright 2010 DevTeamName. All rights reserved.
//

#import "cocos2d.h"
#import <GameKit/GameKit.h>

@interface Multiplayer : CCLayer {
	NSMutableArray *flowers;
	CCLabelTTF *levelLabel;
	CCLabelTTF *oppLevelLabel;
	CGSize winSize;
	bool firstGo;
	int winWidth;
	int winHeight;
	int newHeight;
}
@property (nonatomic, retain) CCLabelTTF *oppLevelLabel;
+(id) scene;

@end