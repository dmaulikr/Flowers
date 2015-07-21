//
//  GamePlay.h
//  Flowers
//
//  Created by Ryan Fox on 10/2/10.
//  Copyright 2010 DevTeamName. All rights reserved.
//

#import "cocos2d.h"

@interface FlowerLevel : CCLayer {
	NSMutableArray *flowers;
	CCLabelTTF *levelLabel;
	CCLabelTTF *trialLabel;
	CCLabelTTF *timeLabel;
	bool changingLevel;
	bool gameOver;
	CGSize winSize;
	int winWidth;
	int winHeight;
	int newHeight;
}
+(id) scene;
@end
