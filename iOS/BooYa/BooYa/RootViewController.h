//
//  RootViewController.h
//  BooYa
//
//  Created by נועם מה-יפית on 11/9/11.
//  Copyright 2011 OnO Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BooYaAppDelegate.h"
#import "LoginViewController.h"

@interface RootViewController : UIViewController <UIAlertViewDelegate , LoginProtocol>
{
    BooYaAppDelegate		*_appDelegate;
	LoginViewController		*_loginVC;
    UIImageView *_splashBooYaImage;
}

@property (nonatomic, retain) IBOutlet UIImageView *_splashBooYaImage;

- (void)loadLoginView;
- (IBAction)buttonPushed:(id)sender;
- (void)startSplashBooYa;
- (void)stopSplashBooYa;

@end
