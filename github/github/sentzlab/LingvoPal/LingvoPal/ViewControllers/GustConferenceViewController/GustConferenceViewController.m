//
//  GustConferenceViewController.m
//  LingvoPal
//
//  Created by Artak on 3/16/16.
//  Copyright © 2016 SentzLab Inc. All rights reserved.
//

#import "GustConferenceViewController.h"
#import "ChatManager.h"
#import "LocalVideoView.h"
#import "Settings.h"
#import <mach/mach.h>
#import "AppDelegate.h"
#import "Helper.h"
#import "OpponentVideoView.h"
#import "PortalSession.h"
#import "Constants.h"
#import "MoneyInformingViewController.h"
#import "RateViewController.h"
#import "ConferenceWaitingViewController.h"


const NSTimeInterval k1RefreshTimeInterval = 1.f;

@interface GustConferenceViewController () <QBRTCClientDelegate, PortalSessionDelegate>

@property (assign, nonatomic) NSTimeInterval timeDuration;
@property (strong, nonatomic) NSTimer *callTimer;

@property (strong, nonatomic) QBRTCCameraCapture *cameraCapture;

@property (strong, nonatomic) NSMutableDictionary *videoViews;

@property (assign, nonatomic) BOOL isOffer;

@property (nonatomic, strong) UIButton *micrButton;
@property (nonatomic, strong) UIButton *dynamicButton;
@property (nonatomic, strong) UIButton *videoButton;
@property (nonatomic, strong) UIButton *callEndButton;
@property (nonatomic, strong) UIButton *cameraButton;

@property (nonatomic, strong) LocalVideoView *ownVideoView;

@property (strong, nonatomic) NSMutableArray *activeUsers;

@property (nonatomic, assign) BOOL translatorGone;

@end

@implementation GustConferenceViewController

- (void)dealloc {
    
    NSLog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}


