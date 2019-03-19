//
//  PnrListVCPresenter.m
//  PoporNetRecord
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.

#import "PnrListVCPresenter.h"
#import "PnrListVCInteractor.h"

#import "PnrWebServer.h"
#import "PnrConfig.h"

#import "PnrDetailVCRouter.h"
#import "PnrListVCCell.h"
#import <PoporFoundation/NSString+format.h>
#import <PoporUI/UIDevice+Tool.h>
#import <PoporUI/UIImage+create.h>

@interface PnrListVCPresenter ()

@property (nonatomic, weak  ) id<PnrListVCProtocol> view;
@property (nonatomic, strong) PnrListVCInteractor  * interactor;
@property (nonatomic, weak  ) PnrConfig * config;

@end

@implementation PnrListVCPresenter

- (id)init {
    if (self = [super init]) {
        [self initInteractors];
        self.config = [PnrConfig share];
    }
    return self;
}

- (void)setMyView:(id<PnrListVCProtocol>)view {
    self.view = view;
}

- (void)initInteractors {
    if (!self.interactor) {
        self.interactor = [PnrListVCInteractor new];
    }
}

#pragma mark - VC_DataSource

#pragma mark - TV_Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.view.infoTV) {
        return 1;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.view.infoTV) {
        return self.view.weakInfoArray.count;
    }else{
        return 2;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.view.infoTV) {
        return self.config.listCellHeight;
    }else{
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.view.infoTV) {
        return 10;
    }else{
        return 0.1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.view.infoTV) {
        static NSString * CellID   = @"infoTV";
        static UIFont * cellFont15;
        if (!cellFont15) {
            cellFont15 = [UIFont systemFontOfSize:20];
        }
        PnrListVCCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        if (!cell) {
            cell = [[PnrListVCCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellID];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        PnrEntity * entity = self.view.weakInfoArray[self.view.weakInfoArray.count -  indexPath.row - 1];
        
        if (entity.title) {
            NSMutableAttributedString * att = [NSMutableAttributedString new];
            //[att addString:entity.title font:cellFont15 color:ColorBlack3];
            //[att addString:[NSString stringWithFormat:@" %@", entity.request] font:cellFont15 color:ColorBlack6];
            
            [att addString:entity.title font:self.config.listFontTitle color:self.config.listColorTitle];
            [att addString:[NSString stringWithFormat:@" %@", entity.path] font:self.config.listFontRequest color:self.config.listColorRequest];
            
            cell.requestL.attributedText = att;
        }else{
            cell.requestL.text      = entity.path;
            cell.requestL.font      = self.config.listFontRequest;
            cell.requestL.textColor = self.config.listColorRequest;
        }
        cell.timeL.text    = entity.time;
        cell.domainL.text  = entity.domain;
        
        if (indexPath.row%2 == 0) {
            cell.backgroundColor = [UIColor whiteColor];
        }else{
            cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
        }
        return cell;
    }else{
        static NSString * CellID = @"alertTV";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellID];
            cell.backgroundColor     = [UIColor clearColor];
            cell.textLabel.font      = [UIFont systemFontOfSize:16];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.tintColor           = [UIColor whiteColor];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"彩色:高内存";
            if (self.config.jsonViewColorBlack) {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }else{
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }else{
            cell.textLabel.text = @"黑色:低内存";
            if (self.config.jsonViewColorBlack) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.view.infoTV) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        PnrEntity * entity = self.view.weakInfoArray[self.view.weakInfoArray.count -  indexPath.row - 1];
        
        __weak typeof(self) weakSelf = self;
        [entity getJsonArrayBlock:^(NSArray *titleArray, NSArray *jsonArray, NSMutableArray *cellAttArray) {
            
            NSDictionary * vcDic = @{
                                     @"title":@"请求详情",
                                     @"jsonArray":jsonArray,
                                     @"titleArray":titleArray,
                                     @"cellAttArray":cellAttArray,
                                     };
            [weakSelf.view.vc.navigationController pushViewController:[PnrDetailVCRouter vcWithDic:vcDic] animated:YES];
        }];
       
    }else{
        if (indexPath.row == 0) {
            [self save__textColor:PoporNetRecordTextColorColors];
        }else if (indexPath.row == 1) {
            [self save__textColor:PoporNetRecordTextColorBlack];
        }
        [self setRightBarAction];
        [self.view.alertBubbleView closeEvent];
    }
    
}

