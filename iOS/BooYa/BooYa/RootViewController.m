//
//  RootViewController.m
//  BooYa
//
//  Created by נועם מה-יפית on 11/9/11.
//  Copyright 2011 OnO Apps. All rights reserved.
//

#import "RootViewController.h"
#import "StuffViewController.h"

@implementation RootViewController


#pragma mark -
#pragma mark view Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:)
//												 name: kReachabilityChangedNotification object:nil];
	
	_appDelegate = (BooYaAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (![[NSUserDefaults standardUserDefaults] objectForKey:kUserRegisterd])
	{
		[self loadLoginView];
	}
}

- (void)loadLoginView
{
	if (_loginVC) {
		[_loginVC release];
		_loginVC = nil;
	}
	
	_loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
	_loginVC.delegate = self;
	_loginVC.view.frame = CGRectMake(0, 0, 320, 480);
	[self.view addSubview:_loginVC.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	// the user want to stop the game
	if (_appDelegate._stoppedPressed) {
		[self loadLoginView];
	}
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

#pragma mark -
#pragma mark LoginProtocol

- (void)loginDismiss
{
	NSLog(@"In Login dismiss");
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yo!" 
													message:@"Can we pleeeease use your contact list (it's the only way to play BooYA!)." 
												   delegate:nil
										  cancelButtonTitle:@"Ok"
										  otherButtonTitles:@"No",nil];
	[alert show];
	[alert release];
}

#pragma mark -
#pragma mark Stuff button pressed

- (IBAction)stuffButtonPressed:(UIButton *)bttn
{
	StuffViewController *stuffViewController = [[StuffViewController alloc] initWithNibName:@"StuffViewController" bundle:nil];
	[self.navigationController pushViewController:stuffViewController animated:YES];
	[stuffViewController release];
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil];
	self.navigationItem.backBarButtonItem = backButton;
	[backButton release];
	backButton = nil;
}

#pragma mark -
#pragma mark UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// NO - button pressed
	if (buttonIndex == 0) 
	{
		NSLog(@"NO - stay in log in screen");
	}
	else 
	{ // Yes - go to home screen
		[_loginVC.view removeFromSuperview];
	}

}

#pragma mark -
#pragma mark Memory managment


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [super dealloc];
}

@end
