//
//  ResultatModel.m
//  Televoting
//
//  Created by Thomas Mac on 30/06/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import "ResultatModel.h"

@interface ResultatModel () {
    NSMutableData* _downloadedDataResultat;
}

@end

@implementation ResultatModel

- (void) getResultatsByUser:(int)user_id questionnaire_id:(int)questionnaire_id
{
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/getResultatsByUser.php?user_id=%d&questionnaire_id=%d", user_id, questionnaire_id]];
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    _downloadedDataResultat = [[NSMutableData alloc] init];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_downloadedDataResultat appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    NSMutableArray* _resultats = [[NSMutableArray alloc] init];
    
    NSError* error;
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:_downloadedDataResultat options:NSJSONReadingAllowFragments error:&error];
    
    [_resultats addObject:jsonArray[0][@"cours_name"]];
    [_resultats addObject:jsonArray[0][@"questionnaire_name"]];
    
    [_resultats addObject:jsonArray[1][@"nombre_de_bonnes_reponses"]];
    [_resultats addObject:jsonArray[1][@"nombre_de_fautes"]];
    [_resultats addObject:jsonArray[1][@"note"]];
    
    [_resultats addObject:jsonArray[2][@"moyenneNote"]];
    
    [_resultats addObject:jsonArray[3][@"maxNote"]];
    
    [_resultats addObject:jsonArray[4][@"minNote"]];
    
    [_resultats addObject:jsonArray[5][@"moyenneNombreBonnesReponses"]];
    
    [_resultats addObject:jsonArray[6][@"moyenneNombreFautes"]];
    
    [_resultats addObject:jsonArray[7]];
    
    [_resultats addObject:jsonArray[8]];
    
    if (self.delegate) {
        [self.delegate getResultatsDownloaded:_resultats];
    }
}

@end
