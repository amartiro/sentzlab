//
//  ooVooVideoViewController.h
//  LingvoPal
//
//  Created by Artak Martirosyan on 6/28/16.
//  Copyright © 2016 SentzLab Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"

@interface ooVooVideoViewController : UIViewController

@property (nonatomic, strong) NSString *streamId;
@property (nonatomic, strong) NSString *userId;

//@property (nonatomic, strong) NSNumber *translatorQBID;

@property (nonatomic, strong) NSString *ownoVoId;
@property (nonatomic, strong) NSString *transoVoId;
@property (nonatomic, strong) NSString *initiatoroVoId;


@property (nonatomic, strong) NSString *transId;
@property (nonatomic, assign) CallType callType;
@property (nonatomic, assign) BOOL isTranslator;
@property (nonatomic, assign) BOOL isInitiator;

@end
