//
//  WMStoreProductReviewModel.m
//  SuperApp
//
//  Created by VanJay on 2020/6/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreProductReviewModel.h"
#import "SAInternationalizationModel.h"


@implementation WMStoreProductReviewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.maxShowImageCount = 3;
        self.numberOfLinesOfNameLabel = 1;
        self.contentMaxRowCount = 3;
        self.merchantReplyMaxRowCount = 3;
        self.numberOfLinesOfReviewContentLabel = 3;
        self.numberOfLinesOfMerchantReplyLabel = 3;
    }
    return self;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"reviewId": @"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"replys": WMReviewMerchantReplyModel.class,
        @"itemBasicInfoRespDTOS": WMStoreReviewGoodsModel.class,
    };
}

- (NSString *)head {
    return self.anonymous == WMReviewAnonymousStateTrue ? @"" : _head;
}

- (NSString *)nickName {
    NSString *showNickname = @"";
    if (self.anonymous == WMReviewAnonymousStateTrue && self.cellType != WMStoreProductReviewCellTypeMyReview) {
        if (_nickName.length >= 2) {
            NSString *first = [_nickName hd_substringAvoidBreakingUpCharacterSequencesWithRange:NSMakeRange(0, 1)];
            NSString *last = [_nickName hd_substringAvoidBreakingUpCharacterSequencesWithRange:NSMakeRange(_nickName.length - 1, 1)];
            showNickname = [NSString stringWithFormat:@"%@***%@", first, last];
        } else {
            showNickname = _nickName;
        }
    } else {
        showNickname = _nickName;
    }
    return showNickname;
}

- (NSArray<NSString *> *)tags {
    if (!_tags) {
        NSMutableArray *arr = [NSMutableArray array];
        [self.itemBasicInfoRespDTOS enumerateObjectsUsingBlock:^(WMStoreReviewGoodsModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if (obj.disLike == WMStoreReviewGoodsStatusLike) {
                [arr addObject:obj.goodName.desc];
            }
        }];
        _tags = arr.copy;
    }
    return _tags;
}

- (NSString *)deliveryScoreStr {
    NSString *showStr = @"";
    if (self.deliveryScore > 4) {
        showStr = WMLocalizedString(@"rating_level_very_good", @"Excellent");
    } else if (self.deliveryScore > 3) {
        showStr = WMLocalizedString(@"rating_level_great", @"Great");
    } else if (self.deliveryScore > 2) {
        showStr = WMLocalizedString(@"rating_level_good", @"Good");
    } else if (self.deliveryScore > 1) {
        showStr = WMLocalizedString(@"rating_level_bad", @"Not Bad");
    } else {
        showStr = WMLocalizedString(@"rating_level_very_bad", @"Bad");
    }
    return showStr;
}

@end
