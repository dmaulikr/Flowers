//
//  HelloWorldLayer.h
//  Flowers
//
//  Created by Ryan Fox on 10/2/10.
//  Copyright DevTeamName 2010. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorld Layer
@interface MainMenu : CCLayer <UIAlertViewDelegate>
{
	CCLabelTTF *highLabel;
}

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;

@end
