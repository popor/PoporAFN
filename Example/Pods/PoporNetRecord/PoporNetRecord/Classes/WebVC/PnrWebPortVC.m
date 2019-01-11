//
//  PnrWebPortVC.m
//  GCDWebServer
//
//  Created by apple on 2018/12/18.
//

#import "PnrWebPortVC.h"
#import <Masonry/Masonry.h>
#import <PoporUI/UIInsetsTextField.h>
#import <PoporFoundation/PrefixColor.h>
#import <PoporUI/IToastKeyboard.h>
#import <PoporUI/UIImage+create.h>

@interface PnrWebPortVC ()

@property (nonatomic        ) int               cellH;
@property (nonatomic, strong) UIColor           * blueColor;

@property (nonatomic, weak  ) PnrWebPortEntity  * portEntity;

@property (nonatomic, strong) UIInsetsTextField * allPortTF;
@property (nonatomic, strong) UIInsetsTextField * headPortTF;
@property (nonatomic, strong) UIInsetsTextField * requestPortTF;
@property (nonatomic, strong) UIInsetsTextField * responsePortTF;

@property (nonatomic, strong) UISwitch          * jsonWindowSwitch;
@property (nonatomic, strong) UISwitch          * detailVCSwitch;

@end

@implementation PnrWebPortVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title                = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    self.blueColor            = RGB16(0X4585F5);
    self.cellH                = 30;
    
    self.portEntity = [PnrWebPortEntity share];
    [self addTFs];
    [self addWindowSwitch];
}

- (void)addTFs {
    NSArray * titleArray = @[@"主页端口", @"head端口", @"参数端口", @"返回数据端口"];
    NSArray * placeArray = @[[NSString stringWithFormat:@"%i", PoporNetRecordAllPort],
                             [NSString stringWithFormat:@"%i", PoporNetRecordHeadPort],
                             [NSString stringWithFormat:@"%i", PoporNetRecordRequestPort],
                             [NSString stringWithFormat:@"%i", PoporNetRecordResponsePort],
                             ];
    NSArray * textArray = @[[NSString stringWithFormat:@"%i", self.portEntity.allPortInt],
                            [NSString stringWithFormat:@"%i", self.portEntity.headPortInt],
                            [NSString stringWithFormat:@"%i", self.portEntity.requestPortInt],
                            [NSString stringWithFormat:@"%i", self.portEntity.responsePortInt],
                            ];
    int height = self.cellH;
    UILabel * lastL;
    for (int i = 0; i<titleArray.count; i++) {
        UILabel * oneL = ({
            UILabel * l = [UILabel new];
            l.frame              = CGRectMake(0, 0, 0, 44);
            l.backgroundColor    = [UIColor clearColor];
            l.font               = [UIFont systemFontOfSize:15];
            l.textColor          = [UIColor darkGrayColor];
            
            [self.view addSubview:l];
            l;
        });
        UIInsetsTextField * oneTF = ({
            UIInsetsTextField * tf = [[UIInsetsTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 44) insets:UIEdgeInsetsMake(0, 10, 0, 10)];
            tf.backgroundColor    = [UIColor clearColor];
            tf.font               = [UIFont systemFontOfSize:15];
            tf.textColor          = [UIColor darkGrayColor];
            
            tf.layer.cornerRadius = 5;
            tf.layer.borderColor  = [UIColor lightGrayColor].CGColor;
            tf.layer.borderWidth  = 1;
            tf.clipsToBounds      = YES;
            
            [self.view addSubview:tf];
            tf;
        });
        UIButton * oneBT = ({
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"更新" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageFromColor:self.blueColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            
            button.layer.cornerRadius = 5;
            button.clipsToBounds      = YES;
            button.titleLabel.font    = [UIFont systemFontOfSize:15];
            
            [self.view addSubview:button];
            
            [button addTarget:self action:@selector(updateTfBtAction:) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
        oneBT.tag         = i;
        oneL.text         = titleArray[i];
        oneTF.placeholder = placeArray[i];
        oneTF.text        = textArray[i];
        
        switch (i) {
            case 0: {
                self.allPortTF      = oneTF;
                break;
            }
            case 1: {
                self.headPortTF = oneTF;
                break;
            }
            case 2: {
                self.requestPortTF = oneTF;
                break;
            }
            case 3: {
                self.responsePortTF = oneTF;
                break;
            }
                
            default:
                break;
        }
        [oneL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            if (lastL) {
                make.top.mas_equalTo(lastL.mas_bottom).mas_offset(10);
            }else{
                make.top.mas_equalTo(20).mas_offset(10);
            }
            
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(height);
        }];
        
        [oneTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(oneL.mas_right).mas_offset(10);
            make.top.mas_equalTo(oneL.mas_top);
            make.bottom.mas_equalTo(oneL.mas_bottom);
            make.width.mas_equalTo(80);
        }];
        [oneBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(oneTF.mas_right).mas_offset(20);
            make.top.mas_equalTo(oneTF.mas_top);
            make.bottom.mas_equalTo(oneTF.mas_bottom);
            make.width.mas_equalTo(60);
        }];
        lastL = oneL;
    }
    
}

