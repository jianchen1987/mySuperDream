//
//  SASingleImageCollectionViewCell.h
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACollectionViewCell.h"
#import <SDWebImage/SDAnimatedImageView.h>

NS_ASSUME_NONNULL_BEGIN


@interface SASingleImageCollectionViewCellModel : NSObject
@property (nonatomic, strong) id associatedObj;         ///< 关联对象
@property (nonatomic, strong) NSString *url;            ///< 地址
@property (nonatomic, copy) NSString *imageName;        ///< 本地图片名
@property (nonatomic, assign) BOOL isLocal;             ///< 本地图片，默认否
@property (nonatomic, assign) CGFloat cornerRadius;     ///< 圆角大小，默认5
@property (nonatomic, assign) BOOL heightFullRounded;   ///< 高度圆角，如果为 true，cornerRadius 将不生效
@property (nonatomic, strong) UIImage *placholderImage; ///< 占位图
@end


@interface SASingleImageCollectionViewCell : SACollectionViewCell
- (void)setModel:(SASingleImageCollectionViewCellModel *)model NS_REQUIRES_SUPER;

@property (nonatomic, strong) SASingleImageCollectionViewCellModel *model; ///< 模型
@property (nonatomic, strong, readonly) SDAnimatedImageView *imageView;    ///< 图片，供外部使用
@end

NS_ASSUME_NONNULL_END
