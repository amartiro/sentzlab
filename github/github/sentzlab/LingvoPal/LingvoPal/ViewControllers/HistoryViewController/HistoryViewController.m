//
//  HistoryViewController.m
//  LingvoPal
//
//  Created by Artak on 12/7/15.
//  Copyright © 2015 SentzLab. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryCell.h"
#import "HistoryItem.h"
#import "Helper.h"

#import "AppDelegate.h"
#import "MFSideMenuContainerViewController.h"
#import "LeftMenuViewController.h"

#import "PortalSession.h"

#import "HistoryTopCell.h"
#import "HistoryMiddleCell.h"
#import "HistoryBottomCell.h"
#import "HistoryCellBase.h"
#import "HistorySingleCell.h"

#define RATE_BUTTON_TAG   78414700
#define FUTURE_BUTTON_TAG 98414700


@interface HistoryViewController () <UITableViewDataSource, UITableViewDelegate, PortalSessionDelegate>
@property (strong, nonatomic)  UITableView *historyTableView;
@property (strong, nonatomic) NSMutableArray * historyItems;
@property (strong, nonatomic) UILabel *noOrderLabel;

@property (strong, nonatomic) UIButton *orderButton;
@property (strong, nonatomic) UIImageView *noHistoryImageView;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndeicator;
@property (assign, nonatomic) BOOL sentRequest;
@property (assign, nonatomic) NSInteger  page;


@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bkgImageView.image = [Helper getImageByImageName:@"gradient"];
    
    UIButton * menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setImage:[Helper getImageByImageName:@"burger"] forState:UIControlStateNormal];
    menuButton.frame = [Helper getRectValue:CGRectMake(5, 20, 41, 34)];
    [menuButton addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(50, 26, 260, 22)]];
    titleLabel.text = @"History";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [Helper fontWithSize:16];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    titleLabel.shadowOffset = CGSizeMake(1, 1);
    [self.view addSubview:titleLabel];
    
    self.historyTableView = [[UITableView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 70, 320, [Helper isiPhone4] ? 390 : 478)]];
    self.historyTableView.dataSource = self;
    self.historyTableView.delegate = self;
    self.historyTableView.backgroundColor = [UIColor clearColor];
    self.historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.historyTableView];
    
    self.activityIndeicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.historyTableView.frame), 44)];
    [self.activityIndeicator setColor:[UIColor whiteColor]];
    [self.historyTableView setTableFooterView:self.activityIndeicator];

    
    self.historyItems = [NSMutableArray array];
    
    self.noOrderLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(30, 120, 260, 60)]];
    self.noOrderLabel.font = [Helper fontWithSize:18];
    self.noOrderLabel.textAlignment = NSTextAlignmentCenter;
    self.noOrderLabel.textColor = [UIColor whiteColor];
    self.noOrderLabel.text = @"Here you will see the list of previus calls which are yet to be made.\nGo on make a call now...";
    self.noOrderLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    self.noOrderLabel.shadowOffset = CGSizeMake(1, 1);
    self.noOrderLabel.numberOfLines = 3;
    [self.view addSubview:self.noOrderLabel];
    self.noOrderLabel.hidden = YES;
    
    self.orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.orderButton setBackgroundImage:[Helper getImageByImageName:@"order_cell"] forState:UIControlStateNormal];
    [self.orderButton setTitle:NSLocalizedString(@"Find interpreter", @"Find interpreter") forState:UIControlStateNormal];
    self.orderButton.titleLabel.font = [Helper fontWithSize:18];
    self.orderButton.frame = [Helper getRectValue:CGRectMake(40, [Helper isiPhone4] ? 420 : 508, 240, 30)];
    [self.orderButton addTarget:self action:@selector(orderAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.orderButton];
    self.orderButton.hidden = YES;
    
    
    self.noHistoryImageView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"wait1"]];
    
    self.noHistoryImageView.center = [Helper getPointValue:CGPointMake(160, 330)];
    self.noHistoryImageView.animationImages = [NSArray arrayWithObjects:
                                               [Helper getImageByImageName:@"wait1"],
                                               [Helper getImageByImageName:@"wait2"],
                                               [Helper getImageByImageName:@"wait3"],
                                               [Helper getImageByImageName:@"wait4"],
                                               nil];
    
    self.noHistoryImageView.animationDuration = 2;
    [self.view addSubview:self.noHistoryImageView];
    self.noHistoryImageView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) menuAction:(UIButton *) button{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.menuViewController toggleLeftSideMenuCompletion:^{
        
    }];
}

- (void)orderAction:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   [appDelegate.menuViewController setCenterViewController:appDelegate.menuViewController.leftMenuViewController.findInterpreterViewController];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.page = 0;
    [self.historyItems removeAllObjects];
    [self getHistory];
    
}

-(void)refreshTableVeiwList
{
    ++self.page;
    self.sentRequest = YES;
    [self getHistory];
    [self.activityIndeicator startAnimating];
    
}
-(void)scrollViewDidScroll: (UIScrollView*)scrollView
{
    if (scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height)
    {
        if (!self.sentRequest) {
            [self refreshTableVeiwList];
        }
    }
}

-(void) getHistory{

    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session getHistoryForTransId:nil withPage:self.page];
    [self startAnimation];
}


#pragma mark PortalSessionDelegate

