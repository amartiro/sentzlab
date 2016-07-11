//
//  QBInitiatorWaitingViewController.h
//  LingvoPal
//
//  Created by Artak on 5/2/16.
//  Copyright © 2016 SentzLab Inc. All rights reserved.
//

#import "BaseViewController.h"

@interface QBInitiatorWaitingViewController : BaseViewController

@property (nonatomic, strong) NSString * streamId;
@property (nonatomic, strong) NSString *transId;
@property (nonatomic, strong) NSMutableArray *opponentQBIds;

@end
