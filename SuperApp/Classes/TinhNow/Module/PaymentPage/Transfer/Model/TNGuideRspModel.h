//
//  TNGuideRspModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/1/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNGuideItemModel : TNModel
/// id
@property (nonatomic, copy) NSString *advId;
/// 标题
@property (nonatomic, copy) NSString *title;
/// 图片链接
@property (nonatomic, copy) NSString *path;
/// 跳转链接
@property (nonatomic, copy) NSString *link;
@end


@interface TNGuideRspModel : TNModel
/// id
@property (nonatomic, copy) NSString *advId;
/// list
@property (strong, nonatomic) NSArray<TNGuideItemModel *> *advList;
@end

NS_ASSUME_NONNULL_END
