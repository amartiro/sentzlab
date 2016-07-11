//
//  TranslatorHistoryViewController.m
//  LingvoPal
//
//  Created by Artak on 1/25/16.
//  Copyright © 2016 SentzLab. All rights reserved.
//

#import "TranslatorHistoryViewController.h"
#import "Helper.h"
#import "AppDelegate.h"
#import "MFSideMenuContainerViewController.h"

#import "HistoryCell.h"
#import "TranslatorHistoryCell.h"
#import "HistoryItem.h"
#import "PortalSession.h"
#import "Constants.h"

#import "HistoryTopCell.h"
#import "HistoryMiddleCell.h"
#import "HistoryBottomCell.h"
#import "HistoryCellBase.h"
#import "HistorySingleCell.h"

#import "LeftMenuViewController.h"



#define TRANSLATOR_RATE_BUTTON_TAG   88414700

@interface TranslatorHistoryViewController()<UITableViewDataSource, UITableViewDelegate, PortalSessionDelegate>

@property (nonatomic, strong) UITableView *historyTableView;
@property (strong, nonatomic) NSMutableArray * historyItems;
@property (strong, nonatomic) UILabel *noHistoryLabel;
@property (strong, nonatomic) UIImageView *noHistoryImageView;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndeicator;
@property (assign, nonatomic) BOOL sentRequest;
@property (assign, nonatomic) NSInteger  page;
@property (strong, nonatomic) UIButton *activeRequestsButton;


@end

@implementation TranslatorHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bkgImageView.image = [Helper getImageByImageName:@"gradient"];
    
    UIButton * menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setImage:[Helper getImageByImageName:@"burger"] forState:UIControlStateNormal];
    menuButton.frame = [Helper getRectValue:CGRectMake(5, 20, 41, 34)];
    [menuButton addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(50, 26, 260, 22)]];
    titleLabel.text = @"My History";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [Helper fontWithSize:16];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    titleLabel.shadowOffset = CGSizeMake(1, 1);
    [self.view addSubview:titleLabel];
    
    self.historyTableView = [[UITableView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 90, 320, [Helper isiPhone4] ? 370 : 458)]];
    self.historyTableView.dataSource = self;
    self.historyTableView.delegate = self;
    self.historyTableView.backgroundColor = [UIColor clearColor];
    self.historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.historyTableView];
    self.historyTableView.hidden = YES;
    
    self.activityIndeicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.historyTableView.frame), 44)];
    [self.activityIndeicator setColor:[UIColor whiteColor]];
    [self.historyTableView setTableFooterView:self.activityIndeicator];

    self.noHistoryLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(30, 120, 260, 60)]];
    self.noHistoryLabel.font = [Helper fontWithSize:18];
    self.noHistoryLabel.textAlignment = NSTextAlignmentCenter;
    self.noHistoryLabel.textColor = [UIColor whiteColor];
    self.noHistoryLabel.text = @"Here you will see the list of previus calls which are yet to be made.\nGo on make a call now...";
    self.noHistoryLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    self.noHistoryLabel.shadowOffset = CGSizeMake(1, 1);
    self.noHistoryLabel.numberOfLines = 3;
    [self.view addSubview:self.noHistoryLabel];
    self.noHistoryLabel.hidden = YES;
    

    
    self.noHistoryImageView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"wait1"]];
    
    self.noHistoryImageView.center = [Helper getPointValue:CGPointMake(160, 300)];
    self.noHistoryImageView.animationImages = [NSArray arrayWithObjects:
                                             [Helper getImageByImageName:@"wait1"],
                                             [Helper getImageByImageName:@"wait2"],
                                             [Helper getImageByImageName:@"wait3"],
                                             [Helper getImageByImageName:@"wait4"],
                                             nil];
    
    self.noHistoryImageView.animationDuration = 2;
    [self.view addSubview:self.noHistoryImageView];
    self.noHistoryImageView.hidden = YES;

    self.historyItems = [NSMutableArray array];
    
    self.activeRequestsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.activeRequestsButton setBackgroundImage:[Helper getImageByImageName:@"order_cell"] forState:UIControlStateNormal];
    [self.activeRequestsButton setTitle:NSLocalizedString(@"Active Requests", @"Active Requests") forState:UIControlStateNormal];
    self.activeRequestsButton.titleLabel.font = [Helper fontWithSize:18];
    self.activeRequestsButton.frame = [Helper getRectValue:CGRectMake(40, [Helper isiPhone4] ? 420 : 508, 240, 30)];
    [self.activeRequestsButton addTarget:self action:@selector(activeRequestsAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.activeRequestsButton];
    self.activeRequestsButton.hidden = YES;
}

