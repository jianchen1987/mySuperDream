//
//  PNGuarateenShareManager.m
//  SuperApp
//
//  Created by xixi_wen on 2023/1/13.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNGuarateenShareManager.h"
#import "PNGuarateenDetailModel.h"
#import "SAAppEnvManager.h"
#import "SASocialShareView.h"


@implementation PNGuarateenShareManager

+ (instancetype)sharedInstance {
    static PNGuarateenShareManager *ins = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ins = [[super allocWithZone:nil] init];
    });
    return ins;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[self class] sharedInstance];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[self class] sharedInstance];
}

- (void)shareGuarateenWithModel:(PNGuarateenDetailModel *)model {
    /// 组装数据
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *bodyStr = model.body;
    if (bodyStr.length > 20) {
        bodyStr = [bodyStr substringToIndex:20];
    }
    [dict setValue:bodyStr forKey:@"body"];
    [dict setValue:model.userMobile forKey:@"userMobile"];
    [dict setValue:model.userName forKey:@"userName"];
    [dict setValue:model.amt forKey:@"amt"];
    [dict setValue:model.feeAmt forKey:@"feeAmt"];
    [dict setValue:model.cy forKey:@"cy"];
    [dict setValue:model.orderNo forKey:@"orderNo"];

    __block NSString *jsonStr = @"";
    NSArray *keys = dict.allKeys;
    [keys enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (idx == 0) {
            jsonStr = [jsonStr stringByAppendingFormat:@"%@=%@", obj, dict[obj]];
        } else {
            jsonStr = [jsonStr stringByAppendingFormat:@"&%@=%@", obj, dict[obj]];
        }
    }];

    SAShareWebpageObject *shareObject = SAShareWebpageObject.new;
    shareObject.title = PNLocalizedString(@"hbTBKfhM", @"你有一笔担保交易");
    shareObject.descr = model.body ?: @"";

    NSString *sitFlag = @"";
    if ([SAAppEnvManager.sharedInstance.appEnvConfig.type isEqualToString:SAAppEnvTypeProduct]) {
        sitFlag = @"";
    } else {
        sitFlag = @"-sit";
    }

    shareObject.webpageUrl = [NSString stringWithFormat:@"https://img.coolcashcam.com/publishv%@/index.html#/secured-txn/order-detail?%@", sitFlag, [jsonStr hd_URLEncodedString]];

    shareObject.thumbImage = [UIImage imageNamed:@"CoolCash"];

    [SASocialShareView showShareWithShareObject:shareObject functionModels:@[SASocialShareView.copyLinkFunctionModel] completion:nil];
}
@end
