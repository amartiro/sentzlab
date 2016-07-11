//
//  HistoryBottomCell.m
//  LingvoPal
//
//  Created by Artak Martirosyan on 5/23/16.
//  Copyright © 2016 SentzLab Inc. All rights reserved.
//

#import "HistoryBottomCell.h"
#import "Helper.h"

@implementation HistoryBottomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bkgView.frame = [Helper getRectValue:CGRectMake(1, 0, 318, 208)];
        self.bkgView.image = [Helper getImageByImageName:@"history_bottom_cell"];
    }
    
    return self;
}

@end
