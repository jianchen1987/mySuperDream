//
//  FunctionCell.h
//  SuperApp
//
//  Created by Quin on 2021/11/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNCollectionViewCell.h"
#import "PNFunctionCellModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNFunctionCell : PNCollectionViewCell
@property (nonatomic, strong) PNFunctionCellModel *model;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) SALabel *titleLB;
@property (nonatomic, strong) SALabel *countLabel;
@end

NS_ASSUME_NONNULL_END