- (NSNumber *)currentUserID {
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    
    return [NSNumber numberWithUnsignedInteger:appDelegate.ownQBId];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor colorWithRed:0.1465 green:0.1465 blue:0.1465 alpha:1.0];
    
    
    // Do any additional setup after loading the view.
    self.activeUsers = [NSMutableArray array];
    self.videoViews = [NSMutableDictionary dictionary];
    self.isOffer = ([[self currentUserID] isEqual:self.session.initiatorID]);
 
    NSLog(@"OWN QBID %@, INITIIATOR QBID %@ , OPPONENT QBID %@", [self currentUserID] , self.session.initiatorID , self.session.opponentsIDs);
    
    if (self.session.conferenceType == QBRTCConferenceTypeVideo) {
        
        Settings *settings = Settings.instance;
        self.cameraCapture = [[QBRTCCameraCapture alloc] initWithVideoFormat:settings.videoFormat
                                                                    position:settings.preferredCameraPostion];
        [self.cameraCapture startSession];
    }
     
    [QBRTCSoundRouter.instance initialize];
    
     if (self.session.conferenceType == QBRTCConferenceTypeAudio) {
        [QBRTCSoundRouter instance].currentSoundRoute = QBRTCSoundRouteReceiver;
    }
    
    self.isOffer ? [self startCall] : [self acceptCall];

    UIView *toolBarView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, [Helper isiPhone4] ? 400 : 488 , 320, 80)]];
    toolBarView.backgroundColor = [UIColor colorWithWhite:0 alpha:.3f];
    [self.view addSubview:toolBarView];
    
    self.micrButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.micrButton.frame = [Helper getRectValue:CGRectMake(0, 0, 80, 80)];
    [self.micrButton setImage:[Helper getImageByImageName:@"microphone_select_icon"] forState:UIControlStateNormal];
    [self.micrButton addTarget:self action:@selector(micrButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [toolBarView addSubview:self.micrButton];
    
    //    self.dynamicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    self.dynamicButton.frame = [Helper getRectValue:CGRectMake(80, 0, 80, 80)];
    //    [self.dynamicButton setImage:[Helper getImageByImageName:@"voice_icon"] forState:UIControlStateNormal];
    //    [self.dynamicButton addTarget:self action:@selector(dynamicAction:) forControlEvents:UIControlEventTouchUpInside];
    //    [toolBarView addSubview:self.dynamicButton];
    
    self.callEndButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.callEndButton.frame = [Helper getRectValue:CGRectMake(240, 0, 80, 80)];
    [self.callEndButton setImage:[Helper getImageByImageName:@"end_call_icon"] forState:UIControlStateNormal];
    [self.callEndButton addTarget:self action:@selector(endCallAction:) forControlEvents:UIControlEventTouchUpInside];
    [toolBarView addSubview:self.callEndButton];
    
    self.videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.videoButton.frame = [Helper getRectValue:CGRectMake(80, 0, 80, 80)];
    [self.videoButton setImage:[Helper getImageByImageName:@"video_call_select_icon"] forState:UIControlStateNormal];
    [self.videoButton addTarget:self action:@selector(videoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [toolBarView addSubview:self.videoButton];
    
    self.cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cameraButton.frame = [Helper getRectValue:CGRectMake(160, 0, 80, 80)];
    [self.cameraButton setImage:[Helper getImageByImageName:@"flip_camera_icon"] forState:UIControlStateNormal];
    [self.cameraButton addTarget:self action:@selector(flipButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [toolBarView addSubview:self.cameraButton];
}

-(void) videoButtonAction:(UIButton *) button{
    self.session.localMediaStream.videoTrack.enabled ^=1;
    self.ownVideoView.hidden = !self.session.localMediaStream.videoTrack.enabled;
    if (self.session.localMediaStream.videoTrack.enabled) {
        [self.videoButton setImage:[Helper getImageByImageName:@"video_call_select_icon"] forState:UIControlStateNormal];
    } else {
        [self.videoButton setImage:[Helper getImageByImageName:@"video_call_icon"] forState:UIControlStateNormal];
    }
}

-(void) micrButtonAction:(UIButton *) button{
    self.session.localMediaStream.audioTrack.enabled ^=1;
    
    if (self.session.localMediaStream.audioTrack.enabled) {
        [self.micrButton setImage:[Helper getImageByImageName:@"microphone_select_icon"] forState:UIControlStateNormal];
    } else {
        [self.micrButton setImage:[Helper getImageByImageName:@"microphone_icon"] forState:UIControlStateNormal];
    }
}

-(void) dynamicAction:(UIButton *) button{
    QBRTCSoundRoute route = [QBRTCSoundRouter instance].currentSoundRoute;
    
    [QBRTCSoundRouter instance].currentSoundRoute =
    (route == QBRTCSoundRouteSpeaker) ? QBRTCSoundRouteReceiver : QBRTCSoundRouteSpeaker;
    
    if ([QBRTCSoundRouter instance].currentSoundRoute == QBRTCSoundRouteSpeaker) {
        [self.dynamicButton setImage:[Helper getImageByImageName:@"voice_icon"] forState:UIControlStateNormal];
    } else {
        [self.dynamicButton setImage:[Helper getImageByImageName:@"headphone_icon"] forState:UIControlStateNormal];
    }
}

-(void) endCallAction:(UIButton *) button{
    if([self.session.initiatorID isEqual:[self currentUserID]]){
        [self setHistory];
    }
    
//    if([self.translatorQBID isEqual:[self currentUserID]]){
//        [self setHistory];
//    }
    
    [self.session hangUp:[NSDictionary dictionaryWithObject:@"hang up" forKey:@"reason"]];
    
    if ([self.translatorQBID isEqualToNumber:[self currentUserID]]){
    //    [self openMoneyViewController:@"New screen with earned money, you are translator and you hunged up"];
    } else if ([self.session.initiatorID isEqualToNumber:[self currentUserID]]){
        [self openRateViewController:@"New screen with spent money, you are initiator and you hunged up"];
    } else {
        [self dismissAction];
    }
}

-(void) openMoneyViewController:(NSString *) content{
    MoneyInformingViewController *viewController = [[MoneyInformingViewController alloc] init];
    viewController.content = content;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) openRateViewController:(NSString *) content{
    RateViewController *viewController = [[RateViewController alloc] init];
    viewController.content = content;
    viewController.transId = self.transId;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) dismissAction{
    [self.callTimer invalidate];
    self.callTimer = nil;
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kStreamId];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) setHistory{
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session setHistoryWithStreamId:self.streamId] ;
}

-(void) startTime{
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session startTimeWithStreamId:self.streamId] ;
}

-(void) stopTime{
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session stopTimeWithStreamId:self.streamId] ;
}

-(void) checkStream{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *transId =  [defaults objectForKey:kTranslatorId];
    NSString *uuid = [Helper GetUUID];
    
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session checkStreamWithTransId:transId withUUID:uuid];
}

