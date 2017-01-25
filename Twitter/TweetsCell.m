//
//  TweetsCell.m
//  Twitter
//
//  Created by Dhara Bavishi on 1/20/17.
//  Copyright © 2017 Dhara Bavishi. All rights reserved.
//

#import "TweetsCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
@interface TweetsCell()
@property (weak, nonatomic) IBOutlet UIImageView *retweetInReplyIcon;

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
    
    if(!_tweets.curUserFavorited){
        sender.selected = true;
        _tweets.curUserFavorited = true;
        _tweets.favoutitesCount +=1;
        [[TwitterClient instance] favoriteATweet:_tweets.tweetID completion:^(id help, NSError *error) {
            if(!error){
                
                
            }else{
                
                sender.selected = false;
                _tweets.curUserFavorited = false;
                _tweets.favoutitesCount -=1;
            }
        }];
    }else{
        sender.selected = false;
        _tweets.curUserFavorited = false;
        _tweets.favoutitesCount -=1;
        [[TwitterClient instance] unfavoriteATweet:_tweets.tweetID completion:^(id help, NSError *error) {
            if(!error){
                
            }else{
                sender.selected = true;
                _tweets.curUserFavorited = true;
                _tweets.favoutitesCount +=1;
                
            }
        }];
    }
    [self updateFavorite];
   
}
- (IBAction)reTweetButtonClick:(UIButton *)sender {
    
    if(!_tweets.curUserReTweeted){
        sender.selected = true;
        _tweets.curUserReTweeted = true;
        _tweets.retweetCount +=1;
        
        [[TwitterClient instance] retweetATweet:_tweets.tweetID completion:^(id help, NSError *error) {
            
            if(!error){
                
            }else{
                sender.selected = false;
                _tweets.curUserReTweeted = false;
                _tweets.retweetCount -=1;
                
            }
            
        }];
       
    }else{
        sender.selected = false;
        _tweets.curUserReTweeted = false;
        _tweets.retweetCount -=1;
        [[TwitterClient instance] undoRetweet:_tweets.tweetID completion:^(id help, NSError *error) {
            
            if(error){
                sender.selected = true;
                _tweets.curUserReTweeted = true;
                _tweets.retweetCount +=1;
            }else{
               
                
            }
            
            
        }];

    }
     [self updateRetweet];
    
    
}
-(IBAction)onReplyClick:(UIButton *)sender{
    
  

    [_delegate loadComposeScreen:_tweets];
  
    
    
}
-(void)updateCell{
    
    
    
    
    [_profileImageView setImageWithURL:_tweets.profileImageURL];
    _nameLabel.text = _tweets.name;
    _displayScreenLabel.text = [NSString stringWithFormat:@"@%@",_tweets.screen_name];
    _timeLabel.text = _tweets.strDate;
  
    _textTxtView.text = _tweets.text;
    [self updateTweetType];
    [self updateFavorite];
    [self updateRetweet];
    
}
-(void)updateTweetType{
    
    if(_tweets.tweetType == kReTweet){
        if(!_tweets.curUserReTweeted){
            _reTweetedLabel.text = @"You retweeted";
            [_retweetInReplyIcon setImage:[UIImage imageNamed:@"retweetGray"]];

        }else{
            _reTweetedLabel.text = [NSString stringWithFormat:@"%@ retweeted",_tweets.retweetedUser.name];
            //_reTweetByIcon.selected = NO;
            [_retweetInReplyIcon setImage:[UIImage imageNamed:@"downarrow"]];

            
        }
    }else if(_tweets.tweetType == kReply){
        
        _reTweetedLabel.text = [NSString stringWithFormat:@"In reply to %@",_tweets.replyToScreenName];
       
        [_retweetInReplyIcon setImage:[UIImage imageNamed:@"downarrow"]];
        
    }else{
        _reTweetedLabel.text = @"";
        _reTweetedLabel.hidden = true;
        _reTweetByIcon.hidden = true;
        _profileImageTopConstraint.constant = 6;
    }
}
-(void)updateFavorite{
    if(_tweets.curUserFavorited){
        _favouriteButton.selected = YES;
        
    }else{
        _favouriteButton.selected = NO;
    }
    _favCountLabel.text = [NSString stringWithFormat:@"%ld",(long)_tweets.favoutitesCount];
}
-(void)updateRetweet{
    
    if(_tweets.curUserReTweeted){
        _retweetButton.selected = YES;
        
    }else{
        _retweetButton.selected = NO;
    }
    _retweetCountLabel.text = [NSString stringWithFormat:@"%ld",(long)_tweets.retweetCount];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _profileImageView.layer.cornerRadius = 5;
    _profileImageView.clipsToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
