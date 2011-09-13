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

@implementation BooYaAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize _addressBookArray;
@synthesize _commManager;
@synthesize _deviceToken;
@synthesize _jsonString;

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
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BooYA!" 
                                                        message:[[[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"aps"] objectForKey:@"alert"]
                                                       delegate:self
                                              cancelButtonTitle:@"Nahh" 
                                              otherButtonTitles:@"Back@YA!!!", nil];
        [alert show];
        [alert release];
    }
	
	_commManager = [ConnectionManager sharedManager];
    
	// first user enter need to load the login screen
	
    self._addressBookArray = [[NSMutableArray alloc] init];
    
    //get address booo
    [NSThread detachNewThreadSelector:@selector(loadAddressBook) toTarget:self withObject:nil];
    
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BooYA!" 
                                                    message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] 
                                                   delegate:self
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:@"Back@YA!!!", nil];
    [alert show];
    [alert release];
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
    	CFIndex nPhones = ABMultiValueGetCount(phones);
       
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
            NSMutableDictionary *personDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:(NSString *)phone, kNumber, [NSNumber numberWithBool:NO], kEnrolled, @"", kUsername, nil];
            
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
    
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
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

- (void)dealloc
{
    self._addressBookArray = nil;
    [_window release];
    [_navigationController release];
    [super dealloc];
}

@end
