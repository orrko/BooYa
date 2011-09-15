//
//  BooYaAppDelegate.m
//  BooYa
//
//  Created by נועם מה-יפית on 11/9/11.
//  Copyright 2011 OnO Apps. All rights reserved.
//

#import "BooYaAppDelegate.h"
#import <AddressBook/AddressBook.h>
#import "SBJsonParser.h"
#import "SBJsonWriter.h"
#import "RootViewController.h"

@implementation BooYaAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize _addressBookArray;
@synthesize _commManager;
@synthesize _deviceToken;
@synthesize _jsonString;
@synthesize _stoppedPressed;
@synthesize _facebook;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    
#if !TARGET_IPHONE_SIMULATOR
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | 
																		   UIRemoteNotificationTypeBadge |
																		   UIRemoteNotificationTypeSound)];
	
#endif
	
	if([launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"]){
		if ([[[[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"aps"] objectForKey:@"alert"] rangeOfString:@"joined"].location != NSNotFound) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"A new social player is in town" 
                                                            message:[[[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"aps"] objectForKey:@"alert"]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:@"Lets BooYA! him!!!", nil];
            [alert setTag:1];
            if (_alertUserInfo) {
                [_alertUserInfo release];
                _alertUserInfo = nil;
            }
            _alertUserInfo = [[NSDictionary alloc] initWithDictionary:[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"]];
            [alert show];
            [alert release];
        }
        else
        {
            BOOL typeIsLoud = ([[[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"booYaType"] isEqualToString:@"loud"] ? YES : NO);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:(typeIsLoud ? @"Not so good, not so bad" : @"Oh mama")
                                                            message:(typeIsLoud ? [NSString stringWithFormat:@"Ok, so you've been a good friend and by not responding on time %@ got more points.",[[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"userName"]] : [NSString stringWithFormat:@"Great response, great points.\nAdd __ points to your pile.\nWanna send %@ a BooYA! back??\nYou can do so straight from here - hit the Back@YA! button.",[[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"userName"]] )
                                                           delegate:(typeIsLoud ? nil : self)
                                                  cancelButtonTitle:(typeIsLoud ? @"OK" : @"Nahh") 
                                                  otherButtonTitles:(typeIsLoud ? nil : @"Back@YA!!!"), nil];
            [alert setTag:3];
            if (_alertUserInfo) {
                [_alertUserInfo release];
                _alertUserInfo = nil;
            }
            _alertUserInfo = [[NSDictionary alloc] initWithDictionary:[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"]];
            [alert show];
            [alert release];
        }
		
    }
	
	_commManager = [ConnectionManager sharedManager];
    
    //reset booya's on server
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kPhoneNumber] != nil) {
        [_commManager grabURLInBackground:[NSString stringWithFormat:@"%@", kServerURL] andDelegate:nil postDict:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"catchBooya", @"funcName", [[NSUserDefaults standardUserDefaults] objectForKey:kUserName], @"userName", nil]];
    }
    
	// first user enter need to load the login screen
	
    self._addressBookArray = [[NSMutableArray alloc] init];
    
    //get address booo
    [NSThread detachNewThreadSelector:@selector(loadAddressBook) toTarget:self withObject:nil];
    
    _facebook = [[Facebook alloc] initWithAppId:@"190714141001784" andDelegate:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        _facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        _facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark -
#pragma mark deviceToken

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken { 
	
	self._deviceToken = [[NSData alloc] initWithData:deviceToken];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err { 
	
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"did fail to register %@",str);    
	
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	NSLog(@"%@", userInfo);
    if ([[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] rangeOfString:@"joined"].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"A new social player is in town" 
                                                        message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] 
                                                       delegate:self
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:@"Lets BooYA! him!!!", nil];
        [alert setTag:1];
        if (_alertUserInfo) {
            [_alertUserInfo release];
            _alertUserInfo = nil;
        }
        _alertUserInfo = [[NSDictionary alloc] initWithDictionary:userInfo];
        [alert show];
        [alert release];
    }
    else
    {
        //sound file for the push
        if (_player != nil) {
            [_player release];
            _player = nil;
        }
        NSString *pathForSoundFile = [[NSBundle mainBundle] pathForResource:[[(NSString *)[[userInfo objectForKey:@"aps"] objectForKey:@"sound"] componentsSeparatedByString:@"."]objectAtIndex:0] ofType:@"wav"];
        NSURL *soundFile = [[NSURL alloc] initFileURLWithPath:pathForSoundFile];
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFile error:NULL];
        [soundFile release];
        //set loop one time
        [_player setNumberOfLoops:0];
        [_player prepareToPlay];
        [_player play];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                        message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
                                                       delegate:self
                                              cancelButtonTitle:nil 
                                              otherButtonTitles:@"Awesome", nil];
        [alert setTag:4];
        if (_alertUserInfo) {
            [_alertUserInfo release];
            _alertUserInfo = nil;
        }
        _alertUserInfo = [[NSDictionary alloc] initWithDictionary:userInfo];
        [alert show];
        [alert release];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:kPhoneNumber] != nil) {
            [_commManager grabURLInBackground:[NSString stringWithFormat:@"%@", kServerURL] andDelegate:nil postDict:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"catchBooya", @"funcName", [[NSUserDefaults standardUserDefaults] objectForKey:kUserName], @"userName", nil]];
        }
    }
}

#pragma mark -
#pragma mark alert view
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0) {
        if (alertView.tag == 1) {//user pushed on the "joined" alert
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ will never see it comin'", [_alertUserInfo objectForKey:@"userName"]] 
                                                            message:[NSString stringWithFormat:@"Hit the BooYA! button and hope that %@ is a snoozer (so you will get points) and not a sharpie (then you are in deep sh@!%$\").", [_alertUserInfo objectForKey:@"userName"]] 
                                                           delegate:self
                                                  cancelButtonTitle:@"Nahh" 
                                                  otherButtonTitles:@"BooYA!", nil];
            [alert setTag:2];
            [alert show];
            [alert release];
        }
        else if(alertView.tag == 2)//user pushed BooYA!
        {
            //send BooYa
            NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:@"sendBooYaMessage", @"funcName", @"userName", @"idTypeSrc", [[NSUserDefaults standardUserDefaults] objectForKey:kUserName], @"idStrSrc", @"userName", @"idTypeTarget", [_alertUserInfo objectForKey:@"userName"], @"idStrTarget", @"", @"booYaId", nil];
            
            [_commManager grabURLInBackground:[NSString stringWithFormat:@"%@", kServerURL] andDelegate:self postDict:postDict];
            
            [(RootViewController *)[[navigationController viewControllers] objectAtIndex:0] startSplashBooYa];
            [_alertUserInfo release];
            _alertUserInfo = nil;
        }
        else if(alertView.tag == 3){//user pushed Back@YA
            //send BooYa
            NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:@"sendBooYaMessage", @"funcName", @"userName", @"idTypeSrc", [[NSUserDefaults standardUserDefaults] objectForKey:kUserName], @"idStrSrc", @"userName", @"idTypeTarget", [_alertUserInfo objectForKey:@"userName"], @"idStrTarget", [_alertUserInfo objectForKey:@"booYaId"], @"booYaId", nil];
            
            [_commManager grabURLInBackground:[NSString stringWithFormat:@"%@", kServerURL] andDelegate:self postDict:postDict];
            
            [(RootViewController *)[[navigationController viewControllers] objectAtIndex:0] startSplashBooYa];
            [_alertUserInfo release];
            _alertUserInfo = nil;
        }
        else if(alertView.tag == 4){//user got push in app and pushed response
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oh mama"
//                                                            message:[NSString stringWithFormat:@"Great response, great points.\nAdd %@ points to your pile.\nWanna send %@ a BooYA! back??\nYou can do so straight from here - hit the Back@YA! button.", [_alertUserInfo objectForKey:@"score"], [_alertUserInfo objectForKey:@"userName"]]
//                                                           delegate:self
//                                                  cancelButtonTitle:@"Nahh" 
//                                                  otherButtonTitles:@"Back@YA!!!", nil];
//            [alert setTag:3];
//            [alert show];
//            [alert release];
        }
    }
    else if(buttonIndex == 0)
    {
       // [_alertUserInfo release];
       // _alertUserInfo = nil;
        
        if (alertView.tag == 4) {//user got push in app and pushed refuse
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oh mama"
                                                            message:[NSString stringWithFormat:@"Great response, great points.\nAdd %@ points to your pile.\nWanna send %@ a BooYA! back??\nYou can do so straight from here - hit the Back@YA! button.", [_alertUserInfo objectForKey:@"score"], [_alertUserInfo objectForKey:@"userName"]]
                                                           delegate:self
                                                  cancelButtonTitle:@"Nahh" 
                                                  otherButtonTitles:@"Back@YA!!!", nil];
            [alert setTag:3];
            [alert show];
            [alert release];
        }
    }
}

-(void)alertViewCancel:(UIAlertView *)alertView
{
   // [_alertUserInfo release];
   // _alertUserInfo = nil;
}

#pragma mark -
#pragma mark AddressBook

-(void)loadAddressBook
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    NSArray *persons = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    for (id person in persons) {
    	ABMultiValueRef phones = ABRecordCopyValue((ABRecordRef)person,kABPersonPhoneProperty);
        ABMultiValueRef emails = ABRecordCopyValue((ABRecordRef)person, kABPersonEmailProperty);
    	CFIndex nPhones = ABMultiValueGetCount(phones);
        CFIndex nEmails = ABMultiValueGetCount(emails);
       
        if (nPhones == 0) {
    		ABAddressBookRemoveRecord(addressBook, person, NULL);
    	}
    	else {
            CFStringRef phone = nil;
    		for (int j = 0; j < nPhones; j++) {
                if([(NSString *)ABMultiValueCopyLabelAtIndex(phones, j) isEqualToString:@"_$!<Mobile>!$_"]) {
                    phone = ABMultiValueCopyValueAtIndex(phones, j);
                    break;
                }
    		}
            if (phone == nil) {
                ABAddressBookRemoveRecord(addressBook, person, NULL);
                continue;
            }
           
            NSMutableDictionary *personDict = nil;
             CFStringRef email = nil;
            if (nEmails > 0) {
                email = ABMultiValueCopyValueAtIndex(emails, 0);
                
                personDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:(NSString *)phone, kNumber, [NSNumber numberWithBool:NO], kEnrolled, @"", kUsername, (NSString *)email, kEmail, nil];
            }
            else
            {
                personDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:(NSString *)phone, kNumber, [NSNumber numberWithBool:NO], kEnrolled, @"", kUsername, nil];
            }
            
            
            
            NSString *personName = nil;
            if (ABRecordCopyValue((ABRecordRef)person,kABPersonFirstNameProperty) == nil) {
                personName = [NSString stringWithFormat:@"%@", ABRecordCopyValue((ABRecordRef)person,kABPersonLastNameProperty)];
            }
            else if (ABRecordCopyValue((ABRecordRef)person,kABPersonLastNameProperty) == nil) {
                personName = [NSString stringWithFormat:@"%@", ABRecordCopyValue((ABRecordRef)person,kABPersonFirstNameProperty)];
            }
            else {
                personName = [NSString stringWithFormat:@"%@ %@", ABRecordCopyValue((ABRecordRef)person,kABPersonFirstNameProperty), ABRecordCopyValue((ABRecordRef)person,kABPersonLastNameProperty)];
            }
            [self._addressBookArray addObject:[NSMutableDictionary dictionaryWithObject:personDict forKey:personName]];
            
    	}
    }
    [persons release];
    
    [self performSelectorOnMainThread:@selector(sendAddressBookToServer:) withObject:self._addressBookArray waitUntilDone:NO];
    
    
    [pool drain];
}

