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

@interface PnrListVCPresenter ()

@property (nonatomic, weak  ) id<PnrListVCProtocol> view;
@property (nonatomic, strong) PnrListVCInteractor * interactor;

@end

@implementation PnrListVCPresenter

- (id)init {
    if (self = [super init]) {
        [self initInteractors];
        
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.view.weakInfoArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 53;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellID = @"CellID";
    PnrListVCCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[PnrListVCCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    PnrVCEntity * entity = self.view.weakInfoArray[indexPath.row];
    
    cell.titleL.text    = entity.request;
    cell.timeL.text     = entity.time;
    cell.subtitleL.text = entity.domain;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PnrVCEntity * entity = self.view.weakInfoArray[indexPath.row];
    NSString * requestDes  = [self replaceUnicode:[entity.requestDic description]];
    NSString * responseDes = [self replaceUnicode:[entity.responseDic description]];
    
    NSArray * infoArray = @[[NSString stringWithFormat:@"接口:\n%@", entity.request],
                            [NSString stringWithFormat:@"链接:\n%@", entity.url],
                            [NSString stringWithFormat:@"时间:\n%@", entity.time],
                            [NSString stringWithFormat:@"方法:\n%@", entity.method],
                            [NSString stringWithFormat:@"head参数:\n%@", entity.headDic],
                            
                            [NSString stringWithFormat:@"请求参数:\n%@", requestDes],
                            [NSString stringWithFormat:@"返回数据:\n%@", responseDes],
                            ];
    NSArray * jsonArray = @[[NSNull null],
                            [NSNull null],
                            [NSNull null],
                            [NSNull null],
                            entity.headDic ?:[NSNull null],
                            
                            entity.requestDic ?:[NSNull null],
                            entity.responseDic ?:[NSNull null],
                            ];
    [self.view.vc.navigationController pushViewController:[PnrDetailVCRouter vcWithDic:@{@"title":@"请求详情", @"infoArray":infoArray, @"jsonArray":jsonArray}] animated:YES];
}

- (NSString *)replaceUnicode:(NSString *)unicodeStr {
    if (unicodeStr) {
        //NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
        NSString *tempStr2 = [unicodeStr stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
        NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
        NSString* returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:nil];
        
        return returnStr ? :unicodeStr;
    }else{
        return nil;
    }
}

//- (NSString *)replaceUnicode1:(NSString *)unicodeStr {
//
//    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
//    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
//    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
//    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
//    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
//                                                           mutabilityOption:NSPropertyListImmutable
//                                                                     format:NULL
//                                                           errorDescription:NULL];
//
//    //NSLog(@"Output = %@", returnStr);
//
//    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
//}
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

#pragma mark - Interactor_EventHandler

@end
