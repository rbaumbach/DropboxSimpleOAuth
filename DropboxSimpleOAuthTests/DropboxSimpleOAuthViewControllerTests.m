#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import "DropboxSimpleOAuth.h"


SpecBegin(DropboxSimpleOAuthViewControllerTests)

describe(@"DropboxSimpleOAuthViewController", ^{
    __block DropboxSimpleOAuthViewController *controller;
    
    beforeEach(^{
        controller = [[DropboxSimpleOAuthViewController alloc] init];
    });
    
    it(@"exists", ^{
        expect(controller).notTo.beNil();
    });
});

SpecEnd