

@interface DropboxLoginUtils : NSObject

@property (copy, nonatomic, readonly) NSString *appKey;
@property (strong, nonatomic, readonly) NSURL *callbackURL;

- (instancetype)initWithAppKey:(NSString *)appKey
                andCallbackURL:(NSURL *)callbackURL;

- (NSURLRequest *)buildLoginRequest;

- (BOOL)requestHasAuthCode:(NSURLRequest *)request;

- (NSString *)authCodeFromRequest:(NSURLRequest *)request;


@end
