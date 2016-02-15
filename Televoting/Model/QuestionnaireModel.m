//
//  QuestionnaireModel.m
//  Mines Douai Televoting
//
//  Created by Thomas Mac on 11/04/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import "QuestionnaireModel.h"
#import "Questionnaire.h"

@interface QuestionnaireModel() {
    NSMutableData* _downloadedData;
}

@end

@implementation QuestionnaireModel

- (void) getQuestionnairesByCours:(int)cours_id user_id:(int)userID {
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/listeQuestionnairesByCours.php?cours_id=%d&user_id=%d", cours_id, userID]];
    
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) getAllQuestionnairesByCours:(int)cours_id
{
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/listeAllQuestionnairesByCours.php?cours_id=%d", cours_id]];
    
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) updateQuestionnaire:(int)questionnaire_id questionnaire_name:(NSString *)questionnaire_name mode_examen:(BOOL)mode_examen pause:(BOOL)pause lancee:(BOOL)lancee malus:(float)malus
{
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/updateQuestionnaire.php?questionnaire_id=%d&questionnaire_name=%@&mode_examen=%d&pause=%d&lancee=%d&malus=%f", questionnaire_id, [questionnaire_name stringByReplacingOccurrencesOfString:@" " withString:@"_"], mode_examen, pause, lancee, malus]];
    
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void)creerQuestionnaire:(int)cours_id questionnaire_name:(NSString *)questionnaire_name
{
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/creationQuestionnaire.php?cours_id=%d&questionnaire_name=%@", cours_id, [questionnaire_name stringByReplacingOccurrencesOfString:@" " withString:@"_"]]];
    
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) reinitialisationQuestionnaire:(int)questionnaire_id
{
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/reinitialisationQuestionnaire.php?questionnaire_id=%d", questionnaire_id]];
    
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) supprimerQuestionnaire:(int)questionnaire_id
{
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/supprimerQuestionnaire.php?questionnaire_id=%d", questionnaire_id]];
    
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
    NSMutableArray* _questionnaires = [[NSMutableArray alloc] init];
 
    NSError* error;
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingAllowFragments error:&error];
    
    for (int i=0;i<jsonArray.count; i++) {
        NSDictionary* jsonElement = jsonArray[i];
        Questionnaire* unQuestionnaire = [[Questionnaire alloc] init];
        unQuestionnaire.questionnaire_id = [jsonElement[@"questionnaire_id"] intValue];
        unQuestionnaire.cours_id = [jsonElement[@"cours_id"] intValue];
        unQuestionnaire.questionnaire_name = jsonElement[@"questionnaire_name"];
        unQuestionnaire.mode_examen = [jsonElement[@"mode_examen"] boolValue];
        unQuestionnaire.malus = [jsonElement[@"malus"] floatValue];
        unQuestionnaire.pause = [jsonElement[@"pause"] boolValue];
        [_questionnaires addObject:unQuestionnaire];
    }
    
    if (self.delegate) {
        [self.delegate questionnaireDownloaded:_questionnaires];
    }
}

@end
