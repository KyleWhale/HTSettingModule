//
//  ZQAccountTools.h
//  Moshfocus
//
//  Created by admin on 16/4/28.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZQAccountTools : NSObject

+ (instancetype)sharedInstance;

- (void)lgjeropj_saveOrUpDataAccount:(ZQAccountModel *)model;
- (ZQAccountModel *)lgjeropj_getAccountData;
- (void)lgjeropj_logOut;

- (BOOL)lgjeropj_islogin;

@end


