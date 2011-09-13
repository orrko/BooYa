//
//  BooYaAppDelegate.h
//  BooYa
//
//  Created by נועם מה-יפית on 11/9/11.
//  Copyright 2011 OnO Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionManager.h"
#import "Constants.h"
#import "ASIHTTPRequest.h"

@interface BooYaAppDelegate : NSObject <UIApplicationDelegate, ASIHTTPRequestDelegate>
{
    UIWindow				*window;
    UINavigationController	*navigationController;
    ConnectionManager		*_commManager;
    NSMutableArray			*_addressBookArray;
	
	NSData					*_deviceToken;
	NSString				*_jsonString;
	
	BOOL					_stoppedPressed;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) NSMutableArray *_addressBookArray;
@property (nonatomic, assign) ConnectionManager *_commManager;

@property (nonatomic, retain) NSData			*_deviceToken;
@property (nonatomic, retain) NSString			*_jsonString;

@property (nonatomic, readwrite) BOOL			_stoppedPressed;

-(void)loadAddressBook;
-(void)sendAddressBookToServer:(NSMutableArray *)addressBook;

@end
