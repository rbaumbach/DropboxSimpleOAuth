#import <AFNetworking/AFNetworking.h>
#import "DropboxLoginManager.h"
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
