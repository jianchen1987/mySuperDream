//
//  TNStoreSceneModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/1/6.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNStoreSceneModel.h"
#import "HDAppTheme+TinhNow.h"
#import "TNAdaptImageModel.h"
#import <NSString+HD_Size.h>


@interface TNStoreSceneModel ()
/// 三行文本高度
@property (nonatomic, assign) CGFloat thirdLineHeight;
@end


@implementation TNStoreSceneModel
- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *text = @"1 \n 2 \n 3";
        self.thirdLineHeight = [text boundingAllRectWithSize:CGSizeMake(kScreenWidth - kRealWidth(30), MAXFLOAT) font:HDAppTheme.TinhNowFont.standard15M lineSpacing:0].height;
    }
    return self;
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"sceneId": @"id"};
}
- (void)setStoreLiveImage:(NSArray *)storeLiveImage {
    _storeLiveImage = storeLiveImage;
    if (!HDIsArrayEmpty(storeLiveImage)) {
        self.storeLiveImageModels = [TNAdaptImageModel getAdaptImageModelsByImagesStrs:storeLiveImage];
    }
}
- (CGFloat)imagesHeight {
    CGFloat height = 0;
    if (!HDIsArrayEmpty(self.storeLiveImageModels)) {
        for (TNAdaptImageModel *model in self.storeLiveImageModels) {
            height += model.imageHeight <= 0 ? kScreenWidth - kRealWidth(30) : model.imageHeight;
        }
        height += kRealWidth(5) * (self.storeLiveImageModels.count - 1);
    }
    return height;
}
- (BOOL)isNeedShowMoreBtn {
    //文本高度
    CGFloat textHeight = [self.name boundingAllRectWithSize:CGSizeMake(kScreenWidth - kRealWidth(30), MAXFLOAT) font:HDAppTheme.TinhNowFont.standard15M lineSpacing:0].height;
    return textHeight > self.thirdLineHeight;
}
- (CGFloat)cellHeight {
    CGFloat height = 0;
    //文本上间距
    height += kRealWidth(15);
    //文本高度
    CGFloat textHeight = [self.name boundingAllRectWithSize:CGSizeMake(kScreenWidth - kRealWidth(30), MAXFLOAT) font:HDAppTheme.TinhNowFont.standard15M lineSpacing:0].height;
    if (textHeight > self.thirdLineHeight) {
        if (!self.showAllText) {
            textHeight = self.thirdLineHeight;
        }
        //加上按钮的高度
        height += kRealWidth(5);
        height += kRealWidth(21);
    }
    height += textHeight;
    //距离图片的高度
    height += kRealWidth(5);
    //加图片高度
    height += self.imagesHeight;
    //底部间距
    height += kRealWidth(15);
    //分割间距
    height += kRealWidth(10);
    return height;
}

@end
