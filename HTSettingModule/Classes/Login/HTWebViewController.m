


#import "HTWebViewController.h"
#import <WebKit/WebKit.h>
#import "HTHttpRequest.h"
#import "HTLoginPointManager.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "ZQAccountTools.h"

@interface HTWebViewController ()<WKUIDelegate,WKNavigationDelegate, WKScriptMessageHandler, ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>

@property (nonatomic, copy) NSString *var_link;
@property (nonatomic, strong) WKWebView *var_webView;
@property (nonatomic, strong) UIProgressView *var_progressView;
@property (nonatomic, strong) UIView *var_noDataView;

@end

@implementation HTWebViewController

- (BOOL)ht_slideBackDisable {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[self.var_webView configuration].userContentController removeScriptMessageHandlerForName:AsciiString(@"iOS")];
    [self.var_webView.configuration.userContentController addScriptMessageHandler:self name:AsciiString(@"iOS")];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [HTCommonConfiguration lgjeropj_shared].BLOCK_stopAdBlock(NO);
    [SVProgressHUD dismiss];
    [[self.var_webView configuration].userContentController removeScriptMessageHandlerForName:AsciiString(@"iOS")];
}

- (void)dealloc {
    [self.var_webView removeObserver:self forKeyPath:AsciiString(@"title")];
    [self.var_webView removeObserver:self forKeyPath:AsciiString(@"estimatedProgress")];
}

- (void)viewDidLoad {
    [super viewDidLoad];    
    // 登录页不弹ad
    [HTCommonConfiguration lgjeropj_shared].BLOCK_stopAdBlock(YES);
    [SVProgressHUD show];
    self.var_link = [[NSUserDefaults standardUserDefaults] stringForKey:@"udf_login_h5"] ?: AsciiString(@"https://www.h5login.work/");
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[AsciiString(@"source")] = self.source;
    if([ZQAccountTools sharedInstance].lgjeropj_islogin){
        self.var_link = [self.var_link stringByAppendingString:AsciiString(@"user")];
        [params setObject:@"account_sh" forKey:@"pointname"];
    } else {
        params[AsciiString(@"type")] = @"2";
        [params setObject:@"signup_sh" forKey:@"pointname"];
    }
    [HTLoginPointManager lgjeropj_maidianRequestWithParams:params];
    [self lgjeropj_addSubView];
    [self lgjeropj_getUrl];
}

- (void)lgjeropj_addSubView {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#1A1C21"];
    
    [self.view addSubview:self.var_progressView];
    [self.var_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusHeight);
        make.height.mas_equalTo(1);
        make.left.right.mas_equalTo(0);
    }];
    
    [self.view addSubview:self.var_webView];
    [self.var_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.var_progressView.mas_bottom);
        make.width.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
    
    [self.view addSubview:self.var_noDataView];
}

- (void)lgjeropj_showNodataView {
    self.var_noDataView.hidden = NO;
}

- (void)lgjeropj_hidenNodataView {
    self.var_noDataView.hidden = YES;
}

- (UIView *)var_noDataView {
    if(!_var_noDataView) {
        _var_noDataView = [[UIView alloc] init];
        _var_noDataView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _var_noDataView.backgroundColor = [UIColor colorWithHexString:@"#111218"];
        _var_noDataView.hidden = YES;
        UIButton *var_setBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [var_setBtn setImage:[UIImage imageNamed:@"icon_wdback"] forState:UIControlStateNormal];
        var_setBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [var_setBtn setTintColor:[UIColor whiteColor]];
        [var_setBtn addTarget:self action:@selector(lgjeropj_backAction) forControlEvents:UIControlEventTouchUpInside];
        [_var_noDataView addSubview:var_setBtn];
        [var_setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kStatusHeight);
            make.left.mas_equalTo(20);
            make.size.mas_equalTo(40);
        }];
        
        UILabel *var_msgLable = [[UILabel alloc] init];
        var_msgLable.font = [UIFont systemFontOfSize:15];
        var_msgLable.textColor = [UIColor whiteColor];
        var_msgLable.textAlignment = NSTextAlignmentCenter;
        var_msgLable.numberOfLines = 0;
        var_msgLable.text = LocalString(@"Network error, retry", nil);
        [_var_noDataView addSubview:var_msgLable];
        [var_msgLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(CGPointMake(0, -60));
            make.left.mas_equalTo(60);
            make.right.mas_equalTo(-60);
        }];
        //
        UIButton *var_refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [var_refreshButton setTitle:LocalString(@"Refresh", nil) forState:UIControlStateNormal];
        var_refreshButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [var_refreshButton setTitleColor:[UIColor colorWithHexString:@"#3CDEF4"] forState:UIControlStateNormal];
        [var_refreshButton addTarget:self action:@selector(ht_refreshButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_var_noDataView addSubview:var_refreshButton];
        var_refreshButton.layer.cornerRadius = 4;
        var_refreshButton.layer.masksToBounds = YES;
        var_refreshButton.layer.borderWidth = 1;
        var_refreshButton.layer.borderColor = [[UIColor colorWithHexString:@"#3CDEF4"] CGColor];
        [var_refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(var_msgLable.mas_bottom).offset(40);
            make.size.mas_equalTo(CGSizeMake(75, 40));
            make.centerX.mas_equalTo(0);
        }];
    }
    return _var_noDataView;
}

