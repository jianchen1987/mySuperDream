//
//  SACollectionReusableView.h
//  SuperApp
//
//  Created by VanJay on 2020/8/24.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACollectionReusableViewModel.h"
#import <HDKitCore/HDKitCore.h>
#import <HDUIKit/HDUIKit.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface SACollectionReusableView : UICollectionReusableView
+ (instancetype)headerWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;
+ (instancetype)headerWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath identifier:(NSString *_Nullable)identifier;

/// 数据模型
@property (nonatomic, strong) SACollectionReusableViewModel *model;
@property (nonatomic, copy) void (^rightButtonClickedHandler)(void);
@property (nonatomic, copy) void (^viewClickedHandler)(SACollectionReusableViewModel *model);
@end

NS_ASSUME_NONNULL_END
