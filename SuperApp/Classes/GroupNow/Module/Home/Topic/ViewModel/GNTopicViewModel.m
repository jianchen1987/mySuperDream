//
//  GNTopicViewModel.m
//  SuperApp
//
//  Created by wmz on 2022/2/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNTopicViewModel.h"
#import <SDWebImage/SDWebImagePrefetcher.h>


@interface GNTopicViewModel ()

@property (nonatomic, strong) GNHomeDTO *homeDTO;

@end


@implementation GNTopicViewModel

- (void)getStoreTopicWithTopicCode:(nullable NSString *)topicPageNo pageNum:(NSInteger)pageNum completion:(nullable void (^)(GNTopicModel *rspModel, BOOL error))completion {
    [self.homeDTO getStoreTopicWithPageNum:@(pageNum) topicPageNo:topicPageNo success:^(GNTopicModel *_Nonnull rspModel) {
        if (!self.rspModel) {
            self.rspModel = rspModel;
            [SDWebImagePrefetcher.sharedImagePrefetcher prefetchURLs:@[[NSURL URLWithString:rspModel.image.desc ?: @""]] progress:nil
                                                           completed:^(NSUInteger noOfFinishedUrls, NSUInteger noOfSkippedUrls) {
                                                               !completion ?: completion(rspModel, NO);
                                                           }];
        } else {
            self.rspModel = rspModel;
            !completion ?: completion(rspModel, NO);
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        self.rspModel = nil;
        !completion ?: completion(nil, YES);
    }];
}

- (GNHomeDTO *)homeDTO {
    if (!_homeDTO) {
        _homeDTO = GNHomeDTO.new;
    }
    return _homeDTO;
}

@end
