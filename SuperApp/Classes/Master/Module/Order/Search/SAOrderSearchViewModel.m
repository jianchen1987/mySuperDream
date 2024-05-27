//
//  SAOrderSearchViewModel.m
//  SuperApp
//
//  Created by Tia on 2023/2/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAOrderSearchViewModel.h"
#import "SACacheManager.h"


@interface SAOrderSearchViewModel ()

@property (nonatomic, assign) BOOL refreshFlag;

@end


@implementation SAOrderSearchViewModel

- (void)loadDefaultData {
    // 加载历史搜索
    NSArray<NSString *> *historyArray = [SACacheManager.shared objectForKey:kCacheKeyOrderSearchHistory type:SACacheTypeDocumentPublic relyLanguage:NO];

    self.dataSource = historyArray.count ? historyArray.mutableCopy : @[];
    self.refreshFlag = !self.refreshFlag;
}

- (void)saveMerchantHistorySearchWithKeyword:(NSString *)keyword {
    NSArray<NSString *> *historyArray = [SACacheManager.shared objectForKey:kCacheKeyOrderSearchHistory type:SACacheTypeDocumentPublic relyLanguage:NO];
    // 去除重复当前
    NSMutableArray<NSString *> *copiedArray = [NSMutableArray arrayWithArray:historyArray];
    for (NSString *str in historyArray) {
        if ([str isEqualToString:keyword]) {
            [copiedArray removeObject:str];
        }
    }
    // 生成新关键词模型
    [copiedArray insertObject:keyword atIndex:0];
    NSUInteger maxHistoryRecordCount = 20;
    if (copiedArray.count > maxHistoryRecordCount) {
        [copiedArray removeObjectsInRange:NSMakeRange(maxHistoryRecordCount, copiedArray.count - maxHistoryRecordCount)];
    }
    // 保存
    [SACacheManager.shared setObject:copiedArray forKey:kCacheKeyOrderSearchHistory type:SACacheTypeDocumentPublic relyLanguage:NO];
    HDLog(@"保存关键词:%@", keyword);
}

- (void)removeAllHistorySearch {
    // 删除内存中历史搜索纪录
    [self.dataSource removeAllObjects];

    [SACacheManager.shared removeObjectForKey:kCacheKeyOrderSearchHistory type:SACacheTypeDocumentPublic];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = NSMutableArray.new;
    }
    return _dataSource;
}

@end
