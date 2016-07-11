//
//  TranlatorProfileViewController.m
//  LingvoPal
//
//  Created by Artak on 12/10/15.
//  Copyright © 2015 SentzLab. All rights reserved.
//

#import "TranlatorProfileViewController.h"

#import "AppDelegate.h"
#import "Helper.h"
#import <QuartzCore/QuartzCore.h>
#import "PortalSession.h"
#import "ReviewCell.h"

#import "ConferenceVideoViewController.h"
#import "PhoneWaitingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ooVooLoginViewController.h"
#import "Constants.h"


@interface TranlatorProfileViewController()  <PortalSessionDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIView *profileInfoBkgView;
@property (strong, nonatomic) UITableView *reviewTableView;
@property (strong, nonatomic) UILabel *transNameLabel;
@property (strong, nonatomic) UIImageView *transProfileImage;
@property (strong, nonatomic) UILabel *proLabel;
@property (strong, nonatomic) IBOutlet UIButton *otherTransButton;
@property (strong, nonatomic) IBOutlet UIButton *acceptButton;

@property (nonatomic, strong) NSString *translatorQBId;
@property (nonatomic, strong) NSString *translatorOVOId;
@property (nonatomic, strong) NSString *transId;
@property (nonatomic, strong) NSString *streamId;



@property (strong, nonatomic) UIView *rateView;
@property (strong, nonatomic) NSArray *reviews;

@end

@implementation TranlatorProfileViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bkgImageView.image = [Helper getImageByImageName:@"gradient1"];
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[Helper getImageByImageName:@"back_icon"] forState:UIControlStateNormal];
    backButton.frame = [Helper getRectValue:CGRectMake(5, 20, 26, 42)];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UILabel *readyLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(20, 60, 280, 20)]];
    readyLabel.text = @"TRANSLATOR IS READY TO START WORK";
    readyLabel.font = [Helper fontWithSize:16];
    readyLabel.textColor = [UIColor whiteColor];
    readyLabel.textAlignment = NSTextAlignmentCenter;
    readyLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    readyLabel.shadowOffset = CGSizeMake(1, 1);
    [self.view addSubview:readyLabel];
    
    self.profileInfoBkgView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 90, 240, 120)]];
    self.profileInfoBkgView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:.7f];
    self.profileInfoBkgView.layer.cornerRadius = [Helper getValue:5];
    [self.view addSubview:self.profileInfoBkgView];
    
    self.transNameLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(100, 15, 120, 25)]];
    self.transNameLabel.text = @"Interpreter";
    self.transNameLabel.font = [Helper fontWithSize:22];
    [self.profileInfoBkgView addSubview:self.transNameLabel];
    
    self.transProfileImage = [[UIImageView alloc] initWithFrame:[Helper getRectValue:CGRectMake(10, 15, 80, 80)]];
    self.transProfileImage.image = [Helper getImageByImageName:@"translater_profile_cell"];
    self.transProfileImage.layer.cornerRadius = [Helper getValue:40];
    self.transProfileImage.clipsToBounds = YES;
    [self.profileInfoBkgView addSubview:self.transProfileImage];
    
    self.proLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(100, 50, 120, 20)]];
    self.proLabel.text = @"Pro";
    self.proLabel.textColor = [UIColor darkGrayColor];
    self.proLabel.font = [Helper fontWithSize:14];
  //  [self.profileInfoBkgView addSubview:self.proLabel];
    
    UILabel *reviewsLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 220, 100, 20)]];
    reviewsLabel.text = @"Reviews";
    reviewsLabel.font = [Helper fontWithSize:16];
    reviewsLabel.textColor = [UIColor whiteColor];
    reviewsLabel.textAlignment = NSTextAlignmentLeft;
    reviewsLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    reviewsLabel.shadowOffset = CGSizeMake(1, 1);
    [self.view addSubview:reviewsLabel];
    
    self.reviewTableView = [[UITableView alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 240, 240, 186)]];
    self.reviewTableView.layer.cornerRadius = [Helper getValue:5];
    self.reviewTableView.dataSource = self;
    self.reviewTableView.delegate = self;
    self.reviewTableView.separatorColor = [UIColor clearColor];
    self.reviewTableView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:.7f];
    [self.view addSubview:self.reviewTableView];
    
    self.acceptButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.acceptButton setBackgroundImage:[Helper getImageByImageName:@"accept_cell"] forState:UIControlStateNormal];
    [self.acceptButton setTitle:@"ACCEPT" forState:UIControlStateNormal];
    self.acceptButton.titleLabel.font = [Helper fontWithSize:18];
    self.acceptButton.frame = [Helper getRectValue:CGRectMake(40, [Helper isiPhone4] ? 380 : 468, 240, 30)];
    [self.acceptButton addTarget:self action:@selector(acceptAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.acceptButton];
    
    self.otherTransButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.otherTransButton setBackgroundImage:[Helper getImageByImageName:@"other_translater_cell"] forState:UIControlStateNormal];
    [self.otherTransButton setTitle:@"OTHER INTERPRETER" forState:UIControlStateNormal];
    self.otherTransButton.titleLabel.font = [Helper fontWithSize:18];
    self.otherTransButton.frame = [Helper getRectValue:CGRectMake(40, [Helper isiPhone4] ? 420 : 508, 240, 30)];
    [self.otherTransButton addTarget:self action:@selector(otherTransAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.otherTransButton];
}

