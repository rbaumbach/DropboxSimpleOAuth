#import "DropboxTokenParameters.h"


NSString *const GrantTypeKey = @"grant_type";
NSString *const GrantTypeValue = @"authorization_code";
NSString *const ClientIDKey = @"client_id";
NSString *const ClientSecretKey = @"client_secret";
NSString *const RedirectURIKey = @"redirect_uri";
NSString *const CodeKey = @"code";

@implementation DropboxTokenParameters

#pragma <TokenParameters>

- (NSDictionary *)build
{
    return @{ ClientIDKey     : self.appKey,
              ClientSecretKey : self.appSecret,
              GrantTypeKey    : GrantTypeValue,
              RedirectURIKey  : self.callbackURLString,
              CodeKey         : self.authorizationCode
            };
}

@end
