#import <SimpleOAuth2/SimpleOAuth2.h>


@interface FakeSimpleOAuth2AuthenticationManager : SimpleOAuth2AuthenticationManager

@property (strong, nonatomic) NSURL *authURL;
@property (strong, nonatomic) NSDictionary *tokenParametersDictionary;
@property (strong, nonatomic) id<TokenParameters> tokenParameters;
@property (copy, nonatomic) void (^successBlock)(id authResponseObject);
@property (copy, nonatomic) void (^failureBlock)(NSError *error);

@end
