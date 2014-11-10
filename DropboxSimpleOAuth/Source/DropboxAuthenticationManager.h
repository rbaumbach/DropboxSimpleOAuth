

@class DropboxLoginResponse;

@interface DropboxAuthenticationManager : NSObject

- (instancetype)initWithAppKey:(NSString *)appKey
                     appSecret:(NSString *)appSecret
             callbackURLString:(NSString *)callbackURLString;

- (void)authenticateClientWithAuthCode:(NSString *)authCode
                               success:(void (^)(DropboxLoginResponse *reponse))success
                               failure:(void (^)(NSError *error))failure;

@end