-(void)sendAddressBookToServer:(NSMutableArray *)addressBook
{
    //create array of numbers
    NSMutableArray *numbers = [NSMutableArray array];
    for (NSMutableDictionary *person in self._addressBookArray) {
        NSString *key = [[person allKeys] objectAtIndex:0];
        NSString *personNumber = [[person objectForKey:key] objectForKey:kNumber];
        [numbers addObject:personNumber];
    }
    SBJsonWriter *string = [[SBJsonWriter alloc] init];
    self._jsonString = [string stringWithObject:numbers];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserRegisterd] != nil) {
        [_commManager grabURLInBackground:[NSString stringWithFormat:@"%@", kServerURL] andDelegate:self postDict:[NSMutableDictionary dictionaryWithObjectsAndKeys:self._jsonString, @"list", @"checkEnrolled", @"funcName", nil]];
    }
    [string release];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    if([[[request userInfo] objectForKey:@"funcName"] isEqualToString:@"sendBooYaMessage"]){
        [(RootViewController *)[[navigationController viewControllers] objectAtIndex:0] stopSplashBooYa];
    }
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    if ([[[request userInfo] objectForKey:@"funcName"] isEqualToString:@"checkEnrolled"]) {
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSMutableDictionary *response = [jsonParser objectWithString:[request responseString]];
        
        int i = 0;
        for (NSMutableDictionary *person in [response objectForKey:@"data"]) {
            @synchronized(self)
            {
                NSString *key = [[[self._addressBookArray objectAtIndex:i] allKeys] objectAtIndex:0];
                NSString *number = [[[self._addressBookArray objectAtIndex:i] objectForKey:key] objectForKey:kNumber];
                if ([number isEqualToString:[person objectForKey:@"phoneNum"]]) {
                    [[[self._addressBookArray objectAtIndex:i] objectForKey:key] setObject:[person objectForKey:@"enrolled"] forKey:kEnrolled];
                    [[[self._addressBookArray objectAtIndex:i] objectForKey:key] setObject:[person objectForKey:@"userName"] forKey:kUsername];
                    [[[self._addressBookArray objectAtIndex:i] objectForKey:key] setObject:[person objectForKey:@"rank"] forKey:kRank];
                }
                i++;
            }
        }
        
        //sort
        [self._addressBookArray sortUsingComparator:(NSComparator)^(NSDictionary *obj1, NSDictionary *obj2){
            NSString *name1 = [[obj1 allKeys] objectAtIndex:0];
            NSString *name2 = [[obj2 allKeys] objectAtIndex:0];
            return [name1 caseInsensitiveCompare:name2]; }];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kGotAddressBookFromServerNotification object:nil];
    }
    else if([[[request userInfo] objectForKey:@"funcName"] isEqualToString:@"sendBooYaMessage"]){
        [(RootViewController *)[[navigationController viewControllers] objectAtIndex:0] stopSplashBooYa];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WooHoo!" 
                                                        message:@"BooYA! sent"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
}

#pragma mark -
#pragma mark UIApplicationDelegate

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return [_facebook handleOpenURL:url]; 
}

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[_facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[_facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    [self sendPostToFacebook];
    
}

-(void)sendPostToFacebook
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"190714141001784", @"app_id",
                                   @"http://developers.facebook.com/docs/reference/dialogs/", @"link",
                                   @"http://www.onoapps.com/images/BooYA_FB_Image.png", @"picture",
                                   @"BooYA! for iOS and Android", @"name",
                                   [NSString stringWithFormat:@"This is my score %@ and I'm ranked %@.", @"", @""], @"caption",
                                   @"Dialogs provide a simple, consistent interface for apps to interact with users.", @"description",
                                   nil];
    
    [_facebook dialog:@"feed" andParams:params andDelegate:self];
}

- (void)dealloc
{
    if (_player) {
        [_player release];
        _player = nil;
    }
    if (_alertUserInfo) {
        [_alertUserInfo release];
        _alertUserInfo = nil;
    }
    self._addressBookArray = nil;
    [_window release];
    [_navigationController release];
    [super dealloc];
}

@end
