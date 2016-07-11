//
//  VideoCallViewController.m
//  LingvoPal
//
//  Created by Artak on 12/16/15.
//  Copyright © 2016 SentzLab. All rights reserved.
//

#import "VideoCallViewController.h"
#import "Helper.h"

#import "LocalVideoView.h"
#import "Settings.h"
#import "QMSoundManager.h"

#import <mach/mach.h>
#import "AppDelegate.h"
#import "PortalSession.h"

@interface VideoCallViewController()<QBRTCClientDelegate, PortalSessionDelegate>

@property (assign, nonatomic) NSTimeInterval timeDuration;
@property (strong, nonatomic) NSTimer *callTimer;
@property (assign, nonatomic) NSTimer *beepTimer;


@property (strong, nonatomic) QBRTCCameraCapture *cameraCapture;

@property (strong, nonatomic) NSMutableDictionary *videoViews;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) LocalVideoView *ownVideoView;
@property (nonatomic, strong) QBRTCRemoteVideoView *translatorVideoView;

@property (nonatomic, strong) UIButton *micrButton;
@property (nonatomic, strong) UIButton *dynamicButton;
@property (nonatomic, strong) UIButton *videoButton;
@property (nonatomic, strong) UIButton *callEndButton;
@property (nonatomic, strong) UIButton *cameraButton;





@end

@implementation VideoCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(10, 20, 300, 30)]];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [Helper fontWithSize:20];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"Connecting";
    [self.view addSubview:self.titleLabel];
    
    self.statusLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(10, 50, 300, 30)]];
    self.statusLabel.backgroundColor = [UIColor clearColor];
    self.statusLabel.textColor = [UIColor whiteColor];
    self.statusLabel.font = [Helper fontWithSize:20];
    self.statusLabel.adjustsFontSizeToFitWidth = YES;
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.statusLabel];
    
    
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
    
    if (self.session.conferenceType == QBRTCConferenceTypeVideo) {
        
        Settings *settings = Settings.instance;
        self.cameraCapture = [[QBRTCCameraCapture alloc] initWithVideoFormat:settings.videoFormat
                                                                    position:settings.preferredCameraPostion];
        [self.cameraCapture startSession];
    }
    
    [QBRTCClient.instance addDelegate:self];
    [QBRTCSoundRouter.instance initialize];
    
    self.beepTimer = [NSTimer scheduledTimerWithTimeInterval:[QBRTCConfig dialingTimeInterval]
                                                      target:self
                                                    selector:@selector(playCallingSound:)
                                                    userInfo:nil
                                                     repeats:YES];
    [self playCallingSound:nil];
    //Start call
    NSDictionary *userInfo = @{@"startCall" : @"userInfo"};
    [self.session startCall:userInfo];
    
    
    if (self.session.conferenceType == QBRTCConferenceTypeAudio) {
        [QBRTCSoundRouter instance].currentSoundRoute = QBRTCSoundRouteReceiver;
    }
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
    [self.session hangUp:[NSDictionary dictionaryWithObject:@"hang up" forKey:@"hangup"]];
    [self dismissAction];
}

-(void) dismissAction{
    [self.callTimer invalidate];
    self.callTimer = nil;
    
    [self setHistory];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) setHistory{
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session setHistoryWithStreamId:self.streamId] ;
}

-(void)  flipButtonAction:(UIButton *) button{
    
    AVCaptureDevicePosition newPosition = (([self.cameraCapture currentPosition] == AVCaptureDevicePositionBack) ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack);
    
    if ([self.cameraCapture hasCameraForPosition:newPosition]) {
        [self.cameraCapture selectCameraPosition:newPosition];
    }
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.ownVideoView = [[LocalVideoView alloc] initWithPreviewlayer:self.cameraCapture.previewLayer];
    self.ownVideoView.frame = self.view.bounds;

    [self.view addSubview:self.ownVideoView];
    [self.view sendSubviewToBack:self.ownVideoView];
}


#pragma Statistic

