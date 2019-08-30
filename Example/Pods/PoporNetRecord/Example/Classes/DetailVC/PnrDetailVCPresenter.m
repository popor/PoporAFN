//
//  PnrDetailVCPresenter.m
//  PoporNetRecord
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.

#import "PnrDetailVCPresenter.h"
#import "PnrDetailVCInteractor.h"

#import <PoporUI/IToastKeyboard.h>
#import <PoporFoundation/NSString+pSize.h>
#import <PoporFoundation/NSString+pAtt.h>
#import <PoporFoundation/Color+pPrefix.h>

#import "PnrConfig.h"
#import "PnrDetailCell.h"

@interface PnrDetailVCPresenter ()

@property (nonatomic, weak  ) id<PnrDetailVCProtocol> view;
@property (nonatomic, strong) PnrDetailVCInteractor * interactor;
@property (nonatomic, weak  ) PnrConfig  * config;

@end

@implementation PnrDetailVCPresenter

- (id)init {
    if (self = [super init]) {
        self.config = [PnrConfig share];
        
    }
    return self;
}

// 初始化数据处理
- (void)setMyInteractor:(PnrDetailVCInteractor *)interactor {
    self.interactor = interactor;
    
}

// 很多操作,需要在设置了view之后才可以执行.
- (void)setMyView:(id<PnrDetailVCProtocol>)view {
    self.view = view;
    
}

#pragma mark - VC_DataSource

#pragma mark - TV_Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.view.cellAttArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float width = self.view.vc.view.frame.size.width;
    NSMutableAttributedString * att = self.view.cellAttArray[indexPath.row];
    static UILabel * l;
    if (!l) {
        l = [UILabel new];
        l.font = self.config.cellTitleFont;
        l.numberOfLines = 0;
    }
    l.frame = CGRectMake(0, 0, width-30, 10);
    
    switch (self.config.jsonViewColorBlack) {
        case PnrListTypeTextColor: {
            l.attributedText = att;
            break;
        }
        case PnrListTypeTextBlack: {
            l.text = att.string;
            break;
        }
        default:{
            break;
        }
    }
    
    [l sizeToFit];
    
    return l.frame.size.height + 20;
    //return MAX(l.frame.size.height + 6, 56);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellID = @"CellID";
    PnrDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[PnrDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSMutableAttributedString * att = self.view.cellAttArray[indexPath.row];
        
    switch (self.config.jsonViewColorBlack) {
        case PnrListTypeTextColor: {
            cell.textL.attributedText = att;
            break;
        }
        case PnrListTypeTextBlack: {
            cell.textL.text = att.string;
            break;
        }
        default:{
            break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.view.infoTV) {
        if (self.view.menu) {
            [self.view.menu setMenuVisible:NO];
            self.view.menu = nil;
        }
    }
}

#pragma mark - VC_EventHandler
- (void)copyAction {
    NSMutableString * text = [NSMutableString new];
    for (NSMutableAttributedString * att in self.view.cellAttArray) {
        [text appendFormat:@"%@\n\n", att.string];
    }
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:text];
    
    AlertToastTitle(@"已复制");
    
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:@[text] applicationActivities:nil];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        [self.view.vc presentViewController:activity animated:YES completion:nil];
    }else{
        [self.view.vc.navigationController pushViewController:activity animated:YES];
    }
}

#pragma mark - Interactor_EventHandler

@end
