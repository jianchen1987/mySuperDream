//
//  PNSingleSelectedAlertView.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import <HDUIKit/HDUIKit.h>
NS_ASSUME_NONNULL_BEGIN


@interface PNSingleSelectedModel : PNModel
/// 显示名字
@property (nonatomic, copy) NSString *name;
/// id
@property (nonatomic, copy) NSString *itemId;
/// 是否选中
@property (nonatomic, assign) BOOL isSelected;
@end


@interface PNSingleSelectedAlertView : HDActionAlertView

///选中回调
@property (nonatomic, copy) void (^selectedCallback)(PNSingleSelectedModel *model);

- (instancetype)initWithDataArr:(NSArray<PNSingleSelectedModel *> *)dataArr title:(NSString *)title;

- (instancetype)initWithDataArr:(NSArray<PNSingleSelectedModel *> *)dataArr title:(NSString *)title forceSelect:(BOOL)forceSelect;
@end

NS_ASSUME_NONNULL_END
