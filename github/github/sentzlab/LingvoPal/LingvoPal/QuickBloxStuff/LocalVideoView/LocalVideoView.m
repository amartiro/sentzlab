////
////  LocalVideoView.m
////  sample-videochat-webrtc
////
////  Created by Andrey Ivanov on 12/10/15.
////  Copyright © 2015 QuickBlox Team. All rights reserved.
////
//
//#import "LocalVideoView.h"
//
//@interface LocalVideoView()
//
//@property (weak, nonatomic) AVCaptureVideoPreviewLayer *videoLayer;
//@property (strong, nonatomic) UIView *containerView;
//
//@end
//
//@implementation LocalVideoView
//
//- (instancetype)initWithPreviewlayer:(AVCaptureVideoPreviewLayer *)layer {
//    
//    self = [super initWithFrame:CGRectZero];
//    if (self) {
//        
//        self.videoLayer = layer;
//        layer.videoGravity = AVLayerVideoGravityResizeAspect;
//        
//        self.containerView = [[UIView alloc] initWithFrame:self.bounds];
//        self.containerView.backgroundColor = [UIColor clearColor];
//        [self.containerView.layer insertSublayer:layer atIndex:0];
//        
//        [self insertSubview:self.containerView atIndex:0];
//    }
//    
//    return self;
//}
//
//- (void)setFrame:(CGRect)frame {
//    
//    [super setFrame:frame];
//
//    self.containerView.frame = self.bounds;
//    self.videoLayer.frame = self.bounds;
//}
//
//@end
