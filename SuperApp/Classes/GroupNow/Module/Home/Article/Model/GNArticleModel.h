//
//  GNArticleModel.h
//  SuperApp
//
//  Created by wmz on 2022/5/31.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNCellModel.h"
#import "GNProductModel.h"
#import "GNStoreCellModel.h"
#import "SAInternationalizationModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNArticleModel : GNCellModel
///文章编码，用于跳转文章详情
@property (nonatomic, copy) NSString *articleCode;
///文章名称
@property (nonatomic, strong) SAInternationalizationModel *articleName;
/// content
@property (nonatomic, strong) SAInternationalizationModel *content;
///文章封面图
@property (nonatomic, copy) NSString *logo;
///用户name
@property (nonatomic, copy) NSString *nickName;
///用户头像
@property (nonatomic, copy) NSString *headUrl;
///文章图片
@property (nonatomic, copy) NSString *imagePath;
///发布时间
@property (nonatomic, assign) NSTimeInterval createTime;
///最大高度
@property (nonatomic, assign) CGFloat maxHigh;
///是否栏目置顶
@property (nonatomic, assign) BOOL columnReleaseTop;
///门店信息
@property (nonatomic, strong) GNStoreCellModel *articleStoreInfo;
///商品信息
@property (nonatomic, strong) GNProductModel *articleProductInfo;
///图片路径
@property (nonatomic, copy) NSArray<NSString *> *imagePathArr;
///展示最大高度
@property (nonatomic, assign) CGFloat showHigh;
/// 绑定类型
@property (nonatomic, strong) GNMessageCode *boundType;
/// 绑定内容
@property (nonatomic, copy) NSString *boundContent;
///绑定图
@property (nonatomic, copy) NSString *boundImage;

@end

NS_ASSUME_NONNULL_END
