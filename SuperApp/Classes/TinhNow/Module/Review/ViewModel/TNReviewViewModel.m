//
//  TNReviewViewModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/3/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNReviewViewModel.h"
#import "TNOrderDTO.h"
#import "TNQueryOrderDetailsRspModel.h"
#import "TNMyReviewDTO.h"
#import "SAUploadImageDTO.h"
#import "HXPhotoModel.h"
#import "TNNotificationConst.h"


@interface TNReviewViewModel ()
/// 订单详情DTO
@property (nonatomic, strong) TNOrderDTO *orderDTO;
///
@property (nonatomic, strong) TNMyReviewDTO *postReviewDTO;
///
@property (nonatomic, strong) SAUploadImageDTO *uploadImageDTO;
///
@property (nonatomic, strong) dispatch_semaphore_t uploadSemaphore;

///
@property (nonatomic, assign) NSInteger beginInt;


@end


@implementation TNReviewViewModel

- (void)getOrderDetailWithOrderNo:(NSString *)orderNo {
    @HDWeakify(self);
    [self.view showloading];
    [self.orderDTO queryOrderDetailsWithOrderNo:orderNo success:^(TNQueryOrderDetailsRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        [self generateDataWithRspModel:rspModel];
        self.refreshFlag = !self.refreshFlag;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.refreshFlag = !self.refreshFlag;
    }];
}

- (void)getReviewNotice {
    [self.postReviewDTO getReviewNoticeWithSuccess:^(NSDictionary *_Nonnull data) {
        self.noticeContent = data[@"content"];
        self.noticeRefreshFlag = !self.noticeRefreshFlag;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];
}

- (void)generateDataWithRspModel:(TNQueryOrderDetailsRspModel *)rspModel {
    __block NSMutableArray<TNSubmitReviewItemModel *> *goodsArray = [NSMutableArray arrayWithCapacity:rspModel.orderDetail.items.count];
    [rspModel.orderDetail.items enumerateObjectsUsingBlock:^(TNOrderDetailsGoodsInfoModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (obj) {
            TNSubmitReviewItemModel *itemModel = [[TNSubmitReviewItemModel alloc] init];
            itemModel.name = obj.name;
            itemModel.itemId = obj.productId;
            itemModel.thumbnail = obj.thumbnail;
            itemModel.skuId = obj.skuId;
            itemModel.mobile = SAUser.shared.loginName;
            itemModel.score = 5;
            itemModel.anonymous = 10;
            itemModel.content = @"";
            itemModel.imageUrls = @[];

            [goodsArray addObject:itemModel];
        }
    }];

    self.dataModel.serviceScore = 5;
    self.dataModel.logisticsScore = 5;
    self.dataModel.itemList = goodsArray;
}

- (void)postReviewAction {
    self.beginInt = 0;
    [self uploadImages];
}

- (void)postReviewData {
    NSString *postDataStr = [self.dataModel yy_modelToJSONString];
    HDLog(@"%@", self.dataModel);
    HDLog(@"postDataStr:%@", postDataStr);
    [self.view showloading];
    @HDWeakify(self);
    [self.postReviewDTO postReviewData:postDataStr success:^{
        @HDStrongify(self);
        [self.view dismissLoading];
        [NAT showToastWithTitle:nil content:TNLocalizedString(@"tn_postReview_success", @"您的商品评价提交成功") type:HDTopToastTypeSuccess];
        [NSNotificationCenter.defaultCenter postNotificationName:kTNNotificationNamePostReviewSuccess object:nil userInfo:@{@"orderNo": self.dataModel.orderNo}];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.view.viewController.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)uploadImages {
    if (self.beginInt >= self.dataModel.itemList.count) {
        [self postReviewData];
        return;
    }
    TNSubmitReviewItemModel *itemModel = self.dataModel.itemList[self.beginInt];

    NSArray<UIImage *> *images = [itemModel.selectedPhotos mapObjectsUsingBlock:^UIImage *_Nonnull(HXPhotoModel *_Nonnull model, NSUInteger idx) {
        return model.previewPhoto ?: model.thumbPhoto;
    }];

    if (images.count > 0) {
        HDTips *hud = [HDTips showLoading:SALocalizedString(@"hud_uploading", @"上传中...") inView:self.view];
        if (self.beginInt == 1) {
            images = @[];
        }
        @HDWeakify(self);
        [self.uploadImageDTO batchUploadImages:images progress:^(NSProgress *_Nonnull progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud showProgressViewWithProgress:progress.fractionCompleted text:[NSString stringWithFormat:@"%.0f%%", progress.fractionCompleted * 100.0]];
            });
        } success:^(NSArray *_Nonnull imageURLArray) {
            @HDStrongify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud showSuccessNotCreateNew:SALocalizedString(@"upload_completed", @"上传完毕")];
            });
            itemModel.imageUrls = imageURLArray;
            self.beginInt++;
            [self uploadImages];
        } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
            [hud hideAnimated:YES];
            return;
        }];
    } else {
        self.beginInt++;
        [self uploadImages];
    }

    /*
    for (int i = 0; i < self.dataModel.itemList.count; i++) {
        TNSubmitReviewItemModel *itemModel = self.dataModel.itemList[i];
        NSArray<UIImage *> *images = [itemModel.selectedPhotos mapObjectsUsingBlock:^UIImage *_Nonnull(HXPhotoModel *_Nonnull model, NSUInteger idx) {
            return model.previewPhoto ?: model.thumbPhoto;
        }];

        if (images.count > 0) {
            dispatch_semaphore_wait(self.uploadSemaphore, DISPATCH_TIME_FOREVER);
            HDTips *hud = [HDTips showLoading:SALocalizedString(@"hud_uploading", @"上传中...") inView:self.view];
            [self.uploadImageDTO batchUploadImages:images progress:^(NSProgress *_Nonnull progress) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud showProgressViewWithProgress:progress.fractionCompleted text:[NSString stringWithFormat:@"%.0f%%", progress.fractionCompleted * 100.0]];
                });
            }
            success:^(NSArray *_Nonnull imageURLArray) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud showSuccessNotCreateNew:SALocalizedString(@"upload_completed", @"上传完毕")];
                });
                itemModel.imageUrls = imageURLArray;
                dispatch_semaphore_signal(self.uploadSemaphore);
            }
            failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
                dispatch_semaphore_signal(self.uploadSemaphore);
                [hud hideAnimated:YES];
            }];
        } else {
            dispatch_semaphore_signal(self.uploadSemaphore);
        }
    }
     */
}

#pragma mark -
- (TNOrderDTO *)orderDTO {
    if (!_orderDTO) {
        _orderDTO = [[TNOrderDTO alloc] init];
    }
    return _orderDTO;
}

- (TNSubmitReviewModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[TNSubmitReviewModel alloc] init];
    }
    return _dataModel;
}

- (TNMyReviewDTO *)postReviewDTO {
    if (!_postReviewDTO) {
        _postReviewDTO = [[TNMyReviewDTO alloc] init];
    }
    return _postReviewDTO;
}

- (SAUploadImageDTO *)uploadImageDTO {
    if (!_uploadImageDTO) {
        _uploadImageDTO = [[SAUploadImageDTO alloc] init];
    }
    return _uploadImageDTO;
}
@end
