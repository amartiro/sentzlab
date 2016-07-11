//
//  QBWaitViewController.m
//  LingvoPal
//
//  Created by Artak Martirosyan on 5/18/16.
//  Copyright © 2016 SentzLab Inc. All rights reserved.
//

#import "QBWaitViewController.h"
#import "QBVideoViewController.h"
#import "Helper.h"
#import "ChatManager.h"
#import "Constants.h"
#import "PortalSession.h"
#import "RateViewController.h"
#import "AppDelegate.h"

@interface QBWaitViewController () <QBRTCClientDelegate, PortalSessionDelegate>

@property (strong, nonatomic) UINavigationController *nav;
@property (weak, nonatomic) QBRTCSession *currentSession;

@property (nonatomic, strong) UIButton *cancelButton;


@end

@implementation QBWaitViewController

- (void)dealloc {
    NSLog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.bkgImageView.image = [Helper getImageByImageName:@"welcome_gradient"];
    
    UIButton * closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[Helper getImageByImageName:@"close_icon"] forState:UIControlStateNormal];
    closeButton.frame = [Helper getRectValue:CGRectMake(0, 20, 60, 60)];
    [closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    
    UIImageView *videoIconImageView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"video_wait_icon"]];
    videoIconImageView.center = [Helper getPointValue:CGPointMake(160, 88)];
    [self.view addSubview:videoIconImageView];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(15, 130, 290, 70)]];
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.font = [Helper fontWithSize:15];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.text = @"You are about to connect for video call.";
    contentLabel.numberOfLines = 4;
    [self.view addSubview:contentLabel];
    
    UIImageView *waitingImageView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"waiting1"]];
    waitingImageView.center = [Helper getPointValue:CGPointMake(160, 320)];
    waitingImageView.animationImages = [NSArray arrayWithObjects:
                                        [Helper getImageByImageName:@"waiting1"],
                                        [Helper getImageByImageName:@"waiting2"],
                                        [Helper getImageByImageName:@"waiting3"],
                                        [Helper getImageByImageName:@"waiting4"],
                                        [Helper getImageByImageName:@"waiting5"],
                                        [Helper getImageByImageName:@"waiting6"],
                                        [Helper getImageByImageName:@"waiting7"],
                                        [Helper getImageByImageName:@"waiting8"],
                                        [Helper getImageByImageName:@"waiting9"],
                                        [Helper getImageByImageName:@"waiting10"],
                                        [Helper getImageByImageName:@"waiting11"],
                                        [Helper getImageByImageName:@"waiting12"],
                                        [Helper getImageByImageName:@"waiting13"],
                                        [Helper getImageByImageName:@"waiting14"],
                                        [Helper getImageByImageName:@"waiting15"],
                                        [Helper getImageByImageName:@"waiting16"],
                                        [Helper getImageByImageName:@"waiting17"],
                                        [Helper getImageByImageName:@"waiting18"],
                                        [Helper getImageByImageName:@"waiting19"],
                                        nil];
    
    [self.view addSubview:waitingImageView];
    [waitingImageView startAnimating];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setBackgroundImage:[Helper getImageByImageName:@"cancel_cell"] forState:UIControlStateNormal];
    [self.cancelButton setTitle:@"CANCEL" forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [Helper fontWithSize:14];
    self.cancelButton.frame = [Helper getRectValue:CGRectMake(121, [Helper isiPhone4] ? 420 : 508, 78, 30)];
    [self.cancelButton addTarget:self action:@selector(cancelStreamAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
    self.cancelButton.hidden = !self.isTranslator;

    [QBRTCClient.instance addDelegate:self];
}

-(void) closeAction:(UIButton *) button{
    [ChatManager.instance logOut];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    if (self.isInitiator) {
        
        NSParameterAssert(!self.currentSession);
        NSParameterAssert(!self.nav);
        
        QBRTCSession *session = [QBRTCClient.instance createNewSessionWithOpponents:self.opponentQBIds withConferenceType:QBRTCConferenceTypeVideo];
        if (session) {
            self.currentSession = session;
            
            QBVideoViewController *viewController = [[QBVideoViewController alloc] init];
            viewController.session = session;
            viewController.streamId = self.streamId;
            viewController.transId = self.transId;
            viewController.translatorQBID = [self.opponentQBIds objectAtIndex:0];
            viewController.callType = self.callType;
            
            self.nav = [[UINavigationController alloc] initWithRootViewController:viewController];
            
            [self presentViewController:self.nav animated:NO completion:nil];
        } else {
            [Helper showAlertViewWithText:@"You should login to use chat API. Session hasn’t been created. Please try to relogin the chat." delegate:nil];
        }
    }
    
    if (self.isTranslator) {
        [self performSelector:@selector(showCancelButton) withObject:nil afterDelay:20.0f];
    }
}

#pragma mark - QBWebRTCChatDelegate

- (void)didReceiveNewSession:(QBRTCSession *)session userInfo:(NSDictionary *)userInfo {
    
    if (self.currentSession) {
        
        [session rejectCall:@{@"reject" : @"busy"}];
        return;
    }
    
    self.currentSession = session;
    
    [QBRTCSoundRouter.instance initialize];
    
    NSParameterAssert(!self.nav);
    
    QBVideoViewController *viewController = [[QBVideoViewController alloc] init];
    viewController.translatorQBID = [NSNumber numberWithInteger:[[userInfo objectForKey:@"tr_qb_id"] integerValue]];
    viewController.streamId = [userInfo objectForKey:@"stream_id"];
    
    NSLog(@"GUEST OPPONENT IDS %@", session.opponentsIDs);
    
    self.nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    viewController.session = session;
    [self presentViewController:self.nav animated:NO completion:nil];
}

- (void)sessionDidClose:(QBRTCSession *)session {
    
    if (session == self.currentSession ) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self closeAction:nil];
            self.nav.view.userInteractionEnabled = NO;
            [self.nav dismissViewControllerAnimated:NO completion:nil];
            self.currentSession = nil;
            self.nav = nil;

            [self.navigationController popViewControllerAnimated:YES];
            
            if (self.isInitiator) {
                [self setHistory];
                [self openRateViewController:@"New screen with spent money, you are initiator and tranlsator hunged up"];
            }
            
//            if (self.isTranslator && self.streamId) {
//                [self setHistory];
//            }
            
//          [self.navigationController popToRootViewControllerAnimated:YES];
//            NSArray* viewControllers = self.navigationController.viewControllers;
//            
//            [self.navigationController popToViewController:[viewControllers objectAtIndex:(viewControllers.count - 3)] animated:YES];
        });
    }
}

