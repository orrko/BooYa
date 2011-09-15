//
//  BooYaViewController.h
//  BooYa
//
//  Created by נועם מה-יפית on 11/9/11.
//  Copyright 2011 OnO Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BooYaAppDelegate.h"
#import "ConnectionManager.h"
#import "ASIHTTPRequest.h"
#import <MessageUI/MessageUI.h>

@interface BooYaViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ASIHTTPRequestDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>
{
    BooYaAppDelegate *_appDelegate;
    UITableView     *_tableView;
    UILabel *_rankLabel;
    UIImageView *_splashImage;
    NSMutableArray  *_dataSource;
    ConnectionManager *_comManager;
    BOOL    _sendGetUserStat;
    BOOL    _sendCheckEnrolled;
}
@property (nonatomic, retain) IBOutlet UITableView *_tableView;
@property (nonatomic, retain) IBOutlet UILabel *_rankLabel;
@property (nonatomic, retain) IBOutlet UIImageView *_splashImage;

-(void)reloadTableView;
- (IBAction)booYaButtonPushed:(id)sender;
- (IBAction)backButtonPushed:(id)sender;
- (IBAction)filterButtonPushed:(id)sender;

@end
