//
//  HTFamilyViewController.m
//  Merriciya
//
//  Created by 昊天 on 2023/5/29.
//

#import "HTFamilyViewController.h"
#import "HTHttpRequest.h"
#import "MJRefresh.h"
#import "ZQAccountTools.h"

@interface HTFamilyViewController ()<UITableViewDataSource,UITableViewDelegate,HTFamilyTableCellClickDelegate>

@end

@implementation HTFamilyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = LocalString(@"Family Account", nil);
    [self ht_setupUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.var_tableView.mj_header beginRefreshing];
}
- (void)ht_setupUI {
    self.var_bottomView = [[UIView alloc] init];
    [self.view addSubview:self.var_bottomView];
    [self.var_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(100);
    }];
    [self ht_setupBottomView];
    
    self.var_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.var_tableView];
    [self.var_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.var_bottomView.mas_top).mas_offset(0);
    }];
    self.var_tableView.delegate = self;
    self.var_tableView.dataSource = self;
    self.var_tableView.backgroundColor = [UIColor clearColor];
    self.var_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.var_tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.var_tableView registerClass:[HTFamilyTableViewCell class] forCellReuseIdentifier:@"CELLString_HTFamilyTableViewCell"];
    [self ht_configRefreshUI];
}
- (void)ht_setupNavigation {
    ZQAccountModel *result = [[ZQAccountTools sharedInstance] lgjeropj_getAccountData];
    if (result.var_identity.intValue == 1 && result.var_bindPlanState.intValue == 0) {
        UIButton *var_dissolveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [var_dissolveButton addTarget:self action:@selector(ht_dissolveFamilyGroupAction:) forControlEvents:UIControlEventTouchUpInside];
        [var_dissolveButton sd_setImageWithURL:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:26] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:var_dissolveButton];
    }else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}