NSInteger QBRTCGetCpuUsagePercentage() {
    // Create an array of thread ports for the current task.
    const task_t task = mach_task_self();
    thread_act_array_t thread_array;
    mach_msg_type_number_t thread_count;
    if (task_threads(task, &thread_array, &thread_count) != KERN_SUCCESS) {
        return -1;
    }
    
    // Sum cpu usage from all threads.
    float cpu_usage_percentage = 0;
    thread_basic_info_data_t thread_info_data = {};
    mach_msg_type_number_t thread_info_count;
    for (size_t i = 0; i < thread_count; ++i) {
        thread_info_count = THREAD_BASIC_INFO_COUNT;
        kern_return_t ret = thread_info(thread_array[i],
                                        THREAD_BASIC_INFO,
                                        (thread_info_t)&thread_info_data,
                                        &thread_info_count);
        if (ret == KERN_SUCCESS) {
            cpu_usage_percentage +=
            100.f * (float)thread_info_data.cpu_usage / TH_USAGE_SCALE;
        }
    }
    
    // Dealloc the created array.
    vm_deallocate(task, (vm_address_t)thread_array,
                  sizeof(thread_act_t) * thread_count);
    return lroundf(cpu_usage_percentage);
}

#pragma mark - QBRTCClientDelegate

- (void)session:(QBRTCSession *)session updatedStatsReport:(QBRTCStatsReport *)report forUserID:(NSNumber *)userID {
    
    NSMutableString *result = [NSMutableString string];
    NSString *systemStatsFormat = @"(cpu)%ld%%\n";
    [result appendString:[NSString stringWithFormat:systemStatsFormat,
                          (long)QBRTCGetCpuUsagePercentage()]];
    
    // Connection stats.
    NSString *connStatsFormat = @"CN %@ms | %@->%@/%@ | (s)%@ | (r)%@\n";
    [result appendString:[NSString stringWithFormat:connStatsFormat,
                          report.connectionRoundTripTime,
                          report.localCandidateType, report.remoteCandidateType, report.transportType,
                          report.connectionSendBitrate, report.connectionReceivedBitrate]];
    
    if (session.conferenceType == QBRTCConferenceTypeVideo) {
        
        // Video send stats.
        NSString *videoSendFormat = @"VS (input) %@x%@@%@fps | (sent) %@x%@@%@fps\n"
        "VS (enc) %@/%@ | (sent) %@/%@ | %@ms | %@\n";
        [result appendString:[NSString stringWithFormat:videoSendFormat,
                              report.videoSendInputWidth, report.videoSendInputHeight, report.videoSendInputFps,
                              report.videoSendWidth, report.videoSendHeight, report.videoSendFps,
                              report.actualEncodingBitrate, report.targetEncodingBitrate,
                              report.videoSendBitrate, report.availableSendBandwidth,
                              report.videoSendEncodeMs,
                              report.videoSendCodec]];
        
        // Video receive stats.
        NSString *videoReceiveFormat =
        @"VR (recv) %@x%@@%@fps | (decoded)%@ | (output)%@fps | %@/%@ | %@ms\n";
        [result appendString:[NSString stringWithFormat:videoReceiveFormat,
                              report.videoReceivedWidth, report.videoReceivedHeight, report.videoReceivedFps,
                              report.videoReceivedDecodedFps,
                              report.videoReceivedOutputFps,
                              report.videoReceivedBitrate, report.availableReceiveBandwidth,
                              report.videoReceivedDecodeMs]];
    }
    // Audio send stats.
    NSString *audioSendFormat = @"AS %@ | %@\n";
    [result appendString:[NSString stringWithFormat:audioSendFormat,
                          report.audioSendBitrate, report.audioSendCodec]];
    
    // Audio receive stats.
    NSString *audioReceiveFormat = @"AR %@ | %@ | %@ms | (expandrate)%@";
    [result appendString:[NSString stringWithFormat:audioReceiveFormat,
                          report.audioReceivedBitrate, report.audioReceivedCodec, report.audioReceivedCurrentDelay,
                          report.audioReceivedExpandRate]];
    
    NSLog(@"%@", result);
}

- (void)session:(QBRTCSession *)session initializedLocalMediaStream:(QBRTCMediaStream *)mediaStream {
    
    session.localMediaStream.videoTrack.videoCapture = self.cameraCapture;
}
/**
 * Called in case when you are calling to user, but he hasn't answered
 */
