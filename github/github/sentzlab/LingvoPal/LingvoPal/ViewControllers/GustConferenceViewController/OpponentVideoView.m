////
////  OpponentVideoView.m
////  LingvoPal
////
////  Created by Artak on 3/16/16.
////  Copyright © 2016 SentzLab Inc. All rights reserved.
////
//
//#import "OpponentVideoView.h"
//#import "Helper.h"
//
//@interface OpponentVideoView()
//@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
//@end
//
//@implementation OpponentVideoView
//
//-(instancetype) initWithFrame:(CGRect)frame{
//    
//    self = [super initWithFrame:frame];
//    if (self) {
//        
//        self.videoView = [[UIView alloc] initWithFrame:self.bounds];
//        [self addSubview:self.videoView];
//        
//        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width,  [Helper getValue:24])];
//        self.statusLabel.backgroundColor = [UIColor colorWithRed:0.9441 green:0.9441 blue:0.9441 alpha:0.350031672297297];
//        self.statusLabel.text = @"";
//        self.statusLabel.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:self.statusLabel];
//        
//        self.roleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height -  [Helper getValue:24], frame.size.width,  [Helper getValue:24])];
//        self.roleLabel.backgroundColor = [UIColor colorWithRed:0.9441 green:0.9441 blue:0.9441 alpha:0.350031672297297];
//        self.roleLabel.text = @"";
//        self.roleLabel.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:self.roleLabel];
//    }
//    
//    return self;
//}
//
////-(void) setFrame:(CGRect)frame{
////    NSLog(@"opponnent FRAME %@", NSStringFromCGRect(frame));
////    self.videoView.frame = CGRectMake(self.videoView.frame.origin.x,self.videoView.frame.origin.y , frame.size.width, frame.size.height);
////}
//- (void)setVideoView:(UIView *)videoView {
//    
//    if (_videoView != videoView) {
//        
//        [_videoView removeFromSuperview];
//        _videoView = videoView;
//        _videoView.frame = self.bounds;
//        [self addSubview:self.videoView];
//        [self sendSubviewToBack:self.videoView];
//    }
//}
//
//- (void)layoutSubviews {
//    
//    [super layoutSubviews];
//    
//    if (CGRectEqualToRect(_videoView.bounds, self.bounds)) {
//        
//        return;
//    }
//    _videoView.frame = self.bounds;
//    
//    _statusLabel.frame = CGRectMake(0, 0, self.bounds.size.width,  [Helper getValue:24]);
//    _roleLabel.frame = CGRectMake(0, self.bounds.size.height -  [Helper getValue:24], self.bounds.size.width,  [Helper getValue:24]);
//}
//
//- (void)setConnectionState:(QBRTCConnectionState)connectionState {
//    
//    if (_connectionState != connectionState) {
//        _connectionState = connectionState;
//        
//        switch (connectionState) {
//                
//            case QBRTCConnectionNew:
//                self.statusLabel.text = @"New";
//                break;
//                
//            case QBRTCConnectionPending:
//                self.statusLabel.text = @"Pending";
//                break;
//                
//            case QBRTCConnectionChecking:
//                self.statusLabel.text = @"Checking";
//                break;
//                
//            case QBRTCConnectionConnecting:
//                self.statusLabel.text = @"Connecting";
//                break;
//                
//            case QBRTCConnectionConnected:
//                self.statusLabel.text = @"Connected";
//                break;
//                
//            case QBRTCConnectionClosed:
//                self.statusLabel.text = @"Closed";
//                break;
//                
//            case QBRTCConnectionHangUp:
//                self.statusLabel.text = @"Hung Up";
//                break;
//                
//            case QBRTCConnectionRejected:
//                self.statusLabel.text = @"Rejected";
//                break;
//                
//            case QBRTCConnectionNoAnswer:
//                self.statusLabel.text = @"No Answer";
//                break;
//                
//            case QBRTCConnectionDisconnectTimeout:
//                self.statusLabel.text = @"Time out";
//                break;
//                
//            case QBRTCConnectionDisconnected:
//                
//                self.statusLabel.text = @"Disconnected";
//                break;
//            default:
//                break;
//        }
//    }
//}
//
//
//
//@end
