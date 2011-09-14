//
//  StuffViewController.m
//  BooYa
//
//  Created by Amit Bar-Shai on 9/13/11.
//  Copyright 2011 OnO Apps. All rights reserved.
//

#import "StuffViewController.h"
#import "Constants.h"


@implementation StuffViewController

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
	
//	UIBarButtonItem *stopPlaying = [[UIBarButtonItem alloc] initWithTitle:@"Stop" style:UIBarButtonItemStyleDone target:self action:@selector(stopButtonPressed)];
//	self.navigationItem.rightBarButtonItem = stopPlaying;
//	[stopPlaying release];
//	stopPlaying = nil;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark Buttons pressed

- (IBAction)screenButtonPressed:(UIButton *)bttn
{
	switch (bttn.tag) 
	{
		case kPauseOrResume:
			[_pauseOrStopBttn setHidden:NO];
			if (!_onResume) {
				//[_bgImageView setImage:[UIImage imageNamed:@"Resume.png"]];
				[_bgImageView setTag:kResumeBG];
				[_pauseOrStopBttn setTitle:@"Resume" forState:UIControlStateNormal];
			}
			else {
				//[_bgImageView setImage:[UIImage imageNamed:@"Pause.png"]];
				[_bgImageView setTag:kPauseBG];
				[_pauseOrStopBttn setTitle:@"Pause" forState:UIControlStateNormal];
			}
			_onResume = !_onResume;
		break;

		case kStop:
			[_pauseOrStopBttn setHidden:NO];
			//[_bgImageView setImage:[UIImage imageNamed:@"Stop.png"]];
			[_bgImageView setTag:kStopBG];
			[_pauseOrStopBttn setTitle:@"Stop" forState:UIControlStateNormal];
			
		break;

		case kPoints:
			[_pauseOrStopBttn setHidden:YES];
			//[_bgImageView setImage:[UIImage imageNamed:@"Points.png"]];
			[_bgImageView setTag:kPointsBG];
			break;
		
		case kInfo:
			[_pauseOrStopBttn setHidden:YES];
			[_bgImageView setTag:kInfoBG];
			//[_bgImageView setImage:[UIImage imageNamed:@"Info.png"]];
			break;

		default:
			break;
	}
}

- (IBAction)actionButtonPressed:(UIButton *)bttn
{
	UIAlertView *alert;
	
	switch (_bgImageView.tag) 
	{
		case kPauseBG:
			alert = [[UIAlertView alloc] initWithTitle:@"Pause playing" 
															message:@"It's no biigie but we would love you to stay, so we ask again..." 
														   delegate:self
												  cancelButtonTitle:@"Yes, I'm a bit tired"
												  otherButtonTitles:@"No way, I'm still in!",nil];

		break;
		
		case kResumeBG:
			alert = [[UIAlertView alloc] initWithTitle:@"Resume playing" 
															message:@"" 
														   delegate:self
												  cancelButtonTitle:@"YES"
												  otherButtonTitles:@"NO",nil];
		break;
			
		case kStopBG:
			alert = [[UIAlertView alloc] initWithTitle:@"Stop playing" 
															message:@"Not that we have a problem with that, but are you sure you want to leave us? We will miss you..." 
														   delegate:self
												  cancelButtonTitle:@"Yes I want to ditch you guys"
												  otherButtonTitles:@"Not leaving, just playing with you...",nil];
			
			[alert setTag:kStopBG];
			
		break;
			
		default:
			break;
	}
	[alert show];
	[alert release];
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// Only if pressed yes
	if (buttonIndex == 0) 
	{
		switch (alertView.tag) 
		{
			
			case kPauseBG:
				NSLog(@"Go to Me, Myself BooYA");
			break;
				
			case kResumeBG:
				NSLog(@"Continue Playing - stay in this screen");
			break;

			case kStopBG:
				_appDelegate._stoppedPressed = YES;
				[self.navigationController popViewControllerAnimated:YES];
			break;
				
			default:
				break;
		}
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