- (void)backAction:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Do you want to cancel current order ?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alertView show];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    NSString *transName = [self.transDict objectForKey:@"name"];
    NSString *transSurName = [self.transDict objectForKey:@"surname"];
    
    self.transNameLabel.text = [NSString stringWithFormat:@"%@ %@", transName, transSurName];
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self.transDict objectForKey:@"img"]]];
    if ([imageData length] > 0) {
        self.transProfileImage.image = [UIImage imageWithData:imageData];
    }
    
    [self.rateView removeFromSuperview];
    
    NSInteger rate = [[self.transDict objectForKey:@"rating"] integerValue];
    self.rateView = [Helper getRateView:rate];
    self.rateView.center = [Helper getPointValue:CGPointMake(135, 75)];
    [self.profileInfoBkgView addSubview:self.rateView];
        
    self.translatorQBId = [self.transDict objectForKey:@"qb_id"];
    self.translatorOVOId = [self.transDict objectForKey:koVoId];
    self.transId =  [self.transDict objectForKey:@"tr_id"];
    self.reviews = [self.transDict objectForKey:@"review"];
        
    [self.reviewTableView reloadData];
        
    self.proLabel.text = [[self.transDict objectForKey:@"pro"] isEqualToString:@"1"] ? @"Lingvo Pro" : @"Lingvo Pal";
}

#pragma UIAlertViewController
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self cancelOrder];
        NSArray *viewControllers = self.navigationController.viewControllers;
        
        [self.navigationController popToViewController:[viewControllers objectAtIndex:([viewControllers count] - 3)] animated:YES];

    }
}

- (void)otherTransAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)acceptAction:(id)sender {
    
    [self acceptTranslator];
}

-(void) acceptTranslator{
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session acceptTransatorWithId:self.transId withOrderId:self.orderId] ;
    [self startAnimation];
}

-(void) cancelOrder{
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session cancelOrderWithOrderId:self.orderId] ;
}

-(void) getStreamInfo{
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session getStreamInfo:self.streamId];
    
}

#pragma mark PortalSessionDelegate


-(void) acceptTransatorResponse:(NSDictionary *) dict{
    NSLog(@"acceptTransatorResponse %@", dict);
    [self stopAnimation];
    self.streamId = [dict objectForKey:@"stream_id"];
    
    if (self.callType == sntzConfVideoCall || self.callType == sntzVideoCall) {
        [self getStreamInfo];
    }
    
    if (self.callType == sntzPhoneCall){
      //  [Helper showAlertViewWithText:@"Waiting for phone call" delegate:nil];
        PhoneWaitingViewController *viewController = [[PhoneWaitingViewController alloc] init];
        viewController.streamId = self.streamId;
        viewController.transId = self.transId;
        viewController.orderId = self.orderId;
        
        [self.navigationController pushViewController:viewController animated:YES];

        return;
    }
}

