//
//  DateSelectionViewController.h
//  LingvoPal
//
//  Created by Artak on 12/8/15.
//  Copyright © 2015 SentzLab. All rights reserved.
//

#import "BaseViewController.h"
#import "Helper.h"

@interface DateSelectionViewController : BaseViewController

@property (nonatomic, strong) NSString *fromLang;
@property (nonatomic, strong) NSString *toLang;
@property (nonatomic, strong) NSString *number1;
@property (nonatomic, strong) NSString *number2;
@property (nonatomic, assign) NSUInteger time;
@property (nonatomic, assign) BOOL isPro;

@property (nonatomic, assign) CallType callType;

@end
