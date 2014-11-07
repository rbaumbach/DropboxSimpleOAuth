//Copyright (c) 2014 Ryan Baumbach <rbaumbach.github@gmail.com>
//
//Permission is hereby granted, free of charge, to any person obtaining
//a copy of this software and associated documentation files (the "Software"),
//to deal in the Software without restriction, including
//without limitation the rights to use, copy, modify, merge, publish,
//distribute, sublicense, and/or sell copies of the Software, and to
//permit persons to whom the Software is furnished to do so, subject to
//the following conditions:
//
//The above copyright notice and this permission notice shall be
//included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <MBProgressHUD/MBProgressHUD.h>
#import <SimpleOAuth2/SimpleOAuth2.h>
#import "DropboxSimpleOAuthViewController.h"
#import "DropboxConstants.h"
#import "DropboxLoginResponse.h"


NSString *const CodeKey = @"code";
NSString *const GrantTypeKey = @"grant_type";
NSString *const GrantTypeValue = @"authorization_code";
NSString *const ClientIDKey = @"client_id";
NSString *const ClientSecretKey = @"client_secret";
NSString *const RedirectURIKey = @"redirect_uri";
NSString *const DropboxAuthClientIDEndpoint = @"/1/oauth2/authorize?client_id=";
NSString *const DropboxTokenEndpoint = @"/1/oauth2/token";
NSString *const DropboxAuthRequestParams = @"&response_type=code&redirect_uri=";
NSString *const NSLocalizedDescriptionKey = @"NSLocalizedDescription";
NSString *const DropboxLoginErrorAlertTitle = @"Dropbox Login Error";
NSString *const DropboxLoginCancelButtonTitle = @"OK";

@interface DropboxSimpleOAuthViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *dropboxWebView;
@property (strong, nonatomic) SimpleOAuth2AuthenticationManager *simpleOAuth2AuthenticationManager;
@property (strong, nonatomic) NSURLRequest *webLoginRequestBuilder;

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
        self.simpleOAuth2AuthenticationManager = [[SimpleOAuth2AuthenticationManager alloc] init];
        self.webLoginRequestBuilder = [[NSURLRequest alloc] init];
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
    NSString *authorizationCode = [request oAuth2AuthorizationCode];
    
    if (authorizationCode) {
        NSDictionary *tokenParams = @{ ClientIDKey     : self.appKey,
                                       ClientSecretKey : self.appSecret,
                                       GrantTypeKey    : GrantTypeValue,
                                       RedirectURIKey  : self.callbackURL.absoluteString,
                                       CodeKey         : authorizationCode
                                     };
        
        NSString *authenticationURLString = [NSString stringWithFormat:@"%@%@", DropboxAuthURL, DropboxTokenEndpoint];
        
        [self.simpleOAuth2AuthenticationManager authenticateOAuthClient:[NSURL URLWithString:authenticationURLString]
                                                        tokenParameters:tokenParams
                                                                success:^(id authResponseObject) {
                                                                    DropboxLoginResponse *loginResponse = [[DropboxLoginResponse alloc] initWithDropboxOAuthResponse:authResponseObject];
                                                                    [self completeAuthWithLoginResponse:loginResponse];
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
    
    NSString *loginURLString = [NSString stringWithFormat:@"%@%@%@%@%@",
                                DropboxAuthURL,
                                DropboxAuthClientIDEndpoint,
                                self.appKey,
                                DropboxAuthRequestParams,
                                self.callbackURL.absoluteString];
    
    NSURL *loginURL = [NSURL URLWithString:loginURLString];
    NSURLRequest *requestBuilder = [self.webLoginRequestBuilder buildWebLoginRequestWithURL:loginURL
                                                                            permissionScope:nil];
    
    [self.dropboxWebView loadRequest:requestBuilder];
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
    NSString *errorMessage = [NSString stringWithFormat:@"%@ - %@", error.domain, error.userInfo[NSLocalizedDescriptionKey]];
    
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:DropboxLoginErrorAlertTitle
                                                         message:errorMessage
                                                        delegate:nil
                                               cancelButtonTitle:DropboxLoginCancelButtonTitle
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
