//
//  ZQAccountTools.m
//  Moshfocus
//
//  Created by admin on 16/4/28.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "ZQAccountTools.h"

@implementation ZQAccountTools

+ (instancetype)sharedInstance {
    static ZQAccountTools *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

//存储
- (void)lgjeropj_saveOrUpDataAccount:(ZQAccountModel*)model {
    NSUserDefaults *var_userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *var_jsonStr = [model yy_modelToJSONString];
    [var_userDefaults setObject:var_jsonStr forKey:@"udf_userAccount"];
    [var_userDefaults synchronize];
}
//获取
- (ZQAccountModel *)lgjeropj_getAccountData {
    NSUserDefaults *var_userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *var_jsonStr = [var_userDefaults objectForKey:@"udf_userAccount"];
    ZQAccountModel *var_model = [ZQAccountModel yy_modelWithJSON:var_jsonStr];
    return var_model ?: [[ZQAccountModel alloc] init];
}
//删除
- (void)lgjeropj_logOut {
    NSUserDefaults *var_userDefaults = [NSUserDefaults standardUserDefaults];
    [var_userDefaults removeObjectForKey:@"udf_userAccount"];
    [var_userDefaults synchronize];
}

- (BOOL)lgjeropj_islogin {

    return [[[self lgjeropj_getAccountData] var_userid] integerValue] > 0;
}

@end
