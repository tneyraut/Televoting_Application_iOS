//
//  PropositionReponseModel.m
//  Mines Douai Televoting
//
//  Created by Thomas Mac on 11/04/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import "PropositionReponseModel.h"
#import "PropositionReponse.h"

@interface PropositionReponseModel() {
    NSMutableData* _downloadedData;
}

@end

@implementation PropositionReponseModel

- (void) creationPropositionReponse:(int)user_id questionnaireID:(int)questionnaire_id questionID:(int)question_id {
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/creationPropositionReponse.php?user_id=%d&questionnaire_id=%d&question_id=%d",user_id,questionnaire_id,question_id]];
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) updatePropositionReponse:(int)user_id questionnaireID:(int)questionnaire_id questionID:(int)question_id reponseID:(int)reponse_id {
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/updatePropositionReponse.php?user_id=%d&questionnaire_id=%d&question_id=%d&reponse_id=%d",user_id,questionnaire_id,question_id,reponse_id]];
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) creationPropositionReponseComplete:(int)user_id questionnaireID:(int)questionnaire_id questionID:(int)question_id reponseID:(int)reponse_id {
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/creationPropositionReponseComplete.php?user_id=%d&questionnaire_id=%d&question_id=%d&reponse_id=%d",user_id,questionnaire_id,question_id,reponse_id]];
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
        [self.delegate propositionReponseActionDone];
    }
}

@end
