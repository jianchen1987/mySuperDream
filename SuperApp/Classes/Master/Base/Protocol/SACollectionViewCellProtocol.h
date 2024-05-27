//
//  SACollectionViewCellProtocol.h
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SACollectionViewCellProtocol <NSObject>
@optional
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath identifier:(NSString *_Nullable)identifier;

- (void)hd_setupViews;
- (void)hd_bindViewModel;
@end

NS_ASSUME_NONNULL_END
