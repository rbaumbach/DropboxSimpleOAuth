#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <AFNetworking/AFNetworking.h>
#import <RealFakes/RealFakes.h>
#import "DropboxLoginManager.h"
#import "DropboxSimpleOAuth.h"
#import "FakeDropboxOAuthResponse.h"


@interface DropboxLoginManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@end

SpecBegin(DropboxLoginManagerTests)

describe(@"DropboxLoginManager", ^{
    __block DropboxLoginManager *manager;
    __block FakeAFHTTPSessionManager *fakeSessionManager;
    
    beforeEach(^{
        manager = [[DropboxLoginManager alloc] initWithAppKey:@"SebastianBach"
                                                    appSecret:@"I-Love-Model-Trains"
                                                  callbackURL:[NSURL URLWithString:@"http://skid-row.18.2.life"]];
    });
    
    it(@"has clientID", ^{
        expect(manager.appKey).to.equal(@"SebastianBach");
    });
    
    it(@"has a clientSecret", ^{
        expect(manager.appSecret).to.equal(@"I-Love-Model-Trains");
    });
    
    it(@"has a callbackURL", ^{
        expect(manager.callbackURL).to.equal([NSURL URLWithString:@"http://skid-row.18.2.life"]);
    });
    
    it(@"has an AFHTTPSessionManager", ^{
        expect(manager.sessionManager).to.beInstanceOf([AFHTTPSessionManager class]);
        expect(manager.sessionManager.baseURL).to.equal([NSURL URLWithString:@"https://www.dropbox.com"]);
        expect(manager.sessionManager.responseSerializer).to.beInstanceOf([AFJSONResponseSerializer class]);
    });
    
    describe(@"#authenticateWithAuthCode:success:failure:", ^{
        __block DropboxLoginResponse *retLoginResponse;
        __block NSError *retError;
        
        beforeEach(^{
            fakeSessionManager = [[FakeAFHTTPSessionManager alloc] init];
            manager.sessionManager = fakeSessionManager;
            
            [manager authenticateWithAuthCode:@"SwayzieXpress"
                                      success:^(DropboxLoginResponse *dropboxLoginResponse) {
                                          retLoginResponse = dropboxLoginResponse;
                                      } failure:^(NSError *error) {
                                          retError = error;
                                      }];
        });
        
        context(@"on success", ^{
            __block id fakeLoginResponse;
            
            beforeEach(^{
                fakeLoginResponse = OCMClassMock([DropboxLoginResponse class]);
                
                if (fakeSessionManager.postSuccessBlock) {
                    fakeSessionManager.postSuccessBlock(nil, [FakeDropboxOAuthResponse response]);
                }
            });

            it(@"makes a POST call with the correct endpoint and parameters to Dropbox", ^{
                expect(fakeSessionManager.postURLString).to.equal(@"/1/oauth2/token");
                expect(fakeSessionManager.postParameters).to.equal(@{ @"client_id"     : manager.appKey,
                                                                      @"client_secret" : manager.appSecret,
                                                                      @"grant_type"    : @"authorization_code",
                                                                      @"redirect_uri"  : manager.callbackURL.absoluteString,
                                                                      @"code"          : @"SwayzieXpress" });
            });
            
            it(@"calls success with dropboxLoginResponse", ^{
                expect(retLoginResponse).to.beInstanceOf([DropboxLoginResponse class]);
                expect(retLoginResponse.accessToken).to.equal(@"Video-Arcade-Token");
                expect(retLoginResponse.tokenType).to.equal(@"type0");
                expect(retLoginResponse.uid).to.equal(@"some-dudes-id-1001");
            });
        });
        
        context(@"on failure", ^{
            __block id fakeError;
            
            beforeEach(^{
                fakeError = OCMClassMock([NSError class]);
                
                if (fakeSessionManager.postFailureBlock) {
                    fakeSessionManager.postFailureBlock(nil, fakeError);
                }
            });
            
            it(@"calls failure block", ^{
                expect(retError).to.equal(fakeError);
            });
        });
    });
});

SpecEnd