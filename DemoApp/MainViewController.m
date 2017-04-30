#import <DropboxSimpleOAuth/DropboxSimpleOAuth.h>
#import "MainViewController.h"
#import "JustAViewController.h"

@implementation MainViewController

- (IBAction)presentDropboxVCTapped:(id)sender
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
    [self presentViewController:viewController
                       animated:YES
                     completion:nil];
}

#pragma mark - Private Method

- (void)displayToken:(NSString *)authToken
{
    UIAlertController *tokenAlertController = [UIAlertController alertControllerWithTitle:@"Dropbox Token"
                                                                                  message:[NSString stringWithFormat:@"Your Token is: %@", authToken]
                                                                           preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:tokenAlertController
                       animated:YES
                     completion:nil];
}

@end
