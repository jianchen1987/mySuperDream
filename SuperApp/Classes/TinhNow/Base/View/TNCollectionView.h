//
//  TNCollectionView.h
//  SuperApp
//
//  Created by seeu on 2020/6/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACollectionView.h"
#import "TNMultiLanguageManager.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNCollectionView : SACollectionView
@property (nonatomic, assign) BOOL needRecognizeSimultaneously; ///< 是否需要识别多个手势
@end

NS_ASSUME_NONNULL_END
