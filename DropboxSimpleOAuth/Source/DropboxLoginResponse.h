

@interface DropboxLoginResponse : NSObject

@property (copy, nonatomic, readonly) NSString *accessToken;
@property (copy, nonatomic, readonly) NSString *tokenType;
@property (copy, nonatomic, readonly) NSString *uid;

- (instancetype)initWithDropboxOAuthResponse:(NSDictionary *)response;

@end
