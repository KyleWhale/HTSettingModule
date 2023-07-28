//
//  HTAboutViewController.m
 
//
//  Created by admin on 2019/9/30.
//  Copyright © 2019年 admin. All rights reserved.
//

#import "HTAboutViewController.h"
#import "HTConfig.h"

@interface HTAboutViewController ()

@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel *versionLab;
@property (nonatomic, strong) UIButton *privacyBtn;

@end

@implementation HTAboutViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self ht_addDefaultLeftItem];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#232331"];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.versionLab];
    [self.view addSubview:self.privacyBtn];
}

- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_momtype_default"]];
        _headerView.contentMode = UIViewContentModeScaleAspectFill;
        _headerView.clipsToBounds = YES;
        _headerView.layer.masksToBounds = YES;
        _headerView.layer.cornerRadius = kScreenWidth/4;
    }
    return _headerView;
}

- (UILabel *)versionLab {
    if (!_versionLab) {
        _versionLab = [[UILabel alloc] init];
        _versionLab.textColor = [UIColor whiteColor];
        _versionLab.textAlignment = NSTextAlignmentCenter;
        _versionLab.numberOfLines = 0;
        _versionLab.font = [UIFont systemFontOfSize:15];
        _versionLab.text = [NSString stringWithFormat:@"%@\n%@%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:AsciiString(@"CFBundleDisplayName")], AsciiString(@"v"), [HTConfig ht_appVer]];
    }
    return _versionLab;
}

- (UIButton *)privacyBtn {
    if (!_privacyBtn) {
        _privacyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSDictionary *var_attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName,[UIColor colorWithHexString:@"#c4a248"],NSForegroundColorAttributeName,[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSUnderlineStyleAttributeName,nil];
        NSMutableAttributedString *var_attributedStr = [[NSMutableAttributedString alloc]initWithString:LocalString(@"Privacy Policy", nil) attributes:var_attributeDict];
        [_privacyBtn setAttributedTitle:var_attributedStr forState:UIControlStateNormal];
        _privacyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_privacyBtn addTarget:self action:@selector(lgjeropj_privacyPolicyClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _privacyBtn;
}

- (void)updateViewConstraints{
    [super updateViewConstraints];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(50);
        make.width.and.height.mas_equalTo(kScreenWidth/2);
    }];
    
    [self.versionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(0);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(50);
    }];
    
    [self.privacyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(60);
    }];
}

- (void)lgjeropj_privacyPolicyClick {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PrivacyPolicy] options:@{} completionHandler:^(BOOL success) {}];
}

@end
