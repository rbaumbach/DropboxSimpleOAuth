# DropboxSimpleOAuth [![Build Status](https://travis-ci.org/rbaumbach/DropboxSimpleOAuth.svg?branch=master)](https://travis-ci.org/rbaumbach/DropboxSimpleOAuth) [![License](http://b.repl.ca/v1/License-MIT-blue.png)](https://github.com/rbaumbach/DropboxSimpleOAuth/blob/master/MIT.LICENSE) [![Cocoapod Version](http://img.shields.io/badge/pod-v0.1.0-blue.svg)](http://cocoapods.org/?q=DropboxSimpleOAuth) [![Cocoapod Platform](http://img.shields.io/badge/platform-iOS-blue.svg)](http://cocoapods.org/?q=DropboxSimpleOAuth)

A quick and simple way to authenticate a Dropbox user in your iPhone or iPad app.

<p align="center">
   <img src="https://github.com/rbaumbach/DropboxSimpleOAuth/blob/master/iPhone5Screenshot.jpg?raw=true" alt="iPhone5 Screenshot"/>
   <img src="https://github.com/rbaumbach/DropboxSimpleOAuth/blob/master/iPadScreenshot.jpg?raw=true" alt="iPad Screenshot"/>
</p>

## Adding DropboxSimpleOAuth to your project

### CocoaPods

[CocoaPods](http://cocoapods.org) is the recommended way to add DropboxSimpleOAuth to your project.

1.  Add DropboxSimpleOAuth to your Podfile `pod 'DropboxSimpleOAuth'`.
2.  Install the pod(s) by running `pod install`.
3.  Add DropboxSimpleOAuth to your files with `#import <DropboxSimpleOAuth/DropboxSimpleOAuth.h>`.

### Clone from Github

1.  Clone repository from github and copy files directly, or add it as a git submodule.
2.  Add all files from 'Source' directory to your project.

## How To

* Create an instance of `DropboxSimpleOAuthViewController` and pass in an [Dropbox app key, app secret, client callback URL](https://www.dropbox.com/developers) and completion block to be executed with `DropboxLoginResponse` and `NSError` arguments.
* Once the instance of `DropboxSimpleOAuthViewController` is presented (either as a modal or pushed on the navigation stack), it will allow the user to login.  After the user logs in, the completion block given in the initialization of the view controller will be executed.  The argument in the completion block, `DropboxLoginResponse`, contains an accessToken and other login information for the authenticated user provided by [Dropbox API Response](https://www.dropbox.com/developers/core/docs#oa2-token).  If there is an issue attempting to authenticate, an error will be given instead.
* By default, if there are issues with authentication, an UIAlertView will be given to the user.  To disable this, and rely on the NSError directly, set the property `shouldShowErrorAlert` to NO.
* Note: Even though an instance of the view controller itself can be initalized without app key, app secret, client callback and completion block (to help with testing), this data must be set using the view controller's properties before it is presented to the user.

### Example Usage

```objective-c
// Simplest Example:

DropboxSimpleOAuthViewController
    *viewController = [[DropboxSimpleOAuthViewController alloc] initWithAppKey:@"123I_am_a_client_id_567890"
                                                                     appSecret:@"shhhhhh, I'm a secret"
                                                                   callbackURL:[NSURL URLWithString:@"http://your.fancy.site"]
                                                                    completion:^(DropboxLoginResponse *response, NSError *error) {
                                                                        NSLog(@"My Access Token is: %@", response.accessToken);
                                                                    }];
[self.navigationController pushViewController:viewController
                                     animated:YES];

// Disable error UIAlertViews Example:

DropboxSimpleOAuthViewController
    *viewController = [[DropboxSimpleOAuthViewController alloc] initWithAppKey:@"123I_am_a_client_id_567890"
                                                                     appSecret:@"shhhhhh, I'm a secret"
                                                                   callbackURL:[NSURL URLWithString:@"http://your.fancy.site"]
                                                                    completion:^(DropboxLoginResponse *response, NSError *error) {
                                                                        NSLog(@"My OAuth Token is: %@", response.accessToken);
                                                                    }];
viewController.shouldShowErrorAlert = NO;

[self.navigationController pushViewController:viewController
                                     animated:YES];
```

## Testing

* Prerequisites: [ruby](https://github.com/sstephenson/rbenv), [ruby gems](https://rubygems.org/pages/download), [bundler](http://bundler.io)

To use the included Rakefile to run expecta tests, run the setup.sh script to bundle required gems and cocoapods:

```bash
$ ./setup.sh
```

Then run rake to run the tests on the command line:

```bash
$ bundle exec rake
```

Additional rake tasks can be seen using rake -T:

```bash
$ rake -T
rake build  # Build DropboxSimpleOAuth
rake clean  # Clean
rake test   # Run Tests
```

## Suggestions, requests, and feedback

Thanks for checking out DropboxSimpleOAuth for your in-app Dropbox authentication.  Any feedback can be
can be sent to: rbaumbach.github@gmail.com.
