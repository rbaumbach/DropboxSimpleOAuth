#import "FakeDropboxAuthenticationManager.h"


@implementation FakeDropboxAuthenticationManager

- (void)authenticateClientWithAuthCode:(NSString *)authCode
                               success:(void (^)(DropboxLoginResponse *reponse))success
                               failure:(void (^)(NSError *error))failure
{
    self.authCode = authCode;
    self.successBlock = success;
    self.failureBlock = failure;
}

@end
