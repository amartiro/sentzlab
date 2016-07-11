//
//  TranslatorHistoryCell.m
//  LingvoPal
//
//  Created by Artak on 1/25/16.
//  Copyright © 2016 SentzLab. All rights reserved.
//

#import "TranslatorHistoryCell.h"
#import "Helper.h"

@implementation TranslatorHistoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *bkgView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 0, 320, 56)]];
        bkgView.backgroundColor = [UIColor whiteColor];
        bkgView.layer.cornerRadius = [Helper getValue:3];
        [self addSubview:bkgView];
        
        self.transNameLabel= [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(5, 5, 100, 20)]];
        self.transNameLabel.backgroundColor = [UIColor clearColor];
        self.transNameLabel.font = [Helper fontWithSize:20];
        self.transNameLabel.textColor = [UIColor blackColor];
        self.transNameLabel.textAlignment = NSTextAlignmentLeft;
        self.transNameLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.transNameLabel];
        
        
        self.langLabel= [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(5, 25, 100, 14)]];
        self.langLabel.backgroundColor = [UIColor clearColor];
        self.langLabel.font = [Helper fontWithSize:12];
        self.langLabel.textColor = [UIColor blackColor];
        self.langLabel.textAlignment = NSTextAlignmentLeft;
        self.langLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.langLabel];
        
        
        self.dateLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(5, 40, 100, 15)]];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.font = [Helper fontWithSize:12];
        self.dateLabel.textColor = [UIColor blackColor];
        self.dateLabel.textAlignment = NSTextAlignmentLeft;
        self.dateLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.dateLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(205, 20, 100, 15)]];
        self.priceLabel.backgroundColor = [UIColor clearColor];
        self.priceLabel.font = [Helper fontWithSize:12];
        self.priceLabel.textColor = [UIColor greenColor];
        self.priceLabel.textAlignment = NSTextAlignmentRight;
        self.priceLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.priceLabel];
        
//        UIView *lineView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 55, 320, 1)]];
//        lineView.backgroundColor = [UIColor grayColor];
//        [self addSubview:lineView];
     }
    
    return self;
}


@end
