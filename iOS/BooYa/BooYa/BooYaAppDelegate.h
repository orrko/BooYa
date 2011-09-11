//
//  BooYaAppDelegate.h
//  BooYa
//
//  Created by נועם מה-יפית on 11/9/11.
//  Copyright 2011 OnO Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BooYaViewController;

@interface BooYaAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet BooYaViewController *viewController;

@end
