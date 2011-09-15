//
//  User.m
//  BooYa
//
//  Created by Amit Bar-Shai on 9/14/11.
//  Copyright 2011 OnO Apps. All rights reserved.
//

#import "User.h"


@implementation User

@synthesize _userName;
@synthesize _userRank;
@synthesize _userPhoneNumber;
//@synthesize _canBooYAHim;

- (void) dealloc
{
	
	self._userName = nil;
	self._userRank = nil;
	self._userPhoneNumber = nil;
	
	[super dealloc];
	
}

@end
