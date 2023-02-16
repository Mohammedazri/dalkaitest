@RestResource(urlMapping='/ConventionService/*')
global with sharing class ConventionServiceWebService{
global class CVSWrapper{
    global String dk_code_cvs;
    global String libelle;
    global String statut;
    global Date date_debut;
    public List<Emplacement> emplacement;
    public List<Service> service;
    public ContratBodyjs contrat;

 }

global class Service{
  public String dk_code_emplacement;
  public Boolean statut_lien;
 }
   global class Emplacement{
    public String dk_code_emplacement;
    public Boolean statut_lien;
   }
   
    global class ContratBodyjs{
    public String dk_code_contrat;
    public Boolean statut_lien;
   }

public static CVSWrapper parse(String json){
        return (CVSWrapper) System.JSON.deserialize(json, CVSWrapper.class);
   }

@HttpPut
global static /*List<ConventionService__c>*/ void UpsertConventionService() {   
String requestBodyCVS = RestContext.request.requestBody.toString();
CVSWrapper lcvsw = (CVSWrapper) JSON.deserialize(requestBodyCVS, CVSWrapper.class);
system.debug('lcvsw :'+lcvsw);
system.debug('lcvsw.dk_code_cvs :'+lcvsw.dk_code_cvs);
system.debug('lcvsw.emplacement :'+lcvsw.emplacement);

ConventionServiceWebService.emplacement lcew = (ConventionServiceWebService.emplacement) JSON.deserialize(requestBodyCVS, ConventionServiceWebService.emplacement.class);

system.debug('lcew :'+lcew);

List<String> cvsCodes = new List<String>();
List<String> empsCodes = new List<String>();
Map<String, CVSWrapper> cvsMap = new Map<String, CVSWrapper>();

List<String> emplacementCodes = new List<String>();
    cvsCodes.add(lcvsw.dk_code_cvs); 
    cvsMap.put(lcvsw.dk_code_cvs, lcvsw);

List<ConventionService__c> Listconventionservice = [SELECT Id,  DKCodeCVS__c, Name, Statut__c, DateDebut__c, DKCodeContrat__c, DKCodeEmplacement__c FROM ConventionService__c WHERE DKCodeCVS__c in : cvsCodes];
List<ConventionService__c> ListConventionServiceUpdate = new List<ConventionService__c>();

List<LienConventionEmplacement__c> emplacementListSup0 = new List<LienConventionEmplacement__c>();
List<LienConventionEmplacement__c> emplacementListSup0ASupprimer = new List<LienConventionEmplacement__c>();
List<LienConventionEmplacement__c> emplacementListEgal0 = new List<LienConventionEmplacement__c>();


List<String> contratCodes = new List<String>();
contratCodes.add(lcvsw.contrat.dk_code_contrat);

list<Contrat__c> listContract =[select id,Contact__c,DKCodeSurContrat__c from Contrat__c where DKCodeSurContrat__c in :contratCodes LIMIT 1];
Contrat__c ctrt =new Contrat__c();
ctrt.DKCodeSurContrat__c=lcvsw.contrat.dk_code_contrat;
for(Contrat__c crtList:listContract){
if(crtList.DKCodeSurContrat__c==lcvsw.contrat.dk_code_contrat){
  ctrt.id=crtList.id;
}else{
ctrt.id=null;
}
}
if(Listconventionservice.size() > 0){
 

    for(ConventionService__c cvs: Listconventionservice){
        CVSWrapper cvsw = cvsMap.get(cvs.DKCodeCVS__c);
        cvs.DKCodeCVS__c = cvsw.dk_code_cvs;
        cvs.Name = cvsw.libelle;
        cvs.Statut__c = cvsw.statut;
        cvs.DateDebut__c = cvsw.date_debut;
        cvs.DKCodeContrat__c=ctrt.DKCodeSurContrat__c;
        cvs.Contrat__c=ctrt.id;
        System.debug('cvs.Contrat__c'+cvs.Contrat__c);
      ListConventionServiceUpdate.add(cvs);

    }

   }   
        else {
          
        ConventionService__c cvs = new ConventionService__c();    
        cvs.DKCodeCVS__c = lcvsw.dk_code_cvs;
        cvs.Name = lcvsw.libelle;
        cvs.Statut__c = lcvsw.statut;
        cvs.DateDebut__c = lcvsw.date_debut;
        cvs.Contrat__c=ctrt.id;
        cvs.DKCodeContrat__c=ctrt.DKCodeSurContrat__c;
        System.debug('cvs.Contrat__c'+cvs.Contrat__c);
        ListConventionServiceUpdate.add(cvs);
        system.debug('ListConventionServiceUpdate :'+ListConventionServiceUpdate);
       
      }  
    try{
        upsert /*insert*/ ListConventionServiceUpdate;  
    }
    catch(DMLException e) {
        system.debug('***************************************** ' + e.getMessage()); 
        system.debug('***************************************** ' + e.getStackTraceString());
     } 

    emplacementCodes.add(lcew.dk_code_emplacement);


system.debug('emplacementCodes :'+emplacementCodes);

Set<String> cvsIds = new Set<String>();

for (ConventionService__c cvs : ListConventionServiceUpdate) {
  cvsIds.add(cvs.DKCodeCVS__c);
}

List<LienConventionEmplacement__c> Listconventionemplacement = [SELECT Id, DKCodeEmplacement__c, Emplacement__c, ConventionService__r.DKCodeCVS__c, StatutLien__c  FROM LienConventionEmplacement__c WHERE (/*DKCodeEmplacement__c in : emplacementCodes AND*/ ConventionService__r.DKCodeCVS__c in : cvsIds)/*=: 'S00011915K'*/];
List<LienConventionEmplacement__c> ListconventionemplacementExistUpdate = new List<LienConventionEmplacement__c>();

system.debug ('Listconventionemplacement :' +Listconventionemplacement);
system.debug ('Listconventionemplacement.size() :' +Listconventionemplacement.size());

for ( Emplacement e : lcvsw.emplacement) {
empsCodes.add(e.dk_code_emplacement);
}

system.debug('empsCodes :'+empsCodes);

Map<String, Emplacement__c> mapemplacementsIds  = new Map<String, Emplacement__c>
 ([SELECT Id, DKCode_Emplacement__c FROM Emplacement__c WHERE DKCode_Emplacement__c in : empsCodes]);
 
system.debug('mapemplacementsIds :'+mapemplacementsIds);

boolean AjoutEmplacementInitial = true;
boolean AjoutEmplacementTraitement = true;

if(Listconventionemplacement.size() > 0 && Listconventionemplacement.size() == lcvsw.emplacement.size()){
    system.debug('lcvsw.emplacement taille :'+lcvsw.emplacement.size());
  for(LienConventionEmplacement__c lceSup0 : Listconventionemplacement){
    system.debug('156');
    for ( Emplacement e : lcvsw.emplacement) {
    
        if (lceSup0.DKCodeEmplacement__c == e.dk_code_emplacement) { 
         if (e.statut_lien == false) {    
         lceSup0.StatutLien__c = e.statut_lien;
         ListconventionemplacementExistUpdate.add(lceSup0);
          }
        }
     }
    }

   if (ListconventionemplacementExistUpdate.size()>0) {  
    system.debug('185');
    try{
        upsert ListconventionemplacementExistUpdate;  
    }
    catch(DMLException e) {
        system.debug('***************************************** ' + e.getMessage()); 
        system.debug('***************************************** ' + e.getStackTraceString());
       
     }
  }

  }
    else {
    system.debug('lcvsw.emplacement :'+lcvsw.emplacement);
     if (Listconventionemplacement.size() == 0) {
    for ( Emplacement e : lcvsw.emplacement) { 
    LienConventionEmplacement__c lceEgla0 = new LienConventionEmplacement__c();
    lceEgla0.ConventionService__c = ListConventionServiceUpdate[0].Id;
    lceEgla0.DKCodeEmplacement__c  = e.dk_code_emplacement;
    lceEgla0.StatutLien__c = e.statut_lien;
    emplacementListEgal0.add(lceEgla0);
    system.debug('emplacementListEgal0:'+emplacementListEgal0);

     }
   
   
   try{
        upsert emplacementListEgal0;  
    }
    catch(DMLException ep) {
        system.debug('***************************************** ' + ep.getMessage()); 
        system.debug('***************************************** ' + ep.getStackTraceString());
     }  
   
    }

  else if (Listconventionemplacement.size() != lcvsw.emplacement.size()) {
    
     try{
        delete Listconventionemplacement;  
      }
    catch(DMLException ep) {
        system.debug('***************************************** ' + ep.getMessage()); 
        system.debug('***************************************** ' + ep.getStackTraceString());
      }    
    for ( Emplacement e : lcvsw.emplacement) { 
      LienConventionEmplacement__c lceEgla0 = new LienConventionEmplacement__c();
      lceEgla0.ConventionService__c = ListConventionServiceUpdate[0].Id;
      lceEgla0.DKCodeEmplacement__c  = e.dk_code_emplacement;
      lceEgla0.StatutLien__c = e.statut_lien;
      emplacementListEgal0.add(lceEgla0);
      system.debug('emplacementListEgal0:'+emplacementListEgal0);
     }
   if (emplacementListEgal0.size()>0) {
   try{
        insert emplacementListEgal0;  
    }
    catch(DMLException ep) {
        system.debug('***************************************** ' + ep.getMessage()); 
        system.debug('***************************************** ' + ep.getStackTraceString());
      }
     }  
    }
  }
 }
}