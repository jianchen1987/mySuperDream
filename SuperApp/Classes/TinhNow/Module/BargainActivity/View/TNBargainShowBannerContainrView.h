//
//  TNBargainShowBannerContainrView.h
//  SuperApp
//
//  Created by 张杰 on 2020/11/10.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNView.h"
@class TNBargainSuccessModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNBargainShowBannerContainrView : TNView
@property (nonatomic, assign) CGFloat scrollInterval;                    //切换图片的时间间隔，可选，默认为5s
@property (nonatomic, assign) CGFloat animationInterVale;                //切换动画时间
@property (strong, nonatomic) NSArray<TNBargainSuccessModel *> *dataArr; //数据源
- (void)showInView:(UIView *)inView;
@end

NS_ASSUME_NONNULL_END
