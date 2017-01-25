//
//  TweetsDetailViewController.m
//  Twitter
//
//  Created by Dhara Bavishi on 1/23/17.
//  Copyright © 2017 Dhara Bavishi. All rights reserved.
//

#import "TweetsDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"
#import "ComposeViewController.h"
@interface TweetsDetailViewController ()

@end

@implementation TweetsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    
    
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
   
    self.title = @"Tweet";
}
-(void)setupView{
    
     self.navigationItem.titleView = nil;
    self.title = @"Tweet";
    [_profileImageView setImageWithURL:_tweet.profileImageURL];
    _nameLabel.text = _tweet.name;
    _screenNameLabel.text = [NSString stringWithFormat:@"@%@",_tweet.screen_name];
    _textTxtView.text = _tweet.text;
    _dateTimeLabel.text = [_tweet getDateTime];
    _favCountLabel.text = [NSString stringWithFormat:@"%ld",(long)_tweet.favoutitesCount];
    _retweetCountLabel.text = [NSString stringWithFormat:@"%ld",(long)_tweet.retweetCount];
    if(_tweet.curUserFavorited){
        _favoriteButton.selected = true;
    }
    if(_tweet.curUserReTweeted){
        _retweetButton.selected = true;
    }
    _profileImageView.layer.cornerRadius = 5;
    _profileImageView.clipsToBounds = YES;
   
    
    
}

- (IBAction)retweetClick:(UIButton *)sender {
    
    if(!_tweet.curUserReTweeted){
        sender.selected = true;
        _tweet.curUserReTweeted = true;
        _tweet.retweetCount +=1;
        
        [[TwitterClient instance] retweetATweet:_tweet.tweetID completion:^(id help, NSError *error) {
            
            if(!error){
                
            }else{
                sender.selected = false;
                _tweet.curUserReTweeted = false;
                _tweet.retweetCount -=1;
                
            }
            
        }];
        
    }else{
        sender.selected = false;
        _tweet.curUserReTweeted = false;
        _tweet.retweetCount -=1;
        [[TwitterClient instance] undoRetweet:_tweet.tweetID completion:^(id help, NSError *error) {
            
            if(error){
                sender.selected = true;
                _tweet.curUserReTweeted = true;
                _tweet.retweetCount +=1;
            }else{
                
                
            }
            
            
        }];
        
    }
    _retweetCountLabel.text = [NSString stringWithFormat:@"%ld",(long)_tweet.retweetCount];
}
- (IBAction)favoriteClick:(UIButton *)sender {
    
    if(!_tweet.curUserFavorited){
        sender.selected = true;
        _tweet.curUserFavorited = true;
        _tweet.favoutitesCount +=1;
        [[TwitterClient instance] favoriteATweet:_tweet.tweetID completion:^(id help, NSError *error) {
            if(!error){
                
                
            }else{
                
                sender.selected = false;
                _tweet.curUserFavorited = false;
                _tweet.favoutitesCount -=1;
            }
        }];
    }else{
        sender.selected = false;
        _tweet.curUserFavorited = false;
        _tweet.favoutitesCount -=1;
        [[TwitterClient instance] unfavoriteATweet:_tweet.tweetID completion:^(id help, NSError *error) {
            if(!error){
                
            }else{
                sender.selected = true;
                _tweet.curUserFavorited = true;
                _tweet.favoutitesCount +=1;
                
            }
        }];
    }
    _favCountLabel.text = [NSString stringWithFormat:@"%ld",(long)_tweet.favoutitesCount];
}
- (IBAction)replyClick:(UIButton *)sender {
    
    ComposeViewController *comp = [self.storyboard instantiateViewControllerWithIdentifier:@"ComposeViewController"];
    comp.tweet = _tweet;
   
    [self.navigationController presentViewController:comp animated:TRUE completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
