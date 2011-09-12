//
//  ConnectionManager.m
//  Onset
//
//  Created by Noam Ma-Yafit on 02/09/10.
//  Copyright 2010 OnO Apps. All rights reserved.
//

#import "ConnectionManager.h"
#import "JSON.h"

static ConnectionManager *sharedConnectionManager = nil;

@implementation ConnectionManager

@synthesize delegate;

#pragma mark Singleton Methods
+ (id)sharedManager {
	@synchronized(self) {
		if(sharedConnectionManager == nil)
		{
			[[self alloc] init];
		}
		
	}
	return sharedConnectionManager;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if(sharedConnectionManager == nil)  {
			sharedConnectionManager = [super allocWithZone:zone];
			return sharedConnectionManager;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (id)retain {
	return self;
}

- (unsigned)retainCount {
	return UINT_MAX; //denotes an object that cannot be released
}

- (void)release {
	// never release
}

- (id)autorelease {
	return self;
}

#pragma mark -
#pragma mark ASIHTTP 
//Connection to server
- (void)grabURLInBackground:(NSString *)urlString andDelegate:(id)dlg postDict:(NSDictionary *)postDict
{
	NSLog(@"%@",urlString);
	
	if (!_queue) {
		_queue = [[ASINetworkQueue alloc] init];
	}
	NSURL *url = [NSURL URLWithString:urlString];
	ASIFormDataRequest *_request = [ASIFormDataRequest requestWithURL:url];
    for (NSString *key in postDict) {
        [_request setPostValue:[postDict objectForKey:key] forKey:key];
    }
    
	[_request setTimeOutSeconds:30];
	
    [_request setDelegate:dlg];
	//[_request startAsynchronous];
	[_queue addOperation:_request]; //queue is an NSOperationQueue
	[_queue go];
	
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
	NSLog(@"response from server: %@",[request responseString]);
	
    //this will redirect to the login view controller for now
    [self.delegate requestFinished:request];
	
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSLog(@"%@",request.error);
	//if code = 4 = request cancelled then don't do anything
	/*if ([error code] != 4) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"System error" 
														message:@"Try again later" 
													   delegate:nil
											  cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}*/	
	
	[self.delegate requestFailed:request];
}

- (void)stopConnection
{
	for (ASIHTTPRequest *operation in [_queue operations]) {
		[operation setDelegate:nil];
		[operation cancel];
	}
	[_queue cancelAllOperations];
}

@end