- (void)ht_refreshButtonAction {
    [self lgjeropj_getUrl];
}

- (UIProgressView *)var_progressView {
    if(!_var_progressView) {
        _var_progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 2)];
        _var_progressView.progressTintColor = [UIColor colorWithHexString:@"#3CDEF4"];
        _var_progressView.trackTintColor = [UIColor clearColor];
        _var_progressView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    }
    return _var_progressView;
}

- (WKWebView *)var_webView {
    if(!_var_webView) {
        WKWebViewConfiguration *var_configuration = [[WKWebViewConfiguration alloc] init];
        var_configuration.preferences.javaScriptEnabled = YES;
        _var_webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, 0,0) configuration:var_configuration];
        _var_webView.navigationDelegate = self;
        _var_webView.UIDelegate = self;
        _var_webView.backgroundColor = [UIColor clearColor];
        _var_webView.opaque = NO;
        _var_webView.scrollView.bounces = NO;
        _var_webView.scrollView.showsHorizontalScrollIndicator = NO;
        _var_webView.scrollView.showsVerticalScrollIndicator = NO;
        _var_webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [_var_webView.configuration.userContentController addScriptMessageHandler:self name:AsciiString(@"iOS")];
        NSKeyValueObservingOptions var_options = NSKeyValueObservingOptionNew;
        [_var_webView addObserver:self forKeyPath:AsciiString(@"title") options:var_options context:nil];
        [_var_webView addObserver:self forKeyPath:AsciiString(@"estimatedProgress") options:var_options context:nil];
    }
    return _var_webView;
}

//get请求
- (void)lgjeropj_getUrl {
    NSDictionary *var_commonDict = [[HTHttpRequest sharedManager] lgjeropj_apiPublicParams];
    NSMutableDictionary *var_parmaDict = [NSMutableDictionary dictionaryWithDictionary:var_commonDict];
    if([var_parmaDict.allKeys containsObject:AsciiString(@"version")]) {
        [var_parmaDict removeObjectForKey:AsciiString(@"version")];
    }
    //0:默认样式(带返回按钮,不带文案) | 1:强制登录(不带返回按钮,文案:Login to Begin Your Premium Journey)  | 2:非强制登录(带返回按钮,文案:Login for Premium Status).web根据该字段改变样式
    [var_parmaDict setObject:self.var_force ?: @"0" forKey:AsciiString(@"force")];
    NSString *var_params = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:var_parmaDict options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    NSString *var_webUrlString = [NSString stringWithFormat:@"%@?%@%@",self.var_link, AsciiString(@"param="), var_params];
    var_webUrlString = [var_webUrlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *var_link = [[NSURL alloc] initWithString:var_webUrlString];
    NSURLRequest *var_request = [NSURLRequest requestWithURL:var_link];
    [self.var_webView loadRequest:var_request];
}

//监听
- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void*)context {
    if([keyPath isEqualToString:AsciiString(@"estimatedProgress")]) {
        self.var_progressView.progress = self.var_webView.estimatedProgress;
        if(self.var_progressView.progress == 1) {
            __weak typeof(self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.var_progressView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            } completion:^(BOOL finished) {
                weakSelf.var_progressView.hidden = YES;
            }];
        }
    }  else if ([keyPath isEqualToString:AsciiString(@"title")]) {
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)lgjeropj_backAction {
    [self lgjeropj_quitWebpage];
}

- (void)lgjeropj_quitWebpage {
    [self.navigationController popViewControllerAnimated:YES];
}

//禁止左右弹动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    scrollView.contentOffset = CGPointMake((scrollView.contentSize.width - kScreenWidth) / 2, scrollView.contentOffset.y);
}

//页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.var_progressView.hidden = NO;
    self.var_progressView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    [self.view bringSubviewToFront:self.var_progressView];
}

//页面加载完毕
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.var_progressView.hidden = YES;
    [self lgjeropj_hidenNodataView];
    [SVProgressHUD dismiss];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if(error) {
        [self lgjeropj_showNodataView];
    }
    [SVProgressHUD dismiss];
}

//页面加载失败
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.var_progressView.hidden = YES;
}

#pragma mark --WKScriptMessageHandler-监听来自web端发过来的消息
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([message.name isEqualToString:AsciiString(@"iOS")]) {
        NSString *var_jsonString = message.body;
        NSDictionary *var_dict = [NSJSONSerialization JSONObjectWithData:[var_jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if([var_dict.allKeys containsObject:AsciiString(@"loginType")]) {
            NSInteger var_tag = [var_dict[AsciiString(@"loginType")] intValue];
            [self lgjeropj_webTellLogic:var_tag andDict:var_dict];
        }
    }
}

//具体的业务
- (void)lgjeropj_webTellLogic:(NSInteger)var_tag andDict:(NSDictionary *)var_dict {
    switch (var_tag) {
        case 1: {
            //谷歌登录
            [self lgjeropj_loginByGoogle];
            [self lgjeropj_htMethodClickMaidian:@"7" andType:@"2" andResult:@"0"];
            break;
        }
        case 2: {
            //facebook登录
            [self lgjeropj_loginByFacebook];
            [self lgjeropj_htMethodClickMaidian:@"8" andType:@"2" andResult:@"0"];
            break;
        }
        case 3: {
            //苹果登录
            [self lgjeropj_appleLogin];
            [self lgjeropj_htMethodClickMaidian:@"15" andType:@"2" andResult:@"0"];
            break;
        }
        case 5: {
            //登录注册完毕
            [self lgjeropj_saveUserDataWithDict:var_dict];
            //埋点
            NSString *var_type = [NSString stringWithFormat:@"%@", var_dict[AsciiString(@"type")]];
            NSString *var_source = [NSString stringWithFormat:@"%@", var_dict[AsciiString(@"source")]];
            if (var_source.integerValue == 1) {
                [self lgjeropj_htMethodClickMaidian:@"11" andType:var_type andResult:@"1"];
            } else if (var_source.integerValue == 2) {
                [self lgjeropj_htMethodClickMaidian:@"12" andType:var_type andResult:@"1"];
            } else if (var_source.integerValue == 3) {
                [self lgjeropj_htMethodResultMaidian:@"3"];
            } else if (var_source.integerValue == 4) {
                [self lgjeropj_htMethodResultMaidian:@"2"];
            } else if (var_source.integerValue == 5) {
                [self lgjeropj_htMethodResultMaidian:@"1"];
            }
            break;
        }
        case 6: {
            //获取用户信息完毕
            [self lgjeropj_saveUserDataWithDict:var_dict];
            [HTCommonConfiguration lgjeropj_shared].BLOCK_subscribeVerifyBlock();
            [self lgjeropj_quitWebpage];
            break;
        }
        case 9: {
            //退出登录
            NSMutableDictionary *var_params = [[NSMutableDictionary alloc] init];
            [var_params setObject:@"account_cl" forKey:@"pointname"];
            [var_params setObject:@"6" forKey:@"kid"];
            [HTLoginPointManager lgjeropj_maidianRequestWithParams:var_params];
            [HTCommonConfiguration lgjeropj_shared].BLOCK_toLogoutBlock();
            [HTCommonConfiguration lgjeropj_shared].BLOCK_subscribeVerifyBlock();
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NTFCTString_UpdateUserDisplayInformation" object:nil];
            [self lgjeropj_quitWebpage];
            break;
        }
        case 10: {
            //更新了用户信息
            [self lgjeropj_saveUserDataWithDict:var_dict];
            [self lgjeropj_quitWebpage];
            break;
        }
        case 12: {
            //放弃修改用户信息,点击弹窗里的cancel或者没有信息变更的情况下触发
            [self lgjeropj_quitWebpage];
            break;
        }
        case 13: {
            //打开terms of service
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:TermService] options:@{} completionHandler:nil];
            break;
        }
        case 14: {
            //打开privacy policy
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PrivacyPolicy] options:@{} completionHandler:nil];
            break;
        }
        case 16: {
            //关闭web,返回原生页面
            [self lgjeropj_quitWebpage];
            [self lgjeropj_htMethodClickMaidian:@"1" andType:@"0" andResult:@"0"];
            break;
        }
        case 17: {
            NSString *var_type = [NSString stringWithFormat:@"%@", var_dict[AsciiString(@"type")]];
            NSString *var_source = [NSString stringWithFormat:@"%@", var_dict[AsciiString(@"source")]];
            if (var_source.integerValue == 1) {
                [self lgjeropj_htMethodClickMaidian:@"11" andType:var_type andResult:@"0"];
            } else if (var_source.integerValue == 2) {
                [self lgjeropj_htMethodClickMaidian:@"12" andType:var_type andResult:@"0"];
            }
        }
        default:
            break;
    }
}

//谷歌登录
- (void)lgjeropj_loginByGoogle {
    [GIDSignIn.sharedInstance signInWithPresentingViewController:self completion:^(GIDSignInResult *signInResult, NSError *error) {
        if (error) {
            NSMutableDictionary *var_dict = [NSMutableDictionary dictionary];
            [var_dict setObject:@"7" forKey:AsciiString(@"loginType")];
            [var_dict setObject:AsciiString(@"Failed") forKey:AsciiString(@"msg")];
            [var_dict setObject:[NSString stringWithFormat:@"%ld-%@", (long)error.code,error.localizedDescription] forKey:AsciiString(@"msgDetails")];
            [self lgjeropj_jsInsertWithJsonString:[var_dict yy_modelToJSONString]];
        }else{
            NSString *tp_face = @"";
            if(signInResult.user.profile.hasImage){
                tp_face = [signInResult.user.profile imageURLWithDimension:120].absoluteString;
            }
            NSMutableDictionary *var_params = [[NSMutableDictionary alloc] init];
            [var_params setObject:@"2" forKey:AsciiString(@"type")];
            [var_params setObject:@"1" forKey:AsciiString(@"thridparty_g")];
            [var_params setObject:[NSString stringWithFormat:@"%@", signInResult.user.profile.email] forKey:AsciiString(@"email")];
            [var_params setObject:tp_face forKey:AsciiString(@"tp_face")];
            [var_params setObject:[NSString stringWithFormat:@"%@", signInResult.user.userID] forKey:AsciiString(@"tp_tpid")];
            [var_params setObject:[NSString stringWithFormat:@"%@", signInResult.user.profile.name] forKey:AsciiString(@"tp_name")];
            [var_params setObject:@"1" forKey:AsciiString(@"loginType")];
            [self lgjeropj_jsInsertWithJsonString:[var_params yy_modelToJSONString]];
        }
    }];
}

