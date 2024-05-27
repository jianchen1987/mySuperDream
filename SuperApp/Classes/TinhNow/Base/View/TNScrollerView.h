//
//  TNScrollerView.h
//  SuperApp
//
//  Created by 张杰 on 2021/5/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface TNScrollerView : UIScrollView
@property (nonatomic, assign) BOOL needRecognizeSimultaneously; ///< 是否需要识别多个手势
@end

NS_ASSUME_NONNULL_END
