///
//  HDCollectionViewBackgroundViewLayoutAttributes.h
//  SuperApp
//
//  Created by VanJay on 2020/8/24.
//  Copyright © 2020 VanJay. All rights reserved.
//

#import "HDCollectionCellBaseEventModel.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface HDCollectionViewBackgroundViewLayoutAttributes : UICollectionViewLayoutAttributes

// 此属性只是header会单独设置，其他均直接返回其frame属性
@property (nonatomic, assign, readonly) CGRect headerFrame;
@property (nonatomic, assign, readonly) CGRect footerFrame;

@property (nonatomic, copy) NSString *eventName;
@property (nonatomic, copy) id parameter;

- (void)callMethod:(HDCollectionCellBaseEventModel *)eventModel;

@end

NS_ASSUME_NONNULL_END
