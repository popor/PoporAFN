//
//  PnrListVCCell.h
//  PoporNetRecord
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.
//

#import <UIKit/UIKit.h>

static int PnrListCellTextLeftGap  = 15;
static int PnrListCellTextRightGap = 35;

@interface PnrListVCCell : UITableViewCell

@property (nonatomic, strong) UILabel * requestL;
@property (nonatomic, strong) UILabel * domainL;

@property (nonatomic, strong) UILabel * timeL;

+ (int)cellLogH:(NSString *)log;

@end
