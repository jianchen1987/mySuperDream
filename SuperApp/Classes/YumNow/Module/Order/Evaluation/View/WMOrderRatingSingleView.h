//
//  WMOrderRatingSingleView.h
//  SuperApp
//
//  Created by VanJay on 2020/4/26.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderRatingSingleView : SAView
/// 评分项名称
@property (nonatomic, copy) NSString *ratingTitle;
/// title
@property (nonatomic, copy) NSString *title;
/// 当前评分
@property (nonatomic, assign, readonly) double score;
/// showDetail
@property (nonatomic, assign) BOOL showDetail;
/// 是否展示匿名按钮
@property (nonatomic, assign) BOOL isShowAnonymous;
/// 选了评分
@property (nonatomic, copy) void (^scoreChangedBlock)(void);
/// 是否匿名
@property (nonatomic, copy) void (^clickedIsAnonymousButtonBlock)(WMReviewAnonymousState anonymousState);
/// 商家
@property (nonatomic, copy) NSString *storeName;
/// 商家
@property (nonatomic, copy) NSString *logoURL;
///textView
@property (nonatomic, strong) UITextView *textView;
/// time
@property (nonatomic, copy) NSString *time;
///floatBtnArr
@property (nonatomic, strong) NSMutableArray <HDUIButton*>*floatBtnArr;
@end

NS_ASSUME_NONNULL_END
