#import <DropboxSimpleOAuth/DropboxSimpleOAuth.h>
#import "JustAViewController.h"

@implementation JustAViewController

#pragma mark - IBActions

- (IBAction)pushDropboxVCOnNavStackTapped:(id)sender
{
    DropboxSimpleOAuthViewController
    *viewController = [[DropboxSimpleOAuthViewController alloc] initWithAppKey:@"enter_your_app_key_here"
                                                                      appSecret:@"enter_your_app_secret_here"
                                                                       callbackURL:[NSURL URLWithString:@"http://enter.callback.url.here"]
                                                                        completion:^(DropboxLoginResponse *response, NSError *error) {
                                                                            if (response.accessToken) {
                                                                                [self displayToken:response.accessToken];
                                                                            }
                                                                        }];
    [self.navigationController pushViewController:viewController
                                         animated:YES];
}

#pragma mark - Private Method

- (void)displayToken:(NSString *)authToken
{
    UIAlertView *tokenAlert = [[UIAlertView alloc] initWithTitle:@"Dropbox Token"
                                                         message:[NSString stringWithFormat:@"Your Token is: %@", authToken]
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [tokenAlert show];
}

@end
