//
//  TweetsCell.h
//  Twitter
//
//  Created by Dhara Bavishi on 1/20/17.
//  Copyright © 2017 Dhara Bavishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweets.h"
@interface TweetsCell : UITableViewCell

@property(strong,nonatomic)Tweets *tweets;
-(void)updateCell;
@end
