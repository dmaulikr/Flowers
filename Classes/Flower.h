//
//  Flower.h
//  FlowersTest
//
//  Created by Ryan Fox on 10/2/10.
//  Copyright 2010 DevTeamName. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Flower : CCSprite {
	bool isGood;
}
@property (nonatomic) bool isGood;
-(CGFloat)width;
-(CGFloat)height;
@end
