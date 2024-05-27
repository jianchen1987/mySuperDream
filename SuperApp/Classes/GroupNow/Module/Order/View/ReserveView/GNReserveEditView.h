//
//  GNReserveEditView.h
//  SuperApp
//
//  Created by wmz on 2022/9/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNReserveCalanderView.h"
#import "GNReserveRspModel.h"
#import "GNView.h"
#import "SACollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNReserveEditView : GNView
///营业时间-小时
@property (nonatomic, copy) NSArray<NSString *> *businessHours;
///选中的时间
@property (nonatomic, copy, nullable) NSString *selectTime;
///数量
@property (nonatomic, assign) NSInteger count;
/// phoneTF
@property (nonatomic, strong) UITextField *phoneTF;
/// bookInput
@property (nonatomic, strong) UITextField *bookTF;
///选中model
@property (nonatomic, strong) GNReserveCalanderModel *selectModel;
///检测可否点击
@property (nonatomic, assign) BOOL checkEnable;

@end


@interface GNReserveArrvalCell : SACollectionViewCell
/// label
@property (nonatomic, strong) HDLabel *label;

@end

NS_ASSUME_NONNULL_END
