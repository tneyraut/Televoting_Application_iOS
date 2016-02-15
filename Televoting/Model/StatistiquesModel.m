//
//  StatistiquesModel.m
//  Televoting
//
//  Created by Thomas Mac on 13/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import "StatistiquesModel.h"

#import "User.h"

@interface StatistiquesModel()
{
    NSMutableData *_downloadedData;
}

@end

@implementation StatistiquesModel

- (void) getStatistiquesParticipantsByQuestionnaire:(int)questionnaire_id
{
    self.mode = 0;
    
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/getStatistiquesParticipantsByQuestionnaire.php?questionnaire_id=%d", questionnaire_id]];
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) getStatistiquesQuestionsByQuestionnaire:(int)questionnaire_id
{
    self.mode = 1;
    
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/getStatistiquesQuestionsByQuestionnaire.php?questionnaire_id=%d", questionnaire_id]];
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) getStatistiquesByQuestion:(int)question_id
{
    self.mode = 2;
    
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/getStatistiquesByQuestion.php?question_id=%d", question_id]];
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) getStatistiquesReponsesByQuestion:(int)question_id questionnaire_id:(int)questionnaire_id
{
    self.mode = 3;
    
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/getStatistiquesReponsesByQuestion.php?questionnaire_id=%d&question_id=%d", questionnaire_id, question_id]];
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
    NSMutableArray* _statistiques = [[NSMutableArray alloc] init];
    
    NSError* error;
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingAllowFragments error:&error];
    
    if (self.mode == 0)
    {
        for (int i=0;i<jsonArray.count;i++)
        {
            NSString *login = [jsonArray objectAtIndex:i][@"login"];
            NSString *note = [jsonArray objectAtIndex:i][@"note"];
            NSString *nombre_de_bonnes_reponses = [jsonArray objectAtIndex:i][@"nombre_de_bonnes_reponses"];
            NSString *nombre_de_fautes = [jsonArray objectAtIndex:i][@"nombre_de_fautes"];
            
            NSArray *array = [[NSArray alloc] initWithObjects:login, note, nombre_de_bonnes_reponses, nombre_de_fautes, nil];
            
            [_statistiques addObject:array];
        }
    }
    
    else if (self.mode == 1)
    {
        for (int i=0;i<jsonArray.count;i++)
        {
            NSString *nombre_de_bonnes_reponses = [jsonArray objectAtIndex:i][@"nombre_de_bonnes_reponses"];
            NSString *nombre_de_fautes = [jsonArray objectAtIndex:i][@"nombre_de_fautes"];
            NSString *nombre_de_participants = [jsonArray objectAtIndex:i][@"nombre_de_participants"];
            //NSString *nombre_de_reponses = [jsonArray objectAtIndex:i][@"nombre_de_reponses"];
            NSString *question = [jsonArray objectAtIndex:i][@"question"];
            
            NSString *pourcentageBonneReponse = [NSString stringWithFormat:@"%d", (int)([nombre_de_bonnes_reponses intValue] / [nombre_de_participants intValue] * 100)];
            
            NSString *pourcentageMauvaiseReponse = [NSString stringWithFormat:@"%d", (int)([nombre_de_fautes intValue] / [nombre_de_participants intValue] * 100)];
            
            NSArray *array = [[NSArray alloc] initWithObjects:question, nombre_de_bonnes_reponses, pourcentageBonneReponse, nombre_de_fautes, pourcentageMauvaiseReponse, nil];
            
            [_statistiques addObject:array];
        }
    }
    
    else if (self.mode == 2)
    {
        NSString *nombre_de_bonnes_reponses = [jsonArray objectAtIndex:0][@"nombre_de_bonnes_reponses"];
        NSString *nombre_de_fautes = [jsonArray objectAtIndex:0][@"nombre_de_fautes"];
        NSString *nombre_de_participants = [jsonArray objectAtIndex:0][@"nombre_de_participants"];
        //NSString *nombre_de_reponses = [jsonArray objectAtIndex:0][@"nombre_de_reponses"];
        NSString *question = [jsonArray objectAtIndex:0][@"question"];
        
        NSString *pourcentageBonneReponse = [NSString stringWithFormat:@"%d", (int)([nombre_de_bonnes_reponses intValue] / [nombre_de_participants intValue] * 100)];
        
        NSString *pourcentageMauvaiseReponse = [NSString stringWithFormat:@"%d", (int)([nombre_de_fautes intValue] / [nombre_de_participants intValue] * 100)];
        
        [_statistiques addObject:question];
        [_statistiques addObject:nombre_de_bonnes_reponses];
        [_statistiques addObject:pourcentageBonneReponse];
        [_statistiques addObject:nombre_de_fautes];
        [_statistiques addObject:pourcentageMauvaiseReponse];
    }
    
    else if (self.mode == 3)
    {
        for (int i=0;i<jsonArray.count;i++)
        {
            NSString *reponse = [jsonArray objectAtIndex:i][1];
            NSString *nombre_de_reponses = [jsonArray objectAtIndex:i][2];
            NSString *nombre_de_participant = [jsonArray objectAtIndex:i][3];
            
            NSString *pourcentage_nombre_de_reponses = [NSString stringWithFormat:@"%d", (int)([nombre_de_reponses intValue] / [nombre_de_participant intValue] * 100)];
            
            
            NSArray *array = [[NSArray alloc] initWithObjects:reponse, pourcentage_nombre_de_reponses, nil];
            
            [_statistiques addObject:array];
        }
    }
    
    if (self.delegate)
    {
        [self.delegate statistiquesDownloaded:_statistiques];
    }
}

@end
