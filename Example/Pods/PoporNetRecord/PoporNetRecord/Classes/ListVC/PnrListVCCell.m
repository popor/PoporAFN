//
//  PnrListVCCell.m
//  linRunShengPi
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.
//

#import "PnrListVCCell.h"
#import <PoporFoundation/PrefixColor.h>
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
            case 0:{
                self.requestL = oneL;
                oneL.textColor = ColorBlack3;
                
                break;
            }
            case 1:{
                self.timeL = oneL;
                oneL.textColor = ColorBlack3;
                self.timeL.textAlignment = NSTextAlignmentRight;
                
                break;
            }
            case 2:{
                self.domainL = oneL;
                oneL.textColor = ColorBlack6;
                break;
            }
            default:
                break;
        }
    }
    
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-35);
        make.top.mas_equalTo(self.requestL.mas_top);
        make.height.mas_equalTo(self.timeL.font.pointSize + 3);
        make.width.mas_equalTo(65);
    }];
    
    [self.requestL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(self.requestL.font.pointSize + 3);
        make.right.mas_equalTo(self.timeL.mas_left);
    }];
    
    [self.domainL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.requestL.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(self.domainL.font.pointSize + 3);
        make.right.mas_equalTo(self.timeL.mas_right);
    }];
}

@end
