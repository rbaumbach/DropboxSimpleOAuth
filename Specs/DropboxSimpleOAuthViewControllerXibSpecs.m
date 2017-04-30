#import <Expecta/Expecta.h>
#import <Specta/Specta.h>
#import "NSLayoutConstraint+TestUtils.h"
#import "DropboxSimpleOAuth.h"


SpecBegin(DropboxSimpleOAuthViewControllerXibTests)

describe(@"DropboxSimpleOAuthViewControllerXib", ^{
    __block DropboxSimpleOAuthViewController *controller;
    __block UIView *dropboxView;
    __block UIWebView *dropboxWebView;
    
    beforeEach(^{
        // controller is only loaded for ownership needs when loading the nib from the bundle
        controller = [[DropboxSimpleOAuthViewController alloc] init];
        
        NSBundle *bundle = [NSBundle bundleForClass:[DropboxSimpleOAuthViewController class]];
        
        NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"DropboxSimpleOAuthViewController"
                                                          owner:controller
                                                        options:nil];
        
        dropboxView = nibViews[0];
        
        dropboxWebView = dropboxView.subviews[0]; // only subview of the main view
    });
    
    describe(@"dropbox web view", ^{
        it(@"s delegate is the file'z owner", ^{
            expect(dropboxWebView.delegate).to.equal(controller);
        });
    });
    
    describe(@"constraints", ^{
        it(@"has at least 4 constraints", ^{
            expect(dropboxView.constraints.count).to.beGreaterThanOrEqualTo(4);
        });
        
        it(@"has Vertical Space - dropboxWebView to View", ^{
            NSLayoutConstraint *expectedConstraint = [NSLayoutConstraint constraintWithItem:dropboxWebView
                                                                                  attribute:NSLayoutAttributeTop
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:dropboxView
                                                                                  attribute:NSLayoutAttributeTop
                                                                                 multiplier:1
                                                                                   constant:0];
            expectedConstraint.priority = 1000;
            expectedConstraint.shouldBeArchived = YES;
            
            expect(dropboxView.constraints).to.contain(expectedConstraint);
        });
        
        it(@"has Horizontal Space - View to dropboxWebView", ^{
            NSLayoutConstraint *expectedConstraint = [NSLayoutConstraint constraintWithItem:dropboxView
                                                                                  attribute:NSLayoutAttributeTrailing
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:dropboxWebView
                                                                                  attribute:NSLayoutAttributeTrailing
                                                                                 multiplier:1
                                                                                   constant:0];
            expectedConstraint.priority = 1000;
            expectedConstraint.shouldBeArchived = YES;
            
            expect(dropboxView.constraints).to.contain(expectedConstraint);
        });
        
        it(@"has Vertical Space - View to dropboxWebView", ^{
            NSLayoutConstraint *expectedConstraint = [NSLayoutConstraint constraintWithItem:dropboxView
                                                                                  attribute:NSLayoutAttributeBottom
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:dropboxWebView
                                                                                  attribute:NSLayoutAttributeBottom
                                                                                 multiplier:1
                                                                                   constant:0];
            expectedConstraint.priority = 1000;
            expectedConstraint.shouldBeArchived = YES;
            
            expect(dropboxView.constraints).to.contain(expectedConstraint);
        });
        
        it(@"has Horizontal Space - dropboxWebView to View", ^{
            NSLayoutConstraint *expectedConstraint = [NSLayoutConstraint constraintWithItem:dropboxWebView
                                                                                  attribute:NSLayoutAttributeLeading
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:dropboxView
                                                                                  attribute:NSLayoutAttributeLeading
                                                                                 multiplier:1
                                                                                   constant:0];
            expectedConstraint.priority = 1000;
            expectedConstraint.shouldBeArchived = YES;
            
            expect(dropboxView.constraints).to.contain(expectedConstraint);
        });
    });
});

SpecEnd
