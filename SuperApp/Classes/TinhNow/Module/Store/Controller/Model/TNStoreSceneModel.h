//
//  TNStoreSceneModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/1/6.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"
@class TNAdaptImageModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNStoreSceneModel : TNModel
/// id
@property (nonatomic, copy) NSString *sceneId;
/// name
@property (nonatomic, copy) NSString *name;
/// 图片
@property (nonatomic, copy) NSArray *storeLiveImage;
/// 图片组高度
@property (nonatomic, assign) CGFloat imagesHeight;
/// cell高度
@property (nonatomic, assign) CGFloat cellHeight;
/// 是否展示全部文本
@property (nonatomic, assign) BOOL showAllText;
/// 是否需要显示更多按钮
@property (nonatomic, assign) BOOL isNeedShowMoreBtn;

//**    自定义字段       */
/// 图片模型数组
@property (nonatomic, copy) NSArray<TNAdaptImageModel *> *storeLiveImageModels;
@end

NS_ASSUME_NONNULL_END
