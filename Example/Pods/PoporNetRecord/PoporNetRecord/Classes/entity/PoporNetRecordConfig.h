//
//  PoporNetRecordConfig.h
//  JSONSyntaxHighlight
//
//  Created by apple on 2018/11/2.
//

#import <Foundation/Foundation.h>
#import <PoporFoundation/PrefixBlock.h>
#import <PoporFoundation/PrefixColor.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(int, PoporNetRecordType) {
    PoporNetRecordAuto = 1, // 开发环境或者虚拟机环境
    PoporNetRecordEnable, // 全部监测
    PoporNetRecordDisable, // 全部忽略
};

typedef void(^PoporNetRecordNcBlock) (UINavigationController * nc);
typedef void(^PoporNetRecordRecordTypeBlock) (PoporNetRecordType type);

#define PnrColorGreen RGB16(0x4BB748)
#define PnrColorRed   RGB16(0xF76738)

@interface PoporNetRecordConfig : NSObject

@property (nonatomic        ) CGFloat            activeAlpha;
@property (nonatomic        ) CGFloat            normalAlpha;
@property (nonatomic        ) NSInteger          recordMaxNum;

// 假如 att font 不为15也需要设置.
@property (nonatomic, strong) UIFont             * cellTitleFont;
@property (nonatomic, strong) NSDictionary       * titleAttributes;// title值颜色
@property (nonatomic, strong) NSDictionary       * keyAttributes;// key值颜色
@property (nonatomic, strong) NSDictionary       * stringAttributes;// value string颜色
@property (nonatomic, strong) NSDictionary       * nonStringAttributes;// value int颜色

@property (nonatomic        ) PoporNetRecordType recordType;//监测类型
    
// Block
@property (nonatomic, copy  ) BlockPVoid                    freshBlock;
@property (nonatomic, copy  ) PoporNetRecordRecordTypeBlock recordTypeBlock;
@property (nonatomic, copy  ) PoporNetRecordNcBlock         presentNCBlock;// 用户更新 presentViewController NC的状态

@property (nonatomic        ) BOOL jsonViewColorBlack;// json详情页面是否使用黑白.
    
+ (instancetype)share;

@end

NS_ASSUME_NONNULL_END
