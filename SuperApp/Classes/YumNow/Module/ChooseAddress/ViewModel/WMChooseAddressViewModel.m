//
//  WMChooseAddressViewModel.m
//  SuperApp
//
//  Created by wmz on 2021/4/16.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMChooseAddressViewModel.h"


@implementation WMChooseAddressViewModel

- (void)localSaveHistoryAddress:(SAAddressModel *)addressModel {
    //历史记录本地存储逻辑
    NSArray *infaceArr = [SACacheManager.shared objectForKey:kCacheKeyUserHistory type:SACacheTypeDocumentNotPublic];
    NSMutableArray *saveMarr = [NSMutableArray arrayWithArray:infaceArr];
    if (infaceArr.count) {
        NSInteger index = NSNotFound;
        for (SAAddressModel *sa in infaceArr) {
            if ([sa.fullAddress isEqualToString:addressModel.fullAddress]) {
                index = [infaceArr indexOfObject:sa];
                break;
            }
        }
        if (index == NSNotFound) {
            if (infaceArr.count >= 3) {
                [saveMarr removeObjectAtIndex:0];
            }
            if ([saveMarr indexOfObject:addressModel] == NSNotFound) {
                [saveMarr addObject:addressModel];
                [SACacheManager.shared setObject:[NSArray arrayWithArray:saveMarr] forKey:kCacheKeyUserHistory type:SACacheTypeDocumentNotPublic];
            }
        } else {
            if (index < infaceArr.count) {
                [saveMarr removeObjectAtIndex:index];
                if ([saveMarr indexOfObject:addressModel] == NSNotFound) {
                    [saveMarr addObject:addressModel];
                    [SACacheManager.shared setObject:[NSArray arrayWithArray:saveMarr] forKey:kCacheKeyUserHistory type:SACacheTypeDocumentNotPublic];
                }
            }
        }
    } else {
        if ([saveMarr indexOfObject:addressModel] == NSNotFound) {
            [saveMarr addObject:addressModel];
            [SACacheManager.shared setObject:[NSArray arrayWithArray:saveMarr] forKey:kCacheKeyUserHistory type:SACacheTypeDocumentNotPublic];
        }
    }
}


- (void)localClearHistoryAddress {
    [SACacheManager.shared removeObjectForKey:kCacheKeyUserHistory type:SACacheTypeDocumentNotPublic];
}
@end
