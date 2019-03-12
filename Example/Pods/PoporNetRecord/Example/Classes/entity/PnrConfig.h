//
//  PnrConfig.h
//  PoporNetRecord
//
//  Created by apple on 2018/11/2.
//

#import <Foundation/Foundation.h>
#import <PoporFoundation/PrefixBlock.h>
#import <PoporFoundation/PrefixColor.h>

#import "PnrPrefix.h"
NS_ASSUME_NONNULL_BEGIN

static NSString * PnrPathRoot      = @"root";
static NSString * PnrPathHead      = @"head";
static NSString * PnrPathParameter = @"parameter";
static NSString * PnrPathResponse  = @"response";
static NSString * PnrPathEdit      = @"edit";
static NSString * PnrPathResubmit  = @"resubmit";

typedef NS_ENUM(int, PoporNetRecordType) {
    PoporNetRecordAuto = 1, // 开发环境或者虚拟机环境
    PoporNetRecordEnable, // 全部监测
    PoporNetRecordDisable, // 全部忽略
};

typedef void(^PoporNetRecordNcBlock) (UINavigationController * nc);
typedef void(^PoporNetRecordRecordTypeBlock) (PoporNetRecordType type);

#define PnrColorGreen  RGB16(0x4BB748)
#define PnrColorRed    RGB16(0xF76738)
#define PnrListCellGap 7

@interface PnrConfig : NSObject

@property (nonatomic        ) CGFloat   activeAlpha;
@property (nonatomic        ) CGFloat   normalAlpha;
//@property (nonatomic        ) NSInteger recordMaxNum;

#pragma mark - 列表配置参数
// = (listFontTitle+3) + (listFontDomain+3) + PnrListCellGap*3,可以通过updateListCellHeight设置
@property (nonatomic        ) float   listCellHeight;

@property (nonatomic, strong) UIFont  * listFontTitle;// 标题
@property (nonatomic, strong) UIFont  * listFontRequest;// 请求
@property (nonatomic, strong) UIFont  * listFontDomain;// 域名
@property (nonatomic, strong) UIFont  * listFontTime;// 时间

@property (nonatomic, strong) UIColor * listColorTitle;// 标题
@property (nonatomic, strong) UIColor * listColorRequest;// 请求
@property (nonatomic, strong) UIColor * listColorDomain;// 域名
@property (nonatomic, strong) UIColor * listColorTime;// 时间
// ▽
@property (nonatomic, strong) NSString * listColorTitleHex;
@property (nonatomic, strong) NSString * listColorRequestHex;
@property (nonatomic, strong) NSString * listColorDomainHex;
@property (nonatomic, strong) NSString * listColorTimeHex;

// -----
@property (nonatomic, strong) UIColor * listColorCell0;// 列表偶数行背景色
@property (nonatomic, strong) UIColor * listColorCell1;// 列表奇数行背景色
// ▽
@property (nonatomic, strong) NSString * listColorCell0Hex;
@property (nonatomic, strong) NSString * listColorCell1Hex;

// -----
@property (nonatomic, strong) UIColor * rootColorKey;
@property (nonatomic, strong) UIColor * rootColorValue;
// ▽
@property (nonatomic, strong) NSString * rootColorKeyHex;
@property (nonatomic, strong) NSString * rootColorValueHex;


#pragma mark - 请求详情配置
// 详情假如 att font 不为15也需要设置.
@property (nonatomic, strong) UIFont       * cellTitleFont;
@property (nonatomic, strong) NSDictionary * titleAttributes;// title值颜色
@property (nonatomic, strong) NSDictionary * keyAttributes;// key值颜色
@property (nonatomic, strong) NSDictionary * stringAttributes;// value string颜色
@property (nonatomic, strong) NSDictionary * nonStringAttributes;// value int颜色

@property (nonatomic        ) PoporNetRecordType recordType;//监测类型
@property (nonatomic        ) PoporNetRecordType listWebType;//网页显示数据

@property (nonatomic, copy  ) BlockPVoid            freshBlock;
@property (nonatomic, copy  ) PoporNetRecordNcBlock presentNCBlock;// 用户更新 presentViewController NC的状态

@property (nonatomic        ) BOOL jsonViewColorBlack;// json详情页面是否使用黑白.

// 自定义ballBT可见度, 假如为YES,那么ballBT第一次显示会设置为hidden=YES.
@property (nonatomic, getter=isCustomBallBtVisible) BOOL customBallBtVisible;

// 设置重新发起请求
@property (nonatomic, copy  ) PnrBlockPPnrEntity reRequestBlock;

+ (instancetype)share;

- (BOOL)isRecord;
- (BOOL)isShowListWeb;

- (void)updateListCellHeight;

@end

NS_ASSUME_NONNULL_END
