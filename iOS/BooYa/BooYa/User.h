//
//  User.h
//  BooYa
//
//  Created by Amit Bar-Shai on 9/14/11.
//  Copyright 2011 OnO Apps. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface User : NSObject {
	NSString	*_userName;
	NSString	*_userRank;
	NSString	*_userPhoneNumber;
//	BOOL		_canBooYAHim;
}

@property (nonatomic, retain) NSString *_userName;
@property (nonatomic, retain) NSString *_userRank;
@property (nonatomic, retain) NSString *_userPhoneNumber;
//@property (nonatomic, readwrite) BOOL _canBooYAHim;

@end
