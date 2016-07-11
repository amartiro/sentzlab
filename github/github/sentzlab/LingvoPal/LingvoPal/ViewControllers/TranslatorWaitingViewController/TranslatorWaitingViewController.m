//
//  TranslatorWaitingViewController.m
//  LingvoPal
//
//  Created by Artak on 2/15/16.
//  Copyright © 2016 SentzLab. All rights reserved.
//

#import "TranslatorWaitingViewController.h"
#import "PortalSession.h"
#import "Constants.h"
//#import "ConferenceWaitingViewController.h"
#import "PhoneWaitingViewController.h"
#import "AppDelegate.h"
#import "ooVooLoginViewController.h"

@interface TranslatorWaitingViewController () <PortalSessionDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UIView *middleBKGView;
@property (strong, nonatomic) UILabel *toLabel;
@property (strong, nonatomic) UILabel *fromLabel;
@property (strong, nonatomic) UILabel *callTypeLabel;
@property (strong, nonatomic) UILabel *proLabel;

@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) NSString *streamId;
@property (strong, nonatomic) NSMutableArray *opponentQBIds;

@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation TranslatorWaitingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.opponentQBIds = [NSMutableArray array];
    
    self.bkgImageView.image = [Helper getImageByImageName:@"gradient2"];
    
