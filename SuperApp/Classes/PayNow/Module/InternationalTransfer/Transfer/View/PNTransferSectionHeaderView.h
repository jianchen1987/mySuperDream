//
//  PNTransferSectionHeaderView.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SATableHeaderFooterView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^RightBtnClickBlock)(void);


@interface PNTransferSectionHeaderView : SATableHeaderFooterView
///
//@property (nonatomic, copy) NSString *title;

- (void)setTitle:(NSString *)title rightImage:(UIImage *)rightBtnImage;

@property (nonatomic, copy) RightBtnClickBlock rightBtnClickBlock;

@end

NS_ASSUME_NONNULL_END
