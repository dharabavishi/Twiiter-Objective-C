//
//  TweetsCell.h
//  Twitter
//
//  Created by Dhara Bavishi on 1/20/17.
//  Copyright © 2017 Dhara Bavishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweets.h"
#import "TwitterClient.h"

@protocol TweetsCellDelegate <NSObject>
-(void)loadComposeScreen:(Tweets *)tweet;
@end

@interface TweetsCell : UITableViewCell

@property(strong,nonatomic)Tweets *tweets;
@property (weak, nonatomic) IBOutlet UITextView *textTxtView;
@property (nonatomic, weak) id <TweetsCellDelegate> delegate;

-(void)updateCell;
@end
