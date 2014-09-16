#import "FakeDropboxLoginManager.h"


@implementation FakeDropboxLoginManager

- (void)authenticateWithAuthCode:(NSString *)authCode
                         success:(void (^)(DropboxLoginResponse *dropboxLoginResponse))success
                         failure:(void (^)(NSError *error))failure
{
    self.authCode = authCode;
    self.success = success;
    self.failure = failure;
}

@end
