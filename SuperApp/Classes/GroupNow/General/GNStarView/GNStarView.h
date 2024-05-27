//
//  GNStarView.h
//  SuperApp
//
//  Created by wmz on 2022/5/31.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <YYText/YYText.h>
NS_ASSUME_NONNULL_BEGIN

@class GNStarView;
@protocol GNStarViewDelegate <NSObject>
@optional
- (void)gn_starView:(GNStarView *)tagView star:(NSInteger)star;
@end


@interface GNStarView : YYLabel
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, weak) id<GNStarViewDelegate> delegate;
@property (nonatomic, assign) CGFloat space;
@property (nonatomic, assign) CGSize iconSize;
@property (nonatomic, strong) NSString *defaultImage;
@property (nonatomic, strong) NSString *selectImage;
@property (nonatomic, assign) NSInteger maxValue;
@property (nonatomic, assign) BOOL canTap;
@end

NS_ASSUME_NONNULL_END
