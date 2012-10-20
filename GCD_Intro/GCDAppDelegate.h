//
//  GCDAppDelegate.h
//  GCD_Intro
//
//  Created by Matthew Henderson on 10/20/12.
//  Copyright (c) 2012 Matthew Henderson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GCDViewController;

@interface GCDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) GCDViewController *viewController;

@end
