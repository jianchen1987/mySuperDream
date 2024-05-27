//
//  TNActivityCardRspModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/1/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNActivityCardModel.h"
#import "TNModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNActivityCardRspModel : TNModel
@property (nonatomic, copy) NSArray<TNActivityCardModel *> *list;
/// cell高度
@property (nonatomic, assign) CGFloat cellHeight;
/// 背景颜色
@property (strong, nonatomic) UIColor *backGroundColor;
/// 是否是专题样式2 的主题场景  显示的布局都要小一点
@property (nonatomic, assign) BOOL isSpecialStyleVertical;
/// 显示场景  首页和专题样式不同
@property (nonatomic, assign) TNActivityCardScene scene;
@end

NS_ASSUME_NONNULL_END
