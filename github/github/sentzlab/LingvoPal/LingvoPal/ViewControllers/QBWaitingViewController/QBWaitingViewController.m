
//  QBWaitingViewController.m
//  LingvoPal
//
//  Created by Artak on 4/29/16.
//  Copyright © 2016 SentzLab Inc. All rights reserved.
//

#import "QBWaitingViewController.h"
#import "Helper.h"
#import "PortalSession.h"
#import "QBVideoViewController.h"
#import "ChatManager.h"
#import "AppDelegate.h"
#import "Constants.h"
#import <Quickblox/Quickblox.h>
#import "Settings.h"

//const NSTimeInterval kQBAnswerTimeInterval = 300.f;
//const NSTimeInterval kQBRTCDisconnectTimeInterval = 60.f;
//const NSTimeInterval kQBDialingTimeInterval = 5.f;


@interface QBWaitingViewController () <QBRTCClientDelegate, PortalSessionDelegate>

@property (weak, nonatomic) QBRTCSession *currentSession;
@property (nonatomic, strong) UIButton *cancelButton;
@property (strong, nonatomic) Settings *settings;

@property (strong, nonatomic) UINavigationController *nav;

@end

@implementation QBWaitingViewController


- (void)dealloc {
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kStreamId];
    NSLog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}

-(instancetype) init{
    self = [super init];
    if (self) {

    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    contentLabel.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud ";    contentLabel.numberOfLines = 4;
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
    self.cancelButton.hidden = YES;
    
    self.settings = Settings.instance;
    [QBRTCClient.instance addDelegate:self];
}

-(void) closeAction:(UIButton *) button{
    [ChatManager.instance logOut];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
  
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    QBUUser *user = [[QBUUser alloc] init];
    user.ID = [[defaults objectForKey:kQBId] integerValue];
    user.password = [defaults objectForKey:kQBPassword];
    
    [self logInChatWithUser:user];
    
    if (self.isTranslator) {
        [self performSelector:@selector(showCancelButton) withObject:nil afterDelay:20.0f];
    }
}

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(void) showCancelButton{
    self.cancelButton.hidden = NO;
}

-(void) cancelStreamAction:(UIButton *) button{
    [self cancelStream];
}

- (void)logInChatWithUser:(QBUUser *)user {
      NSLog(@"QBWaitingViewController qbID: %ld ", (long)user.ID);

    
   // if (QBChat.instance.currentUser.ID != user.ID) {
        if (QBChat.instance.isConnected) {
            [ChatManager.instance logOut];
            [self performSelector:@selector(logInChatWithUser:) withObject:user afterDelay:5.0f];
            return;
        } else {
            [Helper loginQBUser:user completion:^(BOOL error){
                if (!error) {
                    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
                    appDelegate.ownQBId = user.ID;
                    
                    NSLog(@"QB Login chat logged in %ld", (long)user.ID);
                } else {
                    [Helper showAlertViewWithText:[NSString stringWithFormat:@"Failed to login with user %ld", (long) user.ID] delegate:nil];
                }
            }];
        }
//    }
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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)0), dispatch_get_main_queue(), ^{ //(1.5 * NSEC_PER_SEC)
            self.nav.view.userInteractionEnabled = NO;
            [self.nav dismissViewControllerAnimated:NO completion:nil];
         
            self.currentSession = nil;
            self.nav = nil;
        });
    }
}

-(void) cancelStream{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *streamId = [defaults valueForKey:kStreamId];
    NSString *transId =  [defaults objectForKey:kTranslatorId];
    
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session cancelStreamWithStreamId:streamId andTransId:transId];
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

-(void) timeoutToCancelStream:(NSError *) error{
    NSLog(@"timeoutToCancelStream");
    [self cancelStream];
}

@end
