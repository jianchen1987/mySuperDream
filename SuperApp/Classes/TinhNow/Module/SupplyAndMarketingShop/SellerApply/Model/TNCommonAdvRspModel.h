//
//  TNCommonAdvRspModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/1/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNCommonAdvModel : TNModel
/// 图片
@property (nonatomic, copy) NSString *path;
/// 标题
@property (nonatomic, copy) NSString *title;
/// id
@property (nonatomic, copy) NSString *cardId;
/// 跳转
@property (nonatomic, copy) NSString *link;
@end


@interface TNCommonAdvRspModel : TNModel
/// advId
@property (nonatomic, copy) NSString *advId;
///
@property (strong, nonatomic) NSArray<TNCommonAdvModel *> *advList;
@end

NS_ASSUME_NONNULL_END
