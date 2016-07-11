//
//  ReviewCell.h
//  LingvoPal
//
//  Created by Artak on 12/24/15.
//  Copyright © 2015 SentzLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;



-(void) setRate:(NSInteger) rate;

@end
