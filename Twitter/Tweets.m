//
//  Tweets.m
//  Twitter
//
//  Created by Dhara Bavishi on 1/20/17.
//  Copyright © 2017 Dhara Bavishi. All rights reserved.
//

#import "Tweets.h"

@implementation Tweets
    
- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        self.user = [[User alloc] initWithDictionary:dict[@"user"]];
        self.text = dict[@"text"];
        NSString *createAtString = dict[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.timestamp = [formatter dateFromString:createAtString];
        self.tweetID = dict[@"id"];
        self.favourited = dict[@"favorited"];
    }
    
    return self;
}

// gives us the information when it was created
// (how many hours ago)
- (NSString *)hourDistanceTime
{
    // Get the system calendar
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    
    // Create the current date
    NSDate *currentDate = [[NSDate alloc] init];
    
    // Get conversion to months, days, hours, minutes
    unsigned int unitFlags = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear ;
    
    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:currentDate  toDate:self.timestamp  options:0];
    
    return [NSString stringWithFormat:@"%ldm", - [breakdownInfo minute]];
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [tweets addObject: [[Tweets alloc] initWithDictionary:dictionary]];
    }
    
    return tweets;
}


@end