-(void)  flipButtonAction:(UIButton *) button{
    
    AVCaptureDevicePosition newPosition = (([self.cameraCapture currentPosition] == AVCaptureDevicePositionBack) ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack);
    
    if ([self.cameraCapture hasCameraForPosition:newPosition]) {
        [self.cameraCapture selectCameraPosition:newPosition];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.title = @"Connecting...";
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.ownVideoView = [[LocalVideoView alloc] initWithPreviewlayer:self.cameraCapture.previewLayer];
    self.ownVideoView.frame = [Helper getRectValue:CGRectMake(0, 20, 320, 548)];
    
    [self.view addSubview:self.ownVideoView];
    [self.view sendSubviewToBack:self.ownVideoView];
}


-(void) constructVideoViewWithOpponentID:(NSNumber *)opponentID{
    OpponentVideoView* result = self.videoViews[opponentID];
    QBRTCVideoTrack *remoteVideoTrak = [self.session remoteVideoTrackWithUserID:opponentID];
    
    if (!result && remoteVideoTrak) {
        QBRTCRemoteVideoView *remoteVideoView = [[QBRTCRemoteVideoView alloc] initWithFrame:self.view.bounds];
        [remoteVideoView setVideoTrack:remoteVideoTrak];
        
        OpponentVideoView *oppVideoView = [[OpponentVideoView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 0, 100,  125)]];
        [oppVideoView setVideoView:remoteVideoView];
        [self.view addSubview:oppVideoView];
        [self.view sendSubviewToBack:oppVideoView];
        
        self.videoViews[opponentID] = oppVideoView;
    }
}

- (void)startCall {//,@"full_name",
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@", self.translatorQBID],  @"tr_qb_id", self.streamId, @"stream_id",  nil];
    [self.session startCall:userInfo];
}


- (void)acceptCall {
    //Accept call
    NSDictionary *userInfo = @{@"acceptCall" : @"userInfo"};
    [self.session acceptCall:userInfo];
}


- (void)session:(QBRTCSession *)session initializedLocalMediaStream:(QBRTCMediaStream *)mediaStream {
    NSLog(@"initializedLocalMediaStream: ");
    session.localMediaStream.videoTrack.videoCapture = self.cameraCapture;
}
/**
 * Called in case when you are calling to user, but he hasn't answered
 */
- (void)session:(QBRTCSession *)session userDidNotRespond:(NSNumber *)userID {
    
    if (session == self.session) {
        NSLog(@"userDidNotRespond: %@", userID);
        OpponentVideoView *oppVideoView = [self getOppontentVideoView:userID];
        oppVideoView.connectionState = [self.session connectionStateForUser:userID];
    }
}

- (void)session:(QBRTCSession *)session acceptedByUser:(NSNumber *)userID userInfo:(NSDictionary *)userInfo {
    
    if (session == self.session) {
        NSLog(@"acceptedByUser: %@", userID);
        OpponentVideoView *oppVideoView = [self getOppontentVideoView:userID];
        oppVideoView.connectionState = [self.session connectionStateForUser:userID];
    }
}

