//
//  GamePlay.h
//  Flowers
//
//  Created by Ryan Fox on 10/2/10.
//  Copyright 2010 DevTeamName. All rights reserved.
//

#import "cocos2d.h"

@interface FirstLevels : CCLayer {
	NSMutableArray *flowers;
	CCLabelTTF *levelLabel;
	CCLabelTTF *trialLabel;
	CCLabelTTF *timeLabel;
	bool changingLevel;
	bool gameOver;
}
+(id) scene;

@end