-(void) activeRequestsAction:(UIButton *) button{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.menuViewController setCenterViewController:appDelegate.menuViewController.leftMenuViewController.myOrdersViewController];
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

-(void) menuAction:(UIButton *) button{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.menuViewController toggleLeftSideMenuCompletion:^{
        
    }];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.page = 0;
    [self.historyItems removeAllObjects];
    [self getHistory];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.historyItems count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *Id = [defaults objectForKey:kAccessId];
    
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
    cell.conferanceTypeLabel.text = [Helper getCallType:historyItem.callType];
    cell.durationLabel.text = [Helper getMinutesString:(historyItem.endTime - historyItem.startTime)];
    
    if([historyItem.userId isEqualToString:Id]){
        cell.priceLabel.text = @"-85$";
        cell.cardImage.hidden = NO;
        cell.cardNumberLabel.hidden = NO;
        cell.youRatedLabel.text = @"YOU RATED";
      
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

    } else {
        cell.youRatedLabel.text = @"YOU WERE RATED";
        cell.priceLabel.text = @"+85$";
        cell.cardImage.hidden = YES;
        cell.cardNumberLabel.hidden = YES;
        cell.profileImageView.image = [Helper getImageByImageName:@"profile_cell"];
    }
    
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if ([self.historyItems count] == 1) {
            return [Helper getValue:207];
        }else {
            return [Helper getValue:200];
        }    } if (indexPath.row == self.historyItems.count - 1) {
        return [Helper getValue:207];

    } else {
        return [Helper getValue:201];
    }
    
    return [Helper getValue:58];
}


-(void) getHistory{
    
    [self startAnimation];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *transId =  [defaults objectForKey:kTranslatorId];
  
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session getHistoryForTransId:transId withPage:self.page];
}

#pragma mark PortalSessionDelegate

-(void) getHistoryResponse:(NSDictionary *)dict{
    NSLog(@"getHistoryResponse %@", dict);
    NSDictionary *historyDict = [dict objectForKey:@"history"];
    [self stopAnimation];
    [self.activityIndeicator stopAnimating];
    self.sentRequest = NO;

    
   // [self.historyItems removeAllObjects];
  
    for (NSString *key in [historyDict allKeys]) {
        NSDictionary *transDict = [historyDict objectForKey:key];
        
        id lang1 = [transDict objectForKey:@"lang1"];
        id lang2 = [transDict objectForKey:@"lang2"];
        
        HistoryItem *item = [[HistoryItem alloc] init];
        item.transId = [transDict objectForKey:@"tr_id"];
        item.userId = [transDict objectForKey:@"us_id"];
        item.transImage = [transDict objectForKey:@"img"];
        item.transName = [transDict objectForKey:@"name"];
        item.transSurName = [transDict objectForKey:@"surname"];
        item.callType = (CallType)[[transDict objectForKey:@"call_type"] integerValue];
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
    
    self.historyTableView.hidden = NO;
    self.noHistoryLabel.hidden = YES;
    self.noHistoryImageView.hidden = YES;
    self.activeRequestsButton.hidden = YES;
    [self.noHistoryImageView stopAnimating];
    
}

-(void) failedToGetHistory:(NSDictionary *)dict{
    NSLog(@"failedToGetHistory  %@", dict);
    [self stopAnimation];
    
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    if (errorCode == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    //TODO::ARTAK 100 -> your history is empty;
    
    if (errorCode == 100 && [self.historyItems count] == 0) {
        self.historyTableView.hidden = YES;
        self.noHistoryLabel.hidden = NO;
        self.noHistoryImageView.hidden = NO;
        self.activeRequestsButton.hidden = NO;;
        [self.noHistoryImageView startAnimating];
    }
}

-(void) timeoutToGetHistory:(NSError *)error{
    NSLog(@"timeoutToGetHistory");
    [self getHistory];
}

@end