/**
 * Called in case when opponent has rejected you call
 */
- (void)session:(QBRTCSession *)session rejectedByUser:(NSNumber *)userID userInfo:(NSDictionary *)userInfo {
    
    if (session == self.session) {
        NSLog(@"rejectedByUser: %@", userID);
        OpponentVideoView *oppVideoView = [self getOppontentVideoView:userID];
        oppVideoView.connectionState = [self.session connectionStateForUser:userID];
    }
}

/**
 *  Called in case when opponent hung up
 */
- (void)session:(QBRTCSession *)session hungUpByUser:(NSNumber *)userID userInfo:(NSDictionary *)userInfo {
    
    if (session == self.session) {
        NSLog(@"hungUpByUser: %@", userID);
        OpponentVideoView *oppVideoView = [self getOppontentVideoView:userID];
        oppVideoView.connectionState = [self.session connectionStateForUser:userID];
        
        if ([userID isEqualToNumber:self.translatorQBID]) {
            if ([session.initiatorID isEqualToNumber:[self currentUserID]]){
                [self openRateViewController:@"New screen with spent money, you are initiator and tranlsator hunged up"];
             } else {
                [self dismissAction];
            }
        }
    }
}

/**
 *  Called in case when receive remote video track from opponent
 */

- (void)session:(QBRTCSession *)session receivedRemoteVideoTrack:(QBRTCVideoTrack *)videoTrack fromUser:(NSNumber *)userID {
    
    if (session == self.session) {
        NSLog(@"receivedRemoteVideoTrack : %@", userID);
        [self.activeUsers addObject:userID];
        [self updateVideoViews];
    }
}

/**
 *  Called in case when connection initiated
 */
- (void)session:(QBRTCSession *)session startedConnectingToUser:(NSNumber *)userID {
    
    if (session == self.session) {
        NSLog(@"startedConnectionToUser: %@", userID);
        OpponentVideoView *oppVideoView = [self getOppontentVideoView:userID];
        oppVideoView.connectionState = [self.session connectionStateForUser:userID];
    }
}

/**
 *  Called in case when connection is established with opponent
 */
- (void)session:(QBRTCSession *)session connectedToUser:(NSNumber *)userID {
      NSLog(@"connectedToUser: %@", userID);
    
    if (session == self.session) {
        if (!self.callTimer) {
            self.callTimer = [NSTimer scheduledTimerWithTimeInterval:k1RefreshTimeInterval target:self
                                                        selector:@selector(refreshCallTime:) userInfo:nil repeats:YES];
        }
    
        if ([self.translatorQBID isEqual:userID] && self.translatorGone){
            [self startTime];
        }
        
        OpponentVideoView *oppVideoView = [self getOppontentVideoView:userID];
        oppVideoView.connectionState = [self.session connectionStateForUser:userID];
    }
}

/**
 *  Called in case when connection state changed
 */
- (void)session:(QBRTCSession *)session connectionClosedForUser:(NSNumber *)userID {
    NSLog(@"connectionClosedForUser: %@", userID);
    if (session == self.session) {
        OpponentVideoView *oppVideoView = [self getOppontentVideoView:userID];
        oppVideoView.connectionState = [self.session connectionStateForUser:userID];
      
        [self.activeUsers removeObject:userID];
        
        if ([userID isEqualToNumber:session.initiatorID]) {
            if ([self.translatorQBID isEqualToNumber:[self currentUserID]]){
                [self checkStream];
    //            [self openMoneyViewController:@"New screen with earned money, you are translator and initiator hunged up"];
            } else {
                [self dismissAction];
            }
        }
        
        if ([self.translatorQBID isEqual:userID]){
            [self stopTime];
            self.translatorGone = YES;
        }
        
        [self.videoViews removeObjectForKey:userID];
        [oppVideoView setVideoView:nil];
        [oppVideoView removeFromSuperview];
        [self updateVideoViews];
    }
}