//facebook登录
- (void)lgjeropj_loginByFacebook {
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logInWithPermissions:@[AsciiString(@"public_profile"), AsciiString(@"email")] fromViewController:self handler:^(FBSDKLoginManagerLoginResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSMutableDictionary *var_dict = [NSMutableDictionary new];
            [var_dict setObject:@"8" forKey:AsciiString(@"loginType")];
            [var_dict setObject:AsciiString(@"Failed") forKey:AsciiString(@"msg")];
            NSString *var_errorStr = [NSString stringWithFormat:@"%ld-%@",(long)error.code,error.localizedDescription];
            [var_dict setObject:var_errorStr forKey:AsciiString(@"msgDetails")];
            [self lgjeropj_jsInsertWithJsonString:[var_dict yy_modelToJSONString]];
            
        } else if (result.isCancelled) {
            NSMutableDictionary *var_dict = [NSMutableDictionary new];
            [var_dict setObject:@"8" forKey:AsciiString(@"loginType")];
            [var_dict setObject:AsciiString(@"Cancelled") forKey:AsciiString(@"msg")];
            [var_dict setObject:@"" forKey:AsciiString(@"msgDetails")];
            [self lgjeropj_jsInsertWithJsonString:[var_dict yy_modelToJSONString]];
        } else {
            FBSDKProfile *profile = FBSDKProfile.currentProfile;
            NSString *userId = result.token.userID;
            NSString *facebookToken =  result.token.tokenString;
            NSMutableDictionary *var_params = [[NSMutableDictionary alloc] init];
            [var_params setObject:@"2" forKey:AsciiString(@"type")];
            [var_params setObject:@"2" forKey:AsciiString(@"thridparty_g")];
            [var_params setObject:[NSString stringWithFormat:@"%@", profile.email] forKey:AsciiString(@"email")];
            [var_params setObject:[NSString stringWithFormat:@"%@", profile.imageURL.absoluteString] forKey:AsciiString(@"tp_face")];
            [var_params setObject:[NSString stringWithFormat:@"%@", userId] forKey:AsciiString(@"tp_tpid")];
            [var_params setObject:[NSString stringWithFormat:@"%@", profile.name] forKey:AsciiString(@"tp_name")];
            [var_params setObject:[NSString stringWithFormat:@"%@", facebookToken] forKey:AsciiString(@"identityToken")];
            [var_params setObject:@"2" forKey:AsciiString(@"loginType")];
            [self lgjeropj_jsInsertWithJsonString:[var_params yy_modelToJSONString]];
        }
    }];
}

#pragma mark - appleLogin
- (void)lgjeropj_appleLogin {
    if (@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDProvider *var_appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        ASAuthorizationAppleIDRequest *var_request = var_appleIDProvider.createRequest;
        var_request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        ASAuthorizationController *var_controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[var_request]];
        var_controller.delegate = self;
        var_controller.presentationContextProvider = self;
        [var_controller performRequests];
    }
}

//授权成功
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization  NS_SWIFT_NAME(authorizationController(controller:didCompleteWithAuthorization:)) API_AVAILABLE(ios(13.0)) {
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        ASAuthorizationAppleIDCredential *var_appleIDCredential = (ASAuthorizationAppleIDCredential *)authorization.credential;
        [self lgjeropj_actionLoginWithAppleData:var_appleIDCredential];
    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        ASPasswordCredential *var_passwordCredential = (ASPasswordCredential *)authorization.credential;
        [self lgjeropj_actionLoginWithAppleData:var_passwordCredential];
    }
}

//授权失败
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error  NS_SWIFT_NAME(authorizationController(controller:didCompleteWithError:)) API_AVAILABLE(ios(13.0)){
    NSMutableDictionary *var_params = [NSMutableDictionary new];
    [var_params setObject:@"4" forKey:AsciiString(@"loginType")];
    [var_params setObject:AsciiString(@"Authorization failed") forKey:AsciiString(@"msg")];
    NSString *var_errorStr = [NSString stringWithFormat:@"%ld-%@",(long)error.code,error.localizedDescription];
    [var_params setObject:var_errorStr forKey:AsciiString(@"msgDetails")];
    [self lgjeropj_jsInsertWithJsonString:[var_params yy_modelToJSONString]];
}

- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)){
    return [self lgjeropj_getKeyWindow];
}

- (UIWindow *)lgjeropj_getKeyWindow {
    UIWindow *var_window = nil;
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene *var_windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (var_windowScene.activationState == UISceneActivationStateForegroundActive) {
                var_window = var_windowScene.windows.firstObject;
                break;
            }
        }
    } else {
       var_window = [UIApplication sharedApplication].keyWindow;
    }
    return var_window;
}

