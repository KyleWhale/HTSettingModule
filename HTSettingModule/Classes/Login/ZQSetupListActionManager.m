//
//  ZQSetupListActionManager.m
//  Moshfocus
//
//  Created by 李雪健 on 2022/9/9.
//

#import "ZQSetupListActionManager.h"
#import <SDWebImage/SDImageCache.h>
#import "HTAboutViewController.h"
#import "HTFileManager.h"

@implementation ZQSetupListActionManager

- (void)lgjeropj_clearCachesAction {
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    NSString *var_mstutitlesPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:AsciiString(@"Subtitles")];
    if ([HTFileManager ht_fileExistsAtPath:var_mstutitlesPath]) {
        [HTFileManager ht_removeItemAtPath:var_mstutitlesPath];
    }
    [SVProgressHUD showInfoWithStatus:LocalString(@"Clear Success", nil)];
}

- (void)lgjeropj_aboutAction {
    HTAboutViewController *vc = [[HTAboutViewController alloc] init];
    vc.title = LocalString(@"About", nil);
    [[self.var_controller navigationController] pushViewController:vc animated:YES];
}

@end
