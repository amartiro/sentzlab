//
//  TranslatorHistoryCell.h
//  LingvoPal
//
//  Created by Artak on 1/25/16.
//  Copyright © 2016 SentzLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TranslatorHistoryCell : UITableViewCell

@property (nonatomic, strong) UILabel *transNameLabel;
@property (nonatomic, strong) UILabel *langLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end
