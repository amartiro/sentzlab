//
//  ConferenceWaitingViewController.h
//  LingvoPal
//
//  Created by Artak on 3/14/16.
//  Copyright © 2016 SentzLab Inc. All rights reserved.
//

#import "BaseViewController.h"

@interface ConferenceWaitingViewController : BaseViewController

@property (nonatomic, strong) NSString *qbId;
@property (nonatomic, strong) NSString *qbPassword;
@property (nonatomic, assign) BOOL isTranslator;


@end
