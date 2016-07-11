//
//  HistoryCellBase.h
//  LingvoPal
//
//  Created by Artak Martirosyan on 5/25/16.
//  Copyright © 2016 SentzLab Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryCellBase : UITableViewCell

@property (nonatomic, strong) UILabel *youRatedLabel;
@property (nonatomic, strong) UIImageView *bkgView;
@property (nonatomic, strong) UIImageView *profileImageView;

@property (nonatomic, strong) UIImageView *cardImage;

@property (nonatomic, strong) UILabel *transNameLabel;
@property (nonatomic, strong) UILabel *langLabel;

@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *cardNumberLabel;

@property (nonatomic, strong) UILabel *conferanceTypeLabel;
@property (nonatomic, strong) UILabel *fareLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@end
