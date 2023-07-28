//
//  ZQSettingControllerManager.m
//  Moshfocus
//
//  Created by 李雪健 on 2022/9/9.
//

#import "ZQSettingControllerManager.h"
#import "HTFeedbackViewController.h"
#import "ZQSetupListController.h"
#import "HTLoginPointManager.h"
#import "ZQAccountTools.h"

@implementation ZQSettingControllerManager

- (UIView *)lgjeropj_signViewWithTarget:(id)target andAction:(SEL)action {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [[ZQAccountTools sharedInstance] lgjeropj_islogin]?150:190)];
    view.backgroundColor = [UIColor clearColor];

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(kWidthScale(15), 20, view.frame.size.width - kWidthScale(30), view.frame.size.height - 40)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#2F2F43"];
    headerView.layer.masksToBounds = YES;
    headerView.layer.cornerRadius = 12;
    [view addSubview:headerView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, headerView.frame.size.width - 20, 70)];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 3;
    label.font = [UIFont systemFontOfSize:16];
    label.text = LocalString(@"Sign in for full service experience", nil);
    [headerView addSubview:label];
    
    UIButton *loginBut = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBut.frame = CGRectMake((headerView.frame.size.width - 150)/2, CGRectGetMaxY(label.frame) + 10, 150, 44);
    loginBut.backgroundColor = [UIColor whiteColor];
    loginBut.layer.masksToBounds = YES;
    loginBut.layer.cornerRadius = 22;
    loginBut.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [loginBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginBut setTitle:[HTCommonConfiguration lgjeropj_shared].BLOCK_switchStateBlock()?LocalString(@"Log In", nil):AsciiString(@"LOG IN") forState:UIControlStateNormal];
    [loginBut addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:loginBut];
    
    return view;
}

- (UIView *)lgjeropj_loginViewWithTarget:(id)target andAction:(SEL)action {
    ZQAccountModel *result = [[ZQAccountTools sharedInstance] lgjeropj_getAccountData];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [[ZQAccountTools sharedInstance] lgjeropj_islogin]?150:190)];
    view.backgroundColor = [UIColor clearColor];

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(kWidthScale(15), 20, view.frame.size.width - kWidthScale(30), view.frame.size.height - 40)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#2F2F43"];
    headerView.layer.masksToBounds = YES;
    headerView.layer.cornerRadius = 12;
    [view addSubview:headerView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [headerView addGestureRecognizer:singleTap];
    
    UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    iconBtn.frame = CGRectMake(kWidthScale(15), 20, 70, 70);
    iconBtn.layer.cornerRadius = 35;
    iconBtn.clipsToBounds = YES;
    iconBtn.contentMode = UIViewContentModeScaleAspectFill;
    iconBtn.userInteractionEnabled = NO;

    if(result.var_avatar && result.var_avatar.length > 0) {
        [iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:result.var_avatar] forState:UIControlStateNormal];
    } else {
        [iconBtn setBackgroundImage:[UIImage imageNamed:@"icon_defultHeader"] forState:UIControlStateNormal];
    }
    [headerView addSubview:iconBtn];
    
    UIButton *nextBut = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBut.userInteractionEnabled = NO;
    nextBut.frame = CGRectMake(headerView.frame.size.width - 50, CGRectGetMidY(iconBtn.frame) - 12, 25, 25);
    [nextBut sd_setImageWithURL:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:217] forState:UIControlStateNormal];
    [headerView addSubview:nextBut];

    UIButton *editorBut = [UIButton buttonWithType:UIButtonTypeCustom];
    editorBut.userInteractionEnabled = NO;
    editorBut.frame = CGRectMake(CGRectGetMaxX(iconBtn.frame) - 25, CGRectGetMaxY(iconBtn.frame) - 25, 25, 25);
    [editorBut sd_setBackgroundImageWithURL:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:200] forState:UIControlStateNormal];
    [headerView addSubview:editorBut];

    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn.userInteractionEnabled = NO;
    titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    titleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    titleBtn.frame = CGRectMake(CGRectGetMaxX(iconBtn.frame) + 10, 35, headerView.frame.size.width - iconBtn.frame.size.width - 90, titleBtn.titleLabel.font.lineHeight);
    [titleBtn setTitle:result.var_name forState:UIControlStateNormal];
    [headerView addSubview:titleBtn];
    
    
    //
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    detailBtn.userInteractionEnabled = NO;
    detailBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    detailBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [detailBtn setTitleColor:[UIColor colorWithHexString:@"#7474FF"] forState:UIControlStateNormal];
    detailBtn.frame = CGRectMake(CGRectGetMaxX(iconBtn.frame) + 10, CGRectGetMaxY(titleBtn.frame)+3, headerView.frame.size.width - iconBtn.frame.size.width - 90, detailBtn.titleLabel.font.lineHeight);
    
    //
    UIImageView *markImageView = [[UIImageView alloc] init];
    markImageView.frame = CGRectMake(CGRectGetMaxX(iconBtn.frame) + 10, detailBtn.bottom + 3, 70, 70/3.7);
    markImageView.hidden = YES;
    [headerView addSubview:markImageView];

    NSString *var_productIdentifier = @"";
    NSInteger var_expireTime = 0;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([HTCommonConfiguration lgjeropj_shared].BLOCK_vipBlock()) {
        if ([result.var_familyPlanState isEqualToString:@"1"]) {
            if ([result.var_renewStatus isEqualToString:@"1"]) {
                var_productIdentifier = result.var_pid;
            } else if ([result.var_vipEndTime longLongValue] > 0) {
                var_expireTime = [result.var_vipEndTime longLongValue];
            }
        } else if ([result.var_bindPlanState isEqualToString:@"1"]) {
            if ([result.var_bindRenewStatus isEqualToString:@"1"]) {
                var_productIdentifier = result.var_bindPid;
            } else if ([result.var_bindEndTime longLongValue] > 0) {
                var_expireTime = [result.var_bindEndTime longLongValue];
            }
        } else if ([userDefaults boolForKey:@"udf_isDeviceVip"]) {
            var_productIdentifier = [userDefaults objectForKey:@"udf_devicePid"];
        } else if ([userDefaults boolForKey:@"udf_isLocalIapVip"]) {
            if ([userDefaults boolForKey:@"udf_iap_sub"] == YES) {
                var_productIdentifier = [userDefaults objectForKey:@"udf_productIdentifier"];
            } else if ([userDefaults integerForKey:@"udf_iap_expireTime"] > 0) {
                var_expireTime = [userDefaults integerForKey:@"udf_iap_expireTime"];
            }
        }
    }
    
    NSString *detailStr = @"";
    if (var_expireTime > 0) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:var_expireTime];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:AsciiString(@"MMM d, yyyy")];
        NSString *dateString = [formatter stringFromDate:date];
        detailStr = [NSString stringWithFormat:@"%@ %@", LocalString(@"Cancels on", nil), dateString];
    } else {
        if ([var_productIdentifier containsString:AsciiString(@"week")]) {
            detailStr = LocalString(@"Weekly", nil);
        } else if ([var_productIdentifier containsString:AsciiString(@"month")]) {
            detailStr = LocalString(@"Monthly", nil);
        } else if ([var_productIdentifier containsString:AsciiString(@"year")]) {
            detailStr = LocalString(@"Annually", nil);
        } else {
            detailStr = LocalString(@"Free", nil);
        }
    }
    
    if([HTCommonConfiguration lgjeropj_shared].BLOCK_vipBlock()){
        markImageView.hidden = NO;
        if([var_productIdentifier containsString:AsciiString(@"family")]){
            [markImageView sd_setImageWithURL:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:266]];
        } else {
            [markImageView sd_setImageWithURL:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:245]];
        }
    }
    
    
    [detailBtn setTitle:detailStr forState:UIControlStateNormal];
    [headerView addSubview:detailBtn];
    
    return view;
}

