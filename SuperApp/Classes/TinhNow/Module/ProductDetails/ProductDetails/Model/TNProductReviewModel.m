//
//  TNProductReviewModel.m
//  SuperApp
//
//  Created by seeu on 2020/7/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNProductReviewModel.h"
#import "TNMyHadReviewModel.h"


@implementation TNReviewMerchantReplyModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"replyId": @"id"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"imageUrls": [NSString class]};
}
@end


@implementation TNProductReviewModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"replys": [TNReviewMerchantReplyModel class]};
}
+ (instancetype)transformModelWithMyReviewModel:(TNMyHadReviewModel *)model {
    TNProductReviewModel *reviewModel = [[TNProductReviewModel alloc] init];
    reviewModel.head = model.head;
    reviewModel.createdDate = model.createTime;
    reviewModel.anonymous = model.anonymous == 10;
    reviewModel.content = model.content;
    reviewModel.username = model.nickName;
    reviewModel.itemScore = model.score;
    reviewModel.images = model.imageUrls;
    reviewModel.itemId = model.itemId;
    reviewModel.price = model.price;
    reviewModel.quantity = model.quantity;
    reviewModel.totalPrice = model.totalPrice;
    reviewModel.thumbnail = model.thumbnail;
    reviewModel.storeNo = model.storeNo;
    reviewModel.storeNameMap = model.storeNameMap;
    reviewModel.itemNameMap = model.itemNameMap;
    reviewModel.isFromMyReview = YES;
    reviewModel.orderNo = model.orderNo;
    return reviewModel;
}
@end