- (void)session:(QBRTCSession *)session userDoesNotRespond:(NSNumber *)userID {
    
    if (session == self.session) {
         NSLog(@"userDoesNotRespond: %@", userID);
        [self updateState:[self.session connectionStateForUser:userID]];
    }
}

- (void)session:(QBRTCSession *)session acceptedByUser:(NSNumber *)userID userInfo:(NSDictionary *)userInfo {
    
    if (session == self.session) {
          NSLog(@"acceptedByUser: %@", userID);
        [self updateState:[self.session connectionStateForUser:userID]];
    }
}

/**
 * Called in case when opponent has rejected you call
 */
- (void)session:(QBRTCSession *)session rejectedByUser:(NSNumber *)userID userInfo:(NSDictionary *)userInfo {
    
    if (session == self.session) {
        [self updateState:[self.session connectionStateForUser:userID]];
        [self dismissAction];
    }
}

/**
 *  Called in case when opponent hung up
 */
- (void)session:(QBRTCSession *)session hungUpByUser:(NSNumber *)userID userInfo:(NSDictionary *)userInfo {
    
    if (session == self.session) {
        NSLog(@"hungUpByUser: %@", userID);
        [self updateState:[self.session connectionStateForUser:userID]];
        [self dismissAction];
    }
}

/**
 *  Called in case when receive remote video track from opponent
 */

- (void)session:(QBRTCSession *)session receivedRemoteVideoTrack:(QBRTCVideoTrack *)videoTrack fromUser:(NSNumber *)userID {
    
    if (session == self.session) {
         NSLog(@"receivedRemoteVideoTrack: %@", userID);
        id result = self.videoViews[userID];
        
        QBRTCRemoteVideoView *remoteVideoView = nil;
        
        QBRTCVideoTrack *remoteVideoTrak = [self.session remoteVideoTrackWithUserID:userID];
        
        if (!result && remoteVideoTrak) {
            
            remoteVideoView = [[QBRTCRemoteVideoView alloc] initWithFrame:self.view.bounds];
            self.videoViews[userID] = remoteVideoView;
            result = remoteVideoView;
        }
        
        [remoteVideoView setVideoTrack:remoteVideoTrak];

        
        self.ownVideoView.frame = [Helper getRectValue:CGRectMake(10, 423, 100, 125)];

        self.translatorVideoView = result;
        self.translatorVideoView.frame = self.view.bounds;
        [self.view addSubview:self.translatorVideoView];
        [self.view sendSubviewToBack:self.translatorVideoView];
    }
}

/**
 *  Called in case when connection initiated
 */
- (void)session:(QBRTCSession *)session startedConnectionToUser:(NSNumber *)userID {
    
    if (session == self.session) {
        NSLog(@"startedConnectionToUser: %@", userID);
        [self updateState:[self.session connectionStateForUser:userID]];
    }
}

/**
 *  Called in case when connection is established with opponent
 */
- (void)session:(QBRTCSession *)session connectedToUser:(NSNumber *)userID {
    NSLog(@"connectedToUser: %@", userID);
    
    if (self.beepTimer) {
        
        [self.beepTimer invalidate];
        self.beepTimer = nil;
        [QMSysPlayer stopAllSounds];
    }
    
    if (!self.callTimer) {
        
        self.callTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                          target:self
                                                        selector:@selector(refreshCallTime:)
                                                        userInfo:nil
                                                         repeats:YES];
    }
    
//    [self performUpdateUserID:userID block:^(OpponentCollectionViewCell *cell) {
        [self updateState:[self.session connectionStateForUser:userID]];
//    }];
}

/**
 *  Called in case when connection state changed
 */
- (void)session:(QBRTCSession *)session connectionClosedForUser:(NSNumber *)userID {
    
    if (session == self.session) {
        NSLog(@"connectionClosedForUser: %@", userID);
        
//        [self performUpdateUserID:userID block:^(OpponentCollectionViewCell *cell) {
            [self updateState:[self.session connectionStateForUser:userID]];
//           
//            [cell setVideoView:nil];
//        }];
        
         [self.videoViews removeObjectForKey:userID];
        self.translatorVideoView = nil;
    }
}

/**
 *  Called in case when disconnected from opponent
 */
