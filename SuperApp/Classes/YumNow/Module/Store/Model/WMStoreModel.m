

//
//  WMStoreModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreModel.h"
#import "SACaculateNumberTool.h"
#import <YYText/NSAttributedString+YYText.h>
#import <YYText/YYLabel.h>
#import "HDUIGhostButton.h"

@implementation WMBaseStoreModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.numberOfLinesOfNameLabel = 0;
        self.numberOfLinesOfDescLabel = 1;
        self.numberOfLinesOfPromotion = 1;
        self.rate = 150.0 / 350.0;
        self.uuid = [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        self.willDisplayTime = 0;
    }
    return self;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"isNewStore": @[@"new", @"isNew"],
        @"commentsCount": @"reviewCount",
        @"ratingScore": @"reviewScore",
        @"storeType": @"storeType.code",
    };
}

- (NSString *)distanceStr {
    return [SACaculateNumberTool distanceStringFromNumber:self.distance toFixedCount:1 roundingMode:SANumRoundingModeUpAndDown];
}

@end

@implementation WMStoreModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"businessScopes": SAInternationalizationModel.class,
        @"promotions": WMStoreDetailPromotionModel.class,
    };
}

@end

@implementation WMNewStoreModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.storeLogoShowType = YumNowLandingPageStoreCardStyleSmall;
    }
    return self;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"businessScopes": SAInternationalizationModel.class,
    };
}

- (CGFloat)storeCardHeightWith:(YumNowLandingPageStoreCardStyle)storeLogoShowType {
    CGFloat height = 0;
    BOOL hasFastService = self.slowPayMark.boolValue;
    
    bool showRestOrFullOrder = [self _showRestOrFullOrder];
    
    if([storeLogoShowType isEqualToString: YumNowLandingPageStoreCardStyleSmall]) {
        //无标签情况
        if(HDIsArrayEmpty(self.promotions) && HDIsArrayEmpty(self.productPromotions) && !hasFastService && HDIsArrayEmpty(self.serviceLabel) && !showRestOrFullOrder) {
            //图标撑起整个view
            height += kRealWidth(16);
            height += kRealWidth(80);
            height += kRealWidth(18);
            
        }else{ //有标签情况
            height += kRealWidth(16);
            height += kRealWidth(24); //标题
            
            height += kRealWidth(4);
            height += kRealWidth(18); //评星
            
            height += kRealWidth(4);
            height += kRealWidth(18); //距离与时间
            
            if(showRestOrFullOrder) { //休息或者爆单
                height += kRealWidth(4);
                height += kRealWidth(20);
            }
            if (!self.tagString) {
                NSMutableArray *mArr = @[].mutableCopy;
                [mArr addObjectsFromArray: [WMStoreDetailPromotionModel configNewPromotions:self.promotions productPromotion:self.productPromotions hasFastService:hasFastService].mutableCopy];
                
                if (self.serviceLabel.count) {
                    [mArr addObjectsFromArray:[WMStoreDetailPromotionModel configserviceLabel:self.serviceLabel]];
                }
                self.tagString = NSMutableAttributedString.new;
                [mArr enumerateObjectsUsingBlock:^(HDUIGhostButton *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                    NSMutableAttributedString *objStr = [NSMutableAttributedString yy_attachmentStringWithContent:obj contentMode:UIViewContentModeCenter attachmentSize:obj.frame.size
                                                                                                      alignToFont:obj.titleLabel.font
                                                                                                        alignment:YYTextVerticalAlignmentCenter];
                    if (idx != mArr.count - 1) {
                        NSMutableAttributedString *spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill
                                                                                                          attachmentSize:CGSizeMake(kRealWidth(4), 1)
                                                                                                             alignToFont:[UIFont systemFontOfSize:0]
                                                                                                               alignment:YYTextVerticalAlignmentCenter];
                        [objStr appendAttributedString:spaceText];
                    }
                    [self.tagString appendAttributedString:objStr];
                }];
                self.tagString.yy_lineSpacing = kRealWidth(4);
            }
            
            if(self.tagString.length){
                YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth - kRealWidth(140), CGFLOAT_MAX)];
                container.maximumNumberOfRows = self.numberOfLinesOfPromotion == 1 ? self.numberOfLinesOfPromotion : 0;
                container.truncationType = YYTextTruncationTypeEnd;
                
                YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:self.tagString];
                height += kRealWidth(4);
                height += layout.textBoundingSize.height;
            }
            //底部间距
            height += kRealWidth(16);
        }
    }else{ //英文柬文的高度计算
        height += kRealWidth(20); //图片
        height += (kScreenWidth - kRealWidth(12.5) * 2) * 175 / 350.0;
        height += kRealWidth(9.5);

        CGFloat storeNameHeight = [self.storeName.desc boundingRectWithSize:CGSizeMake(kScreenWidth - kRealWidth(30), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:HDAppTheme.font.standard2Bold} context:nil].size.height;
        
        if(storeNameHeight >21) {
            height += 41;
        }else{
            height += 21;
        }
        
        height += kRealWidth(8);
        height += 21; //销量
        
        if (!self.tagString) {
            NSMutableArray *mArr = @[].mutableCopy;
            [mArr addObjectsFromArray: [WMStoreDetailPromotionModel configNewPromotions:self.promotions productPromotion:self.productPromotions hasFastService:hasFastService].mutableCopy];
            
            if (self.serviceLabel.count) {
                [mArr addObjectsFromArray:[WMStoreDetailPromotionModel configserviceLabel:self.serviceLabel]];
            }
            self.tagString = NSMutableAttributedString.new;
            [mArr enumerateObjectsUsingBlock:^(HDUIGhostButton *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                NSMutableAttributedString *objStr = [NSMutableAttributedString yy_attachmentStringWithContent:obj contentMode:UIViewContentModeCenter attachmentSize:obj.frame.size
                                                                                                  alignToFont:obj.titleLabel.font
                                                                                                    alignment:YYTextVerticalAlignmentCenter];
                if (idx != mArr.count - 1) {
                    NSMutableAttributedString *spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill
                                                                                                      attachmentSize:CGSizeMake(kRealWidth(4), 1)
                                                                                                         alignToFont:[UIFont systemFontOfSize:0]
                                                                                                           alignment:YYTextVerticalAlignmentCenter];
                    [objStr appendAttributedString:spaceText];
                }
                [self.tagString appendAttributedString:objStr];
            }];
            self.tagString.yy_lineSpacing = kRealWidth(4);
        }
        
        if(self.tagString.length){
            YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth - kRealWidth(30), CGFLOAT_MAX)];
            container.maximumNumberOfRows = 0;
            container.truncationType = YYTextTruncationTypeEnd;
            
            YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:self.tagString];
            height += kRealWidth(10);
            height += layout.textBoundingSize.height;
        }
        
        height += kRealWidth(20);
        
    }
    return height;
}

- (BOOL)_showRestOrFullOrder {
    if (![self.storeStatus.status isEqualToString:WMStoreStatusOpening] || self.nextServiceTime) {
        return YES;
    } else {
        if (self.fullOrderState == WMStoreFullOrderStateFull) {
            return YES;
        } else if (self.fullOrderState == WMStoreFullOrderStateFullAndStop) {
            return YES;
        } else if (self.slowMealState == WMStoreSlowMealStateSlow) {
            return YES;
        }
    }
    return NO;
}

@end
