//
//  SACMSCardViewConfig.h
//  SuperApp
//
//  Created by Chaos on 2021/6/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACMSDefine.h"
#import "SACMSNode.h"
#import "SACodingModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SACMSTitleViewConfig;
@class SAAddressModel;


@interface SACMSCardViewConfig : SACodingModel

@property (nonatomic, copy, readonly) CMSCardIdentify identify;            ///< 卡片标识
@property (nonatomic, copy, readonly) NSString *cardNo;                    ///< 编号
@property (nonatomic, copy, readonly) NSString *cardName;                  ///< 名称
@property (nonatomic, assign, readonly) NSInteger location;                ///< 位置
@property (nonatomic, strong, nullable) SACMSTitleViewConfig *titleConfig; ///< 标题配置
@property (nonatomic, strong) SAAddressModel *addressModel;                ///< 对应的地址数据
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;              ///< 内边距
@property (nonatomic, strong) NSArray<SACMSNode *> *nodes;                 ///< 节点
@property (nonatomic, assign) CGFloat maxLayoutWidth;                      ///< 最大的布局宽度，即页面宽度

- (NSDictionary *)getCardContent;
- (NSString *)getBackgroundImage;
- (UIColor *)getBackgroundColor;
- (UIEdgeInsets)getContentEdgeInsets;

- (NSArray<NSDictionary *> *)getAllNodeContents;

@end

NS_ASSUME_NONNULL_END