-(void) showCancelButton{
    self.cancelButton.hidden = NO;
}
-(void) openRateViewController:(NSString *) content{
    RateViewController *viewController = [[RateViewController alloc] init];
    viewController.content = content;
    viewController.transId = self.transId;
    
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:appDelegate.navigationController.viewControllers];
    [viewControllers replaceObjectAtIndex:([viewControllers count] - 1) withObject:viewController];
    
    appDelegate.navigationController.viewControllers = [NSArray arrayWithArray:viewControllers];
}

-(void) cancelStreamAction:(UIButton *) button{
    [self cancelStream];
}

-(void) cancelStream{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *streamId = [defaults valueForKey:kStreamId];
    NSString *transId =  [defaults objectForKey:kTranslatorId];
    
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session cancelStreamWithStreamId:streamId andTransId:transId];
}

-(void) setHistory{
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session setHistoryWithStreamId:self.streamId] ;
}


-(void) cancelStreamResponse:(NSDictionary *) dict{
    NSLog(@"cancelStreamResponse %@", dict);
    [self closeAction:nil];
}

-(void) failedToCancelStream:(NSDictionary *) dict{
    NSLog(@"failedToCancelStream  %@", dict);
    
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    if (errorCode == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void) setHistoryResponse:(NSDictionary *) dict{
    NSLog(@"setHistoryResponse %@", dict);
}

-(void) failedToSetHIstory:(NSDictionary *) dict{
    NSLog(@"failedToSetHIstory  %@", dict);
    
    //    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    //    if (errorCode == 1) {
    //        [self.navigationController popToRootViewControllerAnimated:YES];
    //    }
}

-(void) timeoutToSetHistory:(NSError *)error{
    NSLog(@"timeoutToSetHistory");
    [self setHistory];
}

@end
