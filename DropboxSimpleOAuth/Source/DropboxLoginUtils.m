//Copyright (c) 2014 Ryan Baumbach <rbaumbach.github@gmail.com>
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

#import "DropboxLoginUtils.h"
#import "DropboxConstants.h"


NSString *const DropboxAuthClientIDEndpoint = @"/1/oauth2/authorize?client_id=";
NSString *const DropboxAuthRequestParams = @"&response_type=code&redirect_uri=";
NSString *const DropboxAuthCodeParam = @"/?code=";

@interface DropboxLoginUtils ()

@property (copy, nonatomic, readwrite) NSString *appKey;
@property (strong, nonatomic, readwrite) NSURL *callbackURL;

@end

@implementation DropboxLoginUtils

#pragma mark - Init Methods

- (instancetype)initWithAppKey:(NSString *)appKey
                andCallbackURL:(NSURL *)callbackURL;
{
    self = [super init];
    if (self) {
        self.appKey = appKey;
        self.callbackURL = callbackURL;
    }
    return self;
}

#pragma mark - Public Methods

- (NSURLRequest *)buildLoginRequest
{
    NSURL *fullDrooboxLoginURL = [NSURL URLWithString:[self dropboxLoginURLString]];
    return [NSURLRequest requestWithURL:fullDrooboxLoginURL];
}

- (BOOL)requestHasAuthCode:(NSURLRequest *)request
{
    NSString *requestURLString = request.URL.absoluteString;
    NSString *callbackWithAuthParam = [self callbackWithAuthCode];
    
    return [requestURLString hasPrefix:callbackWithAuthParam];
}

- (NSString *)authCodeFromRequest:(NSURLRequest *)request
{
    NSString *requestURLString = request.URL.absoluteString;
    NSString *callbackWithAuthParam = [self callbackWithAuthCode];
    
    return [requestURLString substringFromIndex:[callbackWithAuthParam length]];
}

#pragma mark - Private Methods

- (NSString *)dropboxLoginURLString
{
    return [NSString stringWithFormat:@"%@%@%@%@%@",
            DropboxAuthURL,
            DropboxAuthClientIDEndpoint,
            self.appKey,
            DropboxAuthRequestParams,
            self.callbackURL.absoluteString];
}

- (NSString *)callbackWithAuthCode
{
    return [NSString stringWithFormat:@"%@%@", self.callbackURL.absoluteString, DropboxAuthCodeParam];
}

@end
