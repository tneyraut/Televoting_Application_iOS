//
//  UserModel.m
//  Mines Douai Televoting
//
//  Created by Thomas Mac on 11/04/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import "UserModel.h"
#import "User.h"

@interface UserModel () {
    NSMutableData* _downloadedDataUser;
}

@end

@implementation UserModel

- (void) getUser:(NSString *)login pass:(NSString *)password{
    NSURL* jsonFileUrl = [NSURL URLWithString:[[[@"http://isic.mines-douai.fr/televoting/services/getUser.php?login=" stringByAppendingString:login] stringByAppendingString:@"&password="] stringByAppendingString:password]];
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) getListeElevesByGroupe:(int)groupe_id
{
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/listeElevesByGroupe.php?groupe_id=%d", groupe_id]];
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    _downloadedDataUser = [[NSMutableData alloc] init];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_downloadedDataUser appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    NSMutableArray* _user = [[NSMutableArray alloc] init];
    
    NSError* error;
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:_downloadedDataUser options:NSJSONReadingAllowFragments error:&error];
    
    for (int i=0;i<jsonArray.count; i++) {
        NSDictionary* jsonElement = jsonArray[i];
        
        User* user = [[User alloc] init];
        
        user.user_id = [jsonElement[@"user_id"] intValue];
        user.annee = [jsonElement[@"annee"] intValue];
        user.login = (NSString*)jsonElement[@"login"];
        user.professeur = [jsonElement[@"professeur"] boolValue];
        
        [_user addObject:user];
    }
    if (self.delegate) {
        [self.delegate getUserDownloaded:_user];
    }
}

@end
