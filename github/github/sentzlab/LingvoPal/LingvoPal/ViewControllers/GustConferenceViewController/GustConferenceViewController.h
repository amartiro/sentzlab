//
//  GustConferenceViewController.h
//  LingvoPal
//
//  Created by Artak on 3/16/16.
//  Copyright © 2016 SentzLab Inc. All rights reserved.
//

#import "BaseViewController.h"

@class QBRTCSession;

@interface GustConferenceViewController : UIViewController

@property (strong, nonatomic) QBRTCSession *session;
@property (nonatomic, strong) NSString *streamId;
@property (nonatomic, strong) NSNumber *translatorQBID;
@property (nonatomic, strong) NSString *transId;

@end
