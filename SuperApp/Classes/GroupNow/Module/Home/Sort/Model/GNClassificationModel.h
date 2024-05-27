//
//  GNClassificationModel.h
//  SuperApp
//
//  Created by wmz on 2022/6/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNModel.h"
#import "SAInternationalizationModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNClassificationModel : GNModel
///一级分类编码
@property (nonatomic, copy) NSString *parentCode;
///分类编码
@property (nonatomic, copy) NSString *classificationCode;
///分类图片
@property (nonatomic, copy) NSString *photo;
///分类名称
@property (nonatomic, strong) SAInternationalizationModel *classificationName;
///选中
@property (nonatomic, assign, getter=isSelect) BOOL select;
/// alpah
@property (nonatomic, assign) CGFloat alpah;
@end

NS_ASSUME_NONNULL_END
