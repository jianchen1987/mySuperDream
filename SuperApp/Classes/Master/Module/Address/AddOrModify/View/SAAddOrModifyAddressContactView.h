//
//  SAAddOrModifyAddressContactView.h
//  SuperApp
//
//  Created by VanJay on 2020/5/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAddOrModifyAddressBaseView.h"
#import "SAEnum.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAAddOrModifyAddressContactView : SAAddOrModifyAddressBaseView
/// 姓名
@property (nonatomic, strong, readonly) UITextField *nameTF;
/// 选中的按钮
@property (nonatomic, strong, readonly) HDUIButton *selectedBTN;
/// 名字
@property (nonatomic, copy) NSString *consigneeName;
/// 性别
@property (nonatomic, copy) SAGender gender;
@end

NS_ASSUME_NONNULL_END
