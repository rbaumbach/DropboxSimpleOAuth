

@class DropboxLoginResponse;

@interface DropboxSimpleOAuthViewController : UIViewController

@property (copy, nonatomic) NSString *appKey;
@property (copy, nonatomic) NSString *appSecret;
@property (strong, nonatomic) NSURL *callbackURL;
@property (copy, nonatomic) void (^completion)(DropboxLoginResponse *response, NSError *error);
@property (nonatomic) BOOL shouldShowErrorAlert;

- (instancetype)initWithAppKey:(NSString *)appKey
                    appSecret:(NSString *)appSecret
                     callbackURL:(NSURL *)callbackURL
                      completion:(void (^)(DropboxLoginResponse *response, NSError *error))completion;

@end
