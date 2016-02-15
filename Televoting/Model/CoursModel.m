//
//  CoursModel.m
//  Mines Douai Televoting
//
//  Created by Thomas Mac on 11/04/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import "CoursModel.h"
#import "Cours.h"

@interface CoursModel () {
    NSMutableData* _downloadedData;
}

@end

@implementation CoursModel

- (void) getCoursAFaire:(int)user_id {
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat: @"http://isic.mines-douai.fr/televoting/services/listeCoursAFaire.php?user_id=%d", user_id]];
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) getAllCoursByUser:(int)user_id
{
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat: @"http://isic.mines-douai.fr/televoting/services/listeCours.php?user_id=%d", user_id]];
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) getListeCoursProfesseur:(int)user_id
{
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat: @"http://isic.mines-douai.fr/televoting/services/listeCoursProfesseur.php?user_id=%d", user_id]];
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
    NSMutableArray* _cours = [[NSMutableArray alloc] init];
    
    NSError* error;
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingAllowFragments error:&error];
    
    for (int i=0;i<jsonArray.count; i++) {
        NSDictionary* jsonElement = jsonArray[i];
        Cours* newCours = [[Cours alloc] init];
        newCours.cours_id = [jsonElement[@"cours_id"] intValue];
        newCours.user_id = [jsonElement[@"user_id"] intValue];
        newCours.cours_name = jsonElement[@"cours_name"];
        newCours.annee = [jsonElement[@"annee"] intValue];
        [_cours addObject:newCours];
    }
    if (self.delegate) {
        [self.delegate coursDownloaded:_cours];
    }
}

@end
