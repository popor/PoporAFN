//
//  PnrDetailCell.m
//  PoporNetRecord
//
//  Created by apple on 2018/11/2.
//

#import "PnrDetailCell.h"
#import "PnrConfig.h"
#import <Masonry/Masonry.h>

@interface PnrDetailCell ()

@property (nonatomic, weak  ) PnrConfig * config;

@end

@implementation PnrDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.config = [PnrConfig share];
        [self addViews];
    }
    return self;
}

- (void)addViews {
    self.textL = ({
        UILabel * l = [UILabel new];
        l.font = self.config.cellTitleFont;
        l.numberOfLines = 0;
        l.lineBreakMode = NSLineBreakByClipping;
        
        [self addSubview:l];
        l;
    });
    
    [self.textL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(3, 15, 5, 15));
    }];
}

@end
