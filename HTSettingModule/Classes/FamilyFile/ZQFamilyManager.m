//
//  ZQFamilyManager.m
//  Moshfocus
//
//  Created by dn on 2023/6/26.
//

#import "ZQFamilyManager.h"

@implementation ZQFamilyManager

+ (NSDictionary *)lgjeropj_familyText
{
    NSString *var_titleStr = LocalString(@"How to add family accounts:", nil);
    NSMutableString *var_msgStr = [NSMutableString stringWithString:LocalString(@"Enter the email address or account ID of a family member and click Add to add him or her successfully.", nil)];
    [var_msgStr appendString:@"\n\n"];
    [var_msgStr appendString:AsciiString(@"Note: ")];
    [var_msgStr appendString:@"\n"];
    [var_msgStr appendString:LocalString(@"Family members need to Log In to their family account to get the premium version.", nil)];
    [var_msgStr appendString:@"\n"];
    [var_msgStr appendString:LocalString(@"Your family members can register an account in the My library page or Settings page of the app.", nil)];
    return @{AsciiString(@"title"):var_titleStr,AsciiString(@"msg"):var_msgStr};
}

+ (void)lgjeropj_showUpdataResult:(NSDictionary *)dict andText:(NSString *)text andBlock:(void(^)(bool code, NSString *title, NSString *msg))block
{
    if([dict isKindOfClass:[NSDictionary class]] && dict.count > 0) {
        
    } else {
        return;
    }
    NSInteger status = [[dict objectForKey:@"status"] integerValue];
    
    switch (status) {
        case 200:
        {
            NSInteger remain = [dict[AsciiString(@"remain")] integerValue];
            if (remain == 0) {
                [SVProgressHUD showInfoWithStatus:LocalString(@"Family members reached the upper limit", nil)];
            } else {
                [SVProgressHUD showInfoWithStatus:LocalString(@"Added successfully", nil)];
            }
            break;
        }
        case 300:
        {
            [SVProgressHUD showInfoWithStatus:LocalString(@"The account does not exist", nil)];
            break;
        }
        case 301:
        {
            [SVProgressHUD showInfoWithStatus:LocalString(@"The user already exists", nil)];
            break;
        }
            
        case 302:
        {
            [SVProgressHUD showInfoWithStatus:LocalString(@"The user has already joined another family plan", nil)];
            break;
        }
        case 304:
        {
            NSString *var_titleStr = LocalString(@"Added successfully", nil);
            NSString *var_msgStr = LocalString(@"Please ask your family to install this app and log in to an account with **** on the Mylibrary page.", nil);
            var_msgStr = [var_msgStr stringByReplacingOccurrencesOfString:@"****" withString:text];
            NSInteger var_remain = [[dict objectForKey:AsciiString(@"remain")] integerValue];
            if (var_remain <= 0) {
                var_msgStr = [NSString stringWithFormat:@"%@\n%@", var_msgStr, LocalString(@"Family members reached the upper limit", nil)];
            }
            [SVProgressHUD dismiss];
            if(block) {
                block(1,var_titleStr, var_msgStr);
            }
            break;
        }
        default:
        {
            [SVProgressHUD showInfoWithStatus:[dict objectForKey:@"msg"]];
            break;
        }
    }
}

+ (NSArray *)lgjeropj_questionViewTitleArray:(NSInteger)var_total
{
    NSMutableArray *dataArray = [NSMutableArray array];
    [dataArray addObject:LocalString(@"What is a family package?", nil)];
    [dataArray addObject:[NSString stringWithFormat:LocalString(@"The family plan packs up to %ld independent accounts into one payment, and the accounts are completely independent.\nThe main family account can invite other members at any time, and members can log out at any time.", nil), var_total]];
    [dataArray addObject:LocalString(@"Upgrade to family package?", nil)];
    [dataArray addObject:LocalString(@"If you have already purchased a single plan, you can upgrade to a family plan at any time.\nThe family plan needs to be paid , and the old subscription balance will be refunded to you in proportion.", nil)];
    return dataArray.copy;
}
@end
