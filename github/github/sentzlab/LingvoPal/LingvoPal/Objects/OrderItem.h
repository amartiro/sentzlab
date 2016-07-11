//
//  OrderItem.h
//  LingvoPal
//
//  Created by Artak on 2/3/16.
//  Copyright © 2016 SentzLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Helper.h"


@interface OrderItem : NSObject

@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;

@property (nonatomic, strong) NSString *fromLang;
@property (nonatomic, strong) NSString *toLang;
@property (nonatomic, assign) BOOL isPro;
@property (nonatomic, assign) CallType callType;



@property (nonatomic, assign) NSInteger startTime;

@end
