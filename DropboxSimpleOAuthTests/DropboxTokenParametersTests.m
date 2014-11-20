#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import "DropboxTokenParameters.h"


SpecBegin(DropboxTokenParametersTests)

describe(@"DropboxTokenParameters", ^{
    __block DropboxTokenParameters *tokenParameters;
    
    beforeEach(^{
        tokenParameters = [[DropboxTokenParameters alloc] init];
        tokenParameters.appKey = @"client";
        tokenParameters.appSecret = @"secret";
        tokenParameters.callbackURLString = @"http://whatever.com";
        tokenParameters.authorizationCode = @"iua0f9us09iasdf";
    });
    
    it(@"has clientID", ^{
        expect(tokenParameters.appKey).to.equal(@"client");
    });
    
    it(@"has clientSecret", ^{
        expect(tokenParameters.appSecret).to.equal(@"secret");
    });
    
    it(@"has callbackURLString", ^{
        expect(tokenParameters.callbackURLString).to.equal(@"http://whatever.com");
    });
    
    it(@"has authorizationCode", ^{
        expect(tokenParameters.authorizationCode).to.equal(@"iua0f9us09iasdf");
    });
    
    describe(@"<TokenParameters>", ^{
        describe(@"#build", ^{
            __block NSDictionary *tokenParametersDict;
            
            beforeEach(^{
                tokenParametersDict = [tokenParameters build];
            });
            
            it(@"builds tokenParameters dictionary", ^{
                NSDictionary *expectedTokenParametersDict = @{ @"client_id"     : tokenParameters.appKey,
                                                               @"client_secret" : tokenParameters.appSecret,
                                                               @"grant_type"    : @"authorization_code",
                                                               @"redirect_uri"  : tokenParameters.callbackURLString,
                                                               @"code"          : tokenParameters.authorizationCode
                                                               };
                
                expect(tokenParametersDict).to.equal(expectedTokenParametersDict);
            });
        });
    });
});

SpecEnd