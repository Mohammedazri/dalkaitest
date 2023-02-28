@RestResource(urlMapping='/ConventionService/*')
global with sharing class ConventionServiceWebService{
global class CVSWrapper{
    global String dk_code_cvs;
    global String libelle;
    global String statut;
    global Date date_debut;
    public List<Emplacement> emplacement;
    public Contrat contrat;
    public List<Service> service;
    public Metadonnee metadonnee;
 }
 
   global class Emplacement{
    public String dk_code_emplacement;
    public Boolean statut_lien;

   }
    global class Contrat{
    public String dk_code_contrat;
    public Boolean statut_lien;
   }
    global class Service{
    public String code_service;
    public Boolean statut_lien;
   }
    global class Metadonnee{
    public DateTime date_modification;
    public String effectue_par;

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
system.debug('lcvsw.service :'+lcvsw.service);
 ConventionServiceWebService.emplacement lcew = (ConventionServiceWebService.emplacement) JSON.deserialize(requestBodyCVS, ConventionServiceWebService.emplacement.class);
system.debug('lcew :'+lcew);
List<String> cvsCodes = new List<String>();
List<String> empsCodes = new List<String>();
List<String> servsCodes = new List<String>();
Map<String, CVSWrapper> cvsMap = new Map<String, CVSWrapper>();
List<String> emplacementCodes = new List<String>();
List<String> serviceCodes = new List<String>();
    cvsCodes.add(lcvsw.dk_code_cvs); 
    cvsMap.put(lcvsw.dk_code_cvs, lcvsw);

List<ConventionService__c> Listconventionservice = [SELECT Id,DKCodeEmplacement__c,DKCodeCVS__c, Name, Statut__c, DateDebut__c, DKCodeContrat__c/*, DKCodeEmplacement__c*/ FROM ConventionService__c WHERE DKCodeCVS__c in : cvsCodes];
List<ConventionService__c> ListConventionServiceUpdate = new List<ConventionService__c>();

List<LienConventionEmplacement__c> emplacementListSup0 = new List<LienConventionEmplacement__c>();
List<LienConventionEmplacement__c> emplacementListSup0ASupprimer = new List<LienConventionEmplacement__c>();
List<LienConventionEmplacement__c> emplacementListEgal0 = new List<LienConventionEmplacement__c>();
List<LienConventionService__c> serviceListSup0 = new List<LienConventionService__c>();
List<LienConventionService__c> serviceListSup0ASupprimer = new List<LienConventionService__c>();
List<LienConventionService__c> serviceListEgal0 = new List<LienConventionService__c>();
List<String> contratCodes = new List<String>();
contratCodes.add(lcvsw.contrat.dk_code_contrat);

// contrat part .
list<Contrat__c> listContract =[select id/*,Contact__c*/,DKCodeSurContrat__c from Contrat__c where DKCodeSurContrat__c in :contratCodes LIMIT 1];
Contrat__c ctrt =new Contrat__c();
ctrt.DKCodeSurContrat__c=lcvsw.contrat.dk_code_contrat;
for(Contrat__c crtList:listContract){
  if(crtList.DKCodeSurContrat__c==lcvsw.contrat.dk_code_contrat)
  {
    ctrt.id=crtList.id;
  }
  else{
  ctrt.id=null;
  }
}

// to case listcvs >0




//}

if(Listconventionservice.size() > 0){
    for(ConventionService__c cvs: Listconventionservice){
      system.debug('lock here');
        CVSWrapper cvsw = cvsMap.get(cvs.DKCodeCVS__c);
        cvs.DKCodeCVS__c = cvsw.dk_code_cvs;
        cvs.Name = cvsw.libelle;
        cvs.Statut__c = cvsw.statut;
        cvs.DateDebut__c = cvsw.date_debut;
        //cvs.DKCodeContrat__c = lcvsw[0].dk_code_contrat;  
        cvs.DKCodeContrat__c = ctrt.DKCodeSurContrat__c /*listContract[0].DKCodeSurContrat__c*/ ;
        cvs.Contrat__c=ctrt.id;
        ListConventionServiceUpdate.add(cvs);
    }
   }else {
    system.debug('lock here');
        ConventionService__c cvs = new ConventionService__c();
        cvs.DKCodeCVS__c = lcvsw.dk_code_cvs;
        cvs.Name = lcvsw.libelle;
        cvs.Statut__c = lcvsw.statut;
        cvs.DateDebut__c = lcvsw.date_debut;
        //cvs.DKCodeContrat__c = lcvsw[0].dk_code_contrat;
        cvs.DKCodeContrat__c = ctrt.DKCodeSurContrat__c /*listContract[0].DKCodeSurContrat__c*/;
        cvs.Contrat__c=ctrt.id;
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
System.debug('cvsIds >>> '+cvsIds);


List<LienConventionEmplacement__c> Listconventionemplacement = [SELECT Id, DKCodeEmplacement__c, Emplacement__c, ConventionService__c, ConventionService__r.DKCodeCVS__c, StatutLien__c FROM LienConventionEmplacement__c WHERE (/*DKCodeEmplacement__c in : emplacementCodes AND*/ ConventionService__r.DKCodeCVS__c in : cvsIds)/*=: 'S00011915K'*/];
List<LienConventionEmplacement__c> ListconventionemplacementExistUpdate = new List<LienConventionEmplacement__c>();

List<LienConventionService__c> Listlienconventionservice = [SELECT Id, CodeService__c, Service__c, ConventionService__c, ConventionService__r.DKCodeCVS__c, StatutLien__c FROM LienConventionService__c WHERE (ConventionService__r.DKCodeCVS__c in : cvsIds)/*=: 'S00011915K'*/];
List<LienConventionService__c> ListlienconventionserviceExistUpdate = new List<LienConventionService__c>();

system.debug ('Listconventionemplacement :' +Listconventionemplacement);
system.debug ('Listconventionemplacement.size() :' +Listconventionemplacement.size());

system.debug ('Listlienconventionservice :' +Listlienconventionservice);
system.debug ('Listlienconventionservice.size() :' +Listlienconventionservice.size());

for (Emplacement e : lcvsw.emplacement) {
empsCodes.add(e.dk_code_emplacement);
}
System.debug('empsCodes >>> '+empsCodes);

for (service s : lcvsw.service) {
servsCodes.add(s.code_service);
}
System.debug('servsCodes >>> '+servsCodes);


 Map<String, Emplacement__c> mapemplacementsIds  = new Map<String, Emplacement__c>
 ([SELECT Id, DKCode_Emplacement__c FROM Emplacement__c WHERE DKCode_Emplacement__c in : empsCodes]);
 Map<String, Service__c> mapservicesIds  = new Map<String, Service__c>
 ([SELECT Id, CodeService__c FROM Service__c WHERE CodeService__c in : servsCodes]);
 system.debug('mapemplacementsIds :'+mapemplacementsIds);
 system.debug('mapservicesIds :'+mapservicesIds);
list<Emplacement__c> listEmplacement =[select id, DKCode_Emplacement__c from Emplacement__c where DKCode_Emplacement__c in :empsCodes];
Emplacement__c emplist = new Emplacement__c();
list<Service__c> listService =[select id, CodeService__c from Service__c where CodeService__c in :servsCodes];
 Service__c servlist = new Service__c();


system.debug('lcvsw.emplacement >>> '+lcvsw.emplacement+' <<< ');
if(false/*Listconventionemplacement.size() > 0 && Listconventionemplacement.size() == lcvsw.emplacement.size()*/){
    system.debug('lcvsw.emplacement taille :'+lcvsw.emplacement.size());
 
  for(LienConventionEmplacement__c lceSup0 : Listconventionemplacement){
    for ( Emplacement e : lcvsw.emplacement) {
   
        if (lceSup0.DKCodeEmplacement__c == e.dk_code_emplacement) { 
          system.debug('lock here');
         if (e.statut_lien == false) {    
         lceSup0.StatutLien__c = e.statut_lien;
        ListconventionemplacementExistUpdate.add(lceSup0);
          }
        }
     }
    }
   if (ListconventionemplacementExistUpdate.size()>0) {  
    system.debug('lock here');
    try{
        upsert ListconventionemplacementExistUpdate; 
    }
    catch(DMLException e) {
        system.debug('***************************************** ' + e.getMessage()); 
        system.debug('***************************************** ' + e.getStackTraceString());
       
     }
  } 
  }

else{
  system.debug('lock here');
      system.debug('Listconventionemplacement.size >> '+Listconventionemplacement.size()+' <<');
      system.debug('lcvsw.emplacement.size >> '+lcvsw.emplacement.size()+' <<');
      system.debug('lcvsw.emplacement :'+lcvsw.emplacement);

      // premier cas au le l emple n'exicete pas

     if (Listconventionemplacement.size() == 0) {
        for ( Emplacement e : lcvsw.emplacement) {
          if (e.statut_lien == true) {
            LienConventionEmplacement__c lceEgla0 = new LienConventionEmplacement__c();
            system.debug('ListConventionServiceUpdate[0].id :'+ListConventionServiceUpdate[0].id);
            lceEgla0.ConventionService__c = ListConventionServiceUpdate[0].Id;
            lceEgla0.StatutLien__c = e.statut_lien;
            lceEgla0.DKCodeEmplacement__c  = e.dk_code_emplacement;
            for(Emplacement__c emp : listEmplacement){
            if(emp.DKCode_Emplacement__c == e.dk_code_emplacement) {
            lceEgla0.Emplacement__c = emp.id;
            }
          }

    emplacementListEgal0.add(lceEgla0);
    system.debug('emplacementListEgal0:'+emplacementListEgal0);
      }
     } 
   try{
        upsert emplacementListEgal0;  
    }
    catch(DMLException ep) {
        system.debug('***************************************** ' + ep.getMessage()); 
        system.debug('***************************************** ' + ep.getStackTraceString());
     }  
    }
else if (Listconventionemplacement.size() > 0 && Listconventionemplacement.size() <= lcvsw.emplacement.size()) {
System.debug('Listconventionemplacement.size >>> '+Listconventionemplacement.size()+' <<<>>>');

   // else if (Listconventionemplacement.size() > 0 && Listconventionemplacement.size() < lcvsw.emplacement.size()) {
    List<LienConventionEmplacement__c> listLienConvEmpletotrait = new List<LienConventionEmplacement__c>();
  List<LienConventionEmplacement__c> listLienConvEmpletoupsert = new List<LienConventionEmplacement__c>();
  List<LienConventionEmplacement__c> listLienConvEmpletodelete = new List<LienConventionEmplacement__c>();    
  for(ConventionService__c cv:Listconventionservice){
    // le meme dkcode 
    if(cv.DKCodeCVS__c==lcvsw.dk_code_cvs){
          for(LienConventionEmplacement__c lce:Listconventionemplacement){
            if(cv.id==lce.ConventionService__c){
              listLienConvEmpletotrait.add(lce);
            } 
        }
      }
    }

system.debug('listLienConvEmpletotrait >> '+listLienConvEmpletotrait[0]);

for (emplacement  el : lcvsw.emplacement) { 
for(LienConventionEmplacement__c lcve:listLienConvEmpletotrait){
system.debug('avant el.dk_code_emplacement >>> '+el.dk_code_emplacement+'el.statut_lien >>> '+el.statut_lien+'');
system.debug('avant lcve.DKCodeEmplacement__c >>> '+lcve.DKCodeEmplacement__c+' lcve.StatutLien__c >>> '+lcve.StatutLien__c+'');
if(el.statut_lien==false && lcve.DKCodeEmplacement__c==el.dk_code_emplacement && lcve.StatutLien__c==true){
system.debug('apres el.dk_code_emplacement >>> '+el.dk_code_emplacement+' el.statut_lien >>> '+el.statut_lien+'');
system.debug('apres lcve.DKCodeEmplacement__c >>> '+lcve.DKCodeEmplacement__c+' lcve.StatutLien__c >>> '+lcve.StatutLien__c+'');
listLienConvEmpletodelete.add(lcve);

System.debug('listLienConvEmpletodelete >>>  '+listLienConvEmpletodelete);
}
//System.debug('el.statut_lien >>> '+el.statut_lien+'lcve.DKCodeEmplacement__c >>> '+el.dk_code_emplacement+'lcve.StatutLien__c >>> '+lcve.StatutLien__c);
//el.statut_lien=true  && lcve.DKCodeEmplacement__c!=el.dk_code_emplacement && lcve.StatutLien__c==false

  else if(lcve.DKCodeEmplacement__c!=el.dk_code_emplacement && (el.statut_lien=true  || lcve.StatutLien__c==false)){
    //system.debug('el.statut_lien  >>>> '+el.statut_lien+'lcve.DKCodeEmplacement__c  >>>> '+lcveI.DKCodeEmplacement__c+'el.dk_code_emplacement   >>>> '+elI.dk_code_emplacement+'');
    
    System.debug('el.statut_lien >>> '+el.statut_lien+' lcve.DKCodeEmplacement__c >>> '+lcve.DKCodeEmplacement__c+' el.dk_code_emplacement >>> '+el.dk_code_emplacement+'lcve.StatutLien__c >>> '+lcve.StatutLien__c);

    //  Add 
   // if(lcve.StatutLien__c==false){
    LienConventionEmplacement__c lceEgla0 = new LienConventionEmplacement__c();
    lceEgla0.ConventionService__c = ListConventionServiceUpdate[0].Id;
    lceEgla0.DKCodeEmplacement__c  = el.dk_code_emplacement;
    lceEgla0.StatutLien__c = el.statut_lien;
    for(Emplacement__c emp : listEmplacement){
          if(emp.DKCode_Emplacement__c == el.dk_code_emplacement) {
          lceEgla0.Emplacement__c = emp.id;
          }
       }
       listLienConvEmpletoupsert.add(lceEgla0);
       System.debug('listLienConvEmpletoupsert >>> '+listLienConvEmpletoupsert);
      //}
      }
      } 
    }
    
    
    
    System.debug('listLienConvEmpletodelete'+listLienConvEmpletodelete);
if(listLienConvEmpletodelete.size()>0 || listLienConvEmpletoupsert.size()>0){
try{
  
  insert listLienConvEmpletoupsert;
  //upsert listLienConvEmpletoupsert;
  delete  listLienConvEmpletodelete;
  
}
catch(DMLException ep) {
  system.debug('***************************************** ' + ep.getMessage()); 
  system.debug('***************************************** ' + ep.getStackTraceString());

}
}
}
}

  if(Listlienconventionservice.size() > 0 && Listlienconventionservice.size() == lcvsw.service.size()){
    //if(Listlienconventionservice.size() > 0 && Listlienconventionservice.size() == lcvsw.service.size()){

    system.debug('lcvsw.service taille :'+lcvsw.service.size());
 
  for(LienConventionService__c lcsSup0 : Listlienconventionservice){
    for ( Service s : lcvsw.service) { 
        if (lcsSup0.CodeService__c == s.code_service) { 
          system.debug('lock here');
         if (s.statut_lien == false) {    
         lcsSup0.StatutLien__c = s.statut_lien;
        ListlienconventionserviceExistUpdate.add(lcsSup0);
          }
        }
     }
    }
  

   if (ListlienconventionserviceExistUpdate.size()>0) {  
    system.debug('lock here');
    try{
        upsert ListlienconventionserviceExistUpdate;   
    }
    catch(DMLException e) {
        system.debug('***************************************** ' + e.getMessage()); 
        system.debug('***************************************** ' + e.getStackTraceString());
       
       }
      }
    }
  
    else {
      system.debug('lock here');
    system.debug('lcvsw.service :'+lcvsw.service);
     if (Listlienconventionservice.size() == 0) {
      system.debug('lock here');
        for ( Service s : lcvsw.service) { 
          if (s.statut_lien == true) {
            system.debug('lock here');
             LienConventionService__c lcsEgla0 = new LienConventionService__c ();
             lcsEgla0.ConventionService__c = ListConventionServiceUpdate[0].Id;
             lcsEgla0.CodeService__c  = s.code_service;
             lcsEgla0.StatutLien__c = s.statut_lien;
             for(Service__c ser : listService){
               if(ser.CodeService__c == s.code_service) {
               lcsEgla0.Service__c = ser.id;
             }
           } 
             serviceListEgal0.add(lcsEgla0);
             system.debug('serviceListEgal0:'+serviceListEgal0);
     
      }
     }
   try{
        upsert serviceListEgal0;  
    }
    catch(DMLException ep) {
        system.debug('***************************************** ' + ep.getMessage()); 
        system.debug('***************************************** ' + ep.getStackTraceString());
     }  
   
    }
  }
}}