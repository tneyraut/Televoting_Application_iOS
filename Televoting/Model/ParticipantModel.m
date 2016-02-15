//
//  ParticipantModel.m
//  Mines Douai Televoting
//
//  Created by Thomas Mac on 11/04/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import "ParticipantModel.h"
#import "Participant.h"

@interface ParticipantModel() {
    NSMutableData* _downloadedData;
}

@end

@implementation ParticipantModel

- (void) creationParticipant:(int)user_id uneAnnee:(int)annee {
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/creationParticipant.php?user_id=%d&annee=%d",user_id,annee]];
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) updateParticipant:(int)user_id fautes:(int)nombre_de_fautes bonnesReponses:(int)nombre_de_bonnes_reponses ident:(int)questionnaire_id {
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/updateParticipant.php?user_id=%d&nombre_de_fautes=%d&nombre_de_bonnes_reponses=%d&questionnaire_id=%d",user_id,nombre_de_fautes,nombre_de_bonnes_reponses,questionnaire_id]];
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    _downloadedData = [[NSMutableData alloc] init];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_downloadedData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.delegate)
    {
        [self.delegate participantActionDone];
    }
}

@end
