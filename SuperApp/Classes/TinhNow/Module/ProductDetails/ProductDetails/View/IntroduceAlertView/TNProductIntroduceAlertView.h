//
//  TNProductIntroduceAlertView.h
//  SuperApp
//
//  Created by 张杰 on 2022/8/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface TNProductIntroduceAlertView : HDActionAlertView
- (instancetype)initWithHtml:(NSString *)html storeId:(NSString *)storeId image:(NSString *)image;
@end

NS_ASSUME_NONNULL_END
