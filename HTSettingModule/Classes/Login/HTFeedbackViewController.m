//
//  HTFeedbackViewController.m
 
//
//  Created by admin on 2019/9/30.
//  Copyright © 2019年 admin. All rights reserved.
//

#import "HTFeedbackViewController.h"
#import "HTHttpRequest.h"

@interface HTFeedbackViewController () <UITextViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *feedbackView;
@property (nonatomic, strong) UITextView *feedbackTextView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UIView *emailView;
@property (nonatomic, strong) UITextView *emailTextView;
@property (nonatomic, strong) UILabel *emailplaceholderLabel;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UIImageView *tBackImgView;
@property (nonatomic, strong) UILabel *emailTitleLabel;
@property (nonatomic, strong) UILabel *contentTitleLabel;

@end

@implementation HTFeedbackViewController

- (void)updateViewConstraints{
    [super updateViewConstraints];
    [self.feedbackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(10);
        make.height.mas_equalTo(180 + 20);
    }];
    
    [self.contentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.feedbackView);
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(20);
    }];
    
    [self.feedbackTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentTitleLabel.mas_bottom).offset(5);
        make.left.equalTo(self.feedbackView).offset(10);
        make.bottom.and.right.equalTo(self.feedbackView).offset(-20);
    }];
    
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.feedbackTextView.mas_top).offset(7);
        make.left.equalTo(self.feedbackTextView.mas_left).offset(5);
        make.right.equalTo(self.feedbackTextView.mas_right).offset(-5);
        make.height.mas_equalTo(50);
    }];
    
    [self.emailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.feedbackView.mas_bottom).offset(16);
        make.height.mas_equalTo(90 + 20);
    }];
    
    [self.emailTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.emailView);
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(20);
    }];
    
    [self.emailTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emailTitleLabel.mas_bottom).offset(5);
        make.left.equalTo(self.emailView).offset(10);
        make.bottom.and.right.equalTo(self.emailView).offset(-15);
    }];
    
    [self.emailplaceholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emailTextView.mas_top).offset(7);
        make.left.equalTo(self.emailTextView.mas_left).offset(5);
        make.right.equalTo(self.emailTextView.mas_right).offset(-5);
        make.height.mas_equalTo(50);
    }];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emailView.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(80);
        make.right.equalTo(self.view).offset(-80);
        make.height.mas_equalTo(50);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ht_addDefaultLeftItem];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#232331"];
    [self.view addSubview:self.feedbackView];
    [self.feedbackView addSubview:self.contentTitleLabel];
    [self.feedbackView addSubview:self.feedbackTextView];
    [self.feedbackTextView addSubview:self.placeholderLabel];
    [self.view addSubview:self.emailView];
    [self.emailView addSubview:self.emailTitleLabel];
    [self.emailView addSubview:self.emailTextView];
    [self.emailTextView addSubview:self.emailplaceholderLabel];
    [self.view addSubview:self.submitBtn];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)lgjeropj_submitClick:(UIButton *)sender {
    if (self.emailTextView.text.length <= 0 || self.feedbackTextView.text.length <= 0) {
        [SVProgressHUD showInfoWithStatus:(self.emailTextView.text.length <= 0 ? LocalString(@"Enter the email address", nil) : LocalString(@"Please describe your problems or suggestions here.", nil))];
        return;
    }

    [SVProgressHUD show];
    NSMutableDictionary *var_params = [NSMutableDictionary dictionary];
    [var_params setObject:self.emailTextView.text forKey:AsciiString(@"mail")];
    [var_params setObject:self.feedbackTextView.text forKey:AsciiString(@"content")];
    [var_params setObject:[NSNumber numberWithInteger:[HTCommonConfiguration lgjeropj_shared].BLOCK_switchStateBlock()] forKey:AsciiString(@"d_module")];
    __weak typeof(self) weakSelf = self;
    [[HTHttpRequest sharedManager] ht_post:[NSString stringWithFormat:@"%d", 5] andParameters:var_params andCompletion:^(id  _Nullable data, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        HTResponseModel *var_resposne = (HTResponseModel *)data;
        [SVProgressHUD showInfoWithStatus:var_resposne.msg];
        [weakSelf ht_leftItemClicked:nil];
    }];
}

///UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length <= 0) {
        if (textView.tag == 100001) {
            self.placeholderLabel.text = LocalString(@"Please describe your problems or suggestions here.", nil);
        } else if (textView.tag == 100002) {
            self.emailplaceholderLabel.text = LocalString(@"Please leave your e-mail address for us to better serve you", nil);
        }
    } else {
        if (textView.tag == 100001) {
            self.placeholderLabel.text = @"";
        } else if (textView.tag == 100002) {
            self.emailplaceholderLabel.text = @"";
        }
    }
}

- (UIView *)feedbackView {
    if (!_feedbackView) {
        _feedbackView = [[UIView alloc] init];
        _feedbackView.backgroundColor = [UIColor colorWithHexString:@"#29293A"];
    }
    return _feedbackView;
}

- (UILabel *)contentTitleLabel {
    if (!_contentTitleLabel) {
        _contentTitleLabel = [[UILabel alloc] init];
        _contentTitleLabel.textAlignment = NSTextAlignmentLeft;
        _contentTitleLabel.font = [UIFont boldSystemFontOfSize:16];
        _contentTitleLabel.textColor = [UIColor whiteColor];
        _contentTitleLabel.text = LocalString(@"Describe the problem", nil);
    }
    return _contentTitleLabel;
}

- (UITextView *)feedbackTextView {
    if (!_feedbackTextView) {
        _feedbackTextView = [[UITextView alloc] init];
        _feedbackTextView.backgroundColor = [UIColor clearColor];
        _feedbackTextView.delegate = self;
        _feedbackTextView.tag = 100001;
        _feedbackTextView.textColor = [UIColor whiteColor];
        _feedbackTextView.font = [UIFont systemFontOfSize:14];
    }
    return _feedbackTextView;
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.text = LocalString(@"Please describe your problems or suggestions here.", nil);
        _placeholderLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _placeholderLabel.enabled = NO;
        _placeholderLabel.font = [UIFont systemFontOfSize:14];
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.numberOfLines = 3;
        [_placeholderLabel sizeToFit];
    }
    return _placeholderLabel;
}

- (UIView *)emailView {
    if (!_emailView) {
        _emailView = [[UIView alloc] init];
        _emailView.backgroundColor = [UIColor colorWithHexString:@"#29293A"];
    }
    return _emailView;
}

- (UILabel *)emailTitleLabel {
    if (!_emailTitleLabel) {
        _emailTitleLabel = [[UILabel alloc] init];
        _emailTitleLabel.textAlignment = NSTextAlignmentLeft;
        _emailTitleLabel.font = [UIFont boldSystemFontOfSize:16];
        _emailTitleLabel.textColor = [UIColor whiteColor];
        _emailTitleLabel.text = LocalString(@"Email address", nil);
    }
    return _emailTitleLabel;
}

- (UITextView *)emailTextView {
    if (!_emailTextView) {
        _emailTextView = [[UITextView alloc] init];
        _emailTextView.backgroundColor = [UIColor clearColor];
        _emailTextView.delegate = self;
        _emailTextView.tag = 100002;
        _emailTextView.font = [UIFont systemFontOfSize:14];
        _emailTextView.textColor = [UIColor whiteColor];
    }
    return _emailTextView;
}

- (UILabel *)emailplaceholderLabel {
    if (!_emailplaceholderLabel) {
        _emailplaceholderLabel = [[UILabel alloc] init];
        _emailplaceholderLabel.text = LocalString(@"Please leave your e-mail address for us to better serve you", nil);
        _emailplaceholderLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _emailplaceholderLabel.enabled = NO;
        _emailplaceholderLabel.backgroundColor = [UIColor clearColor];
        _emailplaceholderLabel.numberOfLines = 3;
        _emailplaceholderLabel.font = [UIFont systemFontOfSize:14];
        [_emailplaceholderLabel sizeToFit];
    }
    return _emailplaceholderLabel;
}

- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn setTitle:LocalString(@"SUBMIT", nil) forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _submitBtn.backgroundColor = [UIColor colorWithHexString:@"#B82450"];
        _submitBtn.layer.cornerRadius = 10;
        _submitBtn.layer.masksToBounds = YES;
        [_submitBtn addTarget:self action:@selector(lgjeropj_submitClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

@end
