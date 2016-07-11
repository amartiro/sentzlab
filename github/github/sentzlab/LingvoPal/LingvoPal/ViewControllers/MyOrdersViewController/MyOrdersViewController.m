//
//  MyOrdersViewController.m
//  LingvoPal
//
//  Created by Artak on 2/15/16.
//  Copyright © 2016 SentzLab. All rights reserved.
//

#import "MyOrdersViewController.h"
#import "Helper.h"
#import "AppDelegate.h"
#import "MFSideMenuContainerViewController.h"
#import "OrderCell.h"
#import "PortalSession.h"
#import "Constants.h"
#import "OrderItem.h"
#import "TranslatorWaitingViewController.h"

#define TRANSLATE_BUTTON_TAG   38414700

@interface MyOrdersViewController() <UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate, PortalSessionDelegate>

@property (nonatomic, strong) UILabel *proLabel;
@property (nonatomic, strong) UIActionSheet *proActionSheet;
@property (nonatomic, strong) UITableView *ordersTableView;
@property (nonatomic, strong) UILabel *noOrderLabel;
@property (nonatomic, strong) UIImageView *noOrderImageView;


@property (nonatomic, assign) NSInteger rowIndex;

@property (nonatomic, assign) BOOL isPro;
@property (nonatomic, assign) BOOL palEnabled;



@property (nonatomic, strong) NSMutableArray *orderItems;
@property (nonatomic, strong) NSMutableArray *proOrderItems;
@property (nonatomic, strong) NSMutableArray *palOrderItems;



@end

@implementation MyOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isPro = YES;
    self.palEnabled = YES;
    self.orderItems = [NSMutableArray array];
    self.proOrderItems = [NSMutableArray array];
    self.palOrderItems = [NSMutableArray array];

    self.bkgImageView.image = [Helper getImageByImageName:@"gradient"];
    
    UIButton * menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setImage:[Helper getImageByImageName:@"burger"] forState:UIControlStateNormal];
    menuButton.frame = [Helper getRectValue:CGRectMake(5, 20, 41, 34)];
    [menuButton addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(50, 26, 260, 22)]];
    titleLabel.text = @"Requests";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [Helper fontWithSize:16];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    titleLabel.shadowOffset = CGSizeMake(1, 1);
    [self.view addSubview:titleLabel];
    
    
//    UILabel *qualificationLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 60, 220, 14)]];
//    qualificationLabel.text = @"QUALIFICATION";
//    qualificationLabel.font = [Helper fontWithSize:12];
//    qualificationLabel.textColor = [UIColor whiteColor];
//    qualificationLabel.textAlignment = NSTextAlignmentLeft;
//    qualificationLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
//    qualificationLabel.shadowOffset = CGSizeMake(1, 1);
//    [self.view addSubview:qualificationLabel];
//    
//    UIImageView *proBKG = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"text_cell"]];
//    proBKG.frame = [Helper getRectValue:CGRectMake(40, 75, 240, 30)];
//    proBKG.userInteractionEnabled = YES;
//    [self.view addSubview:proBKG];
//    
//    self.proLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(5, 5, 200, 20)]];
//    self.proLabel.text = @"LingvoPro";
//    self.proLabel.textColor = [UIColor colorWithRed:(122.0f/255.0f) green:(122.0f/255.0f) blue:(126.0f/255.0f) alpha:1.0f];
//    self.proLabel.font = [Helper fontWithSize:14];
//    self.proLabel.backgroundColor = [UIColor clearColor];
//    [proBKG addSubview:self.proLabel];
//    
//    UIButton* proButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [proButton setBackgroundImage:[Helper getImageByImageName:@"orders_arrow_cell"] forState:UIControlStateNormal];
//    proButton.frame = [Helper getRectValue:CGRectMake(210, 0, 30, 30)];
//    [proButton addTarget:self action:@selector(proAction:) forControlEvents:UIControlEventTouchUpInside];
//    [proBKG addSubview:proButton];
//    
//    self.proActionSheet = [[UIActionSheet alloc] initWithTitle:@"Please specify translator qualification:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
//    [self.proActionSheet addButtonWithTitle:@"LingvoPro"];
//    [self.proActionSheet addButtonWithTitle:@"LingvoPal"];

    
    self.ordersTableView = [[UITableView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 70, 320, [Helper isiPhone4] ? 390 : 478)]];
    self.ordersTableView.delegate = self;
    self.ordersTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.ordersTableView.dataSource = self;
    self.ordersTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.ordersTableView];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor= [UIColor whiteColor];
    [self.ordersTableView addSubview:refreshControl];
    
    self.noOrderLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(20, 140, 280, 30)]];
    self.noOrderLabel.font = [Helper fontWithSize:24];
    self.noOrderLabel.textAlignment = NSTextAlignmentCenter;
    self.noOrderLabel.textColor = [UIColor whiteColor];
    self.noOrderLabel.text = @"Oops, no requests at the moment";
    self.noOrderLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    self.noOrderLabel.shadowOffset = CGSizeMake(1, 1);
    self.noOrderLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:self.noOrderLabel];
    self.noOrderLabel.hidden = YES;
    
    self.noOrderImageView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"wait1"]];

    self.noOrderImageView.center = [Helper getPointValue:CGPointMake(160, 300)];
    self.noOrderImageView.animationImages = [NSArray arrayWithObjects:
                                          [Helper getImageByImageName:@"wait1"],
                                          [Helper getImageByImageName:@"wait2"],
                                          [Helper getImageByImageName:@"wait3"],
                                          [Helper getImageByImageName:@"wait4"],
                                          nil];
    
    self.noOrderImageView.animationDuration = 2;
    [self.view addSubview:self.noOrderImageView];
    self.noOrderImageView.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newOrderNotificationAction:) name:kNewOrderNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNewOrderNotification object:nil];
    
    
    NSLog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}