//    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backButton setImage:[Helper getImageByImageName:@"back_icon"] forState:UIControlStateNormal];
//    backButton.frame = [Helper getRectValue:CGRectMake(5, 20, 26, 42)];
//    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backButton];
    
    UIImageView *timeCircleView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"timer"]];
    timeCircleView.center = [Helper getPointValue:CGPointMake(160, 70)];
    [self.view addSubview:timeCircleView];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(10, 25, 65, 35)]];
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.font = [Helper fontWithSize:33];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    self.timeLabel.shadowOffset = CGSizeMake(1, 1);
    [timeCircleView addSubview:self.timeLabel];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 120, 240, 70)]];
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.font = [Helper fontWithSize:15];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.text = @"You are on the list of interpreters, which we show to customer\nPlease wait couple of minutes, until he decide";
    contentLabel.numberOfLines = 4;
    contentLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    contentLabel.shadowOffset = CGSizeMake(1, 1);
    [self.view addSubview:contentLabel];
    
    self.middleBKGView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 210, 240, 90)]];
    self.middleBKGView.layer.cornerRadius = [Helper getValue:5];
    self.middleBKGView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:.8f];
    [self.view addSubview:self.middleBKGView];
    
    UIImageView *tickImageView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"tick_ellipse"]];
    tickImageView.center = [Helper getPointValue:CGPointMake(15, 15)];
    [self.middleBKGView addSubview:tickImageView];
    
    UILabel *fromStaticLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(30, 5, 40, 20)]];
    fromStaticLabel.text = @"From:";
    fromStaticLabel.textColor = [UIColor colorWithRed:(116.0f/255.0f) green:(116.0f/255.0f) blue:(116.0f/255.0f) alpha:1.0f];
    fromStaticLabel.font = [Helper fontWithSize:12];
    [self.middleBKGView addSubview:fromStaticLabel];
    
    self.fromLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(100, 5, 100, 20)]];
    self.fromLabel.text = [Helper getLanguageFromABRV:self.fromLang];
    self.fromLabel.textColor = [UIColor blackColor];
    self.fromLabel.font = [Helper fontWithSize:12];
    [self.middleBKGView addSubview:self.fromLabel];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"white_long_line"]];
    lineImageView.center = [Helper getPointValue:CGPointMake(120, 30)];
    [self.middleBKGView addSubview:lineImageView];
   
    UIImageView *tickImageView1 = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"tick_ellipse"]];
    tickImageView1.center = [Helper getPointValue:CGPointMake(15, 45)];
    [self.middleBKGView addSubview:tickImageView1];
    
    UILabel *toStaticLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(30, 35, 20, 20)]];
    toStaticLabel.text = @"To:";
    toStaticLabel.textColor = [UIColor colorWithRed:(116.0f/255.0f) green:(116.0f/255.0f) blue:(116.0f/255.0f) alpha:1.0f];
    toStaticLabel.font = [Helper fontWithSize:12];
    [self.middleBKGView addSubview:toStaticLabel];
    
    self.toLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(100, 35, 100, 20)]];
    self.toLabel.text = [Helper getLanguageFromABRV:self.toLang];
    self.toLabel.textColor = [UIColor blackColor];
    self.toLabel.font = [Helper fontWithSize:12];
    [self.middleBKGView addSubview:self.toLabel];
    
    UIImageView *tickImageView2 = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"tick_ellipse"]];
    tickImageView2.center = [Helper getPointValue:CGPointMake(15, 75)];
    [self.middleBKGView addSubview:tickImageView2];
    
    UIImageView *lineImageView2 = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"white_long_line"]];
    lineImageView2.center = [Helper getPointValue:CGPointMake(120, 60)];
    [self.middleBKGView addSubview:lineImageView2];
    
    UILabel *callTypeStaticLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(30, 65, 60, 20)]];
    callTypeStaticLabel.text = @"Call Type:";
    callTypeStaticLabel.textColor = [UIColor colorWithRed:(116.0f/255.0f) green:(116.0f/255.0f) blue:(116.0f/255.0f) alpha:1.0f];
    callTypeStaticLabel.font = [Helper fontWithSize:12];
    [self.middleBKGView addSubview:callTypeStaticLabel];
    
    self.callTypeLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(100, 65, 160, 20)]];
    self.callTypeLabel.text = [Helper getCallType:self.callType];
    self.callTypeLabel.textColor = [UIColor blackColor];
    self.callTypeLabel.font = [Helper fontWithSize:12];
    [self.middleBKGView addSubview:self.callTypeLabel];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setBackgroundImage:[Helper getImageByImageName:@"cancel_cell"] forState:UIControlStateNormal];
    [self.cancelButton setTitle:@"CANCEL" forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [Helper fontWithSize:14];
    self.cancelButton.frame = [Helper getRectValue:CGRectMake(121, [Helper isiPhone4] ? 420 : 508, 78, 30)];
    [self.cancelButton addTarget:self action:@selector(declineOrderAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
    self.cancelButton.hidden = YES;
    
    
//    UIImageView *lineImageView2 = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"white_long_line"]];
//    lineImageView2.center = [Helper getPointValue:CGPointMake(120, 60)];
//    [self.middleBKGView addSubview:lineImageView2];
// 
//    UIImageView *tickImageView2 = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"tick_ellipse"]];
//    tickImageView2.center = [Helper getPointValue:CGPointMake(15, 75)];
//    [self.middleBKGView addSubview:tickImageView2];
//    
//    UILabel *translatorStaticLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(30, 65, 60, 20)]];
//    translatorStaticLabel.text = @"Translator:";
//    translatorStaticLabel.textColor = [UIColor colorWithRed:(116.0f/255.0f) green:(116.0f/255.0f) blue:(116.0f/255.0f) alpha:1.0f];
//    translatorStaticLabel.font = [Helper fontWithSize:12];
//    [self.middleBKGView addSubview:translatorStaticLabel];
//    
//    self.proLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(100, 65, 100, 20)]];
//    self.proLabel.text = self.isPro ? @"Lingvo Pro" : @"Lingvo Pal";
//    self.proLabel.textColor = [UIColor blackColor];
//    self.proLabel.font = [Helper fontWithSize:12];
//    [self.middleBKGView addSubview:self.proLabel];
}

- (void)backAction:(id)sender {
    [Helper deinitializeTimer:self.timer];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getStream];
    
    self.startDate = [NSDate date];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(timerAction:)
                                                     userInfo:nil
                                                      repeats:YES];
    
}

-(void) timerAction:(NSTimer *) timer{
    NSInteger interval = (NSInteger) (120 +[self.startDate timeIntervalSinceNow]);
    
    NSInteger min = interval / 60;
    NSInteger sec = (NSInteger)interval % 60;
    NSString *secStr = [NSString stringWithFormat:(sec < 10 ? @"0%ld" : @"%ld"), (long)sec];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%ld:%@", (long)min, secStr]; //@"5:00";
    
    if (interval <= 0) {
        self.cancelButton.hidden = NO;
        self.timeLabel.hidden = YES;
    }
}

-(void) declineOrderAction:(UIButton *) button{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Do you want to cancel current order ?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alertView show];
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self declineOrder];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getStream{
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session getStreamWithTransId:self.transId withOrderId:self.orderId];
}

