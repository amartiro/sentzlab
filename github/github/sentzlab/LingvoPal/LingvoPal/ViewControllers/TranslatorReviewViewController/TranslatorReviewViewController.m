//
//  TranslatorReviewViewController.m
//  LingvoPal
//
//  Created by Artak on 2/1/16.
//  Copyright © 2016 SentzLab. All rights reserved.
//

#import "TranslatorReviewViewController.h"
#import "Helper.h"
#import "AppDelegate.h"
#import "MFSideMenuContainerViewController.h"
#import "TranslatorReviewCell.h"
#import "PortalSession.h"
#import "Constants.h"
#import "LeftMenuViewController.h"

@interface TranslatorReviewViewController () <UITableViewDataSource, UITableViewDelegate, PortalSessionDelegate>

@property (nonatomic, strong) UITableView *reviewTableView;
@property (nonatomic, strong) NSArray *reviews;
@property (strong, nonatomic) UILabel *noReviewLabel;
@property (strong, nonatomic) UIImageView *noReviewImageView;
@property (strong, nonatomic) UIButton *activeRequestsButton;


@end

@implementation TranslatorReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bkgImageView.image = [Helper getImageByImageName:@"gradient"];
    
//    UIButton * menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [menuButton setImage:[Helper getImageByImageName:@"burger"] forState:UIControlStateNormal];
//    menuButton.frame = [Helper getRectValue:CGRectMake(5, 20, 41, 34)];
//    [menuButton addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:menuButton];
//    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(50, 26, 260, 22)]];
//    titleLabel.text = @"Reviews";
//    titleLabel.textColor = [UIColor whiteColor];
//    titleLabel.font = [Helper fontWithSize:16];
//    titleLabel.textAlignment = NSTextAlignmentLeft;
//    titleLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
//    titleLabel.shadowOffset = CGSizeMake(1, 1);
//    [self.view addSubview:titleLabel];
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[Helper getImageByImageName:@"back_icon"] forState:UIControlStateNormal];
    backButton.frame = [Helper getRectValue:CGRectMake(5, 20, 26, 42)];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    self.reviewTableView = [[UITableView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 90, 320, [Helper isiPhone4] ? 370 : 458)]];
    self.reviewTableView.dataSource = self;
    self.reviewTableView.delegate = self;
    self.reviewTableView.backgroundColor = [UIColor clearColor];
    self.reviewTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.reviewTableView];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor= [UIColor whiteColor];
    [self.reviewTableView addSubview:refreshControl];

    
    self.noReviewLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(20, 80, 280, 200)]];
    self.noReviewLabel.font = [Helper fontWithSize:18];
    self.noReviewLabel.textAlignment = NSTextAlignmentCenter;
    self.noReviewLabel.textColor = [UIColor whiteColor];
    self.noReviewLabel.numberOfLines = 10;
    self.noReviewLabel.text = @" Nobody reviewed you yet. Go on, take some requests to fill this page with positive and thankfull reviews about your brilliant skills and wonderful personality.\n\nN.B.: This part is really important. Be nice to people as the better you rating is more requests will be shared with you.";
    self.noReviewLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    self.noReviewLabel.shadowOffset = CGSizeMake(1, 1);
    [self.view addSubview:self.noReviewLabel];
    self.noReviewLabel.hidden = YES;
    
    self.noReviewImageView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"wait1"]];
    
    self.noReviewImageView.center = [Helper getPointValue:CGPointMake(160, 380)];
    self.noReviewImageView.animationImages = [NSArray arrayWithObjects:
                                               [Helper getImageByImageName:@"wait1"],
                                               [Helper getImageByImageName:@"wait2"],
                                               [Helper getImageByImageName:@"wait3"],
                                               [Helper getImageByImageName:@"wait4"],
                                               nil];
    
    self.noReviewImageView.animationDuration = 2;
    [self.view addSubview:self.noReviewImageView];
    self.noReviewImageView.hidden = YES;
    
    self.activeRequestsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.activeRequestsButton setBackgroundImage:[Helper getImageByImageName:@"order_cell"] forState:UIControlStateNormal];
    [self.activeRequestsButton setTitle:NSLocalizedString(@"Active Requests", @"Active Requests") forState:UIControlStateNormal];
    self.activeRequestsButton.titleLabel.font = [Helper fontWithSize:18];
    self.activeRequestsButton.frame = [Helper getRectValue:CGRectMake(40, [Helper isiPhone4] ? 420 : 508, 240, 30)];
    [self.activeRequestsButton addTarget:self action:@selector(activeRequestsAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.activeRequestsButton];
    self.activeRequestsButton.hidden = YES;
    
}

- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) activeRequestsAction:(UIButton *) button{
    [self.navigationController popViewControllerAnimated:NO];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.menuViewController setCenterViewController:appDelegate.menuViewController.leftMenuViewController.myOrdersViewController];
}

//-(void) menuAction:(UIButton *) button{
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [appDelegate.menuViewController toggleLeftSideMenuCompletion:^{
//        
//    }];
//}

- (void)refresh:(UIRefreshControl *)refreshControl {
    // Do your job, when done:
    [refreshControl endRefreshing];
    [self getReview];
}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self getReview];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.reviews count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TranslatorReviewCell *cell = (TranslatorReviewCell *) [tableView dequeueReusableCellWithIdentifier:@"TranslatorReviewCell"];
    
    if (cell == nil) {
        cell = [[TranslatorReviewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TranslatorReviewCell"];
    }
    
    NSDictionary *reviewDict = [self.reviews objectAtIndex:indexPath.row];
    cell.nameLabel.text = [reviewDict objectForKey:@"name"];
    CallType callType = (CallType)[[reviewDict objectForKey:@"call_type"] integerValue];
    cell.callTypeLabel.text = [Helper getCallType:callType];
    
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[reviewDict objectForKey:@"date"] integerValue]];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"dd-MM-yyyy HH:mm"];
    
    NSString *theDate = [timeFormat stringFromDate:date];
    
    cell.dateLabel.text = theDate;
    
    NSString *fromLang = [reviewDict objectForKey:@"lang1"];
    NSString *toLang = [reviewDict objectForKey:@"lang2"];
    
    cell.langLabel.text = [NSString stringWithFormat:@"%@->%@", [Helper getLanguageFromABRV:fromLang], [Helper getLanguageFromABRV:toLang]];
    
    [cell setRate:[[reviewDict objectForKey:@"rating"] integerValue] andReviewText:[reviewDict objectForKey:@"review"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    NSDictionary *reviewDict = [self.reviews objectAtIndex:indexPath.row];
    
    NSString * reviewText = [reviewDict objectForKey: @"review"];
    
    CGSize size = [Helper getTextHeight:reviewText withFont:[Helper fontWithSize:12] andWidth:300];
    
    float heightToAdd = MAX(90 + size.height, 90.0f); //Some fix height is returned if height is small or change it to MAX(textSize.height, 150.0f); // whatever best fits for you
    return [Helper getValue:heightToAdd];
}


-(void) getReview{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *transId =  [defaults objectForKey:kTranslatorId];
    
    
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session getReviewsForTransId:transId];
    [self startAnimation];
}

-(void) getReviewsResponse:(NSDictionary *)dict{
    NSLog(@"getReviewsResponse %@", dict);
    [self stopAnimation];
    self.reviews = [dict objectForKey:@"reviews"];
   
    [self.reviewTableView reloadData];
    self.noReviewLabel.hidden = YES;
    self.noReviewImageView.hidden = YES;
    self.activeRequestsButton.hidden = YES;
    [self.noReviewImageView stopAnimating];
}

-(void) failedToGetReviews:(NSDictionary *)dict{
    NSLog(@"failedToGetReviews  %@", dict);
    [self stopAnimation];
    
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    if (errorCode == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if (errorCode == 100) {
        self.noReviewLabel.hidden = NO;
        self.noReviewImageView.hidden = NO;
        self.activeRequestsButton.hidden = NO;

        [self.noReviewImageView startAnimating];
    }
}

-(void) timeoutToGetReviews:(NSError *)error{
    NSLog(@"timeoutToGetReviews");
    [self getReview];
}

@end
