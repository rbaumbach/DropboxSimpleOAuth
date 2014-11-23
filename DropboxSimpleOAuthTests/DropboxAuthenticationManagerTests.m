#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <SimpleOAuth2/SimpleOAuth2.h>
#import <RealFakes/RealFakes.h>
#import "FakeDropboxOAuthResponse.h"
#import "DropboxAuthenticationManager.h"
#import "DropboxLoginResponse.h"
#import "DropboxTokenParameters.h"


@interface DropboxAuthenticationManager ()

@property (copy, nonatomic) NSString *appKey;
@property (copy, nonatomic) NSString *appSecret;
@property (copy, nonatomic) NSString *callbackURLString;
@property (copy, nonatomic) SimpleOAuth2AuthenticationManager *simpleOAuth2AuthenticationManager;

@end

SpecBegin(DropboxAuthenticationManagerTests)

describe(@"DropboxAuthenticationManager", ^{
    __block DropboxAuthenticationManager *dropboxAuthenticationManager;
    
    beforeEach(^{
        dropboxAuthenticationManager = [[DropboxAuthenticationManager alloc] initWithAppKey:@"give-me-the-keys"
                                                                                  appSecret:@"spilling-beans"
                                                                          callbackURLString:@"http://call-me-back.8675309"];
    });
    
    it(@"has an appKey", ^{
        expect(dropboxAuthenticationManager.appKey).to.equal(@"give-me-the-keys");
    });
    
    it(@"has an appSecret", ^{
        expect(dropboxAuthenticationManager.appSecret).to.equal(@"spilling-beans");
    });
    
    it(@"has a callbackURLString", ^{
        expect(dropboxAuthenticationManager.callbackURLString).to.equal(@"http://call-me-back.8675309");
    });
    
    it(@"has a simpleOAuth2AuthenticationManager", ^{
        expect(dropboxAuthenticationManager.simpleOAuth2AuthenticationManager).to.beInstanceOf([SimpleOAuth2AuthenticationManager class]);
    });
    
    describe(@"#authenticateClientWithAuthCode:success:failure:", ^{
        __block FakeSimpleOAuth2AuthenticationManager *fakeSimpleAuthManager;
        __block DropboxLoginResponse *dropboxLoginResponse;
        __block NSError *authError;
        
        beforeEach(^{
            fakeSimpleAuthManager = [[FakeSimpleOAuth2AuthenticationManager alloc] init];
            dropboxAuthenticationManager.simpleOAuth2AuthenticationManager = fakeSimpleAuthManager;
            
            [dropboxAuthenticationManager authenticateClientWithAuthCode:@"SF-Giants-The-Best"
                                                                 success:^(DropboxLoginResponse *response) {
                                                                     dropboxLoginResponse = response;
                                                                 } failure:^(NSError *error) {
                                                                     authError = error;
                                                                 }];
        });
        
        it(@"is called with authURL", ^{
            expect(fakeSimpleAuthManager.authURL).to.equal([NSURL URLWithString:@"https://www.dropbox.com/1/oauth2/token"]);
        });
        
        it(@"is called with token parameters", ^{
            DropboxTokenParameters *tokenParameters = (DropboxTokenParameters *)fakeSimpleAuthManager.tokenParameters;
            
            expect(tokenParameters.appKey).to.equal(@"give-me-the-keys");
            expect(tokenParameters.appSecret).to.equal(@"spilling-beans");
            expect(tokenParameters.callbackURLString).to.equal(@"http://call-me-back.8675309");
            expect(tokenParameters.authorizationCode).to.equal(@"SF-Giants-The-Best");
        });
        
        context(@"On Success", ^{
            beforeEach(^{
                if (fakeSimpleAuthManager.success) {
                    fakeSimpleAuthManager.success([FakeDropboxOAuthResponse response]);
                }
            });

            it(@"calls success block with DropboxLoginResponse", ^{
                expect(dropboxLoginResponse.accessToken).to.equal(@"Video-Arcade-Token");
                expect(dropboxLoginResponse.tokenType).to.equal(@"type0");
                expect(dropboxLoginResponse.uid).to.equal(@"some-dudes-id-1001");
            });
        });
        
        context(@"On Failure", ^{
            __block id fakeError;
            
            beforeEach(^{
                fakeError = OCMClassMock([NSError class]);
                
                if (fakeSimpleAuthManager.failure) {
                    fakeSimpleAuthManager.failure(fakeError);
                }
            });
            
            it(@"calls simpleOAuth failure block with error", ^{
                expect(authError).to.equal(fakeError);
            });
        });
    });
});

SpecEnd