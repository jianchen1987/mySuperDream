//
//  UITableView+RecordData.m
//  SuperApp
//
//  Created by wmz on 2023/1/13.
//  Copyright © 2023 chaos network technology. All rights reserved.
//
#import "UITableView+RecordData.h"
#import "WMStoreListItemModel.h"
#import "WMStoreModel.h"


@implementation UITableView (RecordData)

static char kAssociatedObjectKey_showDic;
static char kAssociatedObjectKey_normelshowDic;
static char kAssociatedObjectKey_allShowDicDic;

///记录付费曝光量
- (void)recordExposureCountWithModel:(id)model indexPath:(NSIndexPath *)indexPath position:(NSInteger)position {
    if ([self.indexPathsForVisibleRows indexOfObject:indexPath] != NSNotFound) {
        WMBaseStoreModel *trueModel = nil;
        if ([model isKindOfClass:WMBaseStoreModel.class])
            trueModel = (WMBaseStoreModel *)model;
        if (trueModel && trueModel.payFlag) {
            if (!self.showDic)
                self.showDic = NSMutableDictionary.new;
            if (!self.showDic[trueModel.mShowTime] && !self.isHidden) {
                [LKDataRecord.shared traceEvent:@"sortStoreExposure" name:@"sortStoreExposure" parameters:@{@"type": @(position).stringValue, @"storeNo": trueModel.storeNo, @"plateId": trueModel.uuid}
                                            SPM:nil];
                [self.showDic setObject:trueModel.storeNo forKey:trueModel.mShowTime];
            }
        }
    }
}

///记录普通门店曝光
- (void)recordNormalStoreExposureCountWithModel:(id)model indexPath:(NSIndexPath *)indexPath iocntype:(NSString *)iocntype {
    if ([self.indexPathsForVisibleRows indexOfObject:indexPath] != NSNotFound) {
        WMBaseStoreModel *trueModel = nil;
        if ([model isKindOfClass:WMBaseStoreModel.class])
            trueModel = (WMStoreModel *)model;
        if (trueModel) {
            if (!self.normalShowDic)
                self.normalShowDic = NSMutableDictionary.new;
            if (!self.normalShowDic[trueModel.mShowTime] && !self.isHidden) {
                [LKDataRecord.shared traceEvent:@"merchantExposureInPage" name:@"merchantExposureInPage" parameters:@{
                    @"iocntype": iocntype,
                    @"type": @"merchantExposureInPage",
                    @"storeNo": trueModel.storeNo,
                    @"time": [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970 * 1000]
                }
                                            SPM:nil];
                [self.normalShowDic setObject:trueModel.storeNo forKey:trueModel.mShowTime];
            }
        }
    }
}

///通用记录
- (void)recordStoreExposureCountWithValue:(NSString *)value key:(NSString *)key indexPath:(NSIndexPath *)indexPath info:(NSDictionary *)parameters eventName:(NSString *)eventName {
    if ([self.indexPathsForVisibleRows indexOfObject:indexPath] != NSNotFound) {
        if (value && key) {
            if (!self.allShowDic)
                self.allShowDic = NSMutableDictionary.new;
            if (!self.allShowDic[key] && !self.isHidden) {
                [LKDataRecord.shared traceEvent:eventName name:eventName parameters:parameters SPM:nil];
                [self.allShowDic setObject:value forKey:key];
            }
        }
    }
}

- (void)setShowDic:(NSMutableDictionary *)showDic {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_showDic, showDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)showDic {
    return objc_getAssociatedObject(self, &kAssociatedObjectKey_showDic);
}

- (void)setNormalShowDic:(NSMutableDictionary *)normalShowDic {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_normelshowDic, normalShowDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)normalShowDic {
    return objc_getAssociatedObject(self, &kAssociatedObjectKey_normelshowDic);
}

- (void)setAllShowDic:(NSMutableDictionary *)allShowDic {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_allShowDicDic, allShowDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)allShowDic {
    return objc_getAssociatedObject(self, &kAssociatedObjectKey_allShowDicDic);
}

@end
