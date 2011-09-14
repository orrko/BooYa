//
//  LoginViewController.m
//  BooYa
//
//  Created by Amit Bar-Shai on 9/12/11.
//  Copyright 2011 OnO Apps. All rights reserved.
//

#import "ConnectionManager.h"
#import "SBJsonParser.h"
#import "SBJsonWriter.h"

#import "LoginViewController.h"
#import "Constants.h"

@implementation LoginViewController

@synthesize delegate;

#pragma mark -
#pragma mark View life cycle

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		_appDelegate = (BooYaAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// the user pressed stop game - so present it's saved registration details
	if (_appDelegate._stoppedPressed) 
	{
		_userNameTxtFld.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUsername];
		_phoneNumberTxtFld.text =  [[NSUserDefaults standardUserDefaults] objectForKey:kPhoneNumber];
		_userNameTxtFld.clearButtonMode = UITextFieldViewModeWhileEditing;
		_phoneNumberTxtFld.clearButtonMode = UITextFieldViewModeWhileEditing;
		
		[_userNameTxtFld becomeFirstResponder];
	}
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	[self loginBGAndTxtFldGoUp:YES byNumOfRows:1];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	
	[self loginBGAndTxtFldGoUp:NO byNumOfRows:0];
	
	NSLog(@"in textFieldShouldReturn");
	
	if (!_userNameTxtFld | [_userNameTxtFld.text isEqualToString:@""]) {
		NSLog(@"You didn't enter any user name!");
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Register Screen" 
														message:@"You didn't enter user name" 
													   delegate:nil
											  cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else if (![self validateCountryCode:_phoneNumberTxtFld.text]) {
		NSLog(@"You entered invalid number!");
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Register Screen" 
														message:@"You entered invalid number" 
													   delegate:nil
											  cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else {
		[textField resignFirstResponder];
		
		[[ConnectionManager sharedManager] grabURLInBackground:[NSString stringWithFormat:@"%@", kServerURL]
												   andDelegate:self 
													  postDict:[NSDictionary dictionaryWithObjectsAndKeys:_userNameTxtFld.text, @"userName",_phoneNumberTxtFld.text, @"phoneNumber", @"iphoneRegistration", @"funcName",_appDelegate._jsonString,@"list",_appDelegate._deviceToken,@"token", nil]];
		
	}
	
	return YES;
}

- (BOOL) validateCountryCode: (NSString *) candidate {
    NSString *Regex = @"[0-9]{9,}";
    NSPredicate *Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex]; 
	
    return [Test evaluateWithObject:candidate];
}

- (void)loginBGAndTxtFldGoUp:(BOOL)up byNumOfRows:(CGFloat)numOfRows
{
	if (up) 
	{
		[_bgImageView setFrame:CGRectMake(_bgImageView.frame.origin.x,
										  0 - 44 * (numOfRows - 1),
										  _bgImageView.frame.size.width,
										  _bgImageView.frame.size.height)];
		
		[_userNameTxtFld setFrame:CGRectMake(_userNameTxtFld.frame.origin.x,
										  0 - 44 * (numOfRows - 1),
										  _userNameTxtFld.frame.size.width,
										  _userNameTxtFld.frame.size.height)];
		
		[_phoneNumberTxtFld setFrame:CGRectMake(_phoneNumberTxtFld.frame.origin.x,
										  0 - 44 * (numOfRows - 1),
										  _phoneNumberTxtFld.frame.size.width,
										  _phoneNumberTxtFld.frame.size.height)];
		
		
	}
	else { // return to original place
		
		[_bgImageView setFrame:CGRectMake(_bgImageView.frame.origin.x,
										  0,
										  _bgImageView.frame.size.width,
										  _bgImageView.frame.size.height)];
		
		[_userNameTxtFld setFrame:CGRectMake(_userNameTxtFld.frame.origin.x,
										  0,
										  _userNameTxtFld.frame.size.width,
										  _userNameTxtFld.frame.size.height)];
		
		[_phoneNumberTxtFld setFrame:CGRectMake(_phoneNumberTxtFld.frame.origin.x,
										  0,
										  _phoneNumberTxtFld.frame.size.width,
										  _phoneNumberTxtFld.frame.size.height)];
		
	}
	
}

#pragma mark -
#pragma mark ASIHTTPRequestDelegate

-(void)requestFailed:(ASIHTTPRequest *)request
{
    
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
	SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
	NSMutableDictionary *response = [jsonParser objectWithString:[request responseString]];
	
	for (NSString *key in response) {
		NSLog(@"%@\n", [response objectForKey:key]);
	}
	if ([response objectForKey:@"success"] == [NSNumber numberWithBool:YES])
	{
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserRegisterd];
		[[NSUserDefaults standardUserDefaults] setObject:_userNameTxtFld.text forKey:kUsername];
		[[NSUserDefaults standardUserDefaults] setObject:_phoneNumberTxtFld.text forKey:kPhoneNumber];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
		SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
		NSMutableDictionary *response = [jsonParser objectWithString:[request responseString]];
		
		int i = 0;
		for (NSMutableDictionary *person in [response objectForKey:@"data"]) {
			@synchronized(self)
			{
				NSString *key = [[[_appDelegate._addressBookArray objectAtIndex:i] allKeys] objectAtIndex:0];
				NSString *number = [[[_appDelegate._addressBookArray objectAtIndex:i] objectForKey:key] objectForKey:kNumber];
				if ([number isEqualToString:[person objectForKey:@"phoneNum"]]) {
					[[[_appDelegate._addressBookArray objectAtIndex:i] objectForKey:key] setObject:[person objectForKey:@"enrolled"] forKey:kEnrolled];
					[[[_appDelegate._addressBookArray objectAtIndex:i] objectForKey:key] setObject:[person objectForKey:@"userName"] forKey:kUsername];
				}
				i++;
			}
		}
		
		//sort
		[_appDelegate._addressBookArray sortUsingComparator:(NSComparator)^(NSDictionary *obj1, NSDictionary *obj2){
			NSString *name1 = [[obj1 allKeys] objectAtIndex:0];
			NSString *name2 = [[obj2 allKeys] objectAtIndex:0];
			return [name1 caseInsensitiveCompare:name2]; }];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:kGotAddressBookFromServerNotification object:nil];
		
		[self.delegate loginDismiss];
	}
	else 
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Register Screen" 
														message:@"Sorry, You can't Register " 
													   delegate:nil
											  cancelButtonTitle:@"Ok"
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
