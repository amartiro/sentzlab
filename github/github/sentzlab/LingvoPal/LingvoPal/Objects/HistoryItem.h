//
//  HistoryItem.h
//  LingvoPal
//
//  Created by Artak on 12/23/15.
//  Copyright © 2015 SentzLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Helper.h"

@interface HistoryItem : NSObject

@property (nonatomic, strong) NSString *transId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *transName;
@property (nonatomic, strong) NSString *transSurName;
@property (nonatomic, strong) NSString *transImage;
@property (nonatomic, assign) CallType callType;
@property (nonatomic, assign) NSInteger rating;
@property (nonatomic, strong) NSString *review;

@property (nonatomic, strong) NSString *fromLang;
@property (nonatomic, strong) NSString *toLang;

@property (nonatomic, assign) NSInteger startTime;
@property (nonatomic, assign) NSInteger endTime;

@end
