//
//  PnrListVCCell.m
//  linRunShengPi
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.
//

#import "PnrListVCCell.h"
#import <PoporFoundation/ColorPrefix.h>
#import <Masonry/Masonry.h>

@implementation PnrListVCCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self addViews];
    }
    return self;
}

- (void)addViews {
    for (int i = 0; i<3; i++) {
        UILabel * oneL = ({
            UILabel * l = [UILabel new];
            l.backgroundColor    = [UIColor clearColor];
            l.font               = [UIFont systemFontOfSize:15];
            l.numberOfLines      = 1;
            
            [self addSubview:l];
            l;
        });
        
        switch (i) {
            case 0:
                self.titleL = oneL;
                //oneL.font = [UIFont systemFontOfSize:15];
                oneL.textColor = ColorBlack3;
                
                break;
            case 1:
                self.timeL = oneL;
                //oneL.font = [UIFont systemFontOfSize:15];
                oneL.textColor = ColorBlack3;
                self.timeL.textAlignment = NSTextAlignmentRight;
                
                break;
            case 2:
                self.subtitleL = oneL;
                //oneL.font = [UIFont systemFontOfSize:15];
                oneL.textColor = ColorBlack6;
                
                
                break;
            default:
                break;
        }
    }
    
    [self.titleL setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    self.titleL.numberOfLines =0;
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(self.titleL.font.pointSize + 3);
        make.right.mas_equalTo(self.timeL.mas_left).priorityHigh();
    }];
    
    [self.timeL setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    self.timeL.numberOfLines =0;
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-35);
        make.top.mas_equalTo(self.titleL.mas_top);
        make.height.mas_equalTo(self.timeL.font.pointSize + 3);
        make.width.mas_equalTo(65);
    }];
    
    [self.subtitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.titleL.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(self.subtitleL.font.pointSize + 3);
        make.right.mas_equalTo(self.timeL.mas_right);
    }];
}

@end
