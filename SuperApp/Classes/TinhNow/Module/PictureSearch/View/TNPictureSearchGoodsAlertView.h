//
//  TNPictureSearchGoodsAlertView.h
//  SuperApp
//
//  Created by 张杰 on 2022/1/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNPictureSearchRspModel.h"
#import "TNView.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNPictureSearchGoodsAlertView : TNView
@property (nonatomic, copy) void (^dismissCallBack)(void);
- (instancetype)initWithRspModel:(TNPictureSearchRspModel *)rspModel picUrl:(NSString *)picUrl;
- (void)showInView:(UIView *)inView aboveView:(UIView *)aboveView;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
