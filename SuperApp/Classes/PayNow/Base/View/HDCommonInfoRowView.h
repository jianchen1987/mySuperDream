//
//  HDCommonInfoRowView.h
//  customer
//
//  Created by VanJay on 2019/5/2.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HDDealCommonInfoRowViewModel;

typedef void (^VoidBlock)(void);

NS_ASSUME_NONNULL_BEGIN


@interface HDCommonInfoRowView : UIView

+ (instancetype)commonInfoRowViewWithModel:(HDDealCommonInfoRowViewModel *)model;
- (instancetype)initWithModel:(HDDealCommonInfoRowViewModel *)model;

@property (nonatomic, strong) HDDealCommonInfoRowViewModel *model; ///< 模型

@property (nonatomic, copy) VoidBlock tappedHandler; ///< 按下了

- (void)updateKeyText:(NSString *)keyText valueText:(NSString *)valueText;
@end

NS_ASSUME_NONNULL_END
