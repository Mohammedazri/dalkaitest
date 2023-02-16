@RestResource(urlMapping='/ConventionService/*')
global with sharing class ConventionServiceWebService{

//Wrapper defined Class
global class CVSWrapper{
    global String dk_code_cvs;
    global String libelle;
    global String statut;
    global Date date_debut;
    //String dk_code_contrat;
    //String dk_code_emplacement;
    //public List<Emplacement> emplacement;
    public List<Emplacement> emplacement;
    public ContratBodyjs contrat;
 }

   global class Emplacement{
    public String dk_code_emplacement;
    public Boolean statut_lien;
   // public Boolean statut_lien;

   }
   
    global class ContratBodyjs{
    public String dk_code_contrat;
    public Boolean statut_lien;
   // public Boolean statut_lien;

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
list<Contrat__c> listContract =[select id,Contact__c,DKCodeSurContrat__c from Contrat__c where DKCodeSurContrat__c in :contratCodes];
Contrat__c ctrt =new Contrat__c();
ctrt.DKCodeSurContrat__c=lcvsw.contrat.dk_code_contrat;
for(Contrat__c crtList:listContract){
if(crtList.DKCodeSurContrat__c==lcvsw.contrat.dk_code_contrat){ctrt.id=crtList.id;}else{ctrt.id=null;}}
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
  system.debug('98');
   }   
        else {
          
        ConventionService__c cvs = new ConventionService__c();    
        cvs.DKCodeCVS__c = lcvsw.dk_code_cvs;
        cvs.Name = lcvsw.libelle;
        cvs.Statut__c = lcvsw.statut;
        cvs.DateDebut__c = lcvsw.date_debut;
        //cvs.DKCodeContrat__c = lcvsw[0].dk_code_contrat;
        //cvs.Contrat__c=ctrt.id;
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
     //if (Listconventionemplacement.size() == lcvsw.emplacement.size()) {  
        if (lceSup0.DKCodeEmplacement__c == e.dk_code_emplacement) { 
         if (e.statut_lien == false) {    
         lceSup0.StatutLien__c = e.statut_lien;
         //break;
   
         ListconventionemplacementExistUpdate.add(lceSup0);
          }
        }
       /*else {
         system.debug('emplacement nouveau :'+e);
         lceSup0.StatutLien__c = e.statut_lien;
   
        //ListconventionemplacementExistUpdate.add(lceSup0);
        //emplacementListSup0.add(lceSup0);

          }*/
        //ListconventionemplacementExistUpdate.add(lceSup0);
         //}

       //emplacementListSup0.add(lceSup0);
       //ListconventionemplacementExistUpdate.add(lceSup0);
     }
    }
  

   if (ListconventionemplacementExistUpdate.size()>0) {  
    system.debug('185');
    try{
        upsert ListconventionemplacementExistUpdate;  
        //upsert Listconventionemplacement;  
    }
    catch(DMLException e) {
        system.debug('***************************************** ' + e.getMessage()); 
        system.debug('***************************************** ' + e.getStackTraceString());
       
     }
  }

  /*
  for(LienConventionEmplacement__c lceSup0 : Listconventionemplacement){
    for ( Emplacement e : lcvsw.emplacement) {

        if (lceSup0.DKCodeEmplacement__c != e.dk_code_emplacement) { 
         if (e.statut_lien == true) {    
         lceSup0.StatutLien__c = e.statut_lien;
   
        //emplacementListSup0.add(lceSup0);
          }
          emplacementListSup0.add(lceSup0);
        }

       }

     }
   if (emplacementListSup0.size()>0) {  
    try{
        insert emplacementListSup0;  
        //upsert Listconventionemplacement;  
    }
    catch(DMLException e) {
        system.debug('***************************************** ' + e.getMessage()); 
        system.debug('***************************************** ' + e.getStackTraceString());
       
     }
  }

  */
 
   }
    else {
      system.debug('229');
    system.debug('lcvsw.emplacement :'+lcvsw.emplacement);
     if (Listconventionemplacement.size() == 0) {
      system.debug('232');
        for ( Emplacement e : lcvsw.emplacement) { 
  LienConventionEmplacement__c lceEgla0 = new LienConventionEmplacement__c();
  lceEgla0.ConventionService__c = ListConventionServiceUpdate[0].Id;
    lceEgla0.DKCodeEmplacement__c  = e.dk_code_emplacement;
    //system.debug('mapemplacementsIds.get(e.dk_code_emplacement) :'+mapemplacementsIds.get(e.dk_code_emplacement));
    //lce.Emplacement__c = mapemplacementsIds.get(/*e.dk_code_emplacement*/'S00011915K').Id;
    //emp.StatutService__c = e.statut_lien;
    //if (emp.DKCode_Emplacement__c == lce.DKCodeEmplacement__c) {
     //lce.Emplacement__c = emp.Id;
     //break;
     //}

     
    lceEgla0.StatutLien__c = e.statut_lien;
    // to do : affecter le ID de contran to the add
    //lceEgla0.Contrat__c=ctrt.id;
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
  /*
  to do A optimiser si possible 
  */
  
  else if (Listconventionemplacement.size() != lcvsw.emplacement.size()) {
    system.debug('269');

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

      // to do : affecter le ID de contran to the add
      //lceEgla0.Contrat__c=ctrt.id;

     }  
    /*for ( Emplacement e : lcvsw.emplacement) { 
      for(LienConventionEmplacement__c lceSup0 : Listconventionemplacement){
        if (e.dk_code_emplacement == lceSup0.DKCodeEmplacement__c) {
         AjoutEmplacementTraitement = false;
         //break;
            } 
           }      
         system.debug('AjoutEmplacementTraitement :'+AjoutEmplacementTraitement);
         if (AjoutEmplacementInitial == true && AjoutEmplacementTraitement == true) {
         system.debug('Je suis dans AjoutEmplacement :');
         LienConventionEmplacement__c lceEgla0 = new LienConventionEmplacement__c();
         lceEgla0.ConventionService__c = ListConventionServiceUpdate[0].Id;
         lceEgla0.DKCodeEmplacement__c  = e.dk_code_emplacement;    
         lceEgla0.StatutLien__c = e.statut_lien;
         //break;
   
         ListconventionemplacementExistUpdate.add(lceEgla0);
           }
          
         }
      */ 
   if (emplacementListEgal0.size()>0) { 
    system.debug('315');
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