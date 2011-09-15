//
//  Constants.h
//  BooYa
//
//  Created by נועם מה-יפית on 11/9/11.
//  Copyright 2011 OnO Apps. All rights reserved.
//

#define kServerURL @"http://booya.r4r.co.il/ajax.php"

//notifications
#define kGotAddressBookFromServerNotification @"gotAddressBookFromServerNotification"
//keys
#define kUsername @"username"
#define kEnrolled @"enrolled"
#define kNumber @"number"
#define kEmail @"email"
#define kRank @"rank"

#define kUserRegisterd @"UserRegisterd"
#define kUserName @"userName"
#define kPhoneNumber @"phoneNumber"

typedef enum {
	kPauseOrResume = 1,	
	kStop,
	kPoints,
	kInfo
}kButtonTag;

typedef enum {
	kPauseBG = 1,	
	kResumeBG,
	kStopBG,
	kPointsBG,
	kInfoBG
}kBGTag;