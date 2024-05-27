//
//  TNProductDetailCardCell.h
//  SuperApp
//
//  Created by 张杰 on 2022/8/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNEnum.h"
NS_ASSUME_NONNULL_BEGIN

typedef void (^GetWebViewHeightCallBack)(void);


@interface TNProductDetailCardCellModel : NSObject
///
@property (nonatomic, copy) NSString *html;
///
@property (nonatomic, copy) NSString *storeId;
///
@property (strong, nonatomic) NSString *imageStr;
/// 类型
@property (nonatomic, copy) TNGoodsType type;
@end


@interface TNProductDetailCardCell : SATableViewCell
///
@property (strong, nonatomic) TNProductDetailCardCellModel *model;

/// 高度回调刷新
@property (nonatomic, copy) GetWebViewHeightCallBack webViewHeightCallBack;

@end

NS_ASSUME_NONNULL_END
