//
//  QBWaitViewController.h
//  LingvoPal
//
//  Created by Artak Martirosyan on 5/18/16.
//  Copyright © 2016 SentzLab Inc. All rights reserved.
//

#import "BaseViewController.h"
#import "Helper.h"


@interface QBWaitViewController : BaseViewController

@property (nonatomic, assign) BOOL isInitiator;
@property (nonatomic, strong) NSString * streamId;
@property (nonatomic, strong) NSString *transId;
@property (nonatomic, strong) NSMutableArray *opponentQBIds;
@property (nonatomic, assign) BOOL isTranslator;
@property (nonatomic, assign) CallType callType;


@end
