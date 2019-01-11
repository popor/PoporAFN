//
//  PnrWebVC.m
//  GCDWebServer
//
//  Created by apple on 2018/12/3.
//

#import "PnrWebVC.h"

#import <Masonry/Masonry.h>
#import <PoporQRCodeIos/JPQRCodeTool.h>

#import <PoporFoundation/NSString+format.h>
#import <PoporFoundation/PrefixColor.h>
#import <PoporUI/IToastKeyboard.h>
#import <PoporUI/UIDevice+Tool.h>
#import <PoporUI/UIInsetsTextField.h>

#import "PnrWebPortVC.h"
#import "PoporNetRecordConfig.h"

@interface PnrWebVC ()

@property (nonatomic, strong) UILabel          * infoL;
@property (nonatomic, strong) UIImageView      * qrCodeIV;

@property (nonatomic, weak  ) PnrWebPortEntity * portEntity;

@end

@implementation PnrWebVC

- (void)dealloc {
    if (!self.portEntity.detailVCStartServer) {
        [self.portEntity stopServer];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Web";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.portEntity = [PnrWebPortEntity share];
    [self.portEntity startServerTitle:self.titleArray json:self.jsonArray];
    
    [self setWebUrl:self.portEntity.webServerAll.serverURL.absoluteString];
    [self addQrIV:self.portEntity.webServerAll.serverURL.absoluteString];
    
    {
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(showPnrWebPortVC)];
        self.navigationItem.rightBarButtonItems = @[item1];
    }
}



- (void)setWebUrl:(NSString *)webUrl {
    UIFont * font1 = [UIFont systemFontOfSize:16];
    if (!self.infoL) {
        self.infoL = [UILabel new];
        self.infoL.backgroundColor = [UIColor clearColor];
        self.infoL.font = font1;
        
        [self.view addSubview:self.infoL];
    }
    
    NSMutableAttributedString * att = [NSMutableAttributedString new];
    if (!webUrl) {
        [att addString:@"通过 WIFI 查看详情\n" font:font1 color:[UIColor blackColor]];
        [att addString:@"未开启 WIFI 或者无法获得IP地址" font:font1 color:PnrColorRed];
    }else{
        NSString * wifi = [UIDevice getWifiName];
        if (wifi) {
            [att addString:@"通过 WIFI(" font:font1 color:[UIColor blackColor]];
            [att addString:wifi font:font1 color:PnrColorGreen];
            [att addString:@") 查看详情，确保其他设备处于同一网段内，访问网址:\n" font:font1 color:[UIColor blackColor]];
        }else{
            [att addString:@"通过 WIFI 查看详情，访问网址:\n" font:font1 color:[UIColor blackColor]];
        }
        
        [att addString:webUrl font:font1 color:PnrColorGreen];
    }
    
    self.infoL.attributedText = att;
    self.infoL.numberOfLines  = 0;
    self.infoL.frame = CGRectMake(10, 10, self.view.frame.size.width-20, 60);
}

- (void)addQrIV:(NSString *)webUrl {
    UIImageView * oneIV = ({
        UIImageView * iv = [UIImageView new];
        iv.userInteractionEnabled = YES;
        iv.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:iv];
        iv;
    });
    self.qrCodeIV = oneIV;
    [self.qrCodeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.top.mas_equalTo(self.infoL.mas_bottom).mas_offset(40);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(oneIV.mas_width);
    }];
 
    NSArray *colors = @[RGB16(0X68D3FF), RGB16(0X4585F5)];
    NSString *codeStr = webUrl;
    
    UIImage *img = [JPQRCodeTool generateCodeForString:codeStr withCorrectionLevel:kQRCodeCorrectionLevelHight SizeType:kQRCodeSizeTypeCustom customSizeDelta:20 drawType:kQRCodeDrawTypeSquare gradientType:kQRCodeGradientTypeHorizontal gradientColors:colors];
    
    oneIV.image = img;
}

- (void)showPnrWebPortVC {
    [self.navigationController pushViewController:[PnrWebPortVC new] animated:YES];
}

@end
