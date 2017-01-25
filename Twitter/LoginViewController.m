//
//  LoginViewController.m
//  Twitter
//
//  Created by Dhara Bavishi on 1/14/17.
//  Copyright © 2017 Dhara Bavishi. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "MBProgressHUD.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
}
#pragma mark Button Clicks

- (IBAction)onLoginClick:(UIButton *)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    [[TwitterClient instance]loginWithCompletion:^(User *user, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:TRUE];
        if(!error){
            
            NSLog(@"%@",user.screenName);
            [self performSegueWithIdentifier:@"TweetsVCSeg" sender:nil];
            
        }else{
            
            [[TwitterClient instance]showAlert:self alertTitle:error.localizedDescription];
            NSLog(@"%@",error.description);
        }
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
