#import "FakeSimpleOAuth2AuthenticationManager.h"


@implementation FakeSimpleOAuth2AuthenticationManager

- (void)authenticateOAuthClient:(NSURL *)authURL
                tokenParameters:(id<TokenParameters>)tokenParameters
                        success:(void (^)(id authResponseObject))success
                        failure:(void (^)(NSError *error))failure
{
    self.authURL = authURL;
    self.tokenParameters = tokenParameters;
    self.success = success;
    self.failure = failure;
}

@end