-(void) failedToAcceptTransator:(NSDictionary *) dict{
    NSLog(@"failedToAcceptTransator  %@", dict);
    
    [self stopAnimation];
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    if (errorCode == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if (errorCode == 404) {
        [Helper showAlertViewWithText:@"Your order is closed." delegate:nil];
        NSArray *viewControllers = self.navigationController.viewControllers;
        [self.navigationController popToViewController:[viewControllers objectAtIndex:([viewControllers count] - 3)] animated:YES];
    }
}

-(void) timeoutToAcceptTransator:(NSError *) error{
    NSLog(@"timeoutToAcceptTransator");
    [self acceptTranslator];
}

-(void) cancelOrderResponse:(NSDictionary *) dict{
    NSLog(@"cancelOrderResponse %@", dict);
}

-(void) failedToCancelOrder:(NSDictionary *) dict{
    NSLog(@"failedToCancelOrder  %@", dict);
    
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    if (errorCode == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void) timeoutToCancelOrder:(NSError *) error{
    NSLog(@"timeoutToCancelOrder");
    [self cancelOrder];
}

-(void) getStreamInfoResponse:(NSDictionary *)dict{
    NSLog(@"getStreamInfoResponse %@", dict);
    
    NSMutableArray *opponentsIDs = [NSMutableArray arrayWithObject:[NSNumber numberWithInteger:[self.translatorQBId integerValue]]];
    
    NSArray *qbIds = [dict objectForKey:@"qb_users"];
    for (id qbId in qbIds) {
        NSNumber *qbIdNumber = [NSNumber numberWithInteger:[qbId integerValue]];
        [opponentsIDs addObject:qbIdNumber];
    }
    
    if (self.callType == sntzConfVideoCall){
        ConferenceVideoViewController *viewController = [[ConferenceVideoViewController alloc] init];
        viewController.streamId = self.streamId;
        viewController.transId = self.transId;
        viewController.opponentQBIds = opponentsIDs;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    if (self.callType == sntzVideoCall){
        ooVooLoginViewController *viewController = [[ooVooLoginViewController alloc] init];

        viewController.streamId = self.streamId;
        viewController.transId = self.transId;
        viewController.callType = self.callType;
        
        viewController.isInitiator = YES;
        viewController.isTranslator = NO;
        viewController.streamId = self.streamId;

        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:appDelegate.navigationController.viewControllers];
        [viewControllers removeObjectsInRange:NSMakeRange([viewControllers count] - 2, 2)];
        [viewControllers addObject:viewController];
        appDelegate.navigationController.viewControllers = [NSArray arrayWithArray:viewControllers];
    }
}

-(void) failedToGetStreamInfo:(NSDictionary *)dict{
    NSLog(@"failedToGetStreamInfo  %@", dict);
    
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    if (errorCode == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if (errorCode == 100) {
        [Helper showAlertViewWithText:@"Translator not found" delegate:nil];
    }
}

-(void) timeoutToGetStreamInfo:(NSError *)error{
    NSLog(@"timeoutToGetStreamInfo");
    [self getStreamInfo];
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.reviews count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ReviewCell *cell = (ReviewCell *) [tableView dequeueReusableCellWithIdentifier:@"ReviewCell"];
    
    if (cell == nil) {
        cell = [[ReviewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ReviewCell"];
    }
    
    NSDictionary *reviewDict = [self.reviews objectAtIndex:indexPath.row];
    cell.nameLabel.text = [reviewDict objectForKey:@"name"];
    cell.contentLabel.text = [reviewDict objectForKey:@"review"];
    
    [cell setRate:[[reviewDict objectForKey:@"rating"] integerValue]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [Helper getValue:62];
}


@end
