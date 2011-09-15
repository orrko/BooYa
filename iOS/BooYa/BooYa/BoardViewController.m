//
//  BoardViewController.m
//  BooYa
//
//  Created by Amit Bar-Shai on 9/14/11.
//  Copyright 2011 OnO Apps. All rights reserved.
//

#import "BoardViewController.h"
#import "Constants.h"
#import "BoardCellView.h"
#import "SBJsonParser.h"
#import "User.h"

@implementation BoardViewController

@synthesize _dataSource;
@synthesize _tableView;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		_appDelegate = (BooYaAppDelegate *)[[UIApplication sharedApplication] delegate];
        _comManager = [ConnectionManager sharedManager];
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	
	[super viewWillAppear:animated];
	
	NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:kPhoneNumber];
    
	// get rank
	NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:@"getUserStat", @"funcName", username, @"userName", phone, @"phoneNumber", nil];
	[_comManager grabURLInBackground:[NSString stringWithFormat:@"%@", kServerURL] andDelegate:self postDict:postDict];
	
	// get the leader board
	postDict = [NSDictionary dictionaryWithObjectsAndKeys:@"getLeaderBoard", @"funcName", nil];
    [_comManager grabURLInBackground:[NSString stringWithFormat:@"%@", kServerURL] andDelegate:self postDict:postDict];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark Table view data source
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (BoardCellView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = (BoardCellView *)[[[NSBundle mainBundle] loadNibNamed:@"BoardCellView" owner:self options:nil] objectAtIndex:0];
    }
    
	User *curUser = (User *)[_dataSource objectAtIndex:indexPath.row];
	[[(BoardCellView *)cell _rankLabel] setText:curUser._userRank];
	[[(BoardCellView *)cell _userNameLabel] setText:curUser._userName];
	
	// if I have this phone number in my list
	if (curUser._userPhoneNumber) {
		[[(BoardCellView *)cell _BooYaButton] setTitle:@"BooYa" forState:UIControlStateNormal];
		[[(BoardCellView *)cell _BooYaButton] setEnabled:YES];
	}
	else {
		[[(BoardCellView *)cell _BooYaButton] setTitle:@"UnKnown" forState:UIControlStateNormal];
		[[(BoardCellView *)cell _BooYaButton] setEnabled:NO];
	}

	[[(BoardCellView *)cell _BooYaButton] setTag:indexPath.row];	
    
    // Configure the cell.
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete)
 {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert)
 {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark -
#pragma mark Table view delegates
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (IBAction)booYaButtonPushed:(id)sender 
{
    UIButton *button = (UIButton *)sender;
    int index = button.tag;
    
	if([[button titleForState:UIControlStateNormal] isEqualToString:@"BooYa"])
	{
        //send BooYa
        User *curUser = [_dataSource objectAtIndex:index];
        NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:@"sendBooYaMessage", @"funcName", @"phoneNumber", @"idTypeSrc", [[NSUserDefaults standardUserDefaults] objectForKey:kPhoneNumber], @"idStrSrc", @"phoneNumber", @"idTypeTarget", curUser._userPhoneNumber, @"idStrTarget", @"", @"booYaId", nil];
        
        [_comManager grabURLInBackground:[NSString stringWithFormat:@"%@", kServerURL] andDelegate:self postDict:postDict];
        
    }
}

#pragma mark -
#pragma mark Sort button

- (IBAction)filterButtonPushed:(id)sender {
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 0://My pepole
			
            for (int i = 0; i < [_dataSource count]; i++) 
			{
				// if the user don't have phone number then he is not one of my pepole - REMOVE IT
				if (![(User *)[_dataSource objectAtIndex:i] _userPhoneNumber]) {
					[_dataSource removeObjectAtIndex:i];
				}
			}
			
            break;
        case 1://invitees
            if (_dataSource) {
                [_dataSource release];
            }
            _dataSource = [[NSMutableArray alloc] init];
            for (NSDictionary *person in _appDelegate._addressBookArray) {
                if ([[person objectForKey:[[person allKeys] objectAtIndex:0]] objectForKey:kEnrolled] == [NSNumber numberWithBool:NO]) {
                    [_dataSource addObject:person];
                }
            }
            break;
        case 2://all
            if (_dataSource) {
                [_dataSource release];
            }
            _dataSource = [[NSMutableArray alloc] initWithArray:_appDelegate._addressBookArray];
            break;
    }
    
    [_tableView reloadData];
}

#pragma mark -
#pragma mark Back button

- (IBAction)backButtonPushed:(id)sender {
    
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark ASIHTTPRequest
-(void)requestFailed:(ASIHTTPRequest *)request
{
    
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
	NSLog(@"%@", [request responseString]);
	SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
	NSDictionary *result = [jsonParser objectWithString:[request responseString]];
	
	if ([[[request userInfo] objectForKey:@"funcName"] isEqualToString:@"getUserStat"]) 
	{
		_myRankLabel.text = [NSString stringWithFormat:@"%@", [result objectForKey:@"rank"]];
	}
	else if ([[[request userInfo] objectForKey:@"funcName"] isEqualToString:@"getLeaderBoard"]) 
	{
		BOOL foundAFriend;
		
		if (_dataSource) {
			[_dataSource removeAllObjects];
			[_dataSource release];
			_dataSource = nil;
		}
		_dataSource = [[NSMutableArray alloc] init];
		
		for (NSMutableDictionary *person in [result objectForKey:@"data"]) 
		{
			User *curUser = [[User alloc] init];
			curUser._userName = [person objectForKey:@"userName"];
			curUser._userRank = [person objectForKey:@"score"];
			
			// check if this person phone number matches to one of yours
			foundAFriend = NO;
			for (int i = 0; i < [_appDelegate._addressBookArray count]; i++) 
			{
				NSString *key = [[[_appDelegate._addressBookArray objectAtIndex:i] allKeys] objectAtIndex:0];
				NSString *number = [[[_appDelegate._addressBookArray objectAtIndex:i] objectForKey:key] objectForKey:kNumber];
				// if he is my friend save it's phone number - to BooYA him later
				if ([number isEqualToString:[person objectForKey:@"phoneNumOrg"]]) 
				{
					curUser._userPhoneNumber = number;
					foundAFriend = YES;
				}
				if (foundAFriend) {
					break;
				}
			}
			if (!foundAFriend) {
				curUser._userPhoneNumber = nil;
			}
			[_dataSource addObject:curUser];
			[curUser release];
		}
		
		//sort
		[_dataSource sortUsingComparator:(NSComparator)^(User *obj1, User *obj2)
		{
			if ([obj1._userRank intValue] < [obj2._userRank intValue]) 
			{
				return (NSComparisonResult)NSOrderedDescending;
			}
			
			else if ([obj1._userRank intValue] > [obj2._userRank intValue]) 
			{
				return (NSComparisonResult)NSOrderedAscending;
			}
			else {
				return (NSComparisonResult)NSOrderedSame;
			}
		}];
		
		[_tableView reloadData];
	}
	if ([[[request userInfo] objectForKey:@"funcName"] isEqualToString:@"sendBooYaMessage"]) 
	{
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
#pragma mark Memory managment

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
