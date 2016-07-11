//
//  HistoryCellBase.m
//  LingvoPal
//
//  Created by Artak Martirosyan on 5/25/16.
//  Copyright © 2016 SentzLab Inc. All rights reserved.
//

#import "HistoryCellBase.h"
#import "Helper.h"

@implementation HistoryCellBase

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        self.bkgView = [[UIImageView alloc] initWithFrame:self.bounds];

        [self addSubview:self.bkgView];
        
        self.youRatedLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(10, 25, 120, 20)]];
        self.youRatedLabel.backgroundColor = [UIColor clearColor];
        self.youRatedLabel.font = [Helper fontWithSize:15];
        self.youRatedLabel.textColor = [UIColor blackColor];
        self.youRatedLabel.textAlignment = NSTextAlignmentLeft;
        self.youRatedLabel.adjustsFontSizeToFitWidth = YES;
        self.youRatedLabel.text = @"YOU RATED";
        [self addSubview:self.youRatedLabel];
        
        
        UIView * rateView = [Helper getRateView:3];
        rateView.center = [Helper getPointValue:CGPointMake(50, 55)];
        [self addSubview:rateView];
        
        UILabel *totalLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(180, 25, 120, 20)]];
        totalLabel.backgroundColor = [UIColor clearColor];
        totalLabel.font = [Helper fontWithSize:15];
        totalLabel.textColor = [UIColor blackColor];
        totalLabel.textAlignment = NSTextAlignmentRight;
        totalLabel.text = @"TOTAL";
        [self addSubview:totalLabel];
        
        
        
        UIColor *textColor = [UIColor grayColor];
        
        UILabel *confTypeLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(10, 97, 140, 15)]];
        confTypeLabel.backgroundColor = [UIColor clearColor];
        confTypeLabel.font = [Helper fontWithSize:12];
        confTypeLabel.textColor = [UIColor blackColor];
        confTypeLabel.textAlignment = NSTextAlignmentLeft;
        confTypeLabel.text = @"Conference type";
        [self addSubview:confTypeLabel];
        
        self.conferanceTypeLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(160, 97, 140, 15)]];
        self.conferanceTypeLabel.backgroundColor = [UIColor clearColor];
        self.conferanceTypeLabel.font = [Helper fontWithSize:12];
        self.conferanceTypeLabel.textColor = textColor;
        self.conferanceTypeLabel.textAlignment = NSTextAlignmentRight;
        self.conferanceTypeLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.conferanceTypeLabel];
        
        
        UILabel *fareLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(10, 114, 140, 15)]];
        fareLabel.backgroundColor = [UIColor clearColor];
        fareLabel.font = [Helper fontWithSize:12];
        fareLabel.textColor = [UIColor blackColor];
        fareLabel.textAlignment = NSTextAlignmentLeft;
        fareLabel.text = @"Base fare";
        [self addSubview:fareLabel];
        
        self.fareLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(160, 114, 140, 15)]];
        self.fareLabel.backgroundColor = [UIColor clearColor];
        self.fareLabel.font = [Helper fontWithSize:12];
        self.fareLabel.textColor = textColor;
        self.fareLabel.textAlignment = NSTextAlignmentRight;
        self.fareLabel.adjustsFontSizeToFitWidth = YES;
        self.fareLabel.text = @"2$ per min";
        [self addSubview:self.fareLabel];
        
        UILabel *durationLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(10, 131, 140, 15)]];
        durationLabel.backgroundColor = [UIColor clearColor];
        durationLabel.font = [Helper fontWithSize:12];
        durationLabel.textColor = [UIColor blackColor];
        durationLabel.textAlignment = NSTextAlignmentLeft;
        durationLabel.text = @"Order duration";
        [self addSubview:durationLabel];
        
        self.durationLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(160, 131, 140, 15)]];
        self.durationLabel.backgroundColor = [UIColor clearColor];
        self.durationLabel.font = [Helper fontWithSize:12];
        self.durationLabel.textColor = textColor;
        self.durationLabel.textAlignment = NSTextAlignmentRight;
        self.durationLabel.adjustsFontSizeToFitWidth = YES;
        self.durationLabel.text = @"20 min";
        [self addSubview:self.durationLabel];
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(10, 149, 140, 15)]];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.font = [Helper fontWithSize:12];
        dateLabel.textColor = [UIColor blackColor];
        dateLabel.textAlignment = NSTextAlignmentLeft;
        dateLabel.text = @"Order date";
        [self addSubview:dateLabel];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(160, 149, 140, 15)]];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.font = [Helper fontWithSize:12];
        self.dateLabel.textColor = textColor;
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        self.dateLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.dateLabel];
        
        
        self.cardImage= [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"visa_card"]];
        self.cardImage.center =  [Helper getPointValue:CGPointMake(35, 188)];
        [self addSubview:self.cardImage];
        
        self.cardNumberLabel= [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(70, 185, 90, 22)]];
        self.cardNumberLabel.backgroundColor = [UIColor clearColor];
        self.cardNumberLabel.font = [Helper fontWithSize:16];
        self.cardNumberLabel.textColor = [UIColor blackColor];
        self.cardNumberLabel.textAlignment = NSTextAlignmentLeft;
        self.cardNumberLabel.text = @"******3512";
        self.cardNumberLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.cardNumberLabel];
        
        self.profileImageView= [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"profile_cell"]];
        self.profileImageView.frame = [Helper getRectValue:CGRectMake(129.5f, 2, 60, 60)];
        self.profileImageView.layer.cornerRadius = [Helper getValue:30];
        self.profileImageView.clipsToBounds = YES;
        [self addSubview:self.profileImageView];
        
        self.transNameLabel= [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(50, 65, 220, 20)]];
        self.transNameLabel.backgroundColor = [UIColor clearColor];
        self.transNameLabel.font = [Helper fontWithSize:18];
        self.transNameLabel.textColor = [UIColor blackColor];
        self.transNameLabel.textAlignment = NSTextAlignmentCenter;
        self.transNameLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.transNameLabel];
    
        self.langLabel= [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(50, 85, 220, 14)]];
        self.langLabel.backgroundColor = [UIColor clearColor];
        self.langLabel.font = [Helper fontWithSize:10];
        self.langLabel.textColor = [UIColor blackColor];
        self.langLabel.textAlignment = NSTextAlignmentCenter;
        self.langLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.langLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(160, 40, 140, 15)]];
        self.priceLabel.backgroundColor = [UIColor clearColor];
        self.priceLabel.font = [Helper fontWithSize:12];
        self.priceLabel.textColor = [UIColor orangeColor];
        self.priceLabel.textAlignment = NSTextAlignmentRight;
        self.priceLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.priceLabel];
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
