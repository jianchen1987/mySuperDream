//
//  PayPassWordTip.h
//  SuperApp
//
//  Created by Quin on 2021/11/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNView.h"
#import "PNOperationButton.h"

typedef void (^cancelBtnTapBlock)(void);
typedef void (^sureBtnTapBlock)(void);
NS_ASSUME_NONNULL_BEGIN


@interface PayPassWordTipView : PNView
@property (nonatomic, strong) UIView *bigBgView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) SALabel *detailLB;
@property (nonatomic, strong) PNOperationButton *cancelBtn;
@property (nonatomic, strong) PNOperationButton *sureBtn;

@property (nonatomic, copy) NSString *iconImgName;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *cancelBtnText;
@property (nonatomic, copy) NSString *sureBtnText;

@property (nonatomic, copy) cancelBtnTapBlock cancelBlock;
@property (nonatomic, copy) sureBtnTapBlock sureBlock;
@end

NS_ASSUME_NONNULL_END
