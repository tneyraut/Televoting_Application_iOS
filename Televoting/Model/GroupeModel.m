//
//  GroupeModel.m
//  Televoting
//
//  Created by Thomas Mac on 05/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import "GroupeModel.h"

#import "Groupe.h"

@interface GroupeModel()
{
    NSMutableData* _downloadedData;
}

@end

@implementation GroupeModel

- (void) getListeGroupesByCours:(int)cours_id
{
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/listeGroupesByCours.php?cours_id=%d", cours_id]];
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    _downloadedData = [[NSMutableData alloc] init];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_downloadedData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    NSMutableArray* _groupes = [[NSMutableArray alloc] init];
    
    NSError* error;
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingAllowFragments error:&error];
    
    for (int i=0;i<jsonArray.count;i++)
    {
        NSDictionary *jsonElement = jsonArray[i];
        
        Groupe *groupe = [[Groupe alloc] init];
        
        groupe.groupe_id = [jsonElement[@"groupe_id"] intValue];
        groupe.groupe_name = (NSString*)jsonElement[@"groupe_name"];
        
        [_groupes addObject:groupe];
    }
    
    if (self.delegate)
    {
        [self.delegate groupesDownloaded:_groupes];
    }
}

@end
