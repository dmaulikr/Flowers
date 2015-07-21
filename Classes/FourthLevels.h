//
//  GamePlay.h
//  Flowers
//
//  Created by Ryan Fox on 10/2/10.
//  Copyright 2010 DevTeamName. All rights reserved.
//

#import "cocos2d.h"

@interface FourthLevels : CCLayer {
	NSMutableArray *flowers;
	CCLabelTTF *levelLabel;
	CCLabelTTF *timeLabel;
	CCLabelTTF *trialLabel;
	bool changingLevel;
	bool gameOver;
}
+(id) scene;

@end
