//
//  PnrListVCPresenter.m
//  linRunShengPi
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.

#import "PnrListVCPresenter.h"
#import "PnrListVCInteractor.h"
#import "PnrListVCProtocol.h"

#import "PnrDetailVCRouter.h"

#import "PnrListVCCell.h"
#import <JSONSyntaxHighlight/JSONSyntaxHighlight.h>
#import <PoporFoundation/NSString+format.h>
#import "PoporNetRecordConfig.h"

@interface PnrListVCPresenter ()

@property (nonatomic, weak  ) id<PnrListVCProtocol> view;
@property (nonatomic, strong) PnrListVCInteractor  * interactor;
@property (nonatomic, weak  ) PoporNetRecordConfig * config;

@end

@implementation PnrListVCPresenter

- (id)init {
    if (self = [super init]) {
        [self initInteractors];
        self.config = [PoporNetRecordConfig share];
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
        return 55;
    }else{
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.view.infoTV) {
        return 10;
    }else{
        return 0.1;
    }
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
            cellFont15 = [UIFont systemFontOfSize:15];
        }
        PnrListVCCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        if (!cell) {
            cell = [[PnrListVCCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellID];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        PnrVCEntity * entity = self.view.weakInfoArray[indexPath.row];
        
        if (entity.title) {
            NSMutableAttributedString * att = [NSMutableAttributedString new];
            [att addString:entity.title font:cellFont15 color:ColorBlack3];
            [att addString:[NSString stringWithFormat:@" %@", entity.request] font:cellFont15 color:ColorBlack6];
            cell.requestL.attributedText = att;
        }else{
            cell.requestL.text = entity.request;
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
        
        PnrVCEntity * entity = self.view.weakInfoArray[indexPath.row];
        //NSString * requestDes  = [self replaceUnicode:[entity.requestDic description]];
        //NSString * responseDes = [self replaceUnicode:[entity.responseDic description]];
        NSString * title;
        if (entity.title) {
            title = [NSString stringWithFormat:@" %@\n%@", entity.title, entity.request];
        }else{
            title = [NSString stringWithFormat:@" \n%@",entity.request];
        }
        NSArray * titleArray = @[[NSString stringWithFormat:@"接口:%@", title],
                                 [NSString stringWithFormat:@"链接:\n%@", entity.url],
                                 [NSString stringWithFormat:@"时间:\n%@", entity.time],
                                 [NSString stringWithFormat:@"方法:\n%@", entity.method],
                                 
                                 @"head参数:\n",
                                 @"请求参数:\n",
                                 @"返回数据:\n",
                                 ];
        NSArray * jsonArray = @[[NSNull null],
                                [NSNull null],
                                [NSNull null],
                                [NSNull null],
                                
                                entity.headValue ?:[NSNull null],
                                entity.requesValue ?:[NSNull null],
                                entity.responseValue ?:[NSNull null],
                                ];
        
        
        NSMutableArray * cellAttArray = [NSMutableArray new];
        for (int i = 0; i<jsonArray.count; i++) {
            NSDictionary * json = jsonArray[i];
            
            NSMutableAttributedString * cellAtt = [[NSMutableAttributedString alloc] initWithString:titleArray[i] attributes:self.config.titleAttributes];
            
            if (json) {
                if ([json isKindOfClass:[NSDictionary class]]) {
                    JSONSyntaxHighlight *jsh = [[JSONSyntaxHighlight alloc] initWithJSON:json];
                    jsh.keyAttributes       = self.config.keyAttributes;
                    jsh.stringAttributes    = self.config.stringAttributes;
                    jsh.nonStringAttributes = self.config.nonStringAttributes;
                    NSAttributedString * jsonAtt = [jsh highlightJSON];
                    [cellAtt appendAttributedString:jsonAtt];
                }else if ([json isKindOfClass:[NSString class]]) {
                    [cellAtt addString:(NSString *)json font:nil color:[UIColor darkGrayColor]];
                }
            }
            
            [cellAttArray addObject:cellAtt];
        }
        NSDictionary * vcDic = @{
                                 @"title":@"请求详情",
                                 @"jsonArray":jsonArray,
                                 @"titleArray":titleArray,
                                 @"cellAttArray":cellAttArray,
                                 };
        [self.view.vc.navigationController pushViewController:[PnrDetailVCRouter vcWithDic:vcDic] animated:YES];
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

#pragma mark - Interactor_EventHandler

@end
