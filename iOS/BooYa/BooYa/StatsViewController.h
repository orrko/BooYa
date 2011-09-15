//
//  StatsViewController.h
//  BooYa
//
//  Created by נועם מה-יפית on 14/9/11.
//  Copyright 2011 OnO Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "BooYaAppDelegate.h"
#import "ConnectionManager.h"
#import "ASIHTTPRequest.h"

@interface StatsViewController : UIViewController <ASIHTTPRequestDelegate>{
    BooYaAppDelegate *_appDelegate;
    UILabel *_myScoreLabel;
    UILabel *_myRankingLabel;
    UILabel *_wonSentLabel;
    UILabel *_wonReceivedLabel;
    ConnectionManager *_comManager;
}


@property (nonatomic, retain) IBOutlet UILabel *_myScoreLabel;
@property (nonatomic, retain) IBOutlet UILabel *_myRankingLabel;
@property (nonatomic, retain) IBOutlet UILabel *_wonSentLabel;
@property (nonatomic, retain) IBOutlet UILabel *_wonReceivedLabel;

- (IBAction)backButtonPushed:(id)sender;
- (IBAction)facebookSharePushed:(id)sender;

@end
