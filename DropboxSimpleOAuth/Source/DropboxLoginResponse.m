//Copyright (c) 2016 Ryan Baumbach <github@ryan.codes>
//
//Permission is hereby granted, free of charge, to any person obtaining
//a copy of this software and associated documentation files (the "Software"),
//to deal in the Software without restriction, including
//without limitation the rights to use, copy, modify, merge, publish,
//distribute, sublicense, and/or sell copies of the Software, and to
//permit persons to whom the Software is furnished to do so, subject to
//the following conditions:
//
//The above copyright notice and this permission notice shall be
//included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "DropboxLoginResponse.h"


NSString *const DropboxAccessTokenKey = @"access_token";
NSString *const DropboxTokenTypeKey = @"token_type";
NSString *const DropboxUidKey = @"uid";

@interface DropboxLoginResponse ()

@property (copy, nonatomic, readwrite) NSString *accessToken;
@property (copy, nonatomic, readwrite) NSString *tokenType;
@property (copy, nonatomic, readwrite) NSString *uid;

@end

@implementation DropboxLoginResponse

#pragma mark - Init Methods

- (instancetype)initWithDropboxOAuthResponse:(NSDictionary *)response;
{
    self = [super init];
    if (self) {
        if (response) {
            self.accessToken = response[DropboxAccessTokenKey];
            self.tokenType = response[DropboxTokenTypeKey];
            self.uid = response[DropboxUidKey];
        }
    }
    return self;
}

@end
