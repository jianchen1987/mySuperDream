//
//  TNActivityCardModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/1/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNActivityCardBannerItem.h"
#import "TNModel.h"
NS_ASSUME_NONNULL_BEGIN
//#define cardHeaderHeight kRealWidth(50)

typedef NS_ENUM(NSUInteger, TNActivityCardScene) {
    TNActivityCardSceneIndex = 0, ///首页
    TNActivityCardSceneTopic = 1, ///专题
};

typedef NS_ENUM(NSUInteger, TNActivityCardStyle) {
    TNActivityCardStyleText = 3,            ///纯文本样式
    TNActivityCardStyleBanner = 4,          ///横幅广告
    TNActivityCardStyleScorllItem = 5,      ///滑动类型
    TNActivityCardStyleSixItem = 6,         ///六宫格
    TNActivityCardStyleMultipleBanners = 7, ///多张横幅
    TNActivityCardStyleSquareScorllItem = 8 ///正方形滑动类型
};
typedef NS_ENUM(NSUInteger, TNActivityCardTitlePosition) {
    TNActivityCardTitlePositionTop = 0,    //标题位置在上面
    TNActivityCardTitlePositionBottom = 1, //标题位置在下面
};


@interface TNActivityCardModel : TNModel
/// 定位位置
@property (nonatomic, assign) NSInteger location;
/// 展示类型
@property (nonatomic, assign) TNActivityCardStyle cardStyle;
/// 排序
@property (nonatomic, assign) NSInteger sort;
/// 更多  地址
@property (nonatomic, copy) NSString *moreUrl;
/// 名称
@property (nonatomic, copy) NSString *advertiseName;
/// 卡片数据源
@property (strong, nonatomic) NSArray<TNActivityCardBannerItem *> *bannerList;

//**********绑定属性********//
/// 显示场景  首页和专题样式不同
@property (nonatomic, assign) TNActivityCardScene scene;
/// cell高度
@property (nonatomic, assign) CGFloat cellHeight;
/// cell里面  图片高度
@property (nonatomic, assign) CGFloat imageViewHeight;
/// cell里面头部高度  首页的头部高度为50  专题的为10
@property (nonatomic, assign) CGFloat headerHeight;
/// 验证是否有文本
- (BOOL)checkBannerListHasText:(NSArray *)list;
/// 是否是专题样式2 的主题场景  显示的布局都要小一点
@property (nonatomic, assign) BOOL isSpecialStyleVertical;
/// 标题位置  在卡片上面还是下面
@property (nonatomic, assign) TNActivityCardTitlePosition titlePosition;
@end

NS_ASSUME_NONNULL_END
