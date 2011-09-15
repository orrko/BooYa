//
//  BoardViewController.h
//  BooYa
//
//  Created by Amit Bar-Shai on 9/14/11.
//  Copyright 2011 OnO Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BooYaAppDelegate.h"
#import "ConnectionManager.h"
#import "ASIHTTPRequest.h"


@interface BoardViewController : UIViewController <ASIHTTPRequestDelegate , UITableViewDelegate , UITableViewDataSource> {
	BooYaAppDelegate		*_appDelegate;
	ConnectionManager		*_comManager;
	
	IBOutlet UILabel		*_myRankLabel;
	NSMutableArray			*_dataSource;
	IBOutlet UITableView	*_tableView;
	
	BOOL					_myPepople;
}

@property (nonatomic, retain) NSMutableArray		*_dataSource;
@property (nonatomic, retain) IBOutlet UITableView	*_tableView;

- (IBAction)booYaButtonPushed:(id)sender; 
- (IBAction)backButtonPushed:(id)sender; 

@end