/**
 *  Called in case when disconnected from opponent
 */
- (void)session:(QBRTCSession *)session disconnectedFromUser:(NSNumber *)userID {
    NSLog(@"disconnectedFromUser: %@", userID);
    
    if (session == self.session) {
        OpponentVideoView *oppVideoView = [self getOppontentVideoView:userID];
        oppVideoView.connectionState = [self.session connectionStateForUser:userID];
    }
}

/**
 *  Called in case when disconnected by timeout
 */
- (void)session:(QBRTCSession *)session disconnectedByTimeoutFromUser:(NSNumber *)userID {
    NSLog(@"disconnectedByTimeoutFromUser: %@", userID);
    
    if (session == self.session) {
        OpponentVideoView *oppVideoView = [self getOppontentVideoView:userID];
        oppVideoView.connectionState = [self.session connectionStateForUser:userID];
    }
}

/**
 *  Called in case when connection failed with user
 */
- (void)session:(QBRTCSession *)session connectionFailedWithUser:(NSNumber *)userID {
    NSLog(@"connectionFailedWithUser: %@", userID);
    if (session == self.session) {
        OpponentVideoView *oppVideoView = [self getOppontentVideoView:userID];
        oppVideoView.connectionState = [self.session connectionStateForUser:userID];
    }
}

-(OpponentVideoView *) getOppontentVideoView :(NSNumber *) userID{
    return self.videoViews[userID];
}

