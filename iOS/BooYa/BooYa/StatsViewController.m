//
//  StatsViewController.m
//  BooYa
//
//  Created by נועם מה-יפית on 14/9/11.
//  Copyright 2011 OnO Apps. All rights reserved.
//

#import "StatsViewController.h"

@implementation StatsViewController
@synthesize _wonSentLabel;
@synthesize _wonReceivedLabel;
@synthesize _myScoreLabel;
@synthesize _myRankingLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _appDelegate = (BooYaAppDelegate *)[[UIApplication sharedApplication] delegate];
        _comManager = [ConnectionManager sharedManager];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   // NSArray *fonts = [UIFont familyNames];
    //NSArray *names = [UIFont fontNamesForFamilyName:@"Myriad Pro"];
    //NSLog(@"%@", names);
    _wonReceivedLabel.font = [UIFont fontWithName:@"SFSlapstickComic-Bold" size:24.0];
    _wonSentLabel.font = [UIFont fontWithName:@"SFSlapstickComic-Bold" size:24.0];
    _myScoreLabel.font = [UIFont fontWithName:@"SFSlapstickComic-Bold" size:24.0];
    _myRankingLabel.font = [UIFont fontWithName:@"SFSlapstickComic-Bold" size:24.0];
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:kPhoneNumber];
    NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:@"getUserStat", @"funcName", username, @"userName", phone, @"phoneNumber", nil];
    
    [_comManager grabURLInBackground:[NSString stringWithFormat:@"%@", kServerURL] andDelegate:self postDict:postDict];
}

- (void)viewDidUnload
{
    [self set_myScoreLabel:nil];
    [self set_myRankingLabel:nil];
    [self set_wonSentLabel:nil];
    [self set_wonReceivedLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)backButtonPushed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)facebookSharePushed:(id)sender {
    if (![_appDelegate._facebook isSessionValid]) {
        [_appDelegate._facebook authorize:nil];
    }
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
    _myRankingLabel.text = [NSString stringWithFormat:@"%d",[[result objectForKey:@"rank"] intValue]];
    _myScoreLabel.text = [NSString stringWithFormat:@"%d",[[result objectForKey:@"score"] intValue]];
    _wonSentLabel.text = [NSString stringWithFormat:@"%d/%d", [[result objectForKey:@"sendWin"] intValue], [[result objectForKey:@"sendTotal"] intValue]];
    _wonReceivedLabel.text = [NSString stringWithFormat:@"%d/%d", [[result objectForKey:@"receiveWin"] intValue], [[result objectForKey:@"receiveTotal"] intValue]];
}

#pragma mark -

- (void)dealloc {
    [_myScoreLabel release];
    [_myRankingLabel release];
    [_wonSentLabel release];
    [_wonReceivedLabel release];
    [super dealloc];
}
@end
