//
//  SASuggestionDetailTableViewCell.h
//  SuperApp
//
//  Created by Tia on 2022/11/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACollectionViewCell.h"
#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface SASuggestionDetailTableViewCellModel : NSObject
/// 主题
@property (nonatomic, copy) NSString *title;
/// 时间
@property (nonatomic, assign) NSInteger time;
/// 图片
@property (nonatomic, strong) NSArray<NSString *> *imageUrls;
/// 内容
@property (nonatomic, copy) NSString *content;

@end


@interface SASuggestionDetaiPhotoCell : SACollectionViewCell

@end


@interface SASuggestionDetailTableViewCell : SATableViewCell

@property (nonatomic, strong) SASuggestionDetailTableViewCellModel *model;

@property (nonatomic, copy) void (^clickPhotoBlock)(NSInteger row);

@end

NS_ASSUME_NONNULL_END
