//
//  TNSingleVideoCollectionViewCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/6/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNSingleVideoCollectionViewCellModel : NSObject
@property (nonatomic, strong) id associatedObj;         ///< 关联对象
@property (nonatomic, strong) NSString *coverImageUrl;  ///<封面图片 地址
@property (nonatomic, strong) NSString *videoUrl;       ///<封面图片 地址
@property (nonatomic, assign) CGFloat cornerRadius;     ///< 圆角大小，默认5
@property (nonatomic, assign) BOOL heightFullRounded;   ///< 高度圆角，如果为 true，cornerRadius 将不生效
@property (nonatomic, strong) UIImage *placholderImage; ///< 占位图
@end


@interface TNSingleVideoCollectionViewCell : SACollectionViewCell
@property (nonatomic, strong) TNSingleVideoCollectionViewCellModel *model;     ///< 模型
@property (nonatomic, strong, readonly) SDAnimatedImageView *videoContentView; ///< 图片，供外部使用
@property (nonatomic, copy) void (^videoPlayClickCallBack)(NSURL *url);        ///< 播放视频点击
@property (nonatomic, copy) void (^videoAutoPlayCallBack)(NSURL *url);         ///< 视频自动播放回调
@end

NS_ASSUME_NONNULL_END
