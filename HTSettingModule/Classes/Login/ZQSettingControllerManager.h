//
//  ZQSettingControllerManager.h
//  Moshfocus
//
//  Created by 李雪健 on 2022/9/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BLOCK_SettingActionBlock)(void);

@interface ZQSettingControllerManager : NSObject

@property (nonatomic, weak) id controller;

- (UIView *)lgjeropj_signViewWithTarget:(id)target andAction:(SEL)action;
- (UIView *)lgjeropj_loginViewWithTarget:(id)target andAction:(SEL)action;
- (void)lgjeropj_didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)lgjeropj_feedbackBtnAction;
- (void)lgjeropj_setBtnAction;
- (void)lgjeropj_leftNavigationBarAction;

- (void)lgjeropj_maidianSelfpageShow;
- (void)lgjeropj_maidianVipClick:(NSString *)kidStr;
- (void)lgjeropj_clickEventReportWithKid:(NSString *)kidStr;

@end

NS_ASSUME_NONNULL_END
