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

@interface BooYaViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ASIHTTPRequestDelegate>
{
    BooYaAppDelegate *_appDelegate;
    UITableView     *_tableView;
    NSMutableArray  *_dataSource;
    ConnectionManager *_comManager;
}
@property (nonatomic, retain) IBOutlet UITableView *_tableView;

-(void)reloadTableView;
- (IBAction)booYaButtonPushed:(id)sender;
- (IBAction)backButtonPushed:(id)sender;
- (IBAction)filterButtonPushed:(id)sender;

@end
