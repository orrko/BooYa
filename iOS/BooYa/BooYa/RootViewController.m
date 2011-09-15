//
//  RootViewController.m
//  BooYa
//
//  Created by נועם מה-יפית on 11/9/11.
//  Copyright 2011 OnO Apps. All rights reserved.
//

#import "RootViewController.h"
#import "BooYaViewController.h"
#import "StuffViewController.h"
#import "StatsViewController.h"

@implementation RootViewController
@synthesize _splashBooYaImage;


#pragma mark -
#pragma mark view Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSMutableArray *splashAnimationArray = [NSMutableArray array];
    for (int i = 1; i <= 20; i++) {
        [splashAnimationArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"BooYA_%d.png", i]]];
    }
    for (int i = 1; i <= 20; i++) {
        [splashAnimationArray addObject:[UIImage imageNamed:@"BooYA_20.png"]];
    }
    [_splashBooYaImage setAnimationImages:splashAnimationArray];
    [_splashBooYaImage setAnimationDuration:[splashAnimationArray count]*1/30];
    [_splashBooYaImage setAnimationRepeatCount:1000];
    
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:)
//												 name: kReachabilityChangedNotification object:nil];
	
	_appDelegate = (BooYaAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (![[NSUserDefaults standardUserDefaults] objectForKey:kUserRegisterd])
	{
		[self loadLoginView];
	}
    
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)startSplashBooYa
{
    [_splashBooYaImage startAnimating];
    [_splashBooYaImage setHidden:NO];
}

-(void)stopSplashBooYa
{
    [_splashBooYaImage stopAnimating];
    [_splashBooYaImage setHidden:YES];
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

- (IBAction)buttonPushed:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    switch (button.tag) {
        case 0: //BooYA
        {
            BooYaViewController *booyaVC = [[BooYaViewController alloc] initWithNibName:@"BooYaViewController" bundle:nil];
            [self.navigationController pushViewController:booyaVC animated:YES];
            [booyaVC release];
        }
            break;
            
        case 1://Board
            
            break;
        
        case 2://Stats
        {
            StatsViewController *statViewController = [[StatsViewController alloc] initWithNibName:@"StatsViewController" bundle:nil];
            [self.navigationController pushViewController:statViewController animated:YES];
            [statViewController release];
        }
            break;
            
        case 3://More
        {
            StuffViewController *stuffViewController = [[StuffViewController alloc] initWithNibName:@"StuffViewController" bundle:nil];
            [self.navigationController pushViewController:stuffViewController animated:YES];
            [stuffViewController release];
        } 
            break;
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
												   delegate:self
										  cancelButtonTitle:@"Ok"
										  otherButtonTitles:@"No",nil];
	[alert show];
	[alert release];
}

#pragma mark -
#pragma mark Stuff button pressed

- (IBAction)stuffButtonPressed:(UIButton *)bttn
{
	
}

#pragma mark -
#pragma mark UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// NO - button pressed
	if (buttonIndex == 1) 
	{
		NSLog(@"NO - stay in log in screen");
	}
	else 
	{ // Yes - go to home screen
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionCurlUp animations:^(void) {
            [_loginVC.view removeFromSuperview];
        } completion:^(BOOL finished) {
            
        }];
		
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
    [self set_splashBooYaImage:nil];
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [_splashBooYaImage release];
    [super dealloc];
}


@end
