//
//  TweetsViewController.m
//  Twitter
//
//  Created by Dhara Bavishi on 1/20/17.
//  Copyright © 2017 Dhara Bavishi. All rights reserved.
//

#import "TweetsViewController.h"
#import "TweetsCell.h"
#import "TwitterClient.h"
#import "TweetsDetailViewController.h"
#import "MBProgressHUD.h"
#import "ComposeViewController.h"
#import "UIScrollView+SVInfiniteScrolling.h"
@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate,TweetsCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"";
    self.tweets = [[NSMutableArray alloc] init];
    [self setUpView];
    [self setUpTableView];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];

    [self loadTweets];
    
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"Count is %lu",(unsigned long)_tweets.count);
    [self.tableView reloadData];
   
}
-(void)viewDidAppear:(BOOL)animated{
    [self.tableView triggerInfiniteScrolling];
}
-(void)setUpView{
    
    UIImage *image = [UIImage imageNamed:@"navTitle"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
   
    
}
-(void)setUpTableView{
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    UINib *cell = [UINib nibWithNibName:@"TweetsCell" bundle:nil];
    [self.tableView registerNib:cell forCellReuseIdentifier:@"TweetsCell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [self loadTweets];
    }];

}
- (IBAction)logoutClick:(UIBarButtonItem *)sender {
    
    
    [User logout];
    
}
- (IBAction)composeNewClick:(UIBarButtonItem *)sender{
    
    ComposeViewController *comp = [self.storyboard instantiateViewControllerWithIdentifier:@"ComposeViewController"];
    comp.tweet = nil;
    comp.delegate = self;
    [self.navigationController presentViewController:comp animated:TRUE completion:^{
        
    }];
    
    
    
}
- (void) onRefresh
{
    [_tweets removeAllObjects];
    [self loadTweets];
}

- (void) loadTweets
{
    long lowestTweetID = LONG_MAX;
    
    if(self.tweets.count==0){
        lowestTweetID = 0;
    }else{
        
        for(int i=0;i<_tweets.count;i++){
            Tweets *tt = [_tweets objectAtIndex:i];
            if([tt.tweetID longLongValue]<lowestTweetID){
                lowestTweetID = [tt.tweetID longLongValue];
            }
            
        }
    }
  
     __weak TweetsViewController *weakSelf = self;
    [[TwitterClient instance] homeTimeLineWithParams:[NSString stringWithFormat:@"%ld",lowestTweetID] completion:^(NSArray *result, NSError *error) {
         [MBProgressHUD hideHUDForView:self.view animated:TRUE];
        [weakSelf.refreshControl endRefreshing];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        if(error){
            NSLog(@"erroe is %@",error.localizedDescription);
            [[TwitterClient instance]showAlert:self alertTitle:error.description];
        }else{
           
            
            [weakSelf.tweets addObjectsFromArray:result];
            [weakSelf.tableView reloadData];
        }
        
        
    }];
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TweetsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetsCell" forIndexPath:indexPath];
    cell.tweets = self.tweets[indexPath.row];
    cell.delegate = self;
    [cell updateCell];
    cell.textTxtView.dataDetectorTypes = UIDataDetectorTypeAll;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(forwardToDidSelect:)];
    cell.textTxtView.tag = indexPath.row;
    [cell.textTxtView addGestureRecognizer: tap];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 112; // height of a 4-line non-retweeted tweet
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    
    
    TweetsDetailViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"TweetsDetailViewController"];
    newView.title = @"Tweet";
    newView.tweet = [self.tweets objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:newView animated:YES];
    
    
}
- (void) forwardToDidSelect: (UITapGestureRecognizer *) tap
{
    
    [self tableView: self.tableView didSelectRowAtIndexPath: [NSIndexPath indexPathForRow: tap.view.tag inSection: 0]];
}

#pragma mark Compose Tweet delegate
- (void)tweetComposed:(ComposeViewController *)compose newTweet:(Tweets *)newTweet
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObject:newTweet];
    [arr addObjectsFromArray:self.tweets];
    [self.tweets removeAllObjects];
    [self.tweets addObjectsFromArray:arr];
    [self.tableView reloadData];
    
   
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadComposeScreen:(Tweets *)tweet{
    ComposeViewController *comp = [self.storyboard instantiateViewControllerWithIdentifier:@"ComposeViewController"];
    comp.tweet = tweet;
    comp.delegate = self;
    [self.navigationController presentViewController:comp animated:TRUE completion:^{
        
    }];

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
