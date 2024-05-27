//
//  SATagTableViewCell.h
//  SuperApp
//
//  Created by VanJay on 2020/5/6.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAImageLabelCollectionViewCellModel.h"
#import "SATableViewCell.h"

@class SATagTableViewCell;

NS_ASSUME_NONNULL_BEGIN

@protocol HDStoreSearchTableViewCellDelegate <NSObject>

- (void)storeSearchCollectionViewTableViewCell:(SATagTableViewCell *)tableViewCell didSelectedTag:(SAImageLabelCollectionViewCellModel *)tagModel;

@end


@interface SATagTableViewCell : SATableViewCell <HDSkeletonLayerLayoutProtocol>
@property (nonatomic, weak) id<HDStoreSearchTableViewCellDelegate> delegate;            ///< 代理
@property (nonatomic, copy) NSArray<SAImageLabelCollectionViewCellModel *> *dataSource; ///< 数据源
@end

NS_ASSUME_NONNULL_END
