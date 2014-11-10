#import "FakeDropboxAuthenticationManager.h"


@implementation FakeDropboxAuthenticationManager

- (void)authenticateClientWithAuthCode:(NSString *)authCode
                               success:(void (^)(DropboxLoginResponse *reponse))success
                               failure:(void (^)(NSError *error))failure
{
    self.authCode = authCode;
    self.success = success;
    self.failure = failure;
}

@end
