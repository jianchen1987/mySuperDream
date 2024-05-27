//
//  FunctionCellModel.m
//  SuperApp
//
//  Created by Quin on 2021/11/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNFunctionCellModel.h"
#import "PNWalletListConfigModel.h"


@implementation PNFunctionCellModel
+ (PNFunctionCellModel *)getModel:(NSString *)imageName title:(NSString *)title actionName:(NSString *)actionName tag:(NSInteger)tag {
    PNFunctionCellModel *model = PNFunctionCellModel.new;
    model.imageName = imageName;
    model.title = title;
    model.actionName = actionName;
    model.tag = tag;
    return model;
}

+ (PNFunctionCellModel *)getModel:(NSString *)imageName title:(NSString *)title actionName:(NSString *)actionName {
    return [PNFunctionCellModel getModel:imageName title:title actionName:actionName tag:0];
}

+ (PNFunctionCellModel *)getModelWithWalletConfigModel:(PNWalletListConfigModel *)config {
    PNFunctionCellModel *model = PNFunctionCellModel.new;
    model.imageName = config.logoPath;
    model.title = config.businessName;
    if (config.bizType == PNWalletListItemTypeDeposit) {
        model.actionName = @"deposit";
    } else if (config.bizType == PNWalletListItemTypeTransfer) {
        model.actionName = @"transList";
    } else if (config.bizType == PNWalletListItemTypeInternationalTransfer) {
        model.actionName = @"internationalTransfer";
    } else if (config.bizType == PNWalletListItemTypeBillPayment) {
        model.actionName = @"utilities";
    } else if (config.bizType == PNWalletListItemTypeCoolcashWebsite) {
        model.actionName = @"coolcashOutlet";
    } else if (config.bizType == PNWalletListItemTypeMerchantServices) {
        model.actionName = @"merchantServicesHome";
    } else if (config.bizType == PNWalletListItemTypeApartment) {
        model.actionName = @"apartmentHome";
    } else if (config.bizType == PNWalletListItemTypeRedPacket) {
        model.actionName = @"luckPacketHome";
    } else if (config.bizType == PNWalletListItemTypeGuaratee) {
        model.actionName = @"guaranteeHome";
    } else if (config.bizType == PNWalletListItemTypeScan) {
        model.actionName = @"pnScanner";
    } else if (config.bizType == PNWalletListItemTypePaymentCode) {
        model.actionName = @"paymentCode";
    } else if (config.bizType == PNWalletListItemTypeCollectionCode) {
        model.actionName = @"receiveCode";
    } else if (config.bizType == PNWalletListItemTypeCollectionCredit) {
        model.actionName = @"loanMain";
    }

    return model;
}

@end
