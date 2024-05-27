//
//  PNCollectionView.h
//  SuperApp
//
//  Created by xixi_wen on 2021/12/31.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACollectionView.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNCollectionView : SACollectionView

@property (nonatomic, assign) BOOL needRecognizeSimultaneously; ///< 是否需要识别多个手势

@end

NS_ASSUME_NONNULL_END
