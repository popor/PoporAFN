//
//  PnrDetailVCPresenter.m
//  linRunShengPi
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.

#import "PnrDetailVCPresenter.h"
#import "PnrDetailVCInteractor.h"
#import "PnrDetailVCProtocol.h"

#import <PoporUI/IToastKeyboard.h>
#import <PoporFoundation/NSString+Size.h>

@interface PnrDetailVCPresenter ()

@property (nonatomic, weak  ) id<PnrDetailVCProtocol> view;
@property (nonatomic, strong) PnrDetailVCInteractor * interactor;

@end

@implementation PnrDetailVCPresenter

- (id)init {
    if (self = [super init]) {
        [self initInteractors];
        
    }
    return self;
}

- (void)setMyView:(id<PnrDetailVCProtocol>)view {
    self.view = view;
}

- (void)initInteractors {
    if (!self.interactor) {
        self.interactor = [PnrDetailVCInteractor new];
    }
}

#pragma mark - VC_DataSource

#pragma mark - TV_Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.view.infoArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * content = self.view.infoArray[indexPath.row];
    float height = [content sizeInFont:[UIFont systemFontOfSize:15] width:self.view.vc.view.frame.size.width - 30].height;
    
    return height + 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellID = @"CellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.numberOfLines = 0;
    }
    
    cell.textLabel.text = self.view.infoArray[indexPath.row];
    
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
    for (NSString * string in self.view.infoArray) {
        [text appendFormat:@"%@\n\n", string];
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
