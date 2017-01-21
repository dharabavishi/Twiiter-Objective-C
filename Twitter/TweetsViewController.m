//
//  TweetsViewController.m
//  Twitter
//
//  Created by Dhara Bavishi on 1/20/17.
//  Copyright © 2017 Dhara Bavishi. All rights reserved.
//

#import "TweetsViewController.h"
#import "TweetsCell.h"

@interface TweetsViewController ()


@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCells" forIndexPath:indexPath];
    cell.tweets = tweets[indexPath.row];
    //cell.delegate = self;
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    self.prototypeCell.tweet = self.tweets[indexPath.row];
//    [self.prototypeCell layoutSubviews];
//    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    return size.height + 1;
//}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 112; // height of a 4-line non-retweeted tweet
//}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
//    TweetDetailViewController *vc = [[TweetDetailViewController alloc] init];
//    vc.tweet = self.tweets[indexPath.row];
//    [self.navigationController pushViewController:vc animated:YES];
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
