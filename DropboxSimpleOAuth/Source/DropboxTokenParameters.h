#import <SimpleOAuth2/SimpleOAuth2.h>


@interface DropboxTokenParameters : NSObject <TokenParameters>

@property (copy, nonatomic) NSString *appKey;
@property (copy, nonatomic) NSString *appSecret;
@property (copy, nonatomic) NSString *callbackURLString;
@property (copy, nonatomic) NSString *authorizationCode;

@end
