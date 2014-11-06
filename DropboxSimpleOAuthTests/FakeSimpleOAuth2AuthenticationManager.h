#import <SimpleOAuth2/SimpleOAuth2.h>


@interface FakeSimpleOAuth2AuthenticationManager : SimpleOAuth2AuthenticationManager

@property (copy, nonatomic) NSURL *authURL;
@property (strong, nonatomic) NSDictionary *tokenParameters;
@property (copy, nonatomic) void (^success)(id authResponseObject);
@property (copy, nonatomic) void (^failure)(NSError *error);

@end
