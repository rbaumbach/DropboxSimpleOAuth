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
