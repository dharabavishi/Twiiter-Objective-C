//
//  Tweets.m
//  Twitter
//
//  Created by Dhara Bavishi on 1/20/17.
//  Copyright © 2017 Dhara Bavishi. All rights reserved.
//

#import "Tweets.h"
#import "NSDate+TimeAgo.h"
#import <UIKit/UIKit.h>
@implementation Tweets
    
- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        NSLog(@"Dict is %@",dict);
        self.user = [[User alloc] initWithDictionary:dict[@"user"]];
        self.name = self.user.name;
        self.screen_name = self.user.screenName;
        self.text = dict[@"text"];
        NSString *createAtString = dict[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.timestamp = [formatter dateFromString:createAtString];
        self.strDate = [self getAgoTime];
        self.tweetID = dict[@"id_str"];
        self.retweetCount = [dict[@"retweet_count"] integerValue];
        NSLog(@"retweet coutn is %ld",(long)self.retweetCount);
        NSString *strImage = dict[@"user"][@"profile_image_url_https"];
        self.profileImageURL  = [NSURL URLWithString:strImage];
        self.favoutitesCount = [dict[@"favorite_count"] integerValue];
        self.isRetweet = [dict[@"retweeted"] integerValue];
        
        
        //_tweetID = dict[@"id_str"];
        
        _curUserFavorited = [dict[@"favorited"] boolValue];
        _curUserReTweeted = [dict[@"retweeted"] boolValue];
        _replyToScreenName = dict[@"in_reply_to_screen_name"];
        _retweetedStatusDic = dict[@"retweeted_status"];
        
        if(_retweetedStatusDic!=nil){
            
            _tweetType = kReTweet;
            _retweetedUser = _user;
            _user = [[User alloc] initWithDictionary:_retweetedStatusDic[@"user"]];
        }else if(_replyToScreenName != (id)[NSNull null]){
            
            _tweetType = kReply;
        }else{
            _tweetType = kOriginal;
        }
        _mediaDic = [dict valueForKey:@"entities"];
        if([_mediaDic valueForKey:@"media"]){
            NSArray *array = [[_mediaDic valueForKey:@"media"] objectAtIndex:0];
            _mediaUrl = [NSURL URLWithString:[array valueForKey:@"media_url_https"]];
        }
       
    }
    
    return self;
}
-(NSString *)getDateTime{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yy , hh:mm a"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@"%@",[dateFormatter stringFromDate:self.timestamp]);
    return [dateFormatter stringFromDate:self.timestamp];
}
// gives us the information when it was created
// (how many hours ago)
- (NSString *)getAgoTime
{
    // Get the system calendar
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    
    
    // Get conversion to months, days, hours, minutes
    unsigned int unitFlags = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitMinute;
    
    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:[NSDate date]  toDate:self.timestamp  options:0];
    long min = -[breakdownInfo minute];
    if(min<1){
        
        return [NSString stringWithFormat:@"%ds", (int)(min*60.0)];
    }else if(min<60){
        return [NSString stringWithFormat:@"%ldm", min];
    }else if(min>=60 && min<60*24){
        return [NSString stringWithFormat:@"%dh", (int)(min/60.0)];
    }else if(min>=60*24){
        return [NSString stringWithFormat:@"%dd", (int)((min*60.0)/7.0)];
    }else{
        return @"";
    }
    
}
-(NSMutableAttributedString*)decorateTags:(NSString *)stringWithTags{
    
    
    NSError *error = nil;
    
    //For "Vijay #Apple Dev"
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"@(\\w+)" options:0 error:&error];
    
    //For "Vijay @Apple Dev"
    //NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"@(\\w+)" options:0 error:&error];
    
    NSArray *matches = [regex matchesInString:stringWithTags options:0 range:NSMakeRange(0, stringWithTags.length)];
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:stringWithTags];
    
    NSInteger stringLength=[stringWithTags length];
    
    for (NSTextCheckingResult *match in matches) {
        
        NSRange wordRange = [match rangeAtIndex:1];
        
        NSString* word = [stringWithTags substringWithRange:wordRange];
        
        //Set Font
        UIFont *font1 = [UIFont fontWithName:@"Helvetica-Bold" size:13.0f];
        [attString addAttribute:NSFontAttributeName value:font1 range:NSMakeRange(0, stringLength)];
        
        
        //Set Background Color
        UIColor *backgroundColor=[UIColor orangeColor];
        //[attString addAttribute:NSBackgroundColorAttributeName value:backgroundColor range:wordRange];
        
        //Set Foreground Color
        UIColor *foregroundColor=[UIColor redColor];
        [attString addAttribute:NSForegroundColorAttributeName value:foregroundColor range:wordRange];
        
        NSLog(@"Found tag %@", word);
        
    }
    
    // Set up your text field or label to show up the result
    
    //    yourTextField.attributedText = attString;
    //
    //    yourLabel.attributedText = attString;
    
    return attString;
}
+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [tweets addObject: [[Tweets alloc] initWithDictionary:dictionary]];
    }
    
    return tweets;
}


@end