-(void) getHistoryResponse:(NSDictionary *)dict{
    NSLog(@"getHistoryResponse %@", dict);
    
    [self stopAnimation];
    [self.activityIndeicator stopAnimating];
    self.sentRequest = NO;
    
    NSDictionary *historyDict = [dict objectForKey:@"history"];
    
   // [self.historyItems removeAllObjects];

    
    for (NSString *key in [historyDict allKeys]) {
        NSDictionary *transDict = [historyDict objectForKey:key];
        
        id lang1 = [transDict objectForKey:@"lang1"];
        id lang2 = [transDict objectForKey:@"lang2"];
        
        HistoryItem *item = [[HistoryItem alloc] init];
        item.transId = [transDict objectForKey:@"tr_id"];
        item.userId = [transDict objectForKey:@"us_id"];
        item.transImage = [transDict objectForKey:@"img"];
        item.callType = (CallType)[[transDict objectForKey:@"call_type"] integerValue];
        item.transName = [transDict objectForKey:@"name"];
        item.transSurName = [transDict objectForKey:@"surname"];
        item.startTime = [[transDict objectForKey:@"start_time"] integerValue];
        item.endTime = [[transDict objectForKey:@"end_time"] integerValue];
        item.fromLang = ([lang1 isKindOfClass:[NSNull class]] ? @"" : (NSString *)lang1);
        item.toLang = ([lang2 isKindOfClass:[NSNull class]] ? @"" : (NSString *)lang2);
        item.rating = [[transDict objectForKey:@"rating"] integerValue];
        item.review = [transDict objectForKey:@"review"];
        [self.historyItems addObject:item];
    }
    
    self.historyItems = [NSMutableArray arrayWithArray:[self.historyItems sortedArrayUsingComparator:^NSComparisonResult(HistoryItem* a, HistoryItem* b) {
        
        return a.startTime < b.startTime;
    }]];
    
    [self.historyTableView reloadData];
    [self stopAnimation];
    
    self.historyTableView.hidden = NO;
  //  self.orderButton.center = [Helper getPointValue:CGPointMake(160, [Helper isiPhone4] ? 420 : 508)];
    self.noOrderLabel.hidden = YES;
    self.orderButton.hidden = YES;
    
    self.noHistoryImageView.hidden = YES;
    [self.noHistoryImageView stopAnimating];

}

-(void) failedToGetHistory:(NSDictionary *)dict{
    NSLog(@"failedToGetHistory  %@", dict);
    [self stopAnimation];
    [self.activityIndeicator stopAnimating];

    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    if (errorCode == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

    if (errorCode == 100 && [self.historyItems count] == 0) {
        self.historyTableView.hidden = YES;
    //    self.orderButton.center = [Helper getPointValue:CGPointMake(160, [Helper isiPhone4] ? 420 : 508)];
        self.noOrderLabel.hidden = NO;
        self.orderButton.hidden = NO;
        self.noHistoryImageView.hidden = NO;
        [self.noHistoryImageView startAnimating];
    }
}

-(void) timeoutToGetHistory:(NSError *)error{
    NSLog(@"timeoutToGetHistory");
    [self getHistory];
}



-(void) futureAction:(UIButton *) button{
  //  NSInteger row = button.tag - FUTURE_BUTTON_TAG;
    
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.historyItems count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HistoryItem *historyItem = [self.historyItems objectAtIndex:indexPath.row];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:historyItem.startTime];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"dd-MM-yyyy HH:mm"];
    
    NSString *theDate = [timeFormat stringFromDate:date];
    NSString *langStr = [NSString stringWithFormat:@"%@->%@", [Helper getLanguageFromABRV:historyItem.fromLang], [Helper getLanguageFromABRV:historyItem.toLang]];
    
    HistoryCellBase *cell = nil;
    
    
    NSString *cellIdentifier = @"HistorySingleCell";
    
    if (indexPath.row == 0) {
        if ([self.historyItems count] == 1) {
            cellIdentifier = @"HistorySingleCell";
            
            cell = (HistorySingleCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (cell == nil) {
                cell = [[HistorySingleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            }
        } else {
            cellIdentifier = @"HistoryTopCell";
            
            cell = (HistoryTopCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (cell == nil) {
                cell = [[HistoryTopCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            }
        }
    } else if (indexPath.row == [self.historyItems count] - 1) {
        cellIdentifier = @"HistoryBottomCell";
        
        cell = (HistoryBottomCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[HistoryBottomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        
    } else {
        cellIdentifier = @"HistoryMiddleCell";
        
        cell = (HistoryMiddleCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[HistoryMiddleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
    }
    
    cell.transNameLabel.text = [NSString stringWithFormat:@"%@ %@", historyItem.transName, historyItem.transSurName];
    cell.langLabel.text = langStr;
    cell.dateLabel.text = theDate;
    cell.priceLabel.text = @"-85$";
    cell.conferanceTypeLabel.text = [Helper getCallType:historyItem.callType];
    cell.durationLabel.text = [Helper getMinutesString:(historyItem.endTime - historyItem.startTime)];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[NSURL URLWithString:historyItem.transImage]
                                                completionHandler:^(NSURL *location,NSURLResponse *response, NSError *error) {
                                                    
                                                    NSData *imageData = [NSData dataWithContentsOfURL:location];
                                                    UIImage *image = [UIImage imageWithData:imageData];
                                                    
                                                    dispatch_sync(dispatch_get_main_queue(),^{
                                                        
                                                        
                                                        if (image == nil) {
                                                            cell.profileImageView.image = [Helper getImageByImageName:@"profile_cell"];
                                                        } else {
                                                            cell.profileImageView.image = image;
                                                        }
                                                    });
                                                }];
    [task resume];
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if ([self.historyItems count] == 1) {
            return [Helper getValue:207];
        }else {
            return [Helper getValue:200];
        }
    } if (indexPath.row == self.historyItems.count - 1) {
        return [Helper getValue:207];
        
    } else {
        return [Helper getValue:201];
    }
    
    return [Helper getValue:58];
}

@end