-(void) updateVideoViews{
    NSNumber *userID = [self.activeUsers lastObject];
    
    [self constructVideoViewWithOpponentID:userID];
    OpponentVideoView *oppView = self.videoViews[userID];
    if ([userID isEqualToNumber:self.translatorQBID]) {
        oppView.roleLabel.text = @"Translator";
    }
    
    if ([userID isEqualToNumber:self.session.initiatorID]) {
        oppView.roleLabel.text = @"Initiator";
    }
    
    NSInteger usersCount = [self.activeUsers count];
    switch (usersCount) {
        case 0:
            self.ownVideoView.frame = [Helper getRectValue:CGRectMake(0, 20, 320, 548)];
            break;
        case 1:{
            self.ownVideoView.frame = [Helper getRectValue:CGRectMake(10, 363, 100, 125)];
            NSNumber *user1ID = [self.activeUsers objectAtIndex:0];
            OpponentVideoView *user1View = self.videoViews[user1ID];
            user1View.frame = [Helper getRectValue:CGRectMake(0, 20, 320, 548)];
        }
            break;
        case 2:{
           
            NSNumber *user1ID = [self.activeUsers objectAtIndex:0];
            OpponentVideoView *user1View = self.videoViews[user1ID];
            user1View.frame = [Helper getRectValue:CGRectMake(20, 20, 130, 162.5f)];
            
            NSNumber *user2ID = [self.activeUsers objectAtIndex:1];
            OpponentVideoView *user2View = self.videoViews[user2ID];
            user2View.frame = [Helper getRectValue:CGRectMake(170, 20, 130, 162.5f)];
        }
            break;
        case 3:{
            
            NSNumber *user1ID = [self.activeUsers objectAtIndex:0];
            OpponentVideoView *user1View = self.videoViews[user1ID];
            user1View.frame = [Helper getRectValue:CGRectMake(20, 20, 130, 162.5f)];
            
            NSNumber *user2ID = [self.activeUsers objectAtIndex:1];
            OpponentVideoView *user2View = self.videoViews[user2ID];
            user2View.frame = [Helper getRectValue:CGRectMake(170, 20, 130, 162.5f)];
            
            NSNumber *user3ID = [self.activeUsers objectAtIndex:2];
            OpponentVideoView *user3View = self.videoViews[user3ID];
            user3View.frame = [Helper getRectValue:CGRectMake(95, 190, 130, 162.5f)];
        }
            break;
        case 4:{
            
            NSNumber *user1ID = [self.activeUsers objectAtIndex:0];
            OpponentVideoView *user1View = self.videoViews[user1ID];
            user1View.frame = [Helper getRectValue:CGRectMake(20, 20, 130, 162.5f)];
            
            NSNumber *user2ID = [self.activeUsers objectAtIndex:1];
            OpponentVideoView *user2View = self.videoViews[user2ID];
            user2View.frame = [Helper getRectValue:CGRectMake(170, 20, 130, 162.5f)];
            
            NSNumber *user3ID = [self.activeUsers objectAtIndex:2];
            OpponentVideoView *user3View = self.videoViews[user3ID];
            user3View.frame = [Helper getRectValue:CGRectMake(20, 190, 130, 162.5f)];
            
            NSNumber *user4ID = [self.activeUsers objectAtIndex:3];
            OpponentVideoView *user4View = self.videoViews[user4ID];
            user4View.frame = [Helper getRectValue:CGRectMake(170, 190, 130, 162.5f)];
        }
            
            break;
        case 5:{
            
            NSNumber *user1ID = [self.activeUsers objectAtIndex:0];
            OpponentVideoView *user1View = self.videoViews[user1ID];
            user1View.frame = [Helper getRectValue:CGRectMake(5, 20, 100, 125)];
            
            NSNumber *user2ID = [self.activeUsers objectAtIndex:1];
            OpponentVideoView *user2View = self.videoViews[user2ID];
            user2View.frame = [Helper getRectValue:CGRectMake(110, 20, 100, 125)];
            
            NSNumber *user3ID = [self.activeUsers objectAtIndex:2];
            OpponentVideoView *user3View = self.videoViews[user3ID];
            user3View.frame = [Helper getRectValue:CGRectMake(215, 20, 100, 125)];
            
            NSNumber *user4ID = [self.activeUsers objectAtIndex:3];
            OpponentVideoView *user4View = self.videoViews[user4ID];
            user4View.frame = [Helper getRectValue:CGRectMake(58, 150, 100, 125)];
            
            NSNumber *user5ID = [self.activeUsers objectAtIndex:4];
            OpponentVideoView *user5View = self.videoViews[user5ID];
            user5View.frame = [Helper getRectValue:CGRectMake(162, 150, 100, 125)];
        }
            
            break;
        case 6:{
            
            NSNumber *user1ID = [self.activeUsers objectAtIndex:0];
            OpponentVideoView *user1View = self.videoViews[user1ID];
            user1View.frame = [Helper getRectValue:CGRectMake(5, 20, 100, 125)];
            
            NSNumber *user2ID = [self.activeUsers objectAtIndex:1];
            OpponentVideoView *user2View = self.videoViews[user2ID];
            user2View.frame = [Helper getRectValue:CGRectMake(110, 20, 100, 125)];
            
            NSNumber *user3ID = [self.activeUsers objectAtIndex:2];
            OpponentVideoView *user3View = self.videoViews[user3ID];
            user3View.frame = [Helper getRectValue:CGRectMake(215, 20, 100, 125)];
            
            NSNumber *user4ID = [self.activeUsers objectAtIndex:3];
            OpponentVideoView *user4View = self.videoViews[user4ID];
            user4View.frame = [Helper getRectValue:CGRectMake(5, 150, 100, 125)];
            
            NSNumber *user5ID = [self.activeUsers objectAtIndex:4];
            OpponentVideoView *user5View = self.videoViews[user5ID];
            user5View.frame = [Helper getRectValue:CGRectMake(110, 150, 100, 125)];
            
            NSNumber *user6ID = [self.activeUsers objectAtIndex:5];
            OpponentVideoView *user6View = self.videoViews[user6ID];
            user6View.frame = [Helper getRectValue:CGRectMake(215, 150, 100, 125)];
        }
            
            break;
        
        default:
            break;
    }
}
/**
 *  Called in case when session will close
 */