- (void)session:(QBRTCSession *)session disconnectedFromUser:(NSNumber *)userID {
    
    if (session == self.session) {
        
        NSLog(@"disconnectedFromUser: %@", userID);
//        [self performUpdateUserID:userID block:^(OpponentCollectionViewCell *cell) {
            [self updateState:[self.session connectionStateForUser:userID]];
//        }];
    }
}

/**
 *  Called in case when disconnected by timeout
 */
- (void)session:(QBRTCSession *)session disconnectedByTimeoutFromUser:(NSNumber *)userID {
    
    if (session == self.session) {
        
        NSLog(@"disconnectedByTimeoutFromUser: %@", userID);
//        [self performUpdateUserID:userID block:^(OpponentCollectionViewCell *cell) {
            [self updateState:[self.session connectionStateForUser:userID]];
//        }];
    }
}

/**
 *  Called in case when connection failed with user
 */
- (void)session:(QBRTCSession *)session connectionFailedWithUser:(NSNumber *)userID {
    
    if (session == self.session) {
        
        NSLog(@"connectionFailedWithUser: %@", userID);
//        [self performUpdateUserID:userID block:^(OpponentCollectionViewCell *cell) {
            [self updateState:[self.session connectionStateForUser:userID]];
//        }];
    }
}

/**
 *  Called in case when session will close
 */
- (void)sessionDidClose:(QBRTCSession *)session {
    
    if (session == self.session) {
        
        NSLog(@"sessionDidClose");
        [QBRTCSoundRouter.instance deinitialize];
        
        if (self.beepTimer) {
            
            [self.beepTimer invalidate];
            self.beepTimer = nil;
            [QMSysPlayer stopAllSounds];
        }
        
        [self.callTimer invalidate];
        self.callTimer = nil;
        
        self.titleLabel.text = [NSString stringWithFormat:@"End - %@", [self stringWithTimeDuration:self.timeDuration]];
    }
}

#pragma mark - Timers actions

- (void)playCallingSound:(id)sender {
    
  //  [QMSoundManager playCallingSound];
}

- (void)refreshCallTime:(NSTimer *)sender {
    
    self.timeDuration += 1.0f;
    self.titleLabel.text = [NSString stringWithFormat:@"Call time - %@", [self stringWithTimeDuration:self.timeDuration]];
}

- (NSString *)stringWithTimeDuration:(NSTimeInterval )timeDuration {
    
    NSInteger minutes = timeDuration / 60;
    NSInteger seconds = (NSInteger)timeDuration % 60;
    
    NSString *timeStr = [NSString stringWithFormat:@"%ld:%02ld", (long)minutes, (long)seconds];
    
    return timeStr;
}


- (void)updateState:(QBRTCConnectionState)connectionState {
    
    switch (connectionState) {
            
        case QBRTCConnectionNew:
            self.statusLabel.text = @"New";
            break;
            
        case QBRTCConnectionPending:
            self.statusLabel.text = @"Pending";
            break;
            
        case QBRTCConnectionChecking:
            self.statusLabel.text = @"Checking";
            break;
            
        case QBRTCConnectionConnecting:
            self.statusLabel.text = @"Connecting";
            break;
            
        case QBRTCConnectionConnected:
            self.statusLabel.text = @"Connected";
            break;
            
        case QBRTCConnectionClosed:
            self.statusLabel.text = @"Closed";
            break;
            
        case QBRTCConnectionHangUp:
            self.statusLabel.text = @"Hung Up";
            break;
            
        case QBRTCConnectionRejected:
             self.statusLabel.text = @"Rejected";
             break;
            
        case QBRTCConnectionNoAnswer:
             self.statusLabel.text = @"No Answer";
             break;
            
        case QBRTCConnectionDisconnectTimeout:
            self.statusLabel.text = @"Time out";
            break;
            
        case QBRTCConnectionDisconnected:
            self.statusLabel.text = @"Disconnected";
            break;
        default:
            break;
    }
}

#pragma mark - QBWebRTCChatDelegate

- (void)didReceiveNewSession:(QBRTCSession *)session userInfo:(NSDictionary *)userInfo {
    NSLog(@"didReceiveNewSession %@", userInfo);
    self.session = session;
    [self acceptCall];
}

-(void) acceptCall{
    [QMSysPlayer stopAllSounds];
    [self.session acceptCall:@{@"acceptCall" : @"userInfo"}];
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

@end
