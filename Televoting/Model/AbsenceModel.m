//
//  AbsenceModel.m
//  Televoting
//
//  Created by Thomas Mac on 25/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import "AbsenceModel.h"

@interface AbsenceModel ()
{
    NSMutableData* _downloadedAbsences;
}

@end

@implementation AbsenceModel

- (void)creationAbsence:(int)user_id cours_id:(int)cours_id date_value:(NSString *)date_value
{
    NSURL* jsonFileUrl = [NSURL URLWithString:[[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/creationAbsence.php?user_id=%d&cours_id=%d&date_value=", user_id, cours_id] stringByAppendingString:date_value]];
    
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _downloadedAbsences = [[NSMutableData alloc] init];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_downloadedAbsences appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSMutableArray* _absences = [[NSMutableArray alloc] init];
    
    if (self.delegate)
    {
        [self.delegate absencesDownloaded:_absences];
    }
}

@end
