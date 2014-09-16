#import "DropboxLoginUtils.h"
#import "DropboxConstants.h"


NSString *const DropboxAuthClientIDEndpoint = @"/1/oauth2/authorize?client_id=";
NSString *const DropboxAuthRequestParams = @"&response_type=code&redirect_uri=";
NSString *const DropboxAuthCodeParam = @"/?code=";

@interface DropboxLoginUtils ()

@property (copy, nonatomic, readwrite) NSString *appKey;
@property (strong, nonatomic, readwrite) NSURL *callbackURL;

@end

@implementation DropboxLoginUtils

#pragma mark - Init Methods

- (instancetype)initWithAppKey:(NSString *)appKey
                andCallbackURL:(NSURL *)callbackURL;
{
    self = [super init];
    if (self) {
        self.appKey = appKey;
        self.callbackURL = callbackURL;
    }
    return self;
}

#pragma mark - Public Methods

- (NSURLRequest *)buildLoginRequest
{
    NSURL *fullDrooboxLoginURL = [NSURL URLWithString:[self dropboxLoginURLString]];
    return [NSURLRequest requestWithURL:fullDrooboxLoginURL];
}

- (BOOL)requestHasAuthCode:(NSURLRequest *)request
{
    NSString *requestURLString = request.URL.absoluteString;
    NSString *callbackWithAuthParam = [self callbackWithAuthCode];
    
    return [requestURLString hasPrefix:callbackWithAuthParam];
}

- (NSString *)authCodeFromRequest:(NSURLRequest *)request
{
    NSString *requestURLString = request.URL.absoluteString;
    NSString *callbackWithAuthParam = [self callbackWithAuthCode];
    
    return [requestURLString substringFromIndex:[callbackWithAuthParam length]];
}

#pragma mark - Private Methods

- (NSString *)dropboxLoginURLString
{
    return [NSString stringWithFormat:@"%@%@%@%@%@",
            DropboxAuthURL,
            DropboxAuthClientIDEndpoint,
            self.appKey,
            DropboxAuthRequestParams,
            self.callbackURL.absoluteString];
}

- (NSString *)callbackWithAuthCode
{
    return [NSString stringWithFormat:@"%@%@", self.callbackURL.absoluteString, DropboxAuthCodeParam];
}

@end
