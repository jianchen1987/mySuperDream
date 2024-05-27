//
//  TNShareModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/2/26.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"
#import "TNSocialShareProductDetailImageView.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNShareModel : TNModel
/// 分享标题
@property (nonatomic, copy) NSString *shareTitle;
/// 分享内容
@property (nonatomic, copy) NSString *shareContent;
/// 分享图片
@property (nonatomic, copy) NSString *shareImage;
/// 分享链接
@property (nonatomic, copy) NSString *shareLink;
/// 分享场景  默认是default    没指定可不传
@property (nonatomic, assign) TNShareType type;
/// id  按场景所需传  没有就不传
@property (nonatomic, copy) NSString *sourceId;

/// 埋点前缀
@property (nonatomic, copy) NSString *trackPrefixName;
/// 详情分享需要字段
@property (strong, nonatomic) TNSocialShareProductDetailModel *productDetailModel;
@end
NS_ASSUME_NONNULL_END
