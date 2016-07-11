//
//  ConferenceVideoViewController.h
//  LingvoPal
//
//  Created by Artak on 3/12/16.
//  Copyright © 2016 SentzLab Inc. All rights reserved.
//

#import "BaseViewController.h"

@interface ConferenceVideoViewController : BaseViewController

@property (nonatomic, strong) NSString * streamId;
@property (nonatomic, strong) NSString *transId;
@property (nonatomic, strong) NSMutableArray *opponentQBIds;

@end
