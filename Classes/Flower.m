//
//  Flower.m
//  FlowersTest
//
//  Created by Ryan Fox on 10/2/10.
//  Copyright 2010 DevTeamName. All rights reserved.
//

#import "Flower.h"


@implementation Flower
@synthesize isGood;
-(CGFloat) width
{
    return [self boundingBox].size.width;
}

-(CGFloat) height
{
    return [self boundingBox].size.height;
}
@end
