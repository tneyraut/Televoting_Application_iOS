//
//  RetardModel.m
//  Televoting
//
//  Created by Thomas Mac on 25/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import "RetardModel.h"

@interface RetardModel ()
{
    NSMutableData* _downloadedRetards;
}

@end

@implementation RetardModel

- (void)creationRetard:(int)user_id cours_id:(int)cours_id date_value:(NSString *)date_value
{
    NSURL* jsonFileUrl = [NSURL URLWithString:[[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/creationRetard.php?user_id=%d&cours_id=%d&date_value=", user_id, cours_id] stringByAppendingString:date_value]];
    
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _downloadedRetards = [[NSMutableData alloc] init];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_downloadedRetards appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSMutableArray* _retards = [[NSMutableArray alloc] init];
    
    if (self.delegate)
    {
        [self.delegate retardsDownloaded:_retards];
    }
}

@end
