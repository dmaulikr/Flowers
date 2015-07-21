//
//  FlowersAppDelegate.h
//  Flowers
//
//  Created by Ryan Fox on 10/2/10.
//  Copyright DevTeamName 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface FlowersAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
