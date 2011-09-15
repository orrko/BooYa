//
//  BooYaCellView.m
//  BooYa
//
//  Created by נועם מה-יפית on 12/9/11.
//  Copyright 2011 OnO Apps. All rights reserved.
//

#import "BooYaCellView.h"

@implementation BooYaCellView
@synthesize _rankLabel;
@synthesize _BooYaButton;
@synthesize _nameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_nameLabel release];
    [_rankLabel release];
    [_BooYaButton release];
    [super dealloc];
}

@end
