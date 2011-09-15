//
//  BoardCellView.m
//  BooYa
//
//  Created by Amit Bar-Shai on 9/14/11.
//  Copyright 2011 OnO Apps. All rights reserved.
//

#import "BoardCellView.h"


@implementation BoardCellView

@synthesize _userNameLabel;
@synthesize _BooYaButton;
@synthesize _rankLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

- (void)dealloc {
	
	[_rankLabel release];
    [_userNameLabel release];
    [_BooYaButton release];
	
	[super dealloc];
}


@end
