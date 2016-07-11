////
////  QBVideoViewController.m
////  LingvoPal
////
////  Created by Artak on 4/29/16.
////  Copyright © 2016 SentzLab Inc. All rights reserved.
////
//
//#import "QBVideoViewController.h"
//#import "ChatManager.h"
//#import "LocalVideoView.h"
//#import "QMSoundManager.h"
//#import "Settings.h"
//
//#import "PortalSession.h"
//#import "Helper.h"
//
//#import "AppDelegate.h"
//
//#import "OpponentVideoView.h"
//#import "MoneyInformingViewController.h"
//#import "RateViewController.h"
//#import "Constants.h"
//
//const NSTimeInterval k2RefreshTimeInterval = 1.f;
//
//@interface QBVideoViewController ()<QBRTCClientDelegate, PortalSessionDelegate>
//
//@property (strong, nonatomic) UIView *toolBarView;
//@property (nonatomic, assign) BOOL toolbarVisible;
//@property (assign, nonatomic) NSTimeInterval timeDuration;
//@property (strong, nonatomic) NSTimer *callTimer;
//
//@property (strong, nonatomic) QBRTCCameraCapture *cameraCapture;
//
//@property (strong, nonatomic) NSMutableDictionary *videoViews;
//
//@property (assign, nonatomic) BOOL isOffer;
//
//@property (nonatomic, strong) UIButton *micrButton;
//@property (nonatomic, strong) UIButton *videoButton;
//
//@property (nonatomic, strong) UIButton *callEndButton;
//@property (nonatomic, strong) UIButton *cameraButton;
//
//@property (nonatomic, strong) UIButton *shareButton;
//@property (nonatomic, strong) UIButton *shareActvityButton;
//@property (nonatomic, strong) UIButton *closeShareView;
//@property (nonatomic, strong) UIView *shareView;
//
//@property (nonatomic, strong) LocalVideoView *ownVideoView;
//
//@property (strong, nonatomic) NSMutableArray *activeUsers;
//
//@property (nonatomic, assign) BOOL translatorGone;
//@property (nonatomic, assign) BOOL hungUpedByMe;
//@property (nonatomic, assign) BOOL wasConnected;
//
//
//@end
//
//
//
//@implementation QBVideoViewController
//
//- (void)dealloc {
//    NSLog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
//}
//
//-(instancetype) init{
//    self = [super init];
//    if (self) {
//        self.toolbarVisible = YES;
//    }
//    
//    return self;
//}
//
//- (NSNumber *)currentUserID {
//    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
//    
//    return [NSNumber numberWithUnsignedInteger:appDelegate.ownQBId];
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//   
//    [self.navigationController setNavigationBarHidden:YES];
//  
//    // Do any additional setup after loading the view.
//    self.activeUsers = [NSMutableArray array];
//    self.videoViews = [NSMutableDictionary dictionary];
//    self.isOffer = ([[self currentUserID] isEqual:self.session.initiatorID]);
//    
//    NSLog(@"OWN QBID %@, INITIIATOR QBID %@ , OPPONENT QBID %@", [self currentUserID] , self.session.initiatorID , self.session.opponentsIDs);
//    
//    if (self.session.conferenceType == QBRTCConferenceTypeVideo) {
//        
//        Settings *settings = Settings.instance;
//        self.cameraCapture = [[QBRTCCameraCapture alloc] initWithVideoFormat:settings.videoFormat
//                                                                    position:settings.preferredCameraPostion];
//        [self.cameraCapture startSession];
//    }
//    
//
//    self.view.backgroundColor = [UIColor colorWithRed:0.1465 green:0.1465 blue:0.1465 alpha:1.0];
//    [QBRTCClient.instance addDelegate:self];
//    [QBRTCSoundRouter.instance initialize];
//  
//    self.isOffer ? [self startCall] : [self acceptCall];
//    
//    if (self.session.conferenceType == QBRTCConferenceTypeAudio) {
//        [QBRTCSoundRouter instance].currentSoundRoute = QBRTCSoundRouteReceiver;
//    }
//    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
//    [self.view addGestureRecognizer:tapGesture];
//    
//    self.toolBarView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, [Helper isiPhone4] ? 400 : 488 , 320, 80)]];
//    self.toolBarView.backgroundColor = [UIColor colorWithWhite:0 alpha:.3f];
//    [self.view addSubview:self.toolBarView];
//    
//    BOOL isConference = ((self.callType == sntzConfVideoCall) && self.isOffer);
//    
//    CGFloat buttonWidth = isConference ? 60 : 80;
//    
//    self.micrButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.micrButton.frame = [Helper getRectValue:CGRectMake(0, 0, buttonWidth, 80)];
//    [self.micrButton setImage:[Helper getImageByImageName:@"microphone_select_icon"] forState:UIControlStateNormal];
//    [self.micrButton addTarget:self action:@selector(micrButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.toolBarView addSubview:self.micrButton];
//    
//    self.callEndButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.callEndButton.frame = [Helper getRectValue:CGRectMake(isConference ? 2*buttonWidth : 240, 0, 80, 80)];
//    [self.callEndButton setImage:[Helper getImageByImageName:(isConference ? @"end_call_big_icon" : @"end_call_icon")] forState:UIControlStateNormal];
//    [self.callEndButton addTarget:self action:@selector(endCallAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.toolBarView addSubview:self.callEndButton];
//    
//    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.shareButton.frame = [Helper getRectValue:CGRectMake(260 , 0, buttonWidth, 80)];
//    self.shareButton.hidden = !isConference;
//    [self.shareButton setImage:[Helper getImageByImageName:@"share_icon"] forState:UIControlStateNormal];
//    [self.shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.toolBarView addSubview:self.shareButton];
//    
//    self.videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.videoButton.frame = [Helper getRectValue:CGRectMake(buttonWidth, 0, buttonWidth, 80)];
//    [self.videoButton setImage:[Helper getImageByImageName:@"video_call_select_icon"] forState:UIControlStateNormal];
//    [self.videoButton addTarget:self action:@selector(videoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.toolBarView addSubview:self.videoButton];
//    
//    self.cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.cameraButton.frame = [Helper getRectValue:CGRectMake(isConference ? 200 : 160, 0, buttonWidth, 80)];
//    [self.cameraButton setImage:[Helper getImageByImageName:@"flip_camera_icon"] forState:UIControlStateNormal];
//    [self.cameraButton addTarget:self action:@selector(flipButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.toolBarView addSubview:self.cameraButton];
//    
//    if (isConference) {
//        self.shareView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(2, -155, 316, 150)]];
//        self.shareView.layer.cornerRadius = [Helper getValue:5];
//        self.shareView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0f];
//        [self.view addSubview:self.shareView];
//        
//        UILabel *contentLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(20, 30, 280, 40)]];
//        contentLabel.textColor = [UIColor blackColor];
//        contentLabel.font = [Helper fontWithSize:18];
//        contentLabel.textAlignment = NSTextAlignmentLeft;
//        contentLabel.text = @"Share this link to invite participants to this call";
//        contentLabel.numberOfLines = 2;
//        [self.shareView addSubview:contentLabel];
//        
//        UILabel *psLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 85, 240, 20)]];
//        psLabel.textColor = [UIColor blackColor];
//        psLabel.font = [Helper fontWithSize:12];
//        psLabel.textAlignment = NSTextAlignmentLeft;
//        psLabel.text = @"P.S. Remember you can invite only two person";
//        psLabel.adjustsFontSizeToFitWidth = YES;
//        [self.shareView addSubview:psLabel];
//        
//        self.shareActvityButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.shareActvityButton.frame = [Helper getRectValue:CGRectMake(40 , 110, 240, 30)];
//        [self.shareActvityButton setBackgroundImage:[Helper getImageByImageName:@"share_popup_cell"] forState:UIControlStateNormal];
//        [self.shareActvityButton setTitle:@"SHARE" forState:UIControlStateNormal];
//        [self.shareActvityButton addTarget:self action:@selector(shareActvityAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self.shareView addSubview:self.shareActvityButton];
//    }
//}
//
//-(void) shareAction:(UIButton *) button{
//    [UIView beginAnimations:@"shadowMoveRestAway" context:nil];
//    [UIView setAnimationDuration:0.3];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//
//    if (self.shareView.center.y < 0) {
//        self.shareView.center = [Helper getPointValue:CGPointMake(160, 70)];
//    } else{
//        self.shareView.center = [Helper getPointValue:CGPointMake(160, -80)];
//     }
//
//    [UIView commitAnimations];
//
//}
//
//-(void) shareActvityAction:(UIButton *) button{
//    NSString *linkStr = [NSString stringWithFormat:@"http://trans.sentzhost.com/api/red.php?stream_id=%@", self.streamId];
//
//    NSURL *shareURL = [NSURL URLWithString:linkStr];
//    
//    NSArray *itemsToShare = [NSArray arrayWithObject:shareURL];
//    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
//    [self presentViewController:activityVC animated:YES completion:^{ self.shareView.center = [Helper getPointValue:CGPointMake(160, -80)]; }];
//}
//
//-(void) tapGestureAction:(UITapGestureRecognizer *) gesture{
//    
//    [UIView beginAnimations:@"shadowMoveRestAway" context:nil];
//    [UIView setAnimationDuration:0.3];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    
//    self.toolbarVisible = !self.toolbarVisible;
//    
//    if (self.toolbarVisible) {
//        self.toolBarView.frame = [Helper getRectValue:CGRectMake(0, [Helper isiPhone4] ? 400 : 488 , 320, 80)];
//    } else {
//        self.shareView.center = [Helper getPointValue:CGPointMake(160, -80)];
//        self.toolBarView.frame = [Helper getRectValue:CGRectMake(0, [Helper isiPhone4] ? 480 : 568 , 320, 80)];
//    }
//    
//    [UIView commitAnimations];
//    
//}
//
//
//
//-(void) videoButtonAction:(UIButton *) button{
//    self.session.localMediaStream.videoTrack.enabled ^=1;
//    self.ownVideoView.hidden = !self.session.localMediaStream.videoTrack.enabled;
//    if (self.session.localMediaStream.videoTrack.enabled) {
//        [self.videoButton setImage:[Helper getImageByImageName:@"video_call_select_icon"] forState:UIControlStateNormal];
//    } else {
//        [self.videoButton setImage:[Helper getImageByImageName:@"video_call_icon"] forState:UIControlStateNormal];
//    }
//}
//
//-(void) micrButtonAction:(UIButton *) button{
//    self.session.localMediaStream.audioTrack.enabled ^=1;
//    
//    if (self.session.localMediaStream.audioTrack.enabled) {
//        [self.micrButton setImage:[Helper getImageByImageName:@"microphone_select_icon"] forState:UIControlStateNormal];
//    } else {
//        [self.micrButton setImage:[Helper getImageByImageName:@"microphone_icon"] forState:UIControlStateNormal];
//    }
//}
//
//-(void) endCallAction:(UIButton *) button{
//    if([self.session.initiatorID isEqual:[self currentUserID]]){
//        [self setHistory];
//    }
//    
//    if([self.translatorQBID isEqual:[self currentUserID]]){
//        [self setHistory];
//    }
//    
//    self.hungUpedByMe = YES;
//    [self.session hangUp:[NSDictionary dictionaryWithObject:@"hang up" forKey:@"reason"]];
//    
//    if ([self.translatorQBID isEqualToNumber:[self currentUserID]]){
//        //    [self openMoneyViewController:@"New screen with earned money, you are translator and you hunged up"];
//    } else if ([self.session.initiatorID isEqualToNumber:[self currentUserID]]){
//        [self openRateViewController:@"New screen with spent money, you are initiator and you hunged up"];
//    } else {
//        [self dismissAction];
//    }
//}
//
//-(void) openMoneyViewController:(NSString *) content{
//    MoneyInformingViewController *viewController = [[MoneyInformingViewController alloc] init];
//    viewController.content = content;
//    
//    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
//    
//    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:appDelegate.navigationController.viewControllers];
//    [viewControllers replaceObjectAtIndex:([viewControllers count] - 1) withObject:viewController];
//    
//    appDelegate.navigationController.viewControllers = [NSArray arrayWithArray:viewControllers];
//
//    [self dismissAction];
//}
//
//-(void) openRateViewController:(NSString *) content{
//    RateViewController *viewController = [[RateViewController alloc] init];
//    viewController.content = content;
//    viewController.transId = self.transId;
//    
//    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
//    
//    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:appDelegate.navigationController.viewControllers];
//    [viewControllers replaceObjectAtIndex:([viewControllers count] - 1) withObject:viewController];
//    
//    appDelegate.navigationController.viewControllers = [NSArray arrayWithArray:viewControllers];
//    
//    [self dismissAction];
//}
//
//-(void) dismissAction{
//    //[self closeQBParts];
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//-(void) setHistory{
//    PortalSession *session = [PortalSession sharedInstance];
//    session.delegate = self;
//    [session setHistoryWithStreamId:self.streamId] ;
//}
//
//-(void) startTime{
//    PortalSession *session = [PortalSession sharedInstance];
//    session.delegate = self;
//    [session startTimeWithStreamId:self.streamId] ;
//}
//
//-(void) stopTime{
//    PortalSession *session = [PortalSession sharedInstance];
//    session.delegate = self;
//    [session stopTimeWithStreamId:self.streamId] ;
//}
//
//-(void) checkStream{
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    NSString *transId =  [defaults objectForKey:kTranslatorId];
//    NSString *uuid = [Helper GetUUID];
//    
//    PortalSession *session = [PortalSession sharedInstance];
//    session.delegate = self;
//    [session checkStreamWithTransId:transId withUUID:uuid];
//}
//
//-(void) getStreamTranslator{
//    PortalSession *session = [PortalSession sharedInstance];
//    session.delegate = self;
//    [session getStreamTranslatorWithStreamId:self.streamId andTransId:self.transId];
//}
//
//
//-(void)  flipButtonAction:(UIButton *) button{
//    
//    AVCaptureDevicePosition newPosition = (([self.cameraCapture currentPosition] == AVCaptureDevicePositionBack) ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack);
//    
//    if ([self.cameraCapture hasCameraForPosition:newPosition]) {
//        [self.cameraCapture selectCameraPosition:newPosition];
//    }
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    
//    [QBRTCSoundRouter.instance addObserver:self forKeyPath:@"currentSoundRoute" options:NSKeyValueObservingOptionNew context:nil];
//
//    self.title = @"Connecting...";
//}
//
//-(void) viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    [QBRTCSoundRouter.instance removeObserver:self forKeyPath:@"currentSoundRoute"];
//}
//
//-(void) viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    
//    self.ownVideoView = [[LocalVideoView alloc] initWithPreviewlayer:self.cameraCapture.previewLayer];
//    self.ownVideoView.frame = [Helper getRectValue:CGRectMake(0, 20, 320, 548)];
//    
//    [self.view addSubview:self.ownVideoView];
//    [self.view sendSubviewToBack:self.ownVideoView];
//}
//
//-(void) constructVideoViewWithOpponentID:(NSNumber *)opponentID{
//    OpponentVideoView* result = self.videoViews[opponentID];
//    QBRTCVideoTrack *remoteVideoTrak = [self.session remoteVideoTrackWithUserID:opponentID];
//    
//    if (!result && remoteVideoTrak) {
//        QBRTCRemoteVideoView *remoteVideoView = [[QBRTCRemoteVideoView alloc] initWithFrame:self.view.bounds];
//        [remoteVideoView setVideoTrack:remoteVideoTrak];
//        
//        OpponentVideoView *oppVideoView = [[OpponentVideoView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 0, 100,  125)]];
//        [oppVideoView setVideoView:remoteVideoView];
//        [self.view addSubview:oppVideoView];
//        [self.view sendSubviewToBack:oppVideoView];
//        
//        self.videoViews[opponentID] = oppVideoView;
//    }
//}
//
//- (void)startCall {//,@"full_name",
//    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@", self.translatorQBID],  @"tr_qb_id", self.streamId, @"stream_id",  nil];
//    [self.session startCall:userInfo];
//}
//
//
//- (void)acceptCall {
//    //Accept call
//    NSDictionary *userInfo = @{@"acceptCall" : @"userInfo"};
//    [self.session acceptCall:userInfo];
//}
//
//- (void)session:(QBRTCSession *)session updatedStatsReport:(QBRTCStatsReport *)report forUserID:(NSNumber *)userID {
//    
//
//}
//
//- (void)session:(QBRTCSession *)session initializedLocalMediaStream:(QBRTCMediaStream *)mediaStream {
//    NSLog(@"initializedLocalMediaStream: ");
//    session.localMediaStream.videoTrack.videoCapture = self.cameraCapture;
//}
///**
// * Called in case when you are calling to user, but he hasn't answered
// */
//- (void)session:(QBRTCSession *)session userDidNotRespond:(NSNumber *)userID {
//    
//    if (session == self.session) {
//        NSLog(@"userDidNotRespond: %@", userID);
//        OpponentVideoView *oppVideoView = [self getOppontentVideoView:userID];
//        oppVideoView.connectionState = [self.session connectionStateForUser:userID];
//    }
//}
//
//- (void)session:(QBRTCSession *)session acceptedByUser:(NSNumber *)userID userInfo:(NSDictionary *)userInfo {
//    
//    if (session == self.session) {
//        NSLog(@"acceptedByUser: %@", userID);
//        OpponentVideoView *oppVideoView = [self getOppontentVideoView:userID];
//        oppVideoView.connectionState = [self.session connectionStateForUser:userID];
//    }
//}
//
///**
// * Called in case when opponent has rejected you call
// */
//- (void)session:(QBRTCSession *)session rejectedByUser:(NSNumber *)userID userInfo:(NSDictionary *)userInfo {
//    
//    if (session == self.session) {
//        NSLog(@"rejectedByUser: %@", userID);
//        OpponentVideoView *oppVideoView = [self getOppontentVideoView:userID];
//        oppVideoView.connectionState = [self.session connectionStateForUser:userID];
//    }
//}
//
///**
// *  Called in case when opponent hung up
// */
//- (void)session:(QBRTCSession *)session hungUpByUser:(NSNumber *)userID userInfo:(NSDictionary *)userInfo {
//    
//    if (session == self.session) {
//        NSLog(@"hungUpByUser: %@", userID);
//        OpponentVideoView *oppVideoView = [self getOppontentVideoView:userID];
//        oppVideoView.connectionState = [self.session connectionStateForUser:userID];
//        
//        if ([userID isEqualToNumber:self.translatorQBID]) {
//            if ([session.initiatorID isEqualToNumber:[self currentUserID]]){
//                [self openRateViewController:@"New screen with spent money, you are initiator and tranlsator hunged up"];
//            }
////            else {
////                [self dismissAction];
////            }
//        }
//        
//       if ([self.session.initiatorID isEqualToNumber:userID]){
//            if ([self.translatorQBID isEqualToNumber:[self currentUserID]]){
//                [self openMoneyViewController:@"New screen with earned money, you are translator and you hunged up"];
//            } else {
//                [self dismissAction];
//            }
//       }
//    }
//}
//
///**
// *  Called in case when receive remote video track from opponent
// */
//
//- (void)session:(QBRTCSession *)session receivedRemoteVideoTrack:(QBRTCVideoTrack *)videoTrack fromUser:(NSNumber *)userID {
//    
//    if (session == self.session) {
//        NSLog(@"receivedRemoteVideoTrack : %@", userID);
//        [self.activeUsers addObject:userID];
//        [self updateVideoViews];
//    }
//}
//
///**
// *  Called in case when connection initiated
// */
//- (void)session:(QBRTCSession *)session startedConnectingToUser:(NSNumber *)userID {
//    
//    if (session == self.session) {
//        NSLog(@"startedConnectionToUser: %@", userID);
//        OpponentVideoView *oppVideoView = [self getOppontentVideoView:userID];
//        oppVideoView.connectionState = [self.session connectionStateForUser:userID];
//    }
//}
//
///**
// *  Called in case when connection is established with opponent
// */
//- (void)session:(QBRTCSession *)session connectedToUser:(NSNumber *)userID {
//    NSLog(@"connectedToUser: %@", userID);
//    
//    if (session == self.session) {
//        if (!self.callTimer) {
//            self.callTimer = [NSTimer scheduledTimerWithTimeInterval:k2RefreshTimeInterval target:self
//                                                            selector:@selector(refreshCallTime:) userInfo:nil repeats:YES];
//        }
//        
//        if (self.translatorGone){
//            [self getStreamTranslator];
//        }
//            
//        
//        if ([self.translatorQBID isEqual:userID] && self.translatorGone){
//            [self startTime];
//        }
//        
//        OpponentVideoView *oppVideoView = [self getOppontentVideoView:userID];
//        oppVideoView.connectionState = [self.session connectionStateForUser:userID];
//    }
//}
//
///**
// *  Called in case when connection state changed
// */
//- (void)session:(QBRTCSession *)session connectionClosedForUser:(NSNumber *)userID {
//    NSLog(@"connectionClosedForUser: %@", userID);
//    if (session == self.session) {
//        OpponentVideoView *oppVideoView = [self getOppontentVideoView:userID];
//        oppVideoView.connectionState = [self.session connectionStateForUser:userID];
//        
//        [self.activeUsers removeObject:userID];
//        [self.videoViews removeObjectForKey:userID];
//        [oppVideoView setVideoView:nil];
//        [oppVideoView removeFromSuperview];
//        [self updateVideoViews];
//        
//        
//        if ([userID isEqualToNumber:session.initiatorID]) {
//            if ([self.translatorQBID isEqualToNumber:[self currentUserID]]){
//                self.wasConnected = [Helper isConnected];
//                [self checkStream];
//                
//            }
//            else {
//                //[self dismissAction];
//                [self.session hangUp:[NSDictionary dictionaryWithObject:@"hang up" forKey:@"reason"]];
//            }
//        }
//        
//        if ([userID isEqual:self.translatorQBID]){
//            if ([[self currentUserID] isEqualToNumber:session.initiatorID]) {
//                [self stopTime];
//                self.translatorGone = YES;
//            }
//        }
//        
//
//    }
//}
//
///**
// *  Called in case when disconnected from opponent
// */
//- (void)session:(QBRTCSession *)session disconnectedFromUser:(NSNumber *)userID {
//    NSLog(@"disconnectedFromUser: %@", userID);
//    
//    if (session == self.session) {
//        OpponentVideoView *oppVideoView = [self getOppontentVideoView:userID];
//        oppVideoView.connectionState = [self.session connectionStateForUser:userID];
//    }
//}
//
///**
// *  Called in case when disconnected by timeout
// */
//- (void)session:(QBRTCSession *)session disconnectedByTimeoutFromUser:(NSNumber *)userID {
//    NSLog(@"disconnectedByTimeoutFromUser: %@", userID);
//    
//    if (session == self.session) {
//        OpponentVideoView *oppVideoView = [self getOppontentVideoView:userID];
//        oppVideoView.connectionState = [self.session connectionStateForUser:userID];
//    }
//}
//
///**
// *  Called in case when connection failed with user
// */
//- (void)session:(QBRTCSession *)session connectionFailedWithUser:(NSNumber *)userID {
//    NSLog(@"connectionFailedWithUser: %@", userID);
//    if (session == self.session) {
//        OpponentVideoView *oppVideoView = [self getOppontentVideoView:userID];
//        oppVideoView.connectionState = [self.session connectionStateForUser:userID];
//    }
//}
//
//-(OpponentVideoView *) getOppontentVideoView :(NSNumber *) userID{
//    return self.videoViews[userID];
//}
//
//-(void) updateVideoViews{
//    NSNumber *userID = [self.activeUsers lastObject];
//    
//    [self constructVideoViewWithOpponentID:userID];
//    OpponentVideoView *oppView = self.videoViews[userID];
//    if ([userID isEqualToNumber:self.translatorQBID]) {
//        oppView.roleLabel.text = @"Interpreter";
//    }
//    
//    if ([userID isEqualToNumber:self.session.initiatorID]) {
//        oppView.roleLabel.text = @"Initiator";
//    }
//    
//    NSInteger usersCount = [self.activeUsers count];
//    switch (usersCount) {
//        case 0:
//            self.ownVideoView.frame = [Helper getRectValue:CGRectMake(0, 20, 320, 548)];
//            break;
//        case 1:{
//            self.ownVideoView.frame = [Helper getRectValue:CGRectMake(10, 363, 100, 125)];
//            NSNumber *user1ID = [self.activeUsers objectAtIndex:0];
//            OpponentVideoView *user1View = self.videoViews[user1ID];
//            user1View.frame = [Helper getRectValue:CGRectMake(0, 20, 320, 548)];
//        }
//            break;
//        case 2:{
//            
//            NSNumber *user1ID = [self.activeUsers objectAtIndex:0];
//            OpponentVideoView *user1View = self.videoViews[user1ID];
//            user1View.frame = [Helper getRectValue:CGRectMake(20, 20, 130, 162.5f)];
//            
//            NSNumber *user2ID = [self.activeUsers objectAtIndex:1];
//            OpponentVideoView *user2View = self.videoViews[user2ID];
//            user2View.frame = [Helper getRectValue:CGRectMake(170, 20, 130, 162.5f)];
//        }
//            break;
//        case 3:{
//            
//            NSNumber *user1ID = [self.activeUsers objectAtIndex:0];
//            OpponentVideoView *user1View = self.videoViews[user1ID];
//            user1View.frame = [Helper getRectValue:CGRectMake(20, 20, 130, 162.5f)];
//            
//            NSNumber *user2ID = [self.activeUsers objectAtIndex:1];
//            OpponentVideoView *user2View = self.videoViews[user2ID];
//            user2View.frame = [Helper getRectValue:CGRectMake(170, 20, 130, 162.5f)];
//            
//            NSNumber *user3ID = [self.activeUsers objectAtIndex:2];
//            OpponentVideoView *user3View = self.videoViews[user3ID];
//            user3View.frame = [Helper getRectValue:CGRectMake(95, 190, 130, 162.5f)];
//        }
//            break;
//        case 4:{
//            
//            NSNumber *user1ID = [self.activeUsers objectAtIndex:0];
//            OpponentVideoView *user1View = self.videoViews[user1ID];
//            user1View.frame = [Helper getRectValue:CGRectMake(20, 20, 130, 162.5f)];
//            
//            NSNumber *user2ID = [self.activeUsers objectAtIndex:1];
//            OpponentVideoView *user2View = self.videoViews[user2ID];
//            user2View.frame = [Helper getRectValue:CGRectMake(170, 20, 130, 162.5f)];
//            
//            NSNumber *user3ID = [self.activeUsers objectAtIndex:2];
//            OpponentVideoView *user3View = self.videoViews[user3ID];
//            user3View.frame = [Helper getRectValue:CGRectMake(20, 190, 130, 162.5f)];
//            
//            NSNumber *user4ID = [self.activeUsers objectAtIndex:3];
//            OpponentVideoView *user4View = self.videoViews[user4ID];
//            user4View.frame = [Helper getRectValue:CGRectMake(170, 190, 130, 162.5f)];
//        }
//            
//            break;
//        case 5:{
//            
//            NSNumber *user1ID = [self.activeUsers objectAtIndex:0];
//            OpponentVideoView *user1View = self.videoViews[user1ID];
//            user1View.frame = [Helper getRectValue:CGRectMake(5, 20, 100, 125)];
//            
//            NSNumber *user2ID = [self.activeUsers objectAtIndex:1];
//            OpponentVideoView *user2View = self.videoViews[user2ID];
//            user2View.frame = [Helper getRectValue:CGRectMake(110, 20, 100, 125)];
//            
//            NSNumber *user3ID = [self.activeUsers objectAtIndex:2];
//            OpponentVideoView *user3View = self.videoViews[user3ID];
//            user3View.frame = [Helper getRectValue:CGRectMake(215, 20, 100, 125)];
//            
//            NSNumber *user4ID = [self.activeUsers objectAtIndex:3];
//            OpponentVideoView *user4View = self.videoViews[user4ID];
//            user4View.frame = [Helper getRectValue:CGRectMake(58, 150, 100, 125)];
//            
//            NSNumber *user5ID = [self.activeUsers objectAtIndex:4];
//            OpponentVideoView *user5View = self.videoViews[user5ID];
//            user5View.frame = [Helper getRectValue:CGRectMake(162, 150, 100, 125)];
//        }
//            
//            break;
//        case 6:{
//            
//            NSNumber *user1ID = [self.activeUsers objectAtIndex:0];
//            OpponentVideoView *user1View = self.videoViews[user1ID];
//            user1View.frame = [Helper getRectValue:CGRectMake(5, 20, 100, 125)];
//            
//            NSNumber *user2ID = [self.activeUsers objectAtIndex:1];
//            OpponentVideoView *user2View = self.videoViews[user2ID];
//            user2View.frame = [Helper getRectValue:CGRectMake(110, 20, 100, 125)];
//            
//            NSNumber *user3ID = [self.activeUsers objectAtIndex:2];
//            OpponentVideoView *user3View = self.videoViews[user3ID];
//            user3View.frame = [Helper getRectValue:CGRectMake(215, 20, 100, 125)];
//            
//            NSNumber *user4ID = [self.activeUsers objectAtIndex:3];
//            OpponentVideoView *user4View = self.videoViews[user4ID];
//            user4View.frame = [Helper getRectValue:CGRectMake(5, 150, 100, 125)];
//            
//            NSNumber *user5ID = [self.activeUsers objectAtIndex:4];
//            OpponentVideoView *user5View = self.videoViews[user5ID];
//            user5View.frame = [Helper getRectValue:CGRectMake(110, 150, 100, 125)];
//            
//            NSNumber *user6ID = [self.activeUsers objectAtIndex:5];
//            OpponentVideoView *user6View = self.videoViews[user6ID];
//            user6View.frame = [Helper getRectValue:CGRectMake(215, 150, 100, 125)];
//        }
//            
//            break;
//            
//        default:
//            break;
//    }
//}
//
///**
// *  Called in case when session will close
// */
//
//
//- (void)refreshCallTime:(NSTimer *)sender {
//    
//    self.timeDuration += k2RefreshTimeInterval;
//    self.title = [NSString stringWithFormat:@"Call time - %@", [self stringWithTimeDuration:self.timeDuration]];
//}
//
//- (NSString *)stringWithTimeDuration:(NSTimeInterval )timeDuration {
//    
//    NSInteger minutes = timeDuration / 60;
//    NSInteger seconds = (NSInteger)timeDuration % 60;
//    
//    NSString *timeStr = [NSString stringWithFormat:@"%ld:%02ld", (long)minutes, (long)seconds];
//    
//    return timeStr;
//}
//
//-(void) closeQBParts{
//    [QBRTCSoundRouter.instance deinitialize];
//    [QBRTCClient.instance removeDelegate:self];
//    [self.cameraCapture stopSession];
//}
//
//#pragma mark - QBWebRTCChatDelegate
//
//- (void)didReceiveNewSession:(QBRTCSession *)session userInfo:(NSDictionary *)userInfo {
//    NSLog(@"didReceiveNewSession %@", userInfo);
//    self.session = session;
//    NSLog(@"ARTAK to review: must not reach here");
//    
//    NSArray *opponents = session.opponentsIDs;
//    if ([opponents containsObject:[self currentUserID]]){
//        [self acceptCall];
//    }
//}
//
//- (void)sessionDidClose:(QBRTCSession *)session {
//    
//    if (session == self.session) {
//        
//        NSLog(@"sessionDidClose");
//        [QBRTCSoundRouter.instance deinitialize];
//        
//        [self.callTimer invalidate];
//        self.callTimer = nil;
//        
//        self.title = [NSString stringWithFormat:@"End - %@", [self stringWithTimeDuration:self.timeDuration]];
//    }
//}
//
//
//#pragma mark PortalSessionDelegate
//
//-(void) setHistoryResponse:(NSDictionary *) dict{
//    NSLog(@"setHistoryResponse %@", dict);
//}
//
//-(void) failedToSetHIstory:(NSDictionary *) dict{
//    NSLog(@"failedToSetHIstory  %@", dict);
//    
//    //    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
//    //    if (errorCode == 1) {
//    //        [self.navigationController popToRootViewControllerAnimated:YES];
//    //    }
//}
//
//-(void) timeoutToSetHistory:(NSError *)error{
//    NSLog(@"timeoutToSetHistory");
//    [self setHistory];
//}
//
//-(void) startTimeResponse:(NSDictionary *) dict{
//    NSLog(@"startTimeResponse %@", dict);
//}
//
//-(void) failedToStartTime:(NSDictionary *) dict{
//    NSLog(@"failedToStartTime  %@", dict);
//    
//    //    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
//    //    if (errorCode == 1) {
//    //        [self.navigationController popToRootViewControllerAnimated:YES];
//    //    }
//}
//
//-(void) timeoutToStartTime:(NSError *) error{
//    NSLog(@"timeoutToStartTime");
//    [self startTime];
//}
//
//-(void) stopTimeResponse:(NSDictionary *) dict{
//    NSLog(@"stopTimeResponse %@", dict);
//}
//
//-(void) failedToStopTime:(NSDictionary *) dict{
//    NSLog(@"failedToStopTime  %@", dict);
//    
//    //    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
//    //    if (errorCode == 1) {
//    //        [self.navigationController popToRootViewControllerAnimated:YES];
//    //    }
//}
//
//-(void) timeoutToStopTime:(NSError *) error{
//    NSLog(@"timeoutToStopTime");
//    [self stopTime];
//}
//
//-(void) checkStreamResponse:(NSDictionary *) dict{
//    NSLog(@"%@ checkStreamResponse %@", self, dict);
//  
//    BOOL isTranslator = ([[dict objectForKey:@"is_tr"] integerValue] == 1);
//    
//    if (isTranslator) {
//        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//        
//        [defaults setObject:[dict objectForKey:kStreamId] forKey:kStreamId];
//        [defaults setObject:[dict objectForKey:kQBId] forKey:kQBId];
//        [defaults setObject:[dict objectForKey:kQBPassword] forKey:kQBPassword];
//        
//        if (!self.hungUpedByMe && !self.wasConnected) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://trans.sentzhost.com/api/red.php?stream_id=%@", self.streamId]]];
//            exit(0);
//        } else {
//            [self setHistory];
//            [self openMoneyViewController:@"New screen with earned money, you are translator and initiator hunged up"];
//        }
//    }
//}
//
//-(void) failedToCheckStream:(NSDictionary *) dict{
//    NSLog(@"failedToCheckStream  %@", dict);
//    
//    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
//    if (errorCode == 1) {
//        [self dismissAction];
//        AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
//        [appDelegate.navigationController popToRootViewControllerAnimated:YES];
//    }
//    
//    if (errorCode == 100) {
//        [self openMoneyViewController:@"New screen with earned money, you are translator and initiator hunged up"];
//    }
//}
//
//-(void) timeoutToCheckStream:(NSError *) error{
//    NSLog(@"timeoutToCheckStream");
//    [self checkStream];
//}
//
//-(void) getStreamTranslatorResponse:(NSDictionary *)dict{
//    NSLog(@"getStreamTranslatorResponse %@", dict);
//    NSString *qbId = [dict objectForKey:kQBId];
//    
//    NSNumber *userID = [NSNumber numberWithInteger:[qbId integerValue]];
//    self.translatorQBID = userID;
//    
//    OpponentVideoView *oppView = self.videoViews[userID];
//    if ([userID isEqualToNumber:self.translatorQBID]) {
//        oppView.roleLabel.text = @"Interpreter";
//    }
//    
//}
//
//-(void) failedToGetStreamTranslator:(NSDictionary *) dict{
//    NSLog(@"failedToGetStreamTranslator  %@", dict);
//    
//    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
//    if (errorCode == 1) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
//}
//
//-(void) timeoutToGetStreamTranslator:(NSError *) error{
//    NSLog(@"timeoutToGetStreamTranslator");
//    [self getStreamTranslator];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//@end
