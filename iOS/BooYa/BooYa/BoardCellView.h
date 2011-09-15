//
//  BoardCellView.h
//  BooYa
//
//  Created by Amit Bar-Shai on 9/14/11.
//  Copyright 2011 OnO Apps. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BoardCellView : UITableViewCell {

    IBOutlet UILabel *_rankLabel;
    IBOutlet UILabel *_userNameLabel;
    IBOutlet UIButton *_BooYaButton;
}

@property (nonatomic, retain) IBOutlet UILabel *_userNameLabel;
@property (nonatomic, retain) IBOutlet UIButton *_BooYaButton;
@property (nonatomic, retain) IBOutlet UILabel *_rankLabel;

@end
