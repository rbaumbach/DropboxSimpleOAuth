#import "DropboxLoginManager.h"


@interface FakeDropboxLoginManager : DropboxLoginManager

@property (copy, nonatomic) NSString *authCode;
@property (copy, nonatomic) void (^success)(DropboxLoginResponse *dropboxLoginResponse);
@property (copy, nonatomic) void (^failure)(NSError *error);

@end