-(void) declineOrder{
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session declineOrderFromTransId:self.transId withOrderId:self.orderId];
}


//-(void) getStreamInfo{
//    PortalSession *session = [PortalSession sharedInstance];
//    session.delegate = self;
//    [session getStreamInfo:self.streamId];
//    [self startAnimation];
//}

#pragma mark PortalSessionDelegate

//-(void) getStreamInfoResponse:(NSDictionary *)dict{
//    NSLog(@"getStreamInfoResponse %@", dict);
//    self.opponentQBIds = [NSMutableArray arrayWithObject:[NSNumber numberWithInteger:[self.clientQBID integerValue]]];
//    
//    NSArray *qbIds = [dict objectForKey:@"qb_users"];
//    for (id qbId in qbIds) {
//        NSNumber *qbIdNumber = [NSNumber numberWithInteger:[qbId integerValue]];
//        [self.opponentQBIds addObject:qbIdNumber];
//    }
//    
//    [Helper callVideoToUserIds:self.opponentQBIds withStreamId:self.streamId viewController:self completion:^{
//      //  [self.navigationController popViewControllerAnimated:YES];
//        NSArray *viewControllers = self.navigationController.viewControllers;
//        
//        [self.navigationController popToViewController:[viewControllers objectAtIndex:([viewControllers count] - 4)] animated:YES];
//    }];
//    
//    [self stopAnimation];
//}
//
//-(void) failedToGetStreamInfo:(NSDictionary *)dict{
//    NSLog(@"failedToGetStreamInfo  %@", dict);
//
//    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
//    if (errorCode == 1) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
//
//    if (errorCode == 100) {
//        [Helper showAlertViewWithText:@"Translator not found" delegate:nil];
//        [self stopAnimation];
//    }
//}
//
//-(void) timeoutToGetStreamInfo:(NSError *)error{
//    NSLog(@"timeoutToGetStreamInfo");
//    [self getStreamInfo];
//}
//



-(void) getStreamResponse:(NSDictionary *) dict{
    NSLog(@"getStreamResponse %@", dict);
    
    self.streamId = [dict objectForKey:@"stream_id"];
    self.opponentQBIds = [NSMutableArray arrayWithObject:[NSNumber numberWithInteger:[self.clientQBID integerValue]]];
    if (self.callType == sntzConfVideoCall || self.callType == sntzVideoCall){
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:[dict objectForKey:kStreamId] forKey:kStreamId];
        

        ooVooLoginViewController *viewController = [[ooVooLoginViewController alloc] init];

        viewController.isTranslator = YES;
        viewController.isInitiator = NO;
        viewController.streamId = self.streamId;
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:appDelegate.navigationController.viewControllers];
        [viewControllers replaceObjectAtIndex:([viewControllers count] - 1) withObject:viewController];
        
        appDelegate.navigationController.viewControllers = [NSArray arrayWithArray:viewControllers];
    }
    
    if (self.callType == sntzPhoneCall){
        [Helper showAlertViewWithText:@"Waiting for phone call" delegate:nil];
      
        return;
    }
}

-(void) failedToGetStream:(NSDictionary *) dict{
    NSLog(@"failedToGetStream  %@", dict);
    
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    if (errorCode == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if (errorCode == 100) {
       [self performSelector:@selector(getStream) withObject:nil afterDelay:5.0f];
    }
    
    if (errorCode == 404) {
        [Helper showAlertViewWithText:@"Order is closed." delegate:self];
        [self backAction:nil];
    }
}

-(void) timeoutToGetStream:(NSError *) error{
    NSLog(@"timeoutToGetStream");
    [self getStream];
}

-(void) declineOrderResponse:(NSDictionary *)dict{
    NSLog(@"declineOrderResponse %@", dict);
    [self backAction:nil];
}

-(void) failedToDeclineOrder:(NSDictionary *)dict{
    NSLog(@"failedToDeclineOrder  %@", dict);
    
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    if (errorCode == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if (errorCode == 404) {
        [Helper showAlertViewWithText:@"Order is closed." delegate:self];
    }
}

-(void) timeoutToDeclineOrder:(NSError *)error{
    NSLog(@"timeoutToDeclineOrder");
    [self declineOrder];
}


@end
