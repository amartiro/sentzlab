//
//  VideoCallViewController.h
//  SentzTranslate
//
//  Created by Artak on 12/16/15.
//  Copyright © 2016 SentzLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCallViewController : UIViewController


@property (strong, nonatomic) QBRTCSession *session;
@property (nonatomic, strong) NSString *streamId;

@end