- (void)refreshCallTime:(NSTimer *)sender {
    
    self.timeDuration += k1RefreshTimeInterval;
    self.title = [NSString stringWithFormat:@"Call time - %@", [self stringWithTimeDuration:self.timeDuration]];
}

- (NSString *)stringWithTimeDuration:(NSTimeInterval )timeDuration {
    
    NSInteger minutes = timeDuration / 60;
    NSInteger seconds = (NSInteger)timeDuration % 60;
    
    NSString *timeStr = [NSString stringWithFormat:@"%ld:%02ld", (long)minutes, (long)seconds];
    
    return timeStr;
}

#pragma mark - QBWebRTCChatDelegate

- (void)didReceiveNewSession:(QBRTCSession *)session userInfo:(NSDictionary *)userInfo {
    NSLog(@"didReceiveNewSession %@", userInfo);
    self.session = session;
    NSLog(@"ARTAK to review: must not reach here");
    
    NSArray *opponents = session.opponentsIDs;
    if ([opponents containsObject:[self currentUserID]]){
        [self acceptCall];
    }
}

- (void)sessionDidClose:(QBRTCSession *)session {
    
    if (session == self.session) {
        
        NSLog(@"sessionDidClose");
        [QBRTCSoundRouter.instance deinitialize];
        
        [self.callTimer invalidate];
        self.callTimer = nil;
        
        self.title = [NSString stringWithFormat:@"End - %@", [self stringWithTimeDuration:self.timeDuration]];
    }
}

#pragma mark PortalSessionDelegate

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

-(void) startTimeResponse:(NSDictionary *) dict{
    NSLog(@"startTimeResponse %@", dict);
}

-(void) failedToStartTime:(NSDictionary *) dict{
    NSLog(@"failedToStartTime  %@", dict);
    
    //    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    //    if (errorCode == 1) {
    //        [self.navigationController popToRootViewControllerAnimated:YES];
    //    }
}

-(void) timeoutToStartTime:(NSError *) error{
    NSLog(@"timeoutToStartTime");
    [self startTime];
}

-(void) stopTimeResponse:(NSDictionary *) dict{
    NSLog(@"stopTimeResponse %@", dict);
}

-(void) failedToStopTime:(NSDictionary *) dict{
    NSLog(@"failedToStopTime  %@", dict);
    
    //    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    //    if (errorCode == 1) {
    //        [self.navigationController popToRootViewControllerAnimated:YES];
    //    }
}

-(void) timeoutToStopTime:(NSError *) error{
    NSLog(@"timeoutToStopTime");
    [self stopTime];
}

-(void) checkStreamResponse:(NSDictionary *) dict{
    NSLog(@"checkStreamResponse %@", dict);
    
    NSString *ID = [dict objectForKey:kQBId];
    NSString *password = [dict objectForKey:kQBPassword];
    BOOL isTranslator = ([[dict objectForKey:@"is_tr"] integerValue] == 1);
    
    if (isTranslator) {
        AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;

        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:[dict objectForKey:kStreamId] forKey:kStreamId];
        
        ConferenceWaitingViewController *viewController = [[ConferenceWaitingViewController alloc] init];
        viewController.qbId = ID;
        viewController.qbPassword = password;
        viewController.isTranslator = NO;
         
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:((UINavigationController *)appDelegate.window.rootViewController).viewControllers];
        [viewControllers addObject:viewController];
        ((UINavigationController *)appDelegate.window.rootViewController).viewControllers = viewControllers;
        
        [self dismissAction];

    }
//    else {
//        [self qbLoginWithID:ID andEmail:email andPassword:password];
//    }
}

-(void) failedToCheckStream:(NSDictionary *) dict{
    NSLog(@"failedToCheckStream  %@", dict);
    
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    if (errorCode == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if (errorCode == 100) {
        [self openMoneyViewController:@"New screen with earned money, you are translator and initiator hunged up"];
    }
}

-(void) timeoutToCheckStream:(NSError *) error{
    NSLog(@"timeoutToCheckStream");
    [self checkStream];
}


@end
