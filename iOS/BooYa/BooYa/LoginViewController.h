//
//  LoginViewController.h
//  BooYa
//
//  Created by Amit Bar-Shai on 9/12/11.
//  Copyright 2011 OnO Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BooYaAppDelegate.h"
#import "ASIHTTPRequest.h"

@protocol LoginProtocol

-(void)loginDismiss;

@end

@interface LoginViewController : UIViewController <UITextFieldDelegate , ASIHTTPRequestDelegate> {
	
	BooYaAppDelegate *_appDelegate;
	
	id<LoginProtocol> delegate;
	
	IBOutlet UITextField	*_phoneNumberTxtFld;
	IBOutlet UITextField	*_userNameTxtFld;
	IBOutlet UIImageView	*_bgImageView;
	
	IBOutlet UIButton		*_goForItButton;

}

@property (nonatomic, assign) id<LoginProtocol> delegate;

- (BOOL) validateCountryCode: (NSString *) candidate;
- (void)loginBGAndTxtFldGoUp:(BOOL)up byNumOfRows:(CGFloat)numOfRows;
- (IBAction)goForItButtonPressed:(UIButton *)bttn;

@end