- (void)updateTfBtAction:(UIButton *)bt {
    switch (bt.tag) {
        case 0:{
            if (self.allPortTF.text.length > 0) {
                [PnrWebPortEntity saveAllPort:self.allPortTF.text];
                self.portEntity.allPortInt = self.allPortTF.text.intValue;
                AlertToastTitle(@"重新载入生效");
            }else{
                AlertToastTitle(@"端口号不能为空");
            }
            break;
        }
        case 1:{
            if (self.headPortTF.text.length > 0) {
                [PnrWebPortEntity saveHeadPort:self.headPortTF.text];
                self.portEntity.headPortInt = self.headPortTF.text.intValue;
                AlertToastTitle(@"重新载入生效");
            }else{
                AlertToastTitle(@"端口号不能为空");
            }
            break;
        }
        case 2:{
            if (self.requestPortTF.text.length > 0) {
                [PnrWebPortEntity saveRequestPort:self.requestPortTF.text];
                self.portEntity.requestPortInt = self.requestPortTF.text.intValue;
                AlertToastTitle(@"重新载入生效");
            }else{
                AlertToastTitle(@"端口号不能为空");
            }
            break;
        }
        case 3:{
            if (self.responsePortTF.text.length > 0) {
                [PnrWebPortEntity saveResponsePort:self.responsePortTF.text];
                self.portEntity.responsePortInt = self.responsePortTF.text.intValue;
                AlertToastTitle(@"重新载入生效");
            }else{
                AlertToastTitle(@"端口号不能为空");
            }
            break;
        }
        default:
            break;
    }
    
}

#pragma mark - 新窗口
- (void)addWindowSwitch {
    UIView * lastView = self.responsePortTF;
    NSArray * titleArray = @[@"新窗口打开JSON详情页", @"请求详情 页面开启服务"];
    for (int i=0; i<titleArray.count; i++) {
        UILabel * oneL = ({
            UILabel * l = [UILabel new];
            l.frame              = CGRectMake(0, 0, 0, 44);
            l.backgroundColor    = [UIColor clearColor];
            l.font               = [UIFont systemFontOfSize:15];
            l.textColor          = [UIColor darkGrayColor];
            
            [self.view addSubview:l];
            l;
        });
        
        UISwitch * oneUIS = ({
            UISwitch * uis = [UISwitch new];
            uis.onTintColor = self.blueColor;
            [uis addTarget:self action:@selector(UISAction:) forControlEvents:UIControlEventValueChanged];
            
            [self.view addSubview:uis];
            uis;
        });
        oneL.text = titleArray[i];
        
        switch (i) {
            case 0:{
                self.jsonWindowSwitch = oneUIS;
                [oneUIS setOn:self.portEntity.jsonWindow];
                
                break;
            }
            case 1:{
                self.detailVCSwitch = oneUIS;
                [oneUIS setOn:self.portEntity.detailVCStartServer];
                
                break;
            }
            default:
                break;
        }
        [oneL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(lastView.mas_bottom).mas_offset(10);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(self.cellH);
        }];
        
        [oneUIS mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(220);
            make.top.mas_equalTo(lastView.mas_bottom).mas_offset(10);
        }];
        lastView = oneUIS;
        
    }
}

- (void)UISAction:(UISwitch *)us {
    if (us == self.jsonWindowSwitch) {
        self.portEntity.jsonWindow = us.on;
        [PnrWebPortEntity saveJsonWindow:us.on];
    }else if (us == self.detailVCSwitch) {
        self.portEntity.detailVCStartServer = us.on;
        [PnrWebPortEntity saveDetailVCStartServer:us.on];
    }
    
    AlertToastTitle(@"重新载入生效");
}

@end
