#import <Expecta/Expecta.h>
#import <Specta/Specta.h>
#import <OCMock/OCMock.h>
#import <Swizzlean/Swizzlean.h>
#import <MBProgressHUD/MBProgressHUD.h>

#import "FakeDropboxAuthenticationManager.h"
#import "DropboxSimpleOAuth.h"
#import "DropboxTokenParameters.h"
#import "FakeDropboxOAuthResponse.h"
#import "DropboxAuthenticatioNManager.h"

@interface DropboxSimpleOAuthViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *dropboxWebView;
@property (strong, nonatomic) DropboxAuthenticationManager *dropboxAuthenticationManager;

@end

@interface DropboxAuthenticationManager ()

@property (copy, nonatomic) NSString *appKey;
@property (copy, nonatomic) NSString *appSecret;
@property (copy, nonatomic) NSString *callbackURLString;

@end

SpecBegin(DropboxSimpleOAuthViewController)

describe(@"DropboxSimpleOAuthViewController", ^{
    __block DropboxSimpleOAuthViewController *controller;
    __block NSURL *callbackURL;
    __block DropboxLoginResponse *retLoginResponse;
    __block NSError *retError;
    
    beforeEach(^{
        callbackURL = [NSURL URLWithString:@"http://Delta-Tau-Chi.ios"];
        controller = [[DropboxSimpleOAuthViewController alloc] initWithAppKey:@"los-llaves"
                                                                    appSecret:@"unodostres"
                                                                  callbackURL:callbackURL
                                                                   completion:^(DropboxLoginResponse *response, NSError *error) {
                                                                       retLoginResponse = response;
                                                                       retError = error;
                                                                   }];
    });
    
    describe(@"init", ^{
        it(@"calls -initWithAppKey:appSecret:callbackURL:completion: with nil parameters", ^{
            DropboxSimpleOAuthViewController *basicController = [[DropboxSimpleOAuthViewController alloc] init];
            expect(basicController.appKey).to.beNil;
            expect(basicController.appSecret).to.beNil;
            expect(basicController.callbackURL).to.beNil;
            expect(basicController.completion).to.beNil;
        });
    });
    
    it(@"has a appKey", ^{
        expect(controller.appKey).to.equal(@"los-llaves");
    });
    
    it(@"has a appSecet", ^{
        expect(controller.appSecret).to.equal(@"unodostres");
    });
    
    it(@"has a callbackURL", ^{
        expect(controller.callbackURL).to.equal([NSURL URLWithString:@"http://Delta-Tau-Chi.ios"]);
    });
    
    it(@"has a completion block", ^{
        BOOL hasCompletionBlock = NO;
        if (controller.completion) {
            hasCompletionBlock = YES;
        }
        expect(hasCompletionBlock).to.beTruthy();
    });
    
    it(@"has shouldShowErrorAlert flag that defaults to YES", ^{
        expect(controller.shouldShowErrorAlert).to.beTruthy();
    });
    
    it(@"conforms to <UIWebViewDelegate>", ^{
        BOOL conformsToWebViewDelegateProtocol = [controller conformsToProtocol:@protocol(UIWebViewDelegate)];
        expect(conformsToWebViewDelegateProtocol).to.equal(YES);
    });
    
    it(@"has a DropboxAuthenticationManager", ^{
        expect(controller.dropboxAuthenticationManager).to.beInstanceOf([DropboxAuthenticationManager class]);
        expect(controller.dropboxAuthenticationManager.appKey).to.equal(@"los-llaves");
        expect(controller.dropboxAuthenticationManager.appSecret).to.equal(@"unodostres");
        expect(controller.dropboxAuthenticationManager.callbackURLString).to.equal(@"http://Delta-Tau-Chi.ios");
    });
    
    describe(@"#viewDidAppear", ^{
        __block Swizzlean *superSwizz;
        __block BOOL isSuperCalled;
        __block BOOL retAnimated;
        __block id hudClassMethodMock;
        __block UIWebView *fakeWebView;
        __block id fakeLoginRequest;
        
        beforeEach(^{
            isSuperCalled = NO;
            superSwizz = [[Swizzlean alloc] initWithClassToSwizzle:[UIViewController class]];
            [superSwizz swizzleInstanceMethod:@selector(viewDidAppear:) withReplacementImplementation:^(id _self, BOOL isAnimated) {
                isSuperCalled = YES;
                retAnimated = isAnimated;
            }];
            
            [controller view];
            
            hudClassMethodMock = OCMClassMock([MBProgressHUD class]);
            
            fakeWebView = OCMClassMock([UIWebView class]);
            controller.dropboxWebView = fakeWebView;
            
            fakeLoginRequest = OCMClassMock([NSURLRequest class]);
            
            NSURL *expectedLoginURL = [NSURL URLWithString:@"https://www.dropbox.com/1/oauth2/authorize?client_id=los-llaves&response_type=code&redirect_uri=http://Delta-Tau-Chi.ios"];
            OCMStub(ClassMethod([fakeLoginRequest buildWebLoginRequestWithURL:expectedLoginURL])).andReturn(fakeLoginRequest);
            
            [controller viewDidAppear:YES];
        });
        
        it(@"calls super!!! Thanks for asking!!! =)", ^{
            expect(retAnimated).to.beTruthy();
            expect(isSuperCalled).to.beTruthy();
        });
        
        it(@"displays Progress HUD", ^{
            OCMVerify([hudClassMethodMock showHUDAddedTo:controller.view animated:YES]);
        });
        
        it(@"loads the login using the login request", ^{
            OCMVerify([fakeWebView loadRequest:fakeLoginRequest]);
        });
    });
    
    describe(@"<UIWebViewDelegate>", ^{
        __block id fakeWebView;
        
        beforeEach(^{
            fakeWebView = OCMClassMock([UIWebView class]);
        });
        
        describe(@"#webView:shouldStartLoadWithRequest:navigationType:", ^{
            __block id hudClassMethodMock;
            __block BOOL shouldStartLoad;
            __block id fakeURLRequest;
            __block FakeDropboxAuthenticationManager *fakeAuthManager;
            
            beforeEach(^{
                hudClassMethodMock = OCMClassMock([MBProgressHUD class]);
            });
            
            context(@"request contains dropbox callback URL as the URL Prefix with code param", ^{
                beforeEach(^{
                    fakeURLRequest = OCMClassMock([NSURLRequest class]);
                    OCMStub([fakeURLRequest oAuth2AuthorizationCode]).andReturn(@"authorization-sir");
                    
                    fakeAuthManager = [[FakeDropboxAuthenticationManager alloc] init];
                    controller.dropboxAuthenticationManager = fakeAuthManager;
                    
                    shouldStartLoad = [controller webView:fakeWebView
                               shouldStartLoadWithRequest:fakeURLRequest
                                           navigationType:UIWebViewNavigationTypeFormSubmitted];
                });
                
                it(@"attempts to authenticate with dropbox with authCode", ^{
                    expect(fakeAuthManager.authCode).to.equal(@"authorization-sir");
                });

                context(@"successfully gets auth token from Dropbox", ^{
                    __block id partialMock;
                    __block id fakeDropboxResponse;
                    
                    beforeEach(^{
                        fakeDropboxResponse = OCMClassMock([DropboxLoginResponse class]);
                    });
                    
//                    context(@"has a navigation controlller", ^{
//                        beforeEach(^{
//                            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
//                            partialMock = OCMPartialMock(navigationController);
//                            
//                            if (fakeAuthManager.successBlock) {
//                                fakeAuthManager.successBlock(fakeDropboxResponse);
//                            }
//                        });
//                        
//                        it(@"pops itself off the navigation controller", ^{
//                            OCMVerify([partialMock popViewControllerAnimated:YES]);
//                        });
//                        
//                        it(@"removes the progress HUD", ^{
//                            OCMVerify([hudClassMethodMock hideHUDForView:controller.view
//                                                                animated:YES]);
//                        });
//                        
//                        it(@"calls completion with dropbox login response", ^{
//                            expect(retLoginResponse).to.equal(fakeDropboxResponse);
//                        });
//                    });

//                    context(@"does NOT have a navigation controller", ^{
//                        beforeEach(^{
//                            partialMock = OCMPartialMock(controller);
//
//                            if (fakeAuthManager.successBlock) {
//                                fakeAuthManager.successBlock(fakeDropboxResponse);
//                            }
//                        });
//
//                        it(@"pops itself off the navigation controller", ^{
//                            OCMVerify([partialMock dismissViewControllerAnimated:YES completion:nil]);
//                        });
//
//                        it(@"removes the progress HUD", ^{
//                            OCMVerify([hudClassMethodMock hideHUDForView:controller.view
//                                                                animated:YES]);
//                        });
//
//                        it(@"calls completion with dropbox login response", ^{
//                            expect(retLoginResponse).to.equal(fakeDropboxResponse);
//                        });
//                    });
                });

                context(@"failure while attempting to get auth token from Dropbox", ^{
                    __block id partialMock;
                    __block Swizzlean *presentViewSwizz;
                    __block UIViewController *retViewController;
                    __block BOOL retAnimated;
                    __block id retCompleted;
                    __block NSError *bogusError;
                    
                    beforeEach(^{
                        presentViewSwizz = [[Swizzlean alloc] initWithClassToSwizzle:[UIViewController class]];
                        [presentViewSwizz swizzleInstanceMethod:@selector(presentViewController:animated:completion:)
                                  withReplacementImplementation:^(id _self, UIViewController *viewController, BOOL animated, id completion) {
                                      retViewController = viewController;
                                      retAnimated = animated;
                                      retCompleted = [completion copy];
                                  }];
                        
                        bogusError = [[NSError alloc] initWithDomain:@"bogusDomain" code:177 userInfo:@{ @"NSLocalizedDescription" : @"boooogussss"}];
                    });
                    
                    afterEach(^{
                        retViewController = nil;
                    });
                    
//                    context(@"shouldShowErrorAlert == YES", ^{
//                        beforeEach(^{
//                            controller.shouldShowErrorAlert = YES;
//                            [controller webView:fakeWebView didFailLoadWithError:bogusError];
//                        });
//
//                        it(@"displays a UIAlertController with proper error", ^{
//                            UIAlertController *errorAlertController = (UIAlertController *)retViewController;
//
//                            expect(errorAlertController.title).to.equal(@"Dropbox Login Error");
//                            expect(errorAlertController.message).to.equal(@"bogusDomain - boooogussss");
//                        });
//                    });

                    context(@"shouldShowErrorAlert == NO", ^{
                        beforeEach(^{
                            controller.shouldShowErrorAlert = NO;
                            [controller webView:fakeWebView didFailLoadWithError:bogusError];
                        });
                        
                        it(@"does not display UIAlertController for the error", ^{
                            UIAlertController *errorAlertController = (UIAlertController *)retViewController;
                            
                            expect(errorAlertController).to.beNil();
                        });
                    });

//                    context(@"has a navigation controlller", ^{
//                        beforeEach(^{
//                            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
//                            partialMock = OCMPartialMock(navigationController);
//                            
//                            if (fakeAuthManager.failureBlock) {
//                                fakeAuthManager.failureBlock(bogusError);
//                            }
//                        });
//                        
//                        it(@"pops itself off the navigation controller", ^{
//                            OCMVerify([partialMock popViewControllerAnimated:YES]);
//                        });
//                        
//                        it(@"removes the progress HUD", ^{
//                            OCMVerify([hudClassMethodMock hideHUDForView:controller.view
//                                                                animated:YES]);
//                        });
//                        
//                        it(@"calls completion with nil token", ^{
//                            expect(retLoginResponse).to.beNil();
//                        });
//                        
//                        it(@"calls completion with AFNetworking error", ^{
//                            expect(retError).to.equal(bogusError);
//                        });
//                    });
//
//                    context(@"does NOT have a navigation controller", ^{
//                        beforeEach(^{
//                            partialMock = OCMPartialMock(controller);
//
//                            if (fakeAuthManager.failureBlock) {
//                                fakeAuthManager.failureBlock(bogusError);
//                            }
//                        });
//
//                        it(@"pops itself off the view controller", ^{
//                            OCMVerify([partialMock dismissViewControllerAnimated:YES completion:nil]);
//                        });
//
//                        it(@"removes the progress HUD", ^{
//                            OCMVerify([hudClassMethodMock hideHUDForView:controller.view
//                                                                animated:YES]);
//                        });
//
//                        it(@"calls completion with nil token", ^{
//                            expect(retLoginResponse).to.beNil();
//                        });
//
//                        it(@"calls completion with AFNetworking error", ^{
//                            expect(retError).to.equal(bogusError);
//                        });
//                    });
                });

                it(@"returns NO", ^{
                    expect(shouldStartLoad).to.beFalsy();
                });
            });
            
            context(@"request does NOT contain dropbox callback URL", ^{
                beforeEach(^{
                    fakeURLRequest = OCMClassMock([NSURLRequest class]);
                    OCMStub([fakeURLRequest oAuth2AuthorizationCode]).andReturn(nil);

                    shouldStartLoad = [controller webView:fakeWebView
                               shouldStartLoadWithRequest:fakeURLRequest
                                           navigationType:UIWebViewNavigationTypeFormSubmitted];
                });
                
                it(@"returns YES", ^{
                    expect(shouldStartLoad).to.beTruthy();
                });
            });
        });
        
        describe(@"#webViewDidFinishLoad:", ^{
            __block id hudClassMethodMock;
            
            beforeEach(^{
                hudClassMethodMock = OCMClassMock([MBProgressHUD class]);
                [controller webViewDidFinishLoad:fakeWebView];
            });
            
            it(@"removes the progress HUD", ^{
                OCMVerify([hudClassMethodMock hideHUDForView:controller.view
                                                    animated:YES]);
            });
        });

        describe(@"#webView:didFailLoadWithError:", ^{
            __block id hudClassMethodMock;
            __block Swizzlean *presentViewSwizz;
            __block UIViewController *retViewController;
            __block BOOL retAnimated;
            __block id retCompleted;
            __block NSError *bogusRequestError;
            
            beforeEach(^{
                hudClassMethodMock = OCMClassMock([MBProgressHUD class]);
                
                presentViewSwizz = [[Swizzlean alloc] initWithClassToSwizzle:[UIViewController class]];
                [presentViewSwizz swizzleInstanceMethod:@selector(presentViewController:animated:completion:)
                          withReplacementImplementation:^(id _self, UIViewController *viewController, BOOL animated, id completion) {
                              retViewController = viewController;
                              retAnimated = animated;
                              retCompleted = [completion copy];
                          }];
            });
            
            afterEach(^{
                retViewController = nil;
            });
            
            context(@"error code 102 (WebKitErrorDomain)", ^{
                beforeEach(^{
                    bogusRequestError = [NSError errorWithDomain:@"LameWebKitErrorThatHappensForNoGoodReason"
                                                            code:102
                                                        userInfo:@{ @"NSLocalizedDescription" : @"WTH Error"}];
                    
                    [controller webView:fakeWebView didFailLoadWithError:bogusRequestError];
                });
                
                it(@"does not display UIAlertController for the error", ^{
                    UIAlertController *errorAlertController = (UIAlertController *)retViewController;
                    expect(errorAlertController).to.beNil();
                });
                
                it(@"removes the progress HUD", ^{
                    OCMVerify([hudClassMethodMock hideHUDForView:controller.view
                                                        animated:YES]);
                });
            });
            
            context(@"all other error codes", ^{
                __block id partialMock;
                
                beforeEach(^{
                    bogusRequestError = [NSError errorWithDomain:@"NSURLBlowUpDomainBOOM"
                                                            code:42
                                                        userInfo:@{ @"NSLocalizedDescription" : @"You have no internetz and what not"}];
                });
                
//                context(@"shouldShowErrorAlert == YES", ^{
//                    beforeEach(^{
//                        controller.shouldShowErrorAlert = YES;
//                        [controller webView:fakeWebView didFailLoadWithError:bogusRequestError];
//                    });
//
//                    it(@"displays a UIAlertController with proper error", ^{
//                        UIAlertController *errorAlertController = (UIAlertController *)retViewController;
//                        expect(errorAlertController.title).to.equal(@"Dropbox Login Error");
//                        expect(errorAlertController.message).to.equal(@"NSURLBlowUpDomainBOOM - You have no internetz and what not");
//                    });
//                });
                
                context(@"shouldShowErrorAlert == NO", ^{
                    beforeEach(^{
                        controller.shouldShowErrorAlert = NO;
                        [controller webView:fakeWebView didFailLoadWithError:bogusRequestError];
                    });

                    it(@"does not display UIAlertController for the error", ^{
                        UIAlertController *errorAlertController = (UIAlertController *)retViewController;
                        expect(errorAlertController).to.beNil();
                    });
                });
                
//                context(@"has a navigation controlller", ^{
//                    beforeEach(^{
//                        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
//                        partialMock = OCMPartialMock(navigationController);
//
//                        [controller webView:fakeWebView didFailLoadWithError:bogusRequestError];
//                    });
//
//                    it(@"pops itself off the navigation controller", ^{
//                        OCMVerify([partialMock popViewControllerAnimated:YES]);
//                    });
//
//                    it(@"removes the progress HUD", ^{
//                        OCMVerify([hudClassMethodMock hideHUDForView:controller.view
//                                                            animated:YES]);
//                    });
//
//                    it(@"calls completion with nil token", ^{
//                        expect(retLoginResponse).to.beNil();
//                    });
//
//                    it(@"calls completion with request error", ^{
//                        expect(retError).to.equal(bogusRequestError);
//                    });
//                });
//
//                context(@"does NOT have a navigation controller", ^{
//                    beforeEach(^{
//                        partialMock = OCMPartialMock(controller);
//
//                        [controller webView:fakeWebView didFailLoadWithError:bogusRequestError];
//                    });
//
//                    it(@"pops itself off the view controller", ^{
//                        OCMVerify([partialMock dismissViewControllerAnimated:YES completion:nil]);
//                    });
//
//                    it(@"removes the progress HUD", ^{
//                        OCMVerify([hudClassMethodMock hideHUDForView:controller.view
//                                                            animated:YES]);
//                    });
//
//                    it(@"calls completion with nil token", ^{
//                        expect(retLoginResponse).to.beNil();
//                    });
//
//                    it(@"calls completion with request error", ^{
//                        expect(retError).to.equal(bogusRequestError);
//                    });
//                });
            });
        });
    });
});

SpecEnd
