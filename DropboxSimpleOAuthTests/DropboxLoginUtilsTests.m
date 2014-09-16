#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import "DropboxLoginUtils.h"


@interface DropboxLoginUtils ()

@property (copy, nonatomic, readwrite) NSString *appKey;
@property (strong, nonatomic, readwrite) NSURL *callbackURL;

@end

SpecBegin(DropboxLoginUtilsTests)

describe(@"DropboxLoginUtils", ^{
    __block DropboxLoginUtils *utils;
    
    beforeEach(^{
        utils = [[DropboxLoginUtils alloc] initWithAppKey:@"colt-45-it-works"
                                           andCallbackURL:[NSURL URLWithString:@"https://every-time.40oz"]];
    });
    
    it(@"has a clientID", ^{
        expect(utils.appKey).to.equal(@"colt-45-it-works");
    });
    
    it(@"has a callbackURL", ^{
        expect(utils.callbackURL).to.equal([NSURL URLWithString:@"https://every-time.40oz"]);
    });
    
    describe(@"#buildLoginRequest", ^{
        __block NSURLRequest *request;
        
        beforeEach(^{
            request = [utils buildLoginRequest];
        });
        
        it(@"builds proper login request for Dropbox login", ^{
            NSString *expectedLoginURLString = [NSString stringWithFormat:@"%@%@%@%@%@",
                                                @"https://www.dropbox.com",
                                                @"/1/oauth2/authorize?client_id=",
                                                @"colt-45-it-works",
                                                @"&response_type=code&redirect_uri=",
                                                @"https://every-time.40oz"];

            expect(request.URL.absoluteString).to.equal(expectedLoginURLString);
        });
    });
    
    describe(@"#requestHasAuthCode:", ^{
        __block BOOL requestContainsAuthCode;
        __block NSURLRequest *nonFancyURLRequest;
        
        context(@"request contains auth code", ^{
            beforeEach(^{
                nonFancyURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://every-time.40oz/?code=billieDeeWilliams"]];
                requestContainsAuthCode = [utils requestHasAuthCode:nonFancyURLRequest];
            });
            
            it(@"returns YES", ^{
                expect(requestContainsAuthCode).to.beTruthy();
            });
        });
        
        context(@"request DOES NOT contain auth code", ^{
            beforeEach(^{
                nonFancyURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://every-time.40oz/"]];
                requestContainsAuthCode = [utils requestHasAuthCode:nonFancyURLRequest];
            });
            
            it(@"returns NO", ^{
                expect(requestContainsAuthCode).to.beFalsy();
            });
        });
    });
    
    describe(@"#authCodeFromRequest:", ^{
        __block NSString *authCode;
        
        beforeEach(^{
            NSURLRequest *nonFancyURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://every-time.40oz/?code=LandoCalrissian"]];
            authCode = [utils authCodeFromRequest:nonFancyURLRequest];
        });
        
        it(@"returns the auth code", ^{
            expect(authCode).to.equal(@"LandoCalrissian");
        });
    });
});

SpecEnd