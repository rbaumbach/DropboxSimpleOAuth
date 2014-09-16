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

#import <AFNetworking/AFNetworking.h>
#import "DropboxLoginManager.h"
#import "DropboxLoginResponse.h"
#import "DropboxConstants.h"


NSString *const DropboxAuthTokenEndpoint = @"/1/oauth2/token";
NSString *const CodeKey = @"code";
NSString *const GrantTypeKey = @"grant_type";
NSString *const GrantTypeValue = @"authorization_code";
NSString *const ClientIDKey = @"client_id";
NSString *const ClientSecretKey = @"client_secret";
NSString *const RedirectURIKey = @"redirect_uri";

@interface DropboxLoginManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@property (copy, nonatomic, readwrite) NSString *appKey;
@property (copy, nonatomic, readwrite) NSString *appSecret;
@property (strong, nonatomic, readwrite) NSURL *callbackURL;

@end

@implementation DropboxLoginManager

#pragma mark - Init Methods

- (instancetype)initWithAppKey:(NSString *)appKey
                     appSecret:(NSString *)appSecret
                   callbackURL:(NSURL *)callbackURL
{
    self = [super init];
    if (self) {
        self.appKey = appKey;
        self.appSecret = appSecret;
        self.callbackURL = callbackURL;
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:DropboxAuthURL]];
        self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

#pragma mark - Public Methods

- (void)authenticateWithAuthCode:(NSString *)authCode
                         success:(void (^)(DropboxLoginResponse *dropboxLoginResponse))success
                         failure:(void (^)(NSError *error))failure
{
    [self.sessionManager POST:DropboxAuthTokenEndpoint
                   parameters:[self dropboxTokenParams:authCode]
                      success:^(NSURLSessionDataTask *task, id responseObject) {
                          DropboxLoginResponse *loginResponse = [[DropboxLoginResponse alloc] initWithDropboxOAuthResponse:responseObject];
                          success(loginResponse);
                      } failure:^(NSURLSessionDataTask *task, NSError *error) {
                          failure(error);
                      }];
}

#pragma mark - Private Methods

- (NSDictionary *)dropboxTokenParams:(NSString *)authCode
{
    return @{ ClientIDKey     : self.appKey,
              ClientSecretKey : self.appSecret,
              GrantTypeKey    : GrantTypeValue,
              RedirectURIKey  : self.callbackURL.absoluteString,
              CodeKey         : authCode };
}

@end