#pragma mark - VC_EventHandler
- (void)closeAction {
    UIViewController * topVC = self.view.vc;
    if (topVC.navigationController) {
        if (topVC.navigationController.viewControllers.count == 1) {
            [topVC.navigationController dismissViewControllerAnimated:YES completion:nil];
        }else{
            [topVC.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [topVC dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)clearAction {
    [self.view.weakInfoArray removeAllObjects];
    [self.view.infoTV reloadData];
    
    // 清空记录
    [[PnrWebServer share] clearListWeb];
}

- (void)setTextColorAction:(UIBarButtonItem *)sender event:(UIEvent *)event {
    //CGRect fromRect = [[event.allTouches anyObject] view].frame;
    UITouch * touch = [event.allTouches anyObject];
    //UIWindow * window = [[UIApplication sharedApplication] keyWindow];
                         
    //CGPoint point = [touch locationInView:window];
    //fromRect.origin = point;
    
    CGRect fromRect = [touch.view.superview convertRect:touch.view.frame toView:self.view.vc.navigationController.view];
    fromRect.origin.y -= 7;
    
    NSDictionary * dic = @{
                           @"direction":@(AlertBubbleViewDirectionTop),
                           @"baseView":self.view.vc.navigationController.view,
                           @"borderLineColor":self.view.alertBubbleTVColor,
                           @"borderLineWidth":@(1),
                           @"corner":@(5),
                           @"trangleHeight":@(8),
                           @"trangleWidth":@(8),
                           
                           @"borderInnerGap":@(15),
                           @"customeViewInnerGap":@(0),
                           
                           @"bubbleBgColor":self.view.alertBubbleTVColor,
                           @"bgColor":[UIColor clearColor],
                           @"showAroundRect":@(NO),
                           @"showLogInfo":@(NO),
                           };
    
    self.view.alertBubbleView = [[AlertBubbleView alloc] initWithDic:dic];
    
    [self.view.alertBubbleView showCustomView:self.view.alertBubbleTV around:fromRect close:nil];
}

- (NSString *)textColorText {
    NSString * textColor = [self get__textColor];
    if (!textColor) {
        textColor = PoporNetRecordTextColorColors;
        [self save__textColor:PoporNetRecordTextColorColors];
    }
    // MARK: 设置json字体颜色单例变量
    {
        if ([textColor isEqualToString:PoporNetRecordTextColorColors]) {
            self.config.jsonViewColorBlack = NO;
        }else{
            self.config.jsonViewColorBlack = YES;
        }
    }
    return textColor;
}

- (void)save__textColor:(NSString *)textColor {
    [[NSUserDefaults standardUserDefaults] setObject:textColor forKey:@"PoporNetRecord_textColor"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)get__textColor {
    NSString * info = [[NSUserDefaults standardUserDefaults] objectForKey:@"PoporNetRecord_textColor"];
    return info;
}

- (void)setRightBarAction {
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:[self textColorText] style:UIBarButtonItemStylePlain target:self action:@selector(setTextColorAction:event:)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clearAction)];
    self.view.vc.navigationItem.rightBarButtonItems = @[item2, item1];
}

- (void)updateServerBT {
    PnrWebServer * tool = [PnrWebServer share];
    UIButton * oneBT = self.view.serverBT;
    if (tool.webServer.serverURL) {
        UIImage * image = [UIImage imageFromColor:PnrColorGreen size:CGSizeMake(10, 10) corner:5];
        [oneBT setImage:image forState:UIControlStateNormal];
        
        NSMutableAttributedString * att = [NSMutableAttributedString new];
        [att addString:@"  已开启 " font:[UIFont systemFontOfSize:15] color:PnrColorGreen];
        
        [att addString:[NSString stringWithFormat:@"%@", tool.webServer.serverURL.absoluteString] font:[UIFont systemFontOfSize:15] color:[UIColor blackColor]];
        
        NSString * wifi = [UIDevice getWifiName];
        if (wifi) {
            [att addString:@" (" font:[UIFont systemFontOfSize:15] color:[UIColor blackColor]];
            [att addString:[NSString stringWithFormat:@"%@", wifi] font:[UIFont systemFontOfSize:15] color:PnrColorGreen];
            [att addString:@") " font:[UIFont systemFontOfSize:15] color:[UIColor blackColor]];
            
        }
        
        [oneBT setAttributedTitle:att forState:UIControlStateNormal];
    }else{
        UIImage * image = [UIImage imageFromColor:PnrColorRed size:CGSizeMake(10, 10) corner:5];
        [oneBT setImage:image forState:UIControlStateNormal];
        
        NSMutableAttributedString * att = [NSMutableAttributedString new];
        [att addString:@"  未开启 " font:[UIFont systemFontOfSize:15] color:PnrColorRed];
        [att addString:@"WIFI 或者无法获得IP地址" font:[UIFont systemFontOfSize:15] color:[UIColor blackColor]];
        
        [oneBT setAttributedTitle:att forState:UIControlStateNormal];
    }
}

- (void)editPortAction {
    {
        NSString * message = @"端口修改后，下次启动生效";// @"Get端口和Post端口\n修改后，下次启动生效"
        UIAlertController * oneAC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        
        [oneAC addTextFieldWithConfigurationHandler:^(UITextField *textField){
            
            textField.placeholder = [NSString stringWithFormat:@"%i", PnrPortGet];
            textField.text = [NSString stringWithFormat:@"%i", [PnrPortEntity getPort_get]];
        }];
        //        [oneAC addTextFieldWithConfigurationHandler:^(UITextField *textField){
        //
        //            textField.placeholder = [NSString stringWithFormat:@"%i", PnrPortPost];
        //            textField.text = [NSString stringWithFormat:@"%i", [PnrPortEntity getPort_post]];
        //        }];
        
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * changeAction = [UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            int portGet  = oneAC.textFields[0].text.intValue;
            if (portGet != 0) {
                [PnrPortEntity savePort_get:portGet];
            }
            //            int portGet  = oneAC.textFields[0].text.intValue;
            //            int portPost = oneAC.textFields[1].text.intValue;
            //            if (portGet!=0 && portPost!=0 && portGet!=portPost) {
            //                [PnrPortEntity savePort_get:portGet];
            //                [PnrPortEntity savePort_post:portPost];
            //            }
        }];
        
        [oneAC addAction:cancleAction];
        [oneAC addAction:changeAction];
        
        [self.view.vc presentViewController:oneAC animated:YES completion:nil];
    }
}

#pragma mark - Interactor_EventHandler

@end
