//
//  WMAlertCallPopModel.h
//  SuperApp
//
//  Created by wmz on 2022/4/25.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAContactPhoneModel.h"
#import "WMRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMAlertCallPopModel : WMRspModel
/// 富文本
@property (nonatomic, strong) NSMutableAttributedString *atName;
/// name
@property (nonatomic, strong) NSString *name;
/// 图片
@property (nonatomic, strong) id image;
/// 携带的数据源
@property (nonatomic, strong) id dataSource;
/// 类型
@property (nonatomic, strong) WMCallPhoneType type;

- (instancetype)initName:(id)name image:(id)image data:(nullable id)data type:(WMCallPhoneType)type;

+ (instancetype)initName:(id)name image:(id)image data:(nullable id)data type:(WMCallPhoneType)type;
///客服model
+ (WMAlertCallPopModel *)hotServerModel;

@end

NS_ASSUME_NONNULL_END
