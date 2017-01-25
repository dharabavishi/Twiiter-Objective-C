//
//  Constant.h
//  Twitter
//
//  Created by Dhara Bavishi on 1/24/17.
//  Copyright © 2017 Dhara Bavishi. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#define TWITTER_BLUE  [UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:1]
#define WHITE  [UIColor whiteColor]

#define CONSUMER_KEY @"bBRVqCAgL3F3kATxww9DhWtjy"
#define CONSUMER_SECRET @"dGz9LTIMNBoXRg06sPsXUpJw89btObtmGYEBaKK0XLWJ129B0X"
#define APP_URL  @"https://api.twitter.com"


//Twitter API URL
#define TIMELINE_URL  @"1.1/statuses/home_timeline.json"
#define FAVORITE_URL @"1.1/favorites/create.json"
#define UN_FAVORITE_URL @"1.1/favorites/destroy.json"
#define RETWEET_A_TWEET @"1.1/statuses/retweet"
#define UNDO_RETWEET_A_TWEET @"1.1/statuses/unretweet"
#define COMPOSE_TWEET @"1.1/statuses/update.json"

#endif /* Constant_h */
