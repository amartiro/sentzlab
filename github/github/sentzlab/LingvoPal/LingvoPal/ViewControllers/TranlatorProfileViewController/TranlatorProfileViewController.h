//
//  TranlatorProfileViewController.h
//  LingvoPal
//
//  Created by Artak on 12/10/15.
//  Copyright © 2015 SentzLab. All rights reserved.
//

#import "BaseViewController.h"
#import "Helper.h"

@interface TranlatorProfileViewController : BaseViewController

//@property (nonatomic, strong) NSString *fromLang;
//@property (nonatomic, strong) NSString *toLang;
//@property (nonatomic, assign) NSUInteger time;
//@property (nonatomic, assign) BOOL isPro;


@property (nonatomic, strong) NSDictionary * transDict;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, assign) CallType callType;

@end
