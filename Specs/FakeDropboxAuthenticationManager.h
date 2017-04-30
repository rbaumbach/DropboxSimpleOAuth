#import "DropboxAuthenticationManager.h"

@interface FakeDropboxAuthenticationManager : DropboxAuthenticationManager

@property (copy, nonatomic) NSString *authCode;
@property (copy, nonatomic) void (^successBlock)(DropboxLoginResponse *response);
@property (copy, nonatomic) void (^failureBlock)(NSError *error);

@end
