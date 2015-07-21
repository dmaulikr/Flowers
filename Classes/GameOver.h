//
//  GameOver.h
//  Flowers
//
//  Created by Ryan Fox on 10/2/10.
//  Copyright 2010 DevTeamName. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameOver : CCLayer {
	CCLabelTTF *levelLabel;
	CCLabelTTF *trialLabel;
}
+(id) scene;
@end
