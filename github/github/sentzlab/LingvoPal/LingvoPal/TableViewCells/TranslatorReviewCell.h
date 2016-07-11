//
//  TranslatorReviewCell.h
//  LingvoPal
//
//  Created by Artak on 2/1/16.
//  Copyright © 2016 SentzLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TranslatorReviewCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *callTypeLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *langLabel;

-(void) setRate:(NSInteger) rate andReviewText:(NSString *) reviewText;

@end
