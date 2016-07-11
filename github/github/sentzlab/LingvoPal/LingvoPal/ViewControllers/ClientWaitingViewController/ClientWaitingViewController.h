//
//  ClientWaitingViewController.h
//  LingvoPal
//
//  Created by Artak on 2/16/16.
//  Copyright © 2016 SentzLab. All rights reserved.
//

#import "BaseViewController.h"
#import "Helper.h"

@interface ClientWaitingViewController : BaseViewController

@property (nonatomic, strong) NSString *fromLang;
@property (nonatomic, strong) NSString *toLang;
@property (nonatomic, assign) BOOL isPro;

@property (nonatomic, strong) NSString *transId;
@property (nonatomic, strong) NSString *orderId;

@property (nonatomic, assign) CallType callType;

@end
