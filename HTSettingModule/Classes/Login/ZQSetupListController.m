//
//  ZQSetupListController.m
 
//
//  Created by admin on 2022/3/3.
//

#import "ZQSetupListController.h"
#import "ZQSetupListCell.h"
#import "ZQSetupListActionManager.h"

@interface ZQSetupListController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *var_navView;
@property (nonatomic, strong) UILabel *var_titleLabel;
@property (nonatomic, strong) UIButton *var_leftBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZQSetupListActionManager *var_setupViewModel;

@end

@implementation ZQSetupListController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)updateViewConstraints{
    [super updateViewConstraints];
    
    [self.var_navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view).offset(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(kNavBarHeight);
    }];
    
    [self.var_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.var_navView).offset(kStatusHeight);
        make.left.equalTo(self.var_navView).offset(kWidthScale(15)+44);
        make.right.equalTo(self.var_navView).offset(-(kWidthScale(15)+44));
        make.height.mas_equalTo(44);
    }];
    
    [self.var_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.var_navView).offset(kStatusHeight + 4);
        make.left.equalTo(self.var_navView).offset(kWidthScale(15));
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(36);
    }];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.var_navView.mas_bottom);
        make.right.left.bottom.equalTo(self.view).offset(0);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#232331"];
    [self.view addSubview:self.var_navView];
    [self.var_navView addSubview:self.var_titleLabel];
    [self.var_navView addSubview:self.var_leftBtn];
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZQSetupListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZQSetupListCell class])];
    if (indexPath.section == 0) {
        [cell ht_updateCellWithData:@{LocalString(@"About", nil):[LKFPrivateFunction lgjeropj_imageUrlFromNumber:93]}];
    } else if (indexPath.section == 1) {
        [cell ht_updateCellWithData:@{LocalString(@"Clear Caches", nil):[LKFPrivateFunction lgjeropj_imageUrlFromNumber:94]}];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self.var_setupViewModel lgjeropj_aboutAction];
    } else if (indexPath.section == 1) {
        [self.var_setupViewModel lgjeropj_clearCachesAction];
    }
}


- (UIView *)var_navView {
    if (!_var_navView) {
        _var_navView = [[UIView alloc] init];
        _var_navView.backgroundColor = [UIColor gradient:_var_navView.frame.size direction:1 start:[UIColor colorWithHexString:@"#33335B"] end:[UIColor colorWithHexString:@"#232331"]];
    }
    return _var_navView;
}

- (UILabel *)var_titleLabel {
    if (!_var_titleLabel) {
        _var_titleLabel = [[UILabel alloc] init];
        _var_titleLabel.text = LocalString(@"Settings", nil);
        _var_titleLabel.textColor = [UIColor whiteColor];
        _var_titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _var_titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _var_titleLabel;
}

- (UIButton *)var_leftBtn {
    if (!_var_leftBtn) {
        _var_leftBtn = [[UIButton alloc] init];
        _var_leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_var_leftBtn setImage:[UIImage imageNamed:@"icon_wdback"] forState:UIControlStateNormal];
        [_var_leftBtn addTarget:self action:@selector(ht_leftItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _var_leftBtn;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = isPad ? 70 : 54;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ZQSetupListCell class] forCellReuseIdentifier:NSStringFromClass([ZQSetupListCell class])];
    }
    return _tableView;
}

- (ZQSetupListActionManager *)var_setupViewModel {
    if (!_var_setupViewModel) {
        _var_setupViewModel = [[ZQSetupListActionManager alloc] init];
        _var_setupViewModel.var_controller = self;
    }
    return _var_setupViewModel;
}

@end
