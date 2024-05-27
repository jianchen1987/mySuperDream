//
//  UITableView+RecordData.h
//  SuperApp
//
//  Created by wmz on 2023/1/13.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKDataRecord.h"

NS_ASSUME_NONNULL_BEGIN


@interface UITableView (RecordData)
///付费展示过就存在里面
@property (nonatomic, strong) NSMutableDictionary *showDic;
///普通展示过就存在里面
@property (nonatomic, strong) NSMutableDictionary *normalShowDic;
///通用记录
@property (nonatomic, strong) NSMutableDictionary *allShowDic;

///记录付费门店曝光量
- (void)recordExposureCountWithModel:(id)model indexPath:(NSIndexPath *)indexPath position:(NSInteger)position;
///记录普通门店曝光
- (void)recordNormalStoreExposureCountWithModel:(id)model indexPath:(NSIndexPath *)indexPath iocntype:(NSString *)iocntype;
///通用记录
- (void)recordStoreExposureCountWithValue:(NSString *)value key:(NSString *)key indexPath:(NSIndexPath *)indexPath info:(NSDictionary *)parameters eventName:(NSString *)eventName;
@end

NS_ASSUME_NONNULL_END
