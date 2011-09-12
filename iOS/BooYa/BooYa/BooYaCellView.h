//
//  BooYaCellView.h
//  BooYa
//
//  Created by נועם מה-יפית on 12/9/11.
//  Copyright 2011 OnO Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BooYaCellView : UITableViewCell {
    UILabel *_nameLabel;
    UILabel *_userNameLabel;
    UIButton *_BooYaButton;
}

@property (nonatomic, retain) IBOutlet UILabel *_userNameLabel;
@property (nonatomic, retain) IBOutlet UIButton *_BooYaButton;
@property (nonatomic, retain) IBOutlet UILabel *_nameLabel;


@end
