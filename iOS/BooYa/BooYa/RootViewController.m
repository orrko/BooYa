//
//  RootViewController.m
//  BooYa
//
//  Created by נועם מה-יפית on 11/9/11.
//  Copyright 2011 OnO Apps. All rights reserved.
//

#import "RootViewController.h"
#import "BooYaViewController.h"

@implementation RootViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"BooYa";
}

- (IBAction)buttonPushed:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    switch (button.tag) {
        case 0:
        {
            BooYaViewController *booyaVC = [[BooYaViewController alloc] initWithNibName:@"BooYaViewController" bundle:nil];
            [self.navigationController pushViewController:booyaVC animated:YES];
            [booyaVC release];
        }
            break;
            
        case 1:
            
            break;
        
        case 2:
            
            break;
            
        case 3:
            
            break;
    }
}



/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


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
