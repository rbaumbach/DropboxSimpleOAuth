# DropboxSimpleOAuth [![CircleCI](https://circleci.com/gh/rbaumbach/DropboxSimpleOAuth.svg?style=svg)](https://circleci.com/gh/rbaumbach/DropboxSimpleOAuth) [![codecov.io](https://codecov.io/github/rbaumbach/DropboxSimpleOAuth/coverage.svg?branch=master)](https://codecov.io/github/rbaumbach/DropboxSimpleOAuth?branch=master) [![Cocoapod Version](https://img.shields.io/cocoapods/v/DropboxSimpleOAuth.svg)](http://cocoapods.org/?q=DropboxSimpleOAuth) [![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![Cocoapod Platform](http://img.shields.io/badge/platform-iOS-blue.svg)](http://cocoapods.org/?q=DropboxSimpleOAuth) [![License](https://img.shields.io/dub/l/vibe-d.svg)](https://github.com/rbaumbach/DropboxSimpleOAuth/blob/master/MIT-LICENSE.txt)

A quick and simple way to authenticate a Dropbox user in your iPhone or iPad app.

<p align="center">
   <img src="https://github.com/rbaumbach/DropboxSimpleOAuth/blob/master/iPhone7Screenshot.jpg?raw=true" alt="iPhone 7 Screenshot" width="250" height="510"/>
   <img src="https://github.com/rbaumbach/DropboxSimpleOAuth/blob/master/iPadPro9_7Screenshot.jpg?raw=true"
    alt="iPad Pro 9.7 Screenshot" width="360" height="510"/>
</p>

## Adding DropboxSimpleOAuth to your project

### CocoaPods

[CocoaPods](http://cocoapods.org) is the recommended way to add DropboxSimpleOAuth to your project.

1.  Add DropboxSimpleOAuth to your Podfile `pod 'DropboxSimpleOAuth'`.
2.  Install the pod(s) by running `pod install`.
3.  Add DropboxSimpleOAuth to your files with `#import <DropboxSimpleOAuth/DropboxSimpleOAuth.h>`.

### Carthage

1. Add `github "rbaumbach/DropboxSimpleOAuth"` to your Cartfile.
2. [Follow the directions](https://github.com/Carthage/Carthage#getting-started) to add the dynamic framework to your target.

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

This project has been setup to use [fastlane](https://fastlane.tools) to run the specs.

First, run the setup.sh script to bundle required gems and CocoaPods when in the project directory:

```bash
$ ./setup.sh
```

And then use fastlane to run all the specs on the command line:

```bash
$ bundle exec fastlane specs
```

## Version History

Version history can be found [on releases page](https://github.com/rbaumbach/DropboxSimpleOAuth/releases).

## Suggestions, requests, and feedback

Thanks for checking out DropboxSimpleOAuth for your in-app Dropbox authentication.  Any feedback can be can be sent to: github@ryan.codes.
