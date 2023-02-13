@RestResource(urlMapping='/ConventionService/*')
global with sharing class ConventionServiceWebService{

//global List<emplacement> emplacement;
//Wrapper defined Class
global class CVSWrapper{
    global String dk_code_cvs;
    global String libelle;
    global String statut;
    global Date date_debut;
    //String dk_code_contrat;
    String dk_code_emplacement;
    public List<Emplacement> emplacement;
 }

   public class Emplacement{
    public String dk_code_emplacement;
   }
 public static CVSWrapper parse(String json){
        return (CVSWrapper) System.JSON.deserialize(json, CVSWrapper.class);
    }





@HttpPut
global static /*List<ConventionService__c>*/ void UpsertConventionService() {

   
 String requestBodyCVS = RestContext.request.requestBody.toString();
 //CVSWrapper lcvsw = (CVSWrapper) JSON.deserialize(requestBody, CVSWrapper.class);
 
 CVSWrapper lcvsw = (CVSWrapper) JSON.deserialize(requestBodyCVS, CVSWrapper.class);
 
//Map<String, CVSWrapper> results = (Map<String, CVSWrapper>)JSON.deserializeUntyped(requestBodyCVS);
//system.debug('results :'+results);
//List<ConventionServiceWebService.emplacement> lstOrderLines = (List<ConventionServiceWebService.emplacement>)results.get('emplacement');
//List<CVSWrapper> lcvsw = (List<CVSWrapper>)JSON.deserialize(jsonString, CVSWrapper.class);
system.debug('lcvsw :'+lcvsw);
system.debug('lcvsw.dk_code_cvs :'+lcvsw.dk_code_cvs);
system.debug('lcvsw.emplacement :'+lcvsw.emplacement);




 //String requestBodyEMP = RestContext.request.requestBody.toString();
 ConventionServiceWebService.emplacement lcew = (ConventionServiceWebService.emplacement) JSON.deserialize(requestBodyCVS, ConventionServiceWebService.emplacement.class);
//List<LienConventionEmplacement> lcew = (List<LienConventionEmplacement>) JSON.deserialize(requestBodyCVS, CVSWrapper.emplacement.class);
system.debug('lcew :'+lcew);

List<String> cvsCodes = new List<String>();
Map<String, CVSWrapper> cvsMap = new Map<String, CVSWrapper>();
   
//Map<String, lcvsw.emplacement> empNewMap = new Map<String, lcvsw.emplacement>();
//system.debug('empNewMap :'+empNewMap);

List<String> emplacementCodes = new List<String>();

    cvsCodes.add(lcvsw.dk_code_cvs); 
    cvsMap.put(lcvsw.dk_code_cvs, lcvsw);




List<ConventionService__c> Listconventionservice = [SELECT Id,  DKCodeCVS__c, Name, Statut__c, DateDebut__c, DKCodeContrat__c, DKCodeEmplacement__c FROM ConventionService__c WHERE DKCodeCVS__c in : cvsCodes];
List<ConventionService__c> ListConventionServiceUpdate = new List<ConventionService__c>();
//List<ConventionService__c> ListConventionServiceNotExistUpdate = new List<ConventionService__c>();

if(Listconventionservice.size() > 0){
    for(ConventionService__c cvs: Listconventionservice){
        CVSWrapper cvsw = cvsMap.get(cvs.DKCodeCVS__c);
        cvs.DKCodeCVS__c = cvsw.dk_code_cvs;
        cvs.Name = cvsw.libelle;
        cvs.Statut__c = cvsw.statut;
        cvs.DateDebut__c = cvsw.date_debut;
        //cvs.DKCodeContrat__c = cvsw.dk_code_contrat;
        cvs.DKCodeEmplacement__c = cvsw.dk_code_emplacement;
        ListConventionServiceUpdate.add(cvs);
    }
    
    
   // try{
   //     upsert ListConventionServiceExistUpdate;  
   // }
   // catch(DMLException e) {
    //    system.debug('***************************************** ' + e.getMessage()); 
     //   system.debug('***************************************** ' + e.getStackTraceString());
     //}   
  }
    
    else {
        ConventionService__c cvs = new ConventionService__c();
        //system.debug('cvsMap.get(cvs.DKCodeCVS__c) :'+cvsMap.get(cvs.DKCodeCVS__c));
        //CVSWrapper cvsw = cvsMap.get(cvs.DKCodeCVS__c);
        /*CVSWrapper cvsw = new CVSWrapper();
        cvs.DKCodeCVS__c = cvsw.dk_code_cvs;
        cvs.Statut__c = cvsw.statut;
        cvs.DateDebut__c = cvsw.date_debut;
        cvs.DKCodeContrat__c = cvsw.dk_code_contrat;
        cvs.DKCodeEmplacement__c = cvsw.dk_code_emplacement;
        ListConventionServiceUpdate.add(cvs);*/
        cvs.DKCodeCVS__c = lcvsw.dk_code_cvs;
        cvs.Name = lcvsw.libelle;
        cvs.Statut__c = lcvsw.statut;
        cvs.DateDebut__c = lcvsw.date_debut;
        //cvs.DKCodeContrat__c = lcvsw[0].dk_code_contrat;
        cvs.DKCodeEmplacement__c = lcvsw.dk_code_emplacement;
        ListConventionServiceUpdate.add(cvs);
      }  
    
    try{
        upsert /*insert*/ ListConventionServiceUpdate;  
    }
    catch(DMLException e) {
        system.debug('***************************************** ' + e.getMessage()); 
        system.debug('***************************************** ' + e.getStackTraceString());
     } 
    
    //return ListConventionServiceUpdate;
  
//for(CVSWrapper.LienConventionEmplacement lce: lcvsw.emplacement) {
//for(ConventionServiceWebService.LienConventionEmplacement cew: lcew){
    emplacementCodes.add(lcew.dk_code_emplacement);
    //empMap.put(lcew.dk_code_emplacement, lcew);
    //empMap.put(lcvsw.emplacement, emplacement);
//}
system.debug('emplacementCodes :'+emplacementCodes);

List<LienConventionEmplacement__c> Listconventionemplacement = [SELECT Id, DKCodeEmplacement__c, Emplacement__c FROM LienConventionEmplacement__c WHERE DKCodeEmplacement__c in : emplacementCodes /*=: 'S00011915K'*/];
List<LienConventionEmplacement__c> ListconventionemplacementExistUpdate = new List<LienConventionEmplacement__c>();
//List<LienConventionEmplacement__c> ListconventionemplacementNotExistUpdate = new List<LienConventionEmplacement__c>();

 Map<String, Emplacement__c> mapemplacementsIds  = new Map<String, Emplacement__c>
 ([SELECT Id, DKCode_Emplacement__c FROM Emplacement__c WHERE DKCode_Emplacement__c in : emplacementCodes]);
 
 /*List<Emplacement__c> emplacementsIds = [SELECT Id, DKCode_Emplacement__c FROM Emplacement__c
                                                        WHERE DKCode_Emplacement__c in : emplacementCodes];
*/

system.debug('mapemplacementsIds  :' +mapemplacementsIds);
system.debug ('Listconventionemplacement :' +Listconventionemplacement);
system.debug ('Listconventionemplacement.size() :' +Listconventionemplacement.size());

if(Listconventionemplacement.size() > 0){
    for(LienConventionEmplacement__c lce : Listconventionemplacement){
      for (Emplacement__c emp : mapemplacementsIds.Values()) {
       
    
        //LienConventionEmplacement cew = empMap.get(lce.DKCodeEmplacement__c);       
        //lce.ConventionService__c = ListConventionServiceUpdate[0].Id;
        //lce.DKCodeEmplacement__c = cew.dk_code_emplacement;
        if (emp.DKCode_Emplacement__c == lce.DKCodeEmplacement__c) {
        //lce.Emplacement__c = mapemplacementsIds.get(lce.DKCodeEmplacement__c).Id;
        lce.Emplacement__c = emp.Id;
        }
        //ListconventionemplacementExistUpdate.add(lce);
      }
       ListconventionemplacementExistUpdate.add(lce);
    }
   // try{
    //    upsert ListconventionemplacementExistUpdate;  
    //}
    //catch(DMLException e) {
      // system.debug('***************************************** ' + e.getMessage()); 
      // system.debug('***************************************** ' + e.getStackTraceString());
    // }   
   }
    
    else {
      for (Emplacement__c emp : mapemplacementsIds.Values()) {
        LienConventionEmplacement__c lce = new LienConventionEmplacement__c();
        system.debug('ListConventionServiceUpdate[0].Id :'+ListConventionServiceUpdate[0].Id);
        lce.ConventionService__c = ListConventionServiceUpdate[0].Id;
        system.debug('lcew.dk_code_emplacement :'+lcew.dk_code_emplacement);
        lce.DKCodeEmplacement__c = lcew.dk_code_emplacement;
        if (emp.DKCode_Emplacement__c == lce.DKCodeEmplacement__c) {
        lce.Emplacement__c = emp.Id;
        //lce.Emplacement__c = mapemplacementsIds.get(emp.DKCodeEmplacement__c).Id;
        }
        ListconventionemplacementExistUpdate.add(lce);
       }    
    }
    try{
        upsert /*insert*/ ListconventionemplacementExistUpdate;  
    }
    catch(DMLException e) {
        system.debug('***************************************** ' + e.getMessage()); 
        system.debug('***************************************** ' + e.getStackTraceString());
     } 
    
    //return ListConventionServiceUpdate;
  //}
 }
}