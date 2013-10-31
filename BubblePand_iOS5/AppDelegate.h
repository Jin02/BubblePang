//
//  AppDelegate.h
//  BubblePand_iOS5
//
//  Created by Jin Park on 11. 10. 20..
//  Copyright __MyCompanyName__ 2011년. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
