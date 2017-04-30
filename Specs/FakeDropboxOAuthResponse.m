#import "FakeDropboxOAuthResponse.h"

@implementation FakeDropboxOAuthResponse

+ (NSDictionary *)response
{
    return @{
             @"access_token": @"Video-Arcade-Token",
             @"token_type": @"type0",
             @"uid": @"some-dudes-id-1001"
            };
}

@end
