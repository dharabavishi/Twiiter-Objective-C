//
//  TweetsCell.m
//  Twitter
//
//  Created by Dhara Bavishi on 1/20/17.
//  Copyright © 2017 Dhara Bavishi. All rights reserved.
//

#import "TweetsCell.h"
#import "UIImageView+AFNetworking.h"

@interface TweetsCell()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIButton *reTweetByIcon;
@property (weak, nonatomic) IBOutlet UILabel *reTweetedLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayScreenLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *textDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;

@property (weak, nonatomic) IBOutlet UILabel *favCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileImageTopConstraint;


@end

@implementation TweetsCell
- (IBAction)favButtonClick:(UIButton *)sender {
}
- (IBAction)reTweetButtonClick:(UIButton *)sender {
}
-(void)updateCell{
    
    [_profileImageView setimagew]
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
