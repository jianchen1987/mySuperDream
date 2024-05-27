//
//  TNSkuCountReusableView.h
//  SuperApp
//
//  Created by 张杰 on 2021/8/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModifyShoppingCountView.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN


@interface TNSkuCountReusableView : UICollectionReusableView
/// 数量选择视图
@property (nonatomic, strong) TNModifyShoppingCountView *countView;
@end

NS_ASSUME_NONNULL_END
