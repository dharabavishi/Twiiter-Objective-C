//
//  ComposeViewController.m
//  Twitter
//
//  Created by Dhara Bavishi on 1/24/17.
//  Copyright © 2017 Dhara Bavishi. All rights reserved.
//

#import "ComposeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"
#import "TwitterClient.h"
#import "TweetsViewController.h"
@interface ComposeViewController ()

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self addObserver];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self removeObserver];
}
-(void)setUpView{
    User *user = [User getCurrentUser];
    [self.profileImageView setImageWithURL:user.profileImageUrl];
    
    if(_tweet==nil){
        self.inReplyToView.hidden = TRUE;
        _txtView.placeholder = @"What's happening?";
        _txtView.placeholderColor = [UIColor lightGrayColor];
        _textViewTopConstraint.constant = -30;
    }else{
        self.inReplyToView.hidden = FALSE;
        self.inReplyToLabel.text = [NSString stringWithFormat:@"In reply to %@",_tweet.user.screenName];
        self.txtView.text = [NSString stringWithFormat:@"@%@",_tweet.user.screenName];
    }
    [self.txtView becomeFirstResponder];
    _countView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _countView.layer.borderWidth = 1.0f;
    long diff = 140-_txtView.text.length;
    _countCharacterLabel.text = [NSString stringWithFormat:@"%ld",diff];
    _profileImageView.layer.cornerRadius = 5;
    _profileImageView.clipsToBounds = YES;
    
   
    
    
}
- (IBAction)cancelClick:(UIButton *)sender{

    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)tweetButtonClick:(UIButton *)sender{
    
    [self.txtView resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    
    NSString *replyToID;
    if(_tweet != nil){
        
        replyToID = [NSString stringWithFormat:@"%@",_tweet.tweetID];
    }
    else
    {
        replyToID = 0;
    }
    
    if(_txtView.text.length > 0)
    {
        [[TwitterClient instance] composeTweet:_txtView.text reply:replyToID completion:^(id help, NSError *error) {
            if(error){
                [[TwitterClient instance]showAlert:self alertTitle:error.description];
            }else{
                NSLog(@"%@",help);
                
                [self cancelClick:nil];
                Tweets *new = [[Tweets alloc] initWithDictionary:help];
                [_delegate tweetComposed:self newTweet:new];
                
            }
        }];
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    long diff = 140-textView.text.length-1;
    _countCharacterLabel.text = [NSString stringWithFormat:@"%ld",diff];
    if(textView.text.length>140){
        _tweetButton.enabled = NO;
        _countCharacterLabel.textColor = [UIColor redColor];
        
    }else{
         _tweetButton.enabled = YES;
        _countCharacterLabel.textColor = [UIColor blackColor];
    }
    
    return YES;
}
- (void)addObserver
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myNotificationMethod:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
}
-(void)removeObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)myNotificationMethod:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    _bottomConstraint.constant = keyboardFrameBeginRect.size.height;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
