//
//  SAPhoneFormatValidator.m
//  SuperApp
//
//  Created by seeu on 2021/11/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAPhoneFormatValidator.h"
#import "SAApolloManager.h"
#import <HDKitCore/HDKitCore.h>
#import <YYModel/YYModel.h>


@implementation SAPhoneFormatModel

@end

static NSString *cambodiaPhoneFormatJson
    = @"[{\"prefix\":\"0235\",\"max\":6,\"min\":6,\"carrier\":\"CellCard\"},{\"prefix\":\"011\",\"max\":6,\"min\":6,\"carrier\":\"CellCard\"},{\"prefix\":\"012\",\"max\":7,\"min\":6,\"carrier\":"
      @"\"CellCard\"},{\"prefix\":\"014\",\"max\":6,\"min\":6,\"carrier\":\"CellCard\"},{\"prefix\":\"017\",\"max\":6,\"min\":6,\"carrier\":\"CellCard\"},{\"prefix\":\"061\",\"max\":6,\"min\":6,"
      @"\"carrier\":\"CellCard\"},{\"prefix\":\"076\",\"max\":7,\"min\":7,\"carrier\":\"CellCard\"},{\"prefix\":\"077\",\"max\":6,\"min\":6,\"carrier\":\"CellCard\"},{\"prefix\":\"078\",\"max\":6,"
      @"\"min\":6,\"carrier\":\"CellCard\"},{\"prefix\":\"079\",\"max\":6,\"min\":6,\"carrier\":\"CellCard\"},{\"prefix\":\"085\",\"max\":6,\"min\":6,\"carrier\":\"CellCard\"},{\"prefix\":\"089\","
      @"\"max\":6,\"min\":6,\"carrier\":\"CellCard\"},{\"prefix\":\"092\",\"max\":6,\"min\":6,\"carrier\":\"CellCard\"},{\"prefix\":\"095\",\"max\":6,\"min\":6,\"carrier\":\"CellCard\"},{\"prefix\":"
      @"\"099\",\"max\":6,\"min\":6,\"carrier\":\"CellCard\"},{\"prefix\":\"038\",\"max\":7,\"min\":7,\"carrier\":\"CooTel\"},{\"prefix\":\"039\",\"max\":7,\"min\":7,\"carrier\":\"Kingtel\"},{"
      @"\"prefix\":\"018\",\"max\":7,\"min\":7,\"carrier\":\"Seatel\"},{\"prefix\":\"0236\",\"max\":6,\"min\":6,\"carrier\":\"Metfone\"},{\"prefix\":\"031\",\"max\":7,\"min\":7,\"carrier\":"
      @"\"Metfone\"}"
      @",{\"prefix\":\"060\",\"max\":6,\"min\":6,\"carrier\":\"Metfone\"},{\"prefix\":\"066\",\"max\":6,\"min\":6,\"carrier\":\"Metfone\"},{\"prefix\":\"067\",\"max\":6,\"min\":6,\"carrier\":"
      @"\"Metfone\"},{\"prefix\":\"068\",\"max\":6,\"min\":6,\"carrier\":\"Metfone\"},{\"prefix\":\"071\",\"max\":7,\"min\":7,\"carrier\":\"Metfone\"},{\"prefix\":\"088\",\"max\":7,\"min\":7,"
      @"\"carrier\":\"Metfone\"},{\"prefix\":\"090\",\"max\":6,\"min\":6,\"carrier\":\"Metfone\"},{\"prefix\":\"097\",\"max\":7,\"min\":7,\"carrier\":\"Metfone\"},{\"prefix\":\"013\",\"max\":6,"
      @"\"min\":"
      @"6,\"carrier\":\"qb\"},{\"prefix\":\"080\",\"max\":6,\"min\":6,\"carrier\":\"qb\"},{\"prefix\":\"083\",\"max\":6,\"min\":6,\"carrier\":\"qb\"},{\"prefix\":\"084\",\"max\":6,\"min\":6,"
      @"\"carrier\":\"qb\"},{\"prefix\":\"010\",\"max\":6,\"min\":6,\"carrier\":\"Smart\"},{\"prefix\":\"015\",\"max\":6,\"min\":6,\"carrier\":\"Smart\"},{\"prefix\":\"016\",\"max\":6,\"min\":6,"
      @"\"carrier\":\"Smart\"},{\"prefix\":\"069\",\"max\":6,\"min\":6,\"carrier\":\"Smart\"},{\"prefix\":\"070\",\"max\":6,\"min\":6,\"carrier\":\"Smart\"},{\"prefix\":\"081\",\"max\":6,\"min\":6,"
      @"\"carrier\":\"Smart\"},{\"prefix\":\"086\",\"max\":6,\"min\":6,\"carrier\":\"Smart\"},{\"prefix\":\"087\",\"max\":6,\"min\":6,\"carrier\":\"Smart\"},{\"prefix\":\"093\",\"max\":6,\"min\":6,"
      @"\"carrier\":\"Smart\"},{\"prefix\":\"096\",\"max\":7,\"min\":7,\"carrier\":\"Smart\"},{\"prefix\":\"098\",\"max\":6,\"min\":6,\"carrier\":\"Smart\"}]";


@implementation SAPhoneFormatValidator

+ (BOOL)isCambodia:(NSString *)phoneNo {
    NSString *phone = [phoneNo copy];
    // 去除国家码
    if ([phone hasPrefix:@"855"]) {
        phone = [phone substringFromIndex:3];
    }

    if (![phone hasPrefix:@"0"]) {
        phone = [@"0" stringByAppendingString:phone];
    }
    NSArray *cache = [SAApolloManager getApolloConfigForKey:kApolloSwitchKeyCambodiaPhoneFormatArray];
    NSArray<SAPhoneFormatModel *> *models = nil;
    if (!HDIsArrayEmpty(cache)) {
        models = [NSArray yy_modelArrayWithClass:SAPhoneFormatModel.class json:cache];
    } else {
        models = [NSArray yy_modelArrayWithClass:SAPhoneFormatModel.class json:cambodiaPhoneFormatJson];
    }

    BOOL pass = false;
    for (SAPhoneFormatModel *model in models) {
        if ([phone hasPrefix:model.prefix]) {
            NSString *subPhone = [phone substringFromIndex:model.prefix.length];
            if (subPhone.length <= model.max && subPhone.length >= model.min) {
                pass = true;
                break;
            }
        }
    }

    return pass;
}

@end
