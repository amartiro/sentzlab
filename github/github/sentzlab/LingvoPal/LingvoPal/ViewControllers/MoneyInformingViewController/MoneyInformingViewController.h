//
//  MoneyInformingViewController.h
//  LingvoPal
//
//  Created by Artak on 4/26/16.
//  Copyright © 2016 SentzLab Inc. All rights reserved.
//

#import "BaseViewController.h"

@interface MoneyInformingViewController : BaseViewController

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UILabel *spentLabel;

@end
