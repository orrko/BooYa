//
//  BooYaViewController.m
//  BooYa
//
//  Created by נועם מה-יפית on 11/9/11.
//  Copyright 2011 OnO Apps. All rights reserved.
//

#import "BooYaViewController.h"
#import "Constants.h"
#import "BooYaCellView.h"
#import "SBJsonParser.h"

@implementation BooYaViewController
@synthesize _tableView;
@synthesize _rankLabel;
@synthesize _splashImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _appDelegate = (BooYaAppDelegate *)[[UIApplication sharedApplication] delegate];
        _comManager = [ConnectionManager sharedManager];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:kGotAddressBookFromServerNotification object:nil];
        _dataSource = [[NSMutableArray alloc] initWithArray:_appDelegate._addressBookArray];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Check rank
    _rankLabel.font = [UIFont fontWithName:@"SFSlapstickComic-Bold" size:22.0];
    
    _sendGetUserStat = YES;
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:kPhoneNumber];
    NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:@"getUserStat", @"funcName", username, @"userName", phone, @"phoneNumber",nil];
    
    [_comManager grabURLInBackground:[NSString stringWithFormat:@"%@", kServerURL] andDelegate:self postDict:postDict];
    
    NSMutableArray *splashAnimationArray = [NSMutableArray array];
    for (int i = 1; i <= 20; i++) {
        [splashAnimationArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"BooYA_%d.png", i]]];
    }
    for (int i = 1; i <= 20; i++) {
        [splashAnimationArray addObject:[UIImage imageNamed:@"BooYA_20.png"]];
    }
    [_splashImage setAnimationImages:splashAnimationArray];
    [_splashImage setAnimationDuration:[splashAnimationArray count]*1/30];
    [_splashImage setAnimationRepeatCount:1000];
}

-(void)reloadTableView
{
    [_tableView reloadData];
}

- (IBAction)booYaButtonPushed:(id)sender {
    UIButton *button = (UIButton *)sender;
    int index = button.tag;
    
    if ([[button titleForState:UIControlStateNormal] isEqualToString:@"Invite"]) {
        //send invitation
        if ([MFMessageComposeViewController canSendText]) { //we have the ability to send sms
            NSDictionary *person = [_dataSource objectAtIndex:index];
            NSString *key = [[person allKeys] objectAtIndex:0];
            
            MFMessageComposeViewController *sms = [[MFMessageComposeViewController alloc] init];
            [sms setMessageComposeDelegate:self];
            [sms setBody:@"Hi, have you ever heard someone saying \"I'm having too much fun\"? BooYA! is one FUN-tastic app: www.itunes....."];
            [sms setRecipients:[NSArray arrayWithObject:[[person objectForKey:key] objectForKey:kNumber]]];
            [self presentModalViewController:sms animated:YES];
            [sms release];
        }
        else //send email
        {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't send SMS on this device" 
                                                             message:nil 
                                                            delegate:nil 
                                                   cancelButtonTitle:@"OK" 
                                                   otherButtonTitles:nil];
             [alert show];
             [alert release];
        }
    }
    else if([[button titleForState:UIControlStateNormal] isEqualToString:@"BooYa"]){
        //send BooYa
        _sendCheckEnrolled = YES;
        NSDictionary *person = [_dataSource objectAtIndex:index];
        NSDictionary *key = [[person allKeys] objectAtIndex:0];
        NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:@"sendBooYaMessage", @"funcName", @"phoneNumber", @"idTypeSrc", [[NSUserDefaults standardUserDefaults] objectForKey:kPhoneNumber], @"idStrSrc", @"phoneNumber", @"idTypeTarget", [[person objectForKey:key] objectForKey:kNumber], @"idStrTarget", @"", @"booYaId", nil];
        
        [_comManager grabURLInBackground:[NSString stringWithFormat:@"%@", kServerURL] andDelegate:self postDict:postDict];
        
        _splashImage.hidden = NO;
        [_splashImage startAnimating];
        
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	NSString *message = nil;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			message = @"Result: canceled";
			break;
		case MFMailComposeResultSaved:
			message = @"Result: saved";
			break;
		case MFMailComposeResultSent:
			message = @"Result: sent";
			break;
		case MFMailComposeResultFailed:
			message = @"Result: failed";
			break;
		default:
			message = @"Result: not sent";
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)backButtonPushed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)filterButtonPushed:(id)sender {
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 0://booya
            if (_dataSource) {
                [_dataSource release];
            }
            _dataSource = [[NSMutableArray alloc] init];
            for (NSDictionary *person in _appDelegate._addressBookArray) {
                if ([[person objectForKey:[[person allKeys] objectAtIndex:0]] objectForKey:kEnrolled] == [NSNumber numberWithBool:YES]) {
                    [_dataSource addObject:person];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (BooYaCellView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = (BooYaCellView *)[[[NSBundle mainBundle] loadNibNamed:@"BooYaCellView" owner:self options:nil] objectAtIndex:0];
    }

    NSDictionary *person = [_dataSource objectAtIndex:indexPath.row];
    NSString *key = [[person allKeys] objectAtIndex:0];
    
    [(BooYaCellView *)cell _nameLabel].text = key;
    [(BooYaCellView *)cell _nameLabel].font = [UIFont fontWithName:@"MyriadPro-Bold" size:15];
    if ([[[person objectForKey:key] objectForKey:kRank] intValue] == -1) {
        [(BooYaCellView *)cell _rankLabel].text = @"";
    }
    else
    {
        [(BooYaCellView *)cell _rankLabel].text = [NSString stringWithFormat:@"%d", [[[person objectForKey:key] objectForKey:kRank] intValue]];
    }
    
    [(BooYaCellView *)cell _rankLabel].font = [UIFont fontWithName:@"SFSlapstickComic-Bold" size:17];
    
    if ([[person objectForKey:key] objectForKey:kEnrolled] == [NSNumber numberWithBool:YES]) {
        [[(BooYaCellView *)cell _BooYaButton] setTitle:@"BooYa" forState:UIControlStateNormal];
        [[(BooYaCellView *)cell _BooYaButton] setImage:[UIImage imageNamed:@"BooYAIcon.png"] forState:UIControlStateNormal];
    }
    else
    {
        [[(BooYaCellView *)cell _BooYaButton] setTitle:@"Invite" forState:UIControlStateNormal];
        [[(BooYaCellView *)cell _BooYaButton] setImage:[UIImage imageNamed:@"InviteIcon.png"] forState:UIControlStateNormal];
    }
    [[(BooYaCellView *)cell _BooYaButton] setTag:indexPath.row];
    
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

#pragma mark -
#pragma mark ASIHTTPRequest
-(void)requestFailed:(ASIHTTPRequest *)request
{
    
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%@", [request responseString]);
    if (_sendCheckEnrolled) {
        _sendCheckEnrolled = NO;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WooHoo!" 
                                                        message:@"BooYA! sent"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        _splashImage.hidden = YES;
        [_splashImage stopAnimating];
    }
    else if(_sendGetUserStat)
    {
        _sendGetUserStat = NO;
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *result = [jsonParser objectWithString:[request responseString]];
        _rankLabel.text = [NSString stringWithFormat:@"%@", [result objectForKey:@"rank"]];
        
    }
    
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [self set_tableView:nil];
    [self set_rankLabel:nil];
    [self set_splashImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
   // return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (void)dealloc {
    [_dataSource release];
    [_tableView release];
    [_rankLabel release];
    [_splashImage release];
    [super dealloc];
}
@end
