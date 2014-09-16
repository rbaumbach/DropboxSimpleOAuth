#import <MBProgressHUD/MBProgressHUD.h>
#import "DropboxSimpleOAuthViewController.h"
#import "DropboxLoginManager.h"
#import "DropboxLoginUtils.h"


@interface DropboxSimpleOAuthViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *dropboxWebView;
@property (strong, nonatomic) DropboxLoginManager *loginManager;
@property (strong, nonatomic) DropboxLoginUtils *dropboxLoginUtils;

@end

@implementation DropboxSimpleOAuthViewController

#pragma mark - Init Methods

- (instancetype)initWithAppKey:(NSString *)appKey
                     appSecret:(NSString *)appSecret
                   callbackURL:(NSURL *)callbackURL
                    completion:(void (^)(DropboxLoginResponse *response, NSError *error))completion
{
    self = [super init];
    if (self) {
        self.appKey = appKey;
        self.appSecret = appSecret;
        self.callbackURL = callbackURL;
        self.completion = completion;
        self.shouldShowErrorAlert = YES;
        self.loginManager = [[DropboxLoginManager alloc] initWithAppKey:self.appKey
                                                              appSecret:self.appSecret
                                                            callbackURL:self.callbackURL];
        self.dropboxLoginUtils = [[DropboxLoginUtils alloc] initWithAppKey:self.appKey
                                                            andCallbackURL:self.callbackURL];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithAppKey:nil
                      appSecret:nil
                    callbackURL:nil
                     completion:nil];
}

#pragma mark - View Lifecycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadDropboxLogin];
}

#pragma mark - <UIWebViewDelegate>

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    if ([self.dropboxLoginUtils requestHasAuthCode:request]) {
        [self showProgressHUD];
        
        NSString *dropboxAuthCode = [self.dropboxLoginUtils authCodeFromRequest:request];
        
        [self.loginManager authenticateWithAuthCode:dropboxAuthCode
                                            success:^(DropboxLoginResponse *dropboxLoginResponse) {
                                                [self completeAuthWithLoginResponse:dropboxLoginResponse];
                                            } failure:^(NSError *error) {
                                                [self completeWithError:error];
                                            }];
        
        return NO;
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideProgressHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (error.code != 102) {
        [self completeWithError:error];
        
        if (self.shouldShowErrorAlert) {
            [self showErrorAlert:error];
        }
        
        [self dismissViewController];
    }
    
    [self hideProgressHUD];
}

#pragma mark - Private Methods

- (void)loadDropboxLogin
{
    [self showProgressHUD];
    
    NSURLRequest *loginRequest = [self.dropboxLoginUtils buildLoginRequest];
    [self.dropboxWebView loadRequest:loginRequest];
}

- (void)completeAuthWithLoginResponse:(DropboxLoginResponse *)response
{
    self.completion(response, nil);
    
    [self dismissViewController];
    [self hideProgressHUD];
}

- (void)completeWithError:(NSError *)error
{
    self.completion(nil, error);
    
    if (self.shouldShowErrorAlert) {
        [self showErrorAlert:error];
    }
    
    [self dismissViewController];
    [self hideProgressHUD];
}

- (void)dismissViewController
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
    }
}

- (void)showErrorAlert:(NSError *)error
{
    NSString *errorMessage = [NSString stringWithFormat:@"%@ - %@", error.domain, error.userInfo[@"NSLocalizedDescription"]];
    
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Dropbox Login Error"
                                                         message:errorMessage
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [errorAlert show];
}

- (void)showProgressHUD
{
    [MBProgressHUD showHUDAddedTo:self.view
                         animated:YES];
}

- (void)hideProgressHUD
{
    [MBProgressHUD hideHUDForView:self.view
                         animated:YES];
}

@end
