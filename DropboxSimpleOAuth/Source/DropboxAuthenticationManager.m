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

#import <SimpleOAuth2/SimpleOAuth2.h>
#import "DropboxAuthenticationManager.h"
#import "DropboxLoginResponse.h"
#import "DropboxConstants.h"
#import "DropboxTokenParameters.h"


NSString *const DropboxTokenEndpointTEMP = @"/1/oauth2/token";

@interface DropboxAuthenticationManager ()

@property (copy, nonatomic) NSString *appKey;
@property (copy, nonatomic) NSString *appSecret;
@property (copy, nonatomic) NSString *callbackURLString;
@property (strong, nonatomic) SimpleOAuth2AuthenticationManager *simpleOAuth2AuthenticationManager;

@end

@implementation DropboxAuthenticationManager

#pragma mark - Init Methods

- (instancetype)initWithAppKey:(NSString *)appKey
                     appSecret:(NSString *)appSecret
             callbackURLString:(NSString *)callbackURLString
{
    self = [super init];
    if (self) {
        self.appKey = appKey;
        self.appSecret = appSecret;
        self.callbackURLString = callbackURLString;
        self.simpleOAuth2AuthenticationManager = [[SimpleOAuth2AuthenticationManager alloc] init];
    }
    return self;
}

#pragma mark - Public Methods

- (void)authenticateClientWithAuthCode:(NSString *)authCode
                               success:(void (^)(DropboxLoginResponse *reponse))success
                               failure:(void (^)(NSError *error))failure
{
    NSString *authenticationURLString = [NSString stringWithFormat:@"%@%@", DropboxAuthURL, DropboxTokenEndpointTEMP];
    
    [self.simpleOAuth2AuthenticationManager authenticateOAuthClient:[NSURL URLWithString:authenticationURLString]
                                                    tokenParameters:[self dropboxTokenParametersFromAuthCode:authCode]
                                                            success:^(id authResponseObject) {
                                                                DropboxLoginResponse *loginResponse = [[DropboxLoginResponse alloc] initWithDropboxOAuthResponse:authResponseObject];
                                                                success(loginResponse);
                                                            } failure:failure];
}

#pragma mark - Private Methods

- (id<TokenParameters>)dropboxTokenParametersFromAuthCode:(NSString *)authCode
{
    DropboxTokenParameters *dropboxTokenParameters = [[DropboxTokenParameters alloc] init];
    dropboxTokenParameters.appKey = self.appKey;
    dropboxTokenParameters.appSecret = self.appSecret;
    dropboxTokenParameters.callbackURLString = self.callbackURLString;
    dropboxTokenParameters.authorizationCode = authCode;
    
    return dropboxTokenParameters;
}

@end
