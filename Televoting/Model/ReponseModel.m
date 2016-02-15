//
//  ReponseModel.m
//  Mines Douai Televoting
//
//  Created by Thomas Mac on 11/04/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import "ReponseModel.h"
#import "Reponse.h"

@interface ReponseModel() {
    NSMutableData* _downloadedData;
}

@end

@implementation ReponseModel

- (void) getReponsesByQuestion:(int)question_id {
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/listeReponsesByQuestion.php?question_id=%d", question_id]];
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) updateReponse:(int)reponse_id reponse:(NSString *)reponse reponse_correcte:(int)reponse_correcte question_suivante_id:(int)question_suivante_id
{
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/updateReponse.php?reponse_id=%d&reponse=%@&reponse_correcte=%d&question_suivante_id=%d", reponse_id, [reponse stringByReplacingOccurrencesOfString:@" " withString:@"_"], reponse_correcte, question_suivante_id]];
    
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) creerReponse:(int)question_id reponse:(NSString *)reponse reponse_correcte:(int)reponse_correcte question_suivante_id:(int)question_suivante_id
{
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/creationReponse.php?question_id=%d&reponse=%@&reponse_correcte=%d&question_suivante_id=%d", question_id, [reponse stringByReplacingOccurrencesOfString:@" " withString:@"_"], reponse_correcte, question_suivante_id]];
    
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) supprimerReponse:(int)reponse_id
{
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/supprimerReponse.php?reponse_id=%d", reponse_id]];
    
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
    NSMutableArray* _reponses = [[NSMutableArray alloc] init];
    
    NSError* error;
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingAllowFragments error:&error];
    
    for (int i=0;i<jsonArray.count; i++) {
        NSDictionary* jsonElement = jsonArray[i];
        Reponse* uneReponse = [[Reponse alloc] init];
        uneReponse.reponse_id = [jsonElement[@"reponse_id"] intValue];
        uneReponse.question_id = [jsonElement[@"question_id"] intValue];
        uneReponse.reponse = jsonElement[@"reponse"];
        uneReponse.reponse_correcte = [jsonElement[@"reponse_correcte"] boolValue];
        uneReponse.image = jsonElement[@"image"];
        [_reponses addObject:uneReponse];
    }
    if (self.delegate) {
        [self.delegate reponseDownloaded:_reponses];
    }
}

@end
