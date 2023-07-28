//
//  ZQSettingHeaderView.m
 
//
//  Created by admin on 2022/3/3.
//

#import "ZQSettingHeaderView.h"

@interface ZQSettingHeaderView ()

@property (nonatomic, strong) UIImageView *var_bgImageV;

@end

@implementation ZQSettingHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self lgjeropj_addCellSubViews];
    }
    return self;
}

- (void)lgjeropj_addCellSubViews {
    [self addSubview:self.var_bgImageV];
    [self addSubview:self.var_shareBtn];
    [self addSubview:self.var_setupBtn];
    [self addSubview:self.var_feedbackBtn];
}

- (void)updateConstraints{
    [super updateConstraints];
    [self.var_bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.var_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusHeight+10);
        make.size.mas_equalTo(24);
        make.left.mas_equalTo(kWidthScale(16));
    }];
    
    [self.var_setupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.var_shareBtn);
        make.size.mas_equalTo(24);
        make.right.mas_equalTo(-kWidthScale(16));
    }];
    
    [self.var_feedbackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.var_shareBtn);
        make.size.mas_equalTo(24);
        make.right.equalTo(self.var_setupBtn.mas_left).offset(-24);
    }];
}

- (UIImageView *)var_bgImageV {
    if (!_var_bgImageV) {
        _var_bgImageV = [[UIImageView alloc] init];
        [_var_bgImageV sd_setImageWithURL:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:244]];
    }
    return _var_bgImageV;
}

- (UIButton *)var_shareBtn {
    if (!_var_shareBtn) {
        _var_shareBtn = [[UIButton alloc] init];
        [_var_shareBtn sd_setImageWithURL:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:105] forState:UIControlStateNormal];
    }
    return _var_shareBtn;
}

- (UIButton *)var_setupBtn {
    if (!_var_setupBtn) {
        _var_setupBtn = [[UIButton alloc] init];
        [_var_setupBtn sd_setImageWithURL:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:104] forState:UIControlStateNormal];
    }
    return _var_setupBtn;
}

- (UIButton *)var_feedbackBtn {
    if (!_var_feedbackBtn) {
        _var_feedbackBtn = [[UIButton alloc] init];
        [_var_feedbackBtn sd_setImageWithURL:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:100] forState:UIControlStateNormal];
    }
    return _var_feedbackBtn;
}

@end
