//
//  PnrListVCCell.m
//  PoporNetRecord
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.
//

#import "PnrListVCCell.h"
#import <PoporFoundation/Color+pPrefix.h>
#import <PoporFoundation/NSString+pSize.h>
#import <Masonry/Masonry.h>
#import "PnrConfig.h"

@implementation PnrListVCCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addViews];
    }
    return self;
}

- (void)addViews {
    PnrConfig * config = [PnrConfig share];
    for (int i = 0; i<3; i++) {
        UILabel * oneL = ({
            UILabel * l = [UILabel new];
            l.backgroundColor    = [UIColor clearColor];
            l.font               = [UIFont systemFontOfSize:15];
            
            [self addSubview:l];
            l;
        });
        
        switch (i) {
            case 0:{
                self.requestL  = oneL;
                oneL.textColor = config.listColorTitle;
                oneL.font      = config.listFontTitle;
                oneL.numberOfLines = 1;
                break;
            }
            case 1:{
                oneL.textAlignment = NSTextAlignmentRight;
                self.timeL     = oneL;
                oneL.textColor = config.listColorTime;
                oneL.font      = config.listFontTime;
                oneL.numberOfLines = 1;
                break;
            }
            case 2:{
                self.domainL   = oneL;
                oneL.textColor = config.listColorDomain;
                oneL.font      = config.listFontDomain;
                oneL.numberOfLines = 0;
                break;
            }
            default:
                break;
        }
    }
    float gap = PnrListCellGap;
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-PnrListCellTextRightGap);
        make.top.mas_equalTo(gap);
        make.height.mas_equalTo(self.timeL.font.pointSize + 3);
        make.width.mas_equalTo(65);
    }];
    
    [self.requestL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PnrListCellTextLeftGap);
        make.top.mas_equalTo(gap);
        make.height.mas_equalTo(MAX(config.listFontTitle.pointSize, config.listFontRequest.pointSize) + 3);
        make.right.mas_equalTo(self.timeL.mas_left);
    }];
    
    [self.domainL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PnrListCellTextLeftGap);
        make.top.mas_equalTo(self.requestL.mas_bottom).mas_offset(gap-1);
        //make.height.mas_equalTo(self.domainL.font.pointSize + 3);
        make.right.mas_equalTo(self.timeL.mas_right);
        make.bottom.mas_equalTo(-gap);
    }];
}

+ (int)cellLogH:(NSString *)log {
    static int textWidth;
    
    static PnrConfig * config;
    if (textWidth == 0) {
        textWidth = [[UIScreen mainScreen] bounds].size.width - PnrListCellTextLeftGap - PnrListCellTextRightGap;
        config = [PnrConfig share];
    }

    if (log) {
        return config.listCellHeight - config.listFontTitle.pointSize + [log sizeInFont:config.listFontDomain width:textWidth].height;
    }else{
        return 44;
    }
}

@end
