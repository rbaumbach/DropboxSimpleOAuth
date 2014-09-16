

@class DropboxLoginResponse;

@interface DropboxLoginManager : NSObject

@property (copy, nonatomic, readonly) NSString *appKey;
@property (copy, nonatomic, readonly) NSString *appSecret;
@property (strong, nonatomic, readonly) NSURL *callbackURL;

- (instancetype)initWithAppKey:(NSString *)appKey
                     appSecret:(NSString *)appSecret
                   callbackURL:(NSURL *)callbackURL;

- (void)authenticateWithAuthCode:(NSString *)authCode
                         success:(void (^)(DropboxLoginResponse *dropboxLoginResponse))success
                         failure:(void (^)(NSError *error))failure;

@end