-(void) menuAction:(UIButton *) button{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.menuViewController toggleLeftSideMenuCompletion:^{
        
    }];
}

-(void) newOrderNotificationAction:(NSNotification *) notification{
    [self reloadContent];
}

-(void) reloadContent{
    [self getTranslatorOrders];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    // Do your job, when done:
    [refreshControl endRefreshing];
    [self getTranslatorOrders];
}

-(void) proAction:(UIButton *) button{
    [self.proActionSheet showInView:self.view];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self reloadContent];
}

#pragma mark  UIActionSheetDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex != 0){
        self.proLabel.text = [self.proActionSheet buttonTitleAtIndex:buttonIndex];
        self.isPro = (buttonIndex == 1);
     //   self.palEnabled = self.isPro;
        [self refreshContent];
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isPro) {
        if (self.palEnabled) {
            return [self.orderItems count];
        } else {
            return [self.proOrderItems count];
        }
    } else {
        return [self.palOrderItems count];
    }
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderCell *cell = (OrderCell *) [tableView dequeueReusableCellWithIdentifier:@"OrderCell"];
    
    if (cell == nil) {
        cell = [[OrderCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"OrderCell"];
        [cell.translateButton addTarget:self action:@selector(translateAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    OrderItem *item = nil;
    NSInteger row = indexPath.row;
    
    if (self.isPro) {
        
        if (self.palEnabled) {
            item = [self.orderItems objectAtIndex:row];
        } else {
            item = [self.proOrderItems objectAtIndex:row];
        }
    } else {
        item = [self.palOrderItems objectAtIndex:row];
    }
    
    cell.transNameLabel.text = item.userName;
    cell.langLabel.text = [NSString stringWithFormat:@"%@->%@", [Helper getLanguageFromABRV:item.fromLang], [Helper getLanguageFromABRV:item.toLang]];
    cell.translateButton.tag = TRANSLATE_BUTTON_TAG + indexPath.row;
    cell.priceLabel.text = [Helper getCallType:item.callType];//[NSString stringWithFormat:(item.isPro ? @"Pro 30$/min" : @"Pal 4$/min")];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [Helper getValue:54];
}

-(void) translateAction:(UIButton *) button{
    NSInteger index = button.tag - TRANSLATE_BUTTON_TAG;
    self.rowIndex = index;
    
    [self acceptOrder];
}

-(void) getTranslatorOrders{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *transId =  [defaults objectForKey:kTranslatorId];
    
    
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session getTranslatorOrdersForTransId:transId];
    [self startAnimation];
}

-(void) acceptOrder{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *transId =  [defaults objectForKey:kTranslatorId];
    
    OrderItem *item = nil;
    
    if (self.isPro) {
        if (self.palEnabled) {
            item = [self.orderItems objectAtIndex:self.rowIndex];
        } else {
            item = [self.proOrderItems objectAtIndex:self.rowIndex];
        }
    } else {
        item = [self.palOrderItems objectAtIndex:self.rowIndex];
    }
  
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session acceptOrderFromTransId:transId withOrderId:item.orderId] ;
    
    self.ordersTableView.userInteractionEnabled = NO;
    [self startAnimation];
}


-(void) refreshContent{
    if ((self.isPro && ( [self.proOrderItems count] != 0 || (self.palEnabled && [self.orderItems count] != 0)))
        || (!self.isPro && [self.palOrderItems count] != 0)) {
        
        self.noOrderLabel.hidden = YES;
        self.noOrderImageView.hidden = YES;
        [self.noOrderImageView stopAnimating];
    } else {
        self.noOrderLabel.hidden = NO;
        self.noOrderImageView.hidden = NO;
        [self.noOrderImageView startAnimating];
    }
    
//    CGRect orderTableFrame = CGRectZero;
    
//    if (self.amIPro) {
//        
//        
//        orderTableFrame = [Helper getRectValue:CGRectMake(0, 120, 320, [Helper isiPhone4] ? 340 : 428)];
//    } else {
//        orderTableFrame = [Helper getRectValue:CGRectMake(0, 70, 320, [Helper isiPhone4] ? 390 : 478)];
  //  }
    
 //   self.ordersTableView.frame = [Helper getRectValue:CGRectMake(0, 70, 320, [Helper isiPhone4] ? 390 : 478)];

    
    [self.ordersTableView reloadData];
}

#pragma mark PortalSessionDelegate

-(void) getTranslatorOrdersResponse:(NSDictionary *)dict{
    NSLog(@"getTranslatorOrdersResponse %@", dict);
    [self stopAnimation];
  
    
    NSDictionary *ordersDict = [dict objectForKey:@"orders"];
    
    [self.palOrderItems removeAllObjects];
    [self.proOrderItems removeAllObjects];
    [self.orderItems removeAllObjects];
    
    for (NSString *key in [ordersDict allKeys]) {
        NSDictionary *transDict = [ordersDict objectForKey:key];
        
        OrderItem *item = [[OrderItem alloc] init];
        item.userId = [transDict objectForKey:@"us_id"];
        item.orderId = [transDict objectForKey:@"id"];
        item.userName = [transDict objectForKey:@"name"];
        item.startTime = [[transDict objectForKey:@"start_time"] integerValue];
        item.fromLang = [transDict objectForKey:@"lang1"];
        item.toLang = [transDict objectForKey:@"lang2"];
        item.isPro = ([[transDict objectForKey:@"pro"] integerValue] == 1);
        item.callType = (CallType)[[transDict objectForKey:@"call_type"] integerValue];
        if (item.isPro) {
            [self.proOrderItems addObject:item];
        } else {
            [self.palOrderItems addObject:item];
        }
        [self.orderItems addObject:item];
    }
    
    [self refreshContent];
}

-(void) failedToGetTranslatorOrders:(NSDictionary *)dict{
    NSLog(@"failedToGetTranslatorOrders  %@", dict);
    [self stopAnimation];
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    if (errorCode == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if (errorCode == 100) {
        [self.palOrderItems removeAllObjects];
        [self.proOrderItems removeAllObjects];
        [self.orderItems removeAllObjects];
        
        [self refreshContent];
    }
}

-(void) timeoutToGetTranslatorOrders:(NSError *)error{
    NSLog(@"timeoutToGetHistory");
    [self getTranslatorOrders];
}

-(void) acceptOrderResponse:(NSDictionary *) dict{
    NSLog(@"acceptOrderResponse %@", dict);
    [self stopAnimation];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *transId =  [defaults objectForKey:kTranslatorId];
    
    OrderItem *item = nil;
    
    if (self.isPro) {
        if (self.palEnabled) {
            item = [self.orderItems objectAtIndex:self.rowIndex];
        } else {
            item = [self.proOrderItems objectAtIndex:self.rowIndex];
        }
    } else {
        item = [self.palOrderItems objectAtIndex:self.rowIndex];
    }
    
    TranslatorWaitingViewController *viewController = [[TranslatorWaitingViewController alloc] init];
    viewController.fromLang = item.fromLang;
    viewController.toLang = item.toLang;
    viewController.isPro = item.isPro;
    viewController.orderId = item.orderId;
    viewController.transId = transId;
    viewController.clientQBID = [dict objectForKey:@"qb_id"];
    viewController.callType = item.callType;
    
    self.ordersTableView.userInteractionEnabled = YES;
    [self stopAnimation];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) failedToAcceptOrder:(NSDictionary *) dict{
    NSLog(@"failedToAcceptOrder  %@", dict);
    [self stopAnimation];
    
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    if (errorCode == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if (errorCode == 100) {
       [Helper showAlertViewWithText:@"The request is processiong with other interpreters." delegate:nil];
    }
    
    
    if (errorCode == 404) {
        [Helper showAlertViewWithText:@"Order is closed." delegate:nil];
        [self stopAnimation];
        self.ordersTableView.userInteractionEnabled = YES;
        [self getTranslatorOrders];
    }

}

-(void) timeoutToAcceptOrder:(NSError *) error{
    NSLog(@"timeoutToAcceptOrder");
    [self acceptOrder];
}

@end
