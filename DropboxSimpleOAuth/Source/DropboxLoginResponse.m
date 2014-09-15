#import "DropboxLoginResponse.h"


NSString *const DropboxAccessTokenKey = @"access_token";
NSString *const DropboxTokenTypeKey = @"token_type";
NSString *const DropboxUidKey = @"uid";

@interface DropboxLoginResponse ()

@property (copy, nonatomic, readwrite) NSString *accessToken;
@property (copy, nonatomic, readwrite) NSString *tokenType;
@property (copy, nonatomic, readwrite) NSString *uid;

@end

@implementation DropboxLoginResponse

- (instancetype)initWithDropboxOAuthResponse:(NSDictionary *)response;
{
    self = [super init];
    if (self) {
        if (response) {
            self.accessToken = response[DropboxAccessTokenKey];
            self.tokenType = response[DropboxTokenTypeKey];
            self.uid = response[DropboxUidKey];
        }
    }
    return self;
}

@end
