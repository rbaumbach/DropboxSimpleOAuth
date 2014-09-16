#import "MainViewController.h"
#import "DropboxSimpleOAuth.h"
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

- (IBAction)dropboxVCOnNavControllerTapped:(id)sender
{
    JustAViewController *viewController = [[JustAViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navController
                       animated:YES
                     completion:nil];
}

#pragma mark - Private Method

- (void)displayToken:(NSString *)authToken
{
    UIAlertView *tokenAlert = [[UIAlertView alloc] initWithTitle:@"Dropbox Token"
                                                         message:[NSString stringWithFormat:@"Your Token is: %@", authToken]
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil, nil];
    [tokenAlert show];
}


@end
