//
//  UICollectionView+RecordData.h
//  SuperApp
//
//  Created by wmz on 2023/4/20.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKDataRecord.h"

NS_ASSUME_NONNULL_BEGIN


@interface UICollectionView (RecordData)
///通用记录
@property (nonatomic, strong) NSMutableDictionary *allShowDic;
///通用记录
- (void)recordStoreExposureCountWithValue:(NSString *)value key:(NSString *)key indexPath:(NSIndexPath *)indexPath info:(NSDictionary *)parameters eventName:(NSString *)eventName;
@end

NS_ASSUME_NONNULL_END
