//
//  TNOrderSubmitTermsCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/4/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNOrderSubmitTermsCellModel : TNModel
/// 条款文案
@property (nonatomic, copy) NSString *contentTxt;
@end


@interface TNOrderSubmitTermsCell : SATableViewCell
@property (strong, nonatomic) TNOrderSubmitTermsCellModel *model;
/// 点击条款按钮
@property (nonatomic, copy) void (^clickAgreeTermsCallBack)(BOOL isAgree);
@end

NS_ASSUME_NONNULL_END
