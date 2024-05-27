//
//  UICollectionView+RecordData.m
//  SuperApp
//
//  Created by wmz on 2023/4/20.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "UICollectionView+RecordData.h"
#import <objc/runtime.h>
#import "HDLog.h"


@implementation UICollectionView (RecordData)

static char kAssociatedObjectKey_Collection_allShowDicDic;
///通用记录
- (void)recordStoreExposureCountWithValue:(NSString *)value key:(NSString *)key indexPath:(NSIndexPath *)indexPath info:(NSDictionary *)parameters eventName:(NSString *)eventName {
    if (value && key) {
        if (!self.allShowDic)
            self.allShowDic = NSMutableDictionary.new;
        if (!self.allShowDic[key] && !self.isHidden) {
            [LKDataRecord.shared traceEvent:eventName name:eventName parameters:parameters SPM:nil];
            [self.allShowDic setObject:value forKey:key];
        }
    }
}

- (void)setAllShowDic:(NSMutableDictionary *)allShowDic {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_Collection_allShowDicDic, allShowDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)allShowDic {
    return objc_getAssociatedObject(self, &kAssociatedObjectKey_Collection_allShowDicDic);
}

@end
