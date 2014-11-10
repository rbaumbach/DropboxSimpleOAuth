#import "DropboxAuthenticationManager.h"


@interface FakeDropboxAuthenticationManager : DropboxAuthenticationManager

@property (copy, nonatomic) NSString *authCode;
@property (copy, nonatomic) void (^success)(DropboxLoginResponse *response);
@property (copy, nonatomic) void (^failure)(NSError *error);

@end
