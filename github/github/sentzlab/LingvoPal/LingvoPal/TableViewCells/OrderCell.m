//
//  OrderCell.m
//  LingvoPal
//
//  Created by Artak on 1/22/16.
//  Copyright © 2016 SentzLab. All rights reserved.
//

#import "OrderCell.h"
#import "Helper.h"

@interface OrderCell()



@end

@implementation OrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *bkgView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 0, 320, 52)]];
        bkgView.backgroundColor = [UIColor whiteColor];
        bkgView.layer.cornerRadius = [Helper getValue:3];
        [self addSubview:bkgView];
        
        self.transNameLabel= [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(15, 8, 200, 20)]];
        self.transNameLabel.backgroundColor = [UIColor clearColor];
        self.transNameLabel.font = [Helper fontWithSize:18];
        self.transNameLabel.textColor = [UIColor blackColor];
        self.transNameLabel.textAlignment = NSTextAlignmentLeft;
        self.transNameLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.transNameLabel];
        
        
        self.langLabel= [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(15, 30, 100, 15)]];
        self.langLabel.backgroundColor = [UIColor clearColor];
        self.langLabel.font = [Helper fontWithSize:12];
        self.langLabel.textColor = [UIColor blackColor];
        self.langLabel.textAlignment = NSTextAlignmentLeft;
        self.langLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.langLabel];
        
        
        self.translateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.translateButton.frame = [Helper getRectValue:CGRectMake(250, 11, 52, 30)];
        self.translateButton.titleLabel.font = [Helper fontWithSize:10];
        [self.translateButton setBackgroundImage:[Helper getImageByImageName:@"translate_cell"] forState:UIControlStateNormal];
        [self.translateButton setTitle:@"Translate" forState:UIControlStateNormal];
        [self addSubview:self.translateButton];
        
        self.priceLabel= [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(120, 30, 110, 15)]];
        self.priceLabel.backgroundColor = [UIColor clearColor];
        self.priceLabel.font = [Helper fontWithSize:12];
        self.priceLabel.textColor = [UIColor lightGrayColor];
        self.priceLabel.textAlignment = NSTextAlignmentLeft;
        self.priceLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.priceLabel];
        
//        UIView *lineView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 51, 320, 1)]];
//        lineView.backgroundColor = [UIColor grayColor];
//        [self addSubview:lineView];
    }
    
    return self;
}


@end
