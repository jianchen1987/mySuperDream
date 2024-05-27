//
//  TNCollectionReusableView.h
//  SuperApp
//
//  Created by 张杰 on 2022/11/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface TNCollectionReusableView : UICollectionReusableView
+ (instancetype)headerWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;
+ (instancetype)headerWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath identifier:(NSString *_Nullable)identifier;
//重写
- (void)hd_setupViews;
@end

NS_ASSUME_NONNULL_END