- (void)lgjeropj_actionLoginWithAppleData:(id)data {
    NSMutableDictionary *var_dict = [NSMutableDictionary new];
    if (@available(iOS 13.0, *)) {
        if ([data isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
            ASAuthorizationAppleIDCredential *var_appleIDCredential = (ASAuthorizationAppleIDCredential *)data;
            [var_dict setObject:var_appleIDCredential.user forKey:AsciiString(@"tp_tpid")];//唯一标识
            [var_dict setObject:var_appleIDCredential.email?var_appleIDCredential.email:var_appleIDCredential.user forKey:AsciiString(@"email")];
            NSMutableString *var_mutableString = [NSMutableString string];
            [var_mutableString appendString:var_appleIDCredential.fullName.givenName?:@""];
            [var_mutableString appendString:var_appleIDCredential.fullName.middleName?:@""];
            [var_mutableString appendString:var_appleIDCredential.fullName.familyName?:@""];
            [var_dict setObject:var_mutableString forKey:AsciiString(@"tp_name")];
        } else if ([data isKindOfClass:[ASPasswordCredential class]]) {
            ASPasswordCredential *passwordCredential = (ASPasswordCredential *)data;
            [var_dict setObject:passwordCredential.user forKey:AsciiString(@"tp_tpid")];
            [var_dict setObject:passwordCredential.user forKey:AsciiString(@"email")];
            [var_dict setObject:@"" forKey:AsciiString(@"tp_name")];
        }
        [var_dict setObject:@"2" forKey:AsciiString(@"type")];
        [var_dict setObject:@"" forKey:AsciiString(@"tp_face")];
        [var_dict setObject:@"3" forKey:AsciiString(@"thridparty_g")];//1 谷歌登录 2Facebook登录  3苹果登录 0:原生
        [var_dict setObject:@"3" forKey:AsciiString(@"loginType")];
        [self lgjeropj_jsInsertWithJsonString:[var_dict yy_modelToJSONString]];
    }
}

//js注入
- (void)lgjeropj_jsInsertWithJsonString:(NSString *)jsonSting {
    NSString *var_evaluateJavaScript = [NSString stringWithFormat:@"%@('%@')", AsciiString(@"getNativeParam"), jsonSting];
    //执行一段JS
    [self.var_webView evaluateJavaScript:var_evaluateJavaScript completionHandler:^(id _Nullable object, NSError * _Nullable error) {}];
}

- (void)ht_clearCache {
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];;
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{}];
}

- (void)didReceiveMemoryWarning{
    [self ht_clearCache];
}

//存值
- (void)lgjeropj_saveUserDataWithDict:(NSDictionary *)var_dict {
    NSDictionary *var_dataDict = var_dict[AsciiString(@"data")];
    ZQAccountModel *var_loginUser = [[ZQAccountTools sharedInstance] lgjeropj_getAccountData];
    var_loginUser.var_userid = var_dataDict[AsciiString(@"uid")] ?: var_loginUser.var_userid;
    var_loginUser.var_avatar = var_dataDict[AsciiString(@"user_face")] ?: var_loginUser.var_avatar;
    var_loginUser.var_name = var_dataDict[AsciiString(@"user_name")] ?: var_loginUser.var_name;
    var_loginUser.var_mail = var_dataDict[AsciiString(@"email")] ?: var_loginUser.var_mail;
    var_loginUser.var_gender = var_dataDict[AsciiString(@"user_gender")] ?: var_loginUser.var_gender;
    var_loginUser.var_birth = var_dataDict[AsciiString(@"user_birth")] ?: var_loginUser.var_birth;
    var_loginUser.var_birth = var_dataDict[AsciiString(@"user_birth")] ?: var_loginUser.var_birth;
    var_loginUser.var_phone = var_dataDict[AsciiString(@"phone")] ?: var_loginUser.var_phone;
    var_loginUser.var_fid = var_dataDict[AsciiString(@"fid")] ?: var_loginUser.var_fid;
    var_loginUser.var_identity = var_dataDict[AsciiString(@"master")] ?: var_loginUser.var_identity;
    [[ZQAccountTools sharedInstance] lgjeropj_saveOrUpDataAccount:var_loginUser];
}

//埋点
- (void)lgjeropj_htMethodClickMaidian:(NSString *)htVarKid andType:(NSString *)htVarType andResult:(NSString *)htVarResult {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[AsciiString(@"result")] = htVarResult;
    params[AsciiString(@"kid")] = htVarKid;
    params[AsciiString(@"source")] = self.source;
    params[AsciiString(@"type")] = htVarType;
    [params setObject:@"signup_cl" forKey:@"pointname"];
    [HTLoginPointManager lgjeropj_maidianRequestWithParams:params];
}

- (void)lgjeropj_htMethodResultMaidian:(NSString *)htVarType {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[AsciiString(@"result")] = @"1";
    params[AsciiString(@"type")] = htVarType;
    params[AsciiString(@"source")] = self.source;
    [params setObject:@"third_party_result" forKey:@"pointname"];
    [HTLoginPointManager lgjeropj_maidianRequestWithParams:params];
}

@end