- (void)lgjeropj_didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UIViewController *vc = [[NSClassFromString(@"HTHistoryViewController") alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [[self.controller navigationController] pushViewController:vc animated:YES];
    }
}

- (void)lgjeropj_feedbackBtnAction {
    HTFeedbackViewController *feedVC = [[HTFeedbackViewController alloc] init];
    feedVC.title = LocalString(@"Feedback", nil);
    feedVC.hidesBottomBarWhenPushed = YES;
    [[self.controller navigationController] pushViewController:feedVC animated:YES];
}

- (void)lgjeropj_setBtnAction {
    ZQSetupListController *controller = [[ZQSetupListController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [[self.controller navigationController] pushViewController:controller animated:YES];
}

- (void)lgjeropj_leftNavigationBarAction {
    NSString *var_shareText = [[NSUserDefaults standardUserDefaults] stringForKey:@"udf_shareText"];
    NSString *var_shareLink = [[NSUserDefaults standardUserDefaults] stringForKey:@"udf_shareLink"];
    NSString *var_textToShare = var_shareText ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:AsciiString(@"CFBundleDisplayName")];
    UIImage *var_imageToShare = [UIImage imageNamed:@"icon_momtype_default"];
    NSURL *var_urlToShare = [NSURL URLWithString:var_shareLink];
    NSArray *var_activityItems = @[var_textToShare, var_urlToShare];
    if (var_imageToShare) {
        var_activityItems = @[var_textToShare,var_imageToShare, var_urlToShare];
    }
        
    UIActivityViewController *var_activityVC = [[UIActivityViewController alloc] initWithActivityItems:var_activityItems applicationActivities:nil];
    
    if (isPad) {
        var_activityVC.popoverPresentationController.sourceView = [self.controller view];
        var_activityVC.popoverPresentationController.sourceRect = [self.controller view].frame;
        var_activityVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    }
        
    [self.controller presentViewController:var_activityVC animated:YES completion:nil];
}

#pragma mark- 埋点
- (void)lgjeropj_maidianSelfpageShow {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"page_type"];
    [params setObject:([[NSUserDefaults standardUserDefaults] boolForKey:@"udf_notiAuth"] ? @"1":@"0") forKey:@"notification"];
    [params setObject:@"selfpage_sh_new" forKey:@"pointname"];
    [HTLoginPointManager lgjeropj_maidianRequestWithParams:params];
}

- (void)lgjeropj_maidianVipClick:(NSString *)var_kidStr {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:var_kidStr forKey:AsciiString(@"kid")];
    [params setObject:@"library_cl" forKey:@"pointname"];
    [HTLoginPointManager lgjeropj_maidianRequestWithParams:params];
}

- (void)lgjeropj_clickEventReportWithKid:(NSString *)var_kidStr {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[[ZQAccountTools sharedInstance] lgjeropj_islogin]?@"1":@"2" forKey:@"logstatus"];
    [params setObject:var_kidStr forKey:AsciiString(@"kid")];
    [params setObject:@"selfpage_cl_new" forKey:@"pointname"];
    [HTLoginPointManager lgjeropj_maidianRequestWithParams:params];
}

@end
