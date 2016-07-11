//
//  ooVooLoginViewController.h
//  LingvoPal
//
//  Created by Artak Martirosyan on 6/28/16.
//  Copyright © 2016 SentzLab Inc. All rights reserved.
//

#import "BaseViewController.h"
#import "Helper.h"


@interface ooVooLoginViewController : BaseViewController

@property (nonatomic, strong) NSString * streamId;
@property (nonatomic, strong) NSString *transId;
@property (nonatomic, assign) BOOL isTranslator;
@property (nonatomic, assign) BOOL isInitiator;
@property (nonatomic, assign) CallType callType;

@end
