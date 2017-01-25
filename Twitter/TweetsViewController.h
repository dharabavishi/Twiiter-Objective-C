//
//  TweetsViewController.h
//  Twitter
//
//  Created by Dhara Bavishi on 1/20/17.
//  Copyright © 2017 Dhara Bavishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeViewController.h"

@interface TweetsViewController : UIViewController <ComposeViewControllerDelegate>{
    
    

}
@property(nonatomic,strong)NSMutableArray *tweets;
- (IBAction)composeNewClick:(UIBarButtonItem *)sender;

@end