- (void)ht_setupBottomView {
    [self.var_bottomView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ht_familyQuestionAction:)]];
    
    UILabel *var_whatButton = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    [self.var_bottomView addSubview:var_whatButton];
    var_whatButton.textColor = [UIColor grayColor];
    var_whatButton.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *whatAttString = [[NSMutableAttributedString alloc] initWithString:LocalString(@"What is a family package?", nil)];
    [whatAttString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, whatAttString.string.length)];
    var_whatButton.attributedText = whatAttString;
    
    UILabel *var_upgradeButton = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 40)];
    [self.var_bottomView addSubview:var_upgradeButton];
    var_upgradeButton.textColor = [UIColor grayColor];
    var_upgradeButton.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *upgradeAttString = [[NSMutableAttributedString alloc] initWithString:LocalString(@"Upgrade to family package?", nil)];
    [upgradeAttString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, upgradeAttString.string.length)];
    var_upgradeButton.attributedText = upgradeAttString;
}
- (UIView *)ht_setupSectionView:(NSInteger)type {
    UIView *var_sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    
    UIButton *var_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [var_sectionView addSubview:var_button];
    [var_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(var_sectionView);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(kScreenWidth *0.75);
    }];
    var_button.backgroundColor = [UIColor whiteColor];
    [var_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    var_button.layer.masksToBounds = YES;
    var_button.layer.cornerRadius = 10.0;
    
    if (type == 0) {
        NSString *var_titleString = [NSString stringWithFormat:@"%@(%ld)",LocalString(@"Add family members", nil),self.var_remainNum];
        [var_button setTitle:var_titleString forState:UIControlStateNormal];
        [var_button addTarget:self action:@selector(ht_addMemberAction:) forControlEvents:UIControlEventTouchUpInside];
    }else if (type == 1) {
        [var_button setTitle:LocalString(@"Quit Family Plan", nil) forState:UIControlStateNormal];
        [var_button addTarget:self action:@selector(ht_quitFamilyAction:) forControlEvents:UIControlEventTouchUpInside];
    }else {
        [var_button setTitle:LocalString(@"Buy Family Plan", nil) forState:UIControlStateNormal];
        [var_button addTarget:self action:@selector(ht_buyFamilyAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return var_sectionView;
}
#pragma mark - table delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTFamilyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLString_HTFamilyTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    if (self.dataArray.count > 0) {
        cell.delegate = self;
        ZQFamilyAccountModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [cell lgjeropj_updateCellWithData:model andIndex:indexPath.row];
    }
    
    return cell;
}
- (void)ht_familyMemberCellClick:(NSInteger)index {
    BOOL var_master = [self ht_judgeUserIsMaster];
    if (var_master) {
        ZQFamilyAccountModel *model = [self.dataArray objectAtIndex:index];
        if (model.master.intValue != 1) {
            // 主账号删除子成员
            [self ht_deleteFamilyMember:model];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.dataArray.count > 0) {
        BOOL var_master = [self ht_judgeUserIsMaster];
        if (var_master) {
            if (![HTCommonConfiguration lgjeropj_shared].BLOCK_vipBlock()) {
                return 100;
            }else if (self.var_remainNum > 0) {
                return 100;
            }
        }else {
            return 100;
        }
    }
    
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *var_sectionView = [[UIView alloc] init];
    
    if (self.dataArray.count > 0) {
        BOOL var_master = [self ht_judgeUserIsMaster];
        if (var_master) {
            if (![HTCommonConfiguration lgjeropj_shared].BLOCK_vipBlock()) {
                var_sectionView = [self ht_setupSectionView:2];
            }else if (self.var_remainNum > 0) {
                var_sectionView = [self ht_setupSectionView:0];
            }
        }else {
            var_sectionView = [self ht_setupSectionView:1];
        }
    }
    
    return var_sectionView;
}
- (BOOL)ht_judgeUserIsMaster {
    BOOL var_master = NO;
    ZQAccountModel *result = [[ZQAccountTools sharedInstance] lgjeropj_getAccountData];
    for (ZQFamilyAccountModel *model in self.dataArray) {
        if (model.uid.intValue == result.var_userid.intValue && model.master.intValue == 1) {
            return YES;
        }
    }
    return var_master;
}
#pragma mark - Action
- (void)ht_addMemberAction:(UIButton *)sender {
    HTFamilyMemberViewController *controller = [[HTFamilyMemberViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)ht_quitFamilyAction:(UIButton *)sender {
    ZQFamilyAccountModel *userModel = nil;
    ZQAccountModel *result = [[ZQAccountTools sharedInstance] lgjeropj_getAccountData];
    for (ZQFamilyAccountModel *model in self.dataArray) {
        if (model.uid.intValue == result.var_userid.intValue) {
            userModel = model;
            break;
        }
    }
    if (userModel) {
        [self ht_deleteFamilyMember:userModel];
    }
}
- (void)ht_buyFamilyAction:(UIButton *)sender {
    //前往订阅页
    [HTCommonConfiguration lgjeropj_shared].BLOCK_toPremiumBlock(19);
}

- (void)ht_familyQuestionAction:(UITapGestureRecognizer *)sender {
    HTFamilyQuestionViewController *controller = [[HTFamilyQuestionViewController alloc] init];
    controller.var_total = self.var_currentNum + self.var_remainNum;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)ht_deleteFamilyMember:(ZQFamilyAccountModel *)modelData {
    ZQAccountModel *result = [[ZQAccountTools sharedInstance] lgjeropj_getAccountData];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:modelData.mail forKey:AsciiString(@"mail")];
    [dict setObject:result.var_fid forKey:AsciiString(@"fid")];
    __weak __typeof(self)weakSelf = self;
    [SVProgressHUD show];
    [[HTHttpRequest sharedManager] ht_post:[NSString stringWithFormat:@"%d", 283] andParameters:dict andTrans:NO  andCompletion:^(id model, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        
        if (error == nil) {
            if ( [[model objectForKey:@"status"] integerValue] == 200 ) {
                [weakSelf.dataArray removeObject:modelData];
                weakSelf.var_remainNum = [[model objectForKey:AsciiString(@"remain")] integerValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.var_tableView reloadData];
                });
            }
            // 订阅验证
            [HTCommonConfiguration lgjeropj_shared].BLOCK_subscribeVerifyBlock();
            if ([model objectForKey:@"msg"] && [[model objectForKey:@"msg"] isKindOfClass:[NSString class]] && [[model objectForKey:@"msg"] length] > 0)
            {
                [SVProgressHUD showInfoWithStatus:[model objectForKey:@"msg"]];
            } else {
                [SVProgressHUD dismiss];
            }
        } else {
            [SVProgressHUD showInfoWithStatus:LocalString(@"Time out, server is not responding.", nil)];
        }
    }];
}

- (void)ht_dissolveFamilyGroupAction:(UIButton *)sender {
    UIAlertController *var_alertController = [UIAlertController alertControllerWithTitle:LocalString(@"Are you sure you want to delete this family account?", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *var_okAction = [UIAlertAction actionWithTitle:LocalString(@"Delete", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self lgjeropj_deleteFamilyAction];
    }];
    [var_alertController addAction:var_okAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LocalString(@"Cancel", nil) style:UIAlertActionStyleDefault handler:nil];
    [var_alertController addAction:cancelAction];

    UIPopoverPresentationController *popover = var_alertController.popoverPresentationController;
    if (popover){
        popover.sourceView = self.view;
        popover.sourceRect = CGRectMake(kScreenWidth *0.5 - 100, kScreenHeight, 200, 250);
        popover.permittedArrowDirections = UIPopoverArrowDirectionDown;
    }
    [self presentViewController:var_alertController animated:YES completion:nil];
}

- (void)lgjeropj_deleteFamilyAction
{
    ZQAccountModel *result = [[ZQAccountTools sharedInstance] lgjeropj_getAccountData];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:result.var_userid forKey:AsciiString(@"uid")];
    [dict setObject:result.var_fid forKey:AsciiString(@"fid")];

    [SVProgressHUD show];
    [[HTHttpRequest sharedManager] ht_post:[NSString stringWithFormat:@"%d", 327] andParameters:dict andTrans:NO andCompletion:^(id model, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        
        if (error == nil) {
            if ([[model objectForKey:@"status"] integerValue] == 200 ) {
                // 置空用户数据
                result.var_identity = @"0";
                result.var_fid = @"0";
                result.var_familyPlanState = @"0";
                [[ZQAccountTools sharedInstance] lgjeropj_saveOrUpDataAccount:result];
                //验证
                [HTCommonConfiguration lgjeropj_shared].BLOCK_subscribeVerifyBlock();
                [SVProgressHUD showInfoWithStatus:LocalString(@"You have left the family, you can continue to purchase an individual/family plan", nil)];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } else {
            [SVProgressHUD showInfoWithStatus:LocalString(@"Time out, server is not responding.", nil)];
        }
    }];
}

#pragma mark - data
- (void)ht_configRefreshUI {
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的refreshView方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(ht_loadData)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleMedium;
    self.var_tableView.mj_header = header;
}

- (void)ht_loadData {
    __weak __typeof(self)weakSelf = self;
    ZQAccountModel *result = [[ZQAccountTools sharedInstance] lgjeropj_getAccountData];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:result.var_userid forKey:AsciiString(@"uid")];
    [dict setObject:result.var_fid forKey:AsciiString(@"fid")];
    
    [[HTHttpRequest sharedManager] ht_post:[NSString stringWithFormat:@"%d", 284] andParameters:dict andTrans:NO andCompletion:^(id model, NSError * _Nonnull error) {
        
        if (error == nil) {
            if ([[model objectForKey:@"status"] integerValue] == 200 ) {
                [weakSelf.dataArray removeAllObjects];
                NSArray *dataArr = model[@"data"];
                if (dataArr.count > 0) {
                    NSArray *tmpArr = [NSArray yy_modelArrayWithClass:ZQFamilyAccountModel.class json:dataArr];
                    [weakSelf.dataArray addObjectsFromArray:tmpArr];

                    weakSelf.var_currentNum = [[model objectForKey:AsciiString(@"cur_cnts")] integerValue];
                    weakSelf.var_remainNum = [[model objectForKey:AsciiString(@"remain")] integerValue];
                }
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.var_tableView reloadData];
            });
            [weakSelf.var_tableView.mj_header endRefreshing];
        } else {
            [weakSelf.var_tableView.mj_header endRefreshing];
        }
    }];
}
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}
@end
