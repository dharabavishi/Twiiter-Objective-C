//
//  LoginViewController.m
//  Twitter
//
//  Created by Dhara Bavishi on 1/14/17.
//  Copyright © 2017 Dhara Bavishi. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
        
        
        
    
   
    // Do any additional setup after loading the view.
}
#pragma mark Button Clicks

- (IBAction)onLoginClick:(UIButton *)sender {
    
    [[TwitterClient instance]loginWithCompletion:^(User *user, NSError *error) {
        if(!error){
            
            NSLog(@"%@",user.screenName);
            [self performSegueWithIdentifier:@"TweetsVCSeg" sender:nil];
            
        }else{
            
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
