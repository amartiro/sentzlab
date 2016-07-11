//
//  HistoryCell.h
//  LingvoPal
//
//  Created by Artak on 12/18/15.
//  Copyright © 2015 SentzLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryCell : UITableViewCell

@property (nonatomic, strong) UIImageView *profileImageView;

@property (nonatomic, strong) UILabel *transNameLabel;
@property (nonatomic, strong) UILabel *langLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *priceLabel;



@property (nonatomic, strong) UIButton *futureButton;
@property (nonatomic, strong) UIButton *rateButton;

@end
