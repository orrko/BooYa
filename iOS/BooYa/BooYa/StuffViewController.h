//
//  StuffViewController.h
//  BooYa
//
//  Created by Amit Bar-Shai on 9/13/11.
//  Copyright 2011 OnO Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BooYaAppDelegate.h"

@interface StuffViewController : UIViewController <UIAlertViewDelegate> {
	
	BooYaAppDelegate		*_appDelegate;
	
	IBOutlet UIImageView	*_bgImageView;
	BOOL					_onResume;
	
}

- (IBAction)backButtonPressed:(UIButton *)bttn;
- (IBAction)screenButtonPressed:(UIButton *)bttn;
//- (IBAction)actionButtonPressed:(UIButton *)bttn;

@end