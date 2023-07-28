//
//  ZQSettingViewController.m
 
//  Created by admin on 2019/9/30.
//  Copyright © 2019年 admin. All rights reserved.
//

#import "ZQSettingViewController.h"
#import "ZQSettingHeaderView.h"
#import "ZQSetupListCell.h"
#import "ZQSettingControllerManager.h"
#import "HTWebViewController.h"
#import "ZQAccountTools.h"

@interface ZQSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) ZQSettingHeaderView *navHeaderView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ZQSettingControllerManager *settingViewModel;

@end

@implementation ZQSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#232331"];
    [self.view addSubview:self.navHeaderView];
    [self.view addSubview:self.tableView];
    
    [self.navHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kStatusHeight + 44);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navHeaderView.mas_bottom).offset(0);
        make.left.right.bottom.mas_equalTo(0);
    }];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lgjeropj_updateUI) name:@"NTFCTString_UpdateVIPStatusAndProductsInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lgjeropj_updateUI) name:@"NTFCTString_UpdateUserDisplayInformation" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self lgjeropj_updateUI];
    //埋点
    [self.settingViewModel lgjeropj_maidianSelfpageShow];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NTFCTString_MyMusicReddotStatusChange" object:@(NO)];
}

- (void)lgjeropj_updateUI {
    [self.dataArray removeAllObjects];
    self.dataArray = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark- TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if ([[ZQAccountTools sharedInstance] lgjeropj_islogin]) {
            return 150;
        } else {
            return 190;
        }
    }
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return [[UIView alloc] init];
    }
    
    if (![[ZQAccountTools sharedInstance] lgjeropj_islogin]) {
        return [self.settingViewModel lgjeropj_signViewWithTarget:self andAction:@selector(lgjeropj_loginButtonClick)];
    }
    return [self.settingViewModel lgjeropj_loginViewWithTarget:self andAction:@selector(lgjeropj_jumpToUserinfoPage)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZQSetupListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZQSetupListCell class]) forIndexPath:indexPath];
    NSString *var_titleStr = [self.dataArray objectAtIndex:indexPath.section];
    if (indexPath.section == 0) {
        [cell ht_updateCellWithData:@{var_titleStr:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:101]}];
    } else if (indexPath.section == 1) {
        [cell ht_updateCellWithData:@{var_titleStr:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:196]}];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.settingViewModel lgjeropj_didSelectRowAtIndexPath:indexPath];
}

- (void)lgjeropj_loginButtonClick {
    HTWebViewController *vc = [[HTWebViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.source = @"14";
    [self.navigationController pushViewController:vc animated:YES];
    
    // 埋点
    [self.settingViewModel lgjeropj_clickEventReportWithKid:@"1"];
    [self.settingViewModel lgjeropj_maidianVipClick:@"11"];
}

- (void)lgjeropj_jumpToUserinfoPage {
    HTWebViewController *vc = [[HTWebViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.source = @"14";
    [self.navigationController pushViewController:vc animated:YES];
    
    // 埋点
    [self.settingViewModel lgjeropj_clickEventReportWithKid:@"2"];
    [self.settingViewModel lgjeropj_maidianVipClick:@"12"];
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = @[LocalString(@"Recently Played", nil)].mutableCopy;
    }
    return _dataArray;
}

- (ZQSettingControllerManager *)settingViewModel {
    if (!_settingViewModel) {
        _settingViewModel = [[ZQSettingControllerManager alloc] init];
        _settingViewModel.controller = self;
    }
    return _settingViewModel;
}

- (ZQSettingHeaderView *)navHeaderView {
    if (!_navHeaderView) {
        _navHeaderView = [[ZQSettingHeaderView alloc] init];
        if ([HTCommonConfiguration lgjeropj_shared].BLOCK_switchStateBlock() == NO) {
            _navHeaderView.var_shareBtn.hidden = YES;
            _navHeaderView.var_feedbackBtn.hidden = YES;
        }
        [_navHeaderView.var_shareBtn addTarget:self.settingViewModel action:@selector(lgjeropj_leftNavigationBarAction) forControlEvents:UIControlEventTouchUpInside];
        [_navHeaderView.var_feedbackBtn addTarget:self.settingViewModel action:@selector(lgjeropj_feedbackBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_navHeaderView.var_setupBtn addTarget:self.settingViewModel action:@selector(lgjeropj_setBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navHeaderView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#232331"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ZQSetupListCell class] forCellReuseIdentifier:NSStringFromClass([ZQSetupListCell class])];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
