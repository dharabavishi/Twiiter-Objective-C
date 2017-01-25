//
//  ComposeViewController.h
//  Twitter
//
//  Created by Dhara Bavishi on 1/24/17.
//  Copyright © 2017 Dhara Bavishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPlaceholderTextView.h"
#import "User.h"
#import "Tweets.h"

@class ComposeViewController;
@protocol ComposeViewControllerDelegate <NSObject>
@optional
- (void)tweetComposed:(ComposeViewController *)compose newTweet:(Tweets *)newTweet;

@end

@interface ComposeViewController : UIViewController<UITextViewDelegate>

@property (nonatomic,strong) Tweets *tweet;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *inReplyToLabel;
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *txtView;
@property (weak, nonatomic) IBOutlet UILabel *countCharacterLabel;
@property (weak, nonatomic) IBOutlet UIButton *tweetButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *countView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (weak, nonatomic) IBOutlet UIView *inReplyToView;
@property (nonatomic, weak) id <ComposeViewControllerDelegate> delegate;
- (IBAction)cancelClick:(UIButton *)sender;
- (IBAction)tweetButtonClick:(UIButton *)sender;




@end
