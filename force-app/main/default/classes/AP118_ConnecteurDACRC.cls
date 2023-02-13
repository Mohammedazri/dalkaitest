/**
 * @author Hatem Lahmadi
 * @desc Call API Gateway For Connecteur D@CRC
*/

public with sharing class AP118_ConnecteurDACRC {

public class Demande_OrdreTravailWrapper {
        public Boolean isErrorToken;
        public String strRetourWebServiceForToken;
        public Boolean isErrorDemande;
        public String strRetourWebServiceForDemande;
        public Boolean isErrorOrdreTravail;
        public String strRetourWebServiceForOrdreTravail;
        public String message;
    }
  
     //public static Demande_OrdreTravailWrapper parse(String json) {
     // return (Demande_OrdreTravailWrapper) System.JSON.deserialize(json, Demande_OrdreTravailWrapper.class);
     // }

 
     
     @TestVisible
    private static Case getDemande(Id recordId) {
       return [SELECT Id, CaseNumber, CaseNumberMSAD__c, Origin, CanalCreation__c, GmaoReferente__c, Libelle__c, Details__c, Message_interne__c, Priority, Recordtype.Name,  
               TECH_DateDebutDiffere__c, Date_heure_differe__c, DateAcquittement__c, Status, TECH_DateStatut__c, SourceExterne__c, ID_externe__c, 
               Motif_de_cloture__c, DkCodePlanificateur__c, DatePlanificateur__c, Service__c, Reason, Motif_Depannage__c, ComplementDescriptionMotif__c, SousMotif__c,
               CodeDomaine__c, DescriptionPanne__c, ImpactPanne__c, RefInfoAdditionnelle__c, TypeContact__c, OrdreContact__c, Contact.Title,
               Contact.Id, Technicien__r.Id, Technicien__r.DkCode__c, Contact.Salutation, Contact.FirstName, Contact.LastName,
               Contact.MailingStreet, Contact.MailingPostalCode, Contact.MailingCity, Contact.MailingCountry, Contact.Email,                
               Contact_sollicitant__c, Contact_sollicitant__r.Id, Technicien_sollicitant__r.Id, Technicien_sollicitant__r.DkCode__c, Contact_sollicitant__r.Title, Contact_sollicitant__r.Salutation, Contact_sollicitant__r.FirstName, Contact_sollicitant__r.LastName, 
               Contact_sollicitant__r.MailingStreet, Contact_sollicitant__r.MailingPostalCode, Contact_sollicitant__r.MailingCity, Contact_sollicitant__r.MailingCountry, Contact_sollicitant__r.Email,
               Contact_sollicitant__r.Phone, Contact_sollicitant__r.MobilePhone, TypeLigne__c, OrdreLigne__c, Contact.Phone, Contact.MobilePhone, Rendez_vous_requis__c, Date_souhaitee__c, Parent.Id, Parent.CaseNumber,              
               Emplacement__r.DKCode_Emplacement__c, Emplacement__r.Name, Emplacement__r.DKCodeAdresse__c, Emplacement__r.TECH_Adresse__c,
               Emplacement__r.EmplacementSite__c, Emplacement__r.EmplacementSite__r.Id, Emplacement__r.EmplacementSite__r.DKCode_Emplacement__c, Emplacement__r.EmplacementSite__r.Name, 
               Urgence__c, Criticite__c, Impact__c,
               //Owner.Name, Message_au_technicien__c, 
               //Message_du_differe__c, Groupe_client__c, Subject,
               CreatedDate, LastModifiedDate, CreatedBy.DkCode__c, LastModifiedBy.DkCode__c, NombreRelance__c,
               StatutRetourWebServiceMSAD__c, MessageRetourWebServiceMSAD__c
               FROM Case WHERE Id = :recordId]; 
    }
    
     @TestVisible
    private static List<Intervention__c> getOrdreTravail(Id demandeId) {
        return [SELECT Id, Name, Description__c, Statut__c, DateMajStatut__c, IdOT__c, InterventionNumberMSAD__c, Typologie__c, SousTypologie__c, RealisationPartielle__c,
        DureeSouhaitee__c, CorpsMetier__c,  TypeAffectation__c, LibelleEmplacement__c, LibelleSousEmplacement__c, LibelleInstallation__c, Demande__r.CaseNumber, Demande__r.CaseNumberMSAD__c, Demande__r.Status, Priorite__c, 
        DateSouhaiteeDebutIntervention__c, DateSouhaiteeFinIntervention__c, DateAffectationOT__c, DatePlanifieeDebutIntervention__c, DatePlanifieeFinIntervention__c,
        DateDebutIntervention__c, DateFinIntervention__c, DureeIntervention__c, DureeDeplacement__c,  DureeGlobale__c, DateValidationMop__c, DateCloture__c, 
        EnvoiCRClient__c, CausePanne__c, ProblemeRegle__c, Technicien__r.DkCode__c, Matricule__c, MultiIntervenant__c, LocalisationTechnique__c, 
        RdvClient__c, SousTraitant__c, Materiel__c, CommentaireManager__c, CommentaireClient__c, CommentaireInterne__c, 
        Observation__c, MotifProbleme__c, Origine__c, GMAO__c, NumeroOTGmao__c, NumeroOTParent__c,  MotifDeplanification__c, 
        CreatedDate, CreatedBy.DkCode__c, LastModifiedDate, LastModifiedBy.DkCode__c,
        StatutRetourWebServiceMSAD__c, MessageRetourWebServiceMSAD__c FROM Intervention__c WHERE (Demande__c = :demandeId AND Statut__c != 'Réalisé')]; 
    }
    
    
    /**
     * @description Methode appellé pour récupérer le token d'authentifiaction.
     * @param consigneWrapper
     * @return  String
     */

    @TestVisible
    private static String getToken(Demande_OrdreTravailWrapper demande_OTWrapper) {
        String theToken = '';
        webservicelog__c wsLog = new WebserviceLog__c();
        String endpoint = 'callout:URLOAuthTokenForConnecteurDACRC';

        try {
            WebServiceTokenForConnecteurDACRC__mdt webServiceToken = WebServiceTokenForConnecteurDACRC__mdt.getInstance('demande_OT');
            String clientId = webServiceToken.ClientId__c;
            String clientSecret = webServiceToken.ClientSecret__c;
            String authorization = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(clientId + ':' + clientSecret));
            String bodyRequest='grant_type=' + 'client_credentials' + '&client_id=' + clientId;
            
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('POST');
            request.setTimeout(2 * 60 * 1000);
            request.setHeader('Authorization', authorization);
            request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            request.setBody(bodyRequest);
            HttpResponse response = http.send(request);
            
            System.debug('getToken.getStatusCode : '  + response.getStatusCode());
            System.debug('getToken.getBody : '  + response.getBody());
            
            if(response.getStatusCode() == 200) {
                Token tok = new Token();
                tok = Token.parse(response.getBody());
                return tok.access_token;
            } 
            else {
                demande_OTWrapper.isErrorToken = true;
                demande_OTWrapper.strRetourWebServiceForToken = response.getBody();
                wsLog.StatusCode__c = 'KO';
                wsLog.Response__c = response.getBody();
                wsLog.CodeRetour__c = '' + response.getStatusCode();
                wsLog.Type__c = 'envoi des demandes et OT';
                wsLog.flux__c = 'sortant'; // 'entrant' ou 'sortant'
                wsLog.Endpoint__c = endpoint;
                insert wsLog;
            }
        } 
        catch(exception e) { 
            demande_OTWrapper.isErrorToken = true;
            demande_OTWrapper.strRetourWebServiceForToken = e.getMessage();
            System.debug('exception getToken() ');
            System.debug(e.getMessage());
            wsLog.Response__c = e.getMessage();
            wsLog.StatusCode__c = 'KO';
            wsLog.Type__c = 'envoi des demandes et OT';
            wsLog.flux__c = 'sortant'; // 'entrant' ou 'sortant'
            wsLog.Endpoint__c = endpoint;
            insert wsLog;
        }
        return '';
    }
    
    
    
    @TestVisible
    private static /*Demande_OrdreTravailWrapper*/ void createDemande(String access_token, Case demande, String site) 
    {
        Demande_OrdreTravailWrapper demandeWrapper;
        webservicelog__c wsLog = new WebserviceLog__c();
        String jsonSForDemande;
        //String generatedToken;

        JSONGenerator genForDemande = JSON.createGenerator(true);
        
        genForDemande.writeStartObject();   

            //genForDemande.writeStringField('NumeroDemande', demande.CaseNumber);  
            genForDemande.writeStringField('NumeroDemande', demande.CaseNumberMSAD__c);           
            
            if (String.isEmpty(demande.Origin)) {
            genForDemande.writeNullField('Origine');
            } 
            else {
            genForDemande.writeStringField('Origine', demande.Origin);
            }
            
            if (String.isEmpty(demande.CanalCreation__c)) {
            genForDemande.writeNullField('CanalCreation');
            } 
            else {
            genForDemande.writeStringField('CanalCreation', demande.CanalCreation__c);
            }
            
            if (String.isEmpty(demande.GmaoReferente__c)) {
            genForDemande.writeNullField('GmaoReferente');
            } 
            else {
            genForDemande.writeStringField('GmaoReferente', demande.GmaoReferente__c);
            }
            
            genForDemande.writeStringField('Titre', demande.Libelle__c);           
            genForDemande.writeStringField('CommentaireClient', demande.Details__c);
                       
            if (String.isEmpty(demande.Message_interne__c)) {
            genForDemande.writeNullField('CommentaireInterne');
            } 
            else {
            genForDemande.writeStringField('CommentaireInterne', demande.Message_interne__c);
            }
                      
            genForDemande.writeStringField('PrioriteDemandeur', demande.Urgence__c);
            genForDemande.writeStringField('TypeDemande', demande.RecordType.Name);
            
            if (demande.TECH_DateDebutDiffere__c == Null) {
            genForDemande.writeNullField('DateDebutDiffere');
            }
            else {  
            genForDemande.writeDateTimeField('DateDebutDiffere', demande.TECH_DateDebutDiffere__c);
            }
            
            if (demande.Date_heure_differe__c == Null) {
            genForDemande.writeNullField('DateFinDiffere');
            }
            else {  
            genForDemande.writeDateTimeField('DateFinDiffere', demande.Date_heure_differe__c);
            }
            
            if (demande.DateAcquittement__c == Null) {
            genForDemande.writeNullField('DateAcquittement');
            }
            else {  
            genForDemande.writeDateTimeField('DateAcquittement', demande.DateAcquittement__c);
            }
            
            genForDemande.writeFieldName('Statut');
             genForDemande.writeStartObject();
             genForDemande.writeStringField('StatutDemande', demande.Status);
             
             if (demande.TECH_DateStatut__c == Null) {
             genForDemande.writeNullField('DateStatut');
             }
             else {  
             genForDemande.writeDateTimeField('DateStatut', demande.TECH_DateStatut__c);
             }      
            genForDemande.writeEndObject();
            
            genForDemande.writeFieldName('InfoDemandeExterne');
            genForDemande.writeStartObject();
             if (String.isEmpty(demande.SourceExterne__c)) {
             genForDemande.writeNullField('SourceExterne');
            } 
             else {
             genForDemande.writeStringField('SourceExterne', demande.SourceExterne__c);
            }
            if (String.isEmpty(demande.ID_externe__c)) {
            genForDemande.writeNullField('NumeroDemandeExterne');
            } 
            else {
            genForDemande.writeStringField('NumeroDemandeExterne', demande.ID_externe__c);
            }
           genForDemande.writeEndObject();
            
            /* 
              if (!String.isEmpty(demande.Motif_de_cloture__c) && demande.Motif_de_cloture__c != 'Demande résolue') {
               genForDemande.writeStartArray();  
                genForDemande.writeStartObject();
                genForDemande.writeFieldName('Annulation');
                  genForDemande.writeStringField('MotifAnnulation', demande.Motif_de_cloture__c);
                genForDemande.writeEndObject(); 
               genForDemande.writeEndArray();
               }   
            */
            
           genForDemande.writeFieldName('Planificateur');
           genForDemande.writeStartArray();
           genForDemande.writeStartObject();
            if (String.isEmpty(demande.DkCodePlanificateur__c)) {
            genForDemande.writeNullField('DkCodePlanificateur');
            } 
            else {
            genForDemande.writeStringField('DkCodePlanificateur', demande.DkCodePlanificateur__c);
            }
            if (demande.DatePlanificateur__c == Null) {
            genForDemande.writeNullField('Date');
            }
            else {  
            genForDemande.writeDateTimeField('Date', demande.DatePlanificateur__c);
            }                  
           genForDemande.writeEndObject(); 
           genForDemande.writeEndArray();

           genForDemande.writeFieldName('MotifPanne');
           genForDemande.writeStartObject(); 
           
            if (String.isEmpty(demande.Service__c)) {
            genForDemande.writeNullField('CodeService');
            } 
            else {
            genForDemande.writeStringField('CodeService', demande.Service__c);
            }
            
            if (String.isEmpty(demande.Motif_Depannage__c)) {
            genForDemande.writeNullField('CodeMotif');
            } 
            else {
            genForDemande.writeStringField('CodeMotif', demande.Motif_Depannage__c);
            }
            /*
            if (String.isEmpty(demande.Reason)) {
            genForDemande.writeNullField('CodeMotif');
            } 
            else {
            genForDemande.writeStringField('CodeMotif', demande.Reason);
            }
            */
            if (String.isEmpty(demande.ComplementDescriptionMotif__c)) {
            genForDemande.writeNullField('ComplementDescriptionMotif');
            } 
            else {
            genForDemande.writeStringField('ComplementDescriptionMotif', demande.ComplementDescriptionMotif__c);
            }
            if (String.isEmpty(demande.SousMotif__c)) {
            genForDemande.writeNullField('CodeSousMotif');
            } 
            else {
            genForDemande.writeStringField('CodeSousMotif', demande.SousMotif__c);
            }
            if (String.isEmpty(demande.CodeDomaine__c)) {
            genForDemande.writeNullField('CodeDomaine');
            } 
            else {
            genForDemande.writeStringField('CodeDomaine', demande.CodeDomaine__c);
            }
            if (String.isEmpty(demande.DescriptionPanne__c)) {
            genForDemande.writeNullField('DescriptionPanne');
            } 
            else {
            genForDemande.writeStringField('DescriptionPanne', demande.DescriptionPanne__c);
            }
            if (String.isEmpty(demande.Impact__c)) {
            genForDemande.writeNullField('ImpactPanne');
            } 
            else {
            genForDemande.writeStringField('ImpactPanne', demande.Impact__c);
            }
            if (String.isEmpty(demande.RefInfoAdditionnelle__c)) {
            genForDemande.writeNullField('RefInfoAdditionnelle');
            } 
            else {
            genForDemande.writeStringField('RefInfoAdditionnelle', demande.RefInfoAdditionnelle__c);
            }
           genForDemande.writeEndObject();
            
           genForDemande.writeFieldName('Contact');   
           genForDemande.writeStartArray();       
           genForDemande.writeStartObject();
            if (!String.isEmpty(demande.ContactId)) {
             demande.TypeContact__c = 'Appelant';
             genForDemande.writeStringField('NatureContact', demande.TypeContact__c);
             } 
            genForDemande.writeNumberField('Ordre', demande.OrdreContact__c); 
            
            if (String.isEmpty(demande.Contact.Title)) {
            genForDemande.writeNullField('CodeFonction');
            } 
            else {
            genForDemande.writeStringField('CodeFonction', demande.Contact.Title);
            }
             genForDemande.writeFieldName('IdContact'); 
             genForDemande.writeStartObject();                             
              genForDemande.writeStringField('IdContactRef', demande.Contact.Id);
              if (String.isEmpty(demande.Technicien_sollicitant__c)) {
              genForDemande.writeNullField('IdContactInterneDemande');
              genForDemande.writeStringField('TypologieContact', 'Externe');
              } 
              else {
              genForDemande.writeStringField('IdContactInterneDemande', demande.Technicien_sollicitant__r.DkCode__c);
              genForDemande.writeStringField('TypologieContact', 'Ressource Dalkia');
              }
             genForDemande.writeEndObject();
             
             genForDemande.writeFieldName('EtatCivil');   
             genForDemande.writeStartObject();                     
              genForDemande.writeStringField('Civilite', demande.Contact.Salutation);
              genForDemande.writeStringField('Prenom', demande.Contact.FirstName);
              genForDemande.writeStringField('Nom', demande.Contact.LastName);
             genForDemande.writeEndObject();
             
             genForDemande.writeFieldName('Adresse');
             genForDemande.writeStartObject();
              genForDemande.writeNullField('NumeroVoie'); 
              if (!String.isEmpty(demande.Contact.MailingStreet)) {              
               genForDemande.writeStringField('LibelleVoie', demande.Contact.MailingStreet);
              }
              else {
               genForDemande.writeNullField('LibelleVoie'); 
              }
              
              if (!String.isEmpty(demande.Contact.MailingPostalCode)) {              
               genForDemande.writeStringField('CodePostal', demande.Contact.MailingPostalCode);
              }
              else {
               genForDemande.writeNullField('CodePostal'); 
              }
              
              if (!String.isEmpty(demande.Contact.MailingCity)) {              
               genForDemande.writeStringField('Ville', demande.Contact.MailingCity);
              }
              else {
               genForDemande.writeNullField('Ville'); 
              }
              
              if (!String.isEmpty(demande.Contact.MailingCountry)) {              
               genForDemande.writeStringField('Pays', demande.Contact.MailingCountry);
              }
              else {
               genForDemande.writeNullField('Pays'); 
              }
 
             genForDemande.writeEndObject();
             
             genForDemande.writeFieldName('Coordonnees');
             genForDemande.writeStartObject();                        
              genForDemande.writeStringField('Email', demande.Contact.Email);
              genForDemande.writeFieldName('Ligne');
              genForDemande.writeStartArray();  
              if (!String.isEmpty(demande.Contact.MobilePhone) && !String.isEmpty(demande.Contact.Phone)) {
                genForDemande.writeStartObject();
                  genForDemande.writeStringField('TypeLigne', 'Mobile');
                  genForDemande.writeNumberField('Ordre', demande.OrdreLigne__c);
                  genForDemande.writeStringField('NumLigne', demande.Contact.MobilePhone);
                genForDemande.writeEndObject();
                
                genForDemande.writeStartObject();
                 genForDemande.writeStringField('TypeLigne', 'Fixe');
                  genForDemande.writeNumberField('Ordre', 2);
                  genForDemande.writeStringField('NumLigne', demande.Contact.Phone);
                genForDemande.writeEndObject();
               }
              else { 
                 genForDemande.writeStartObject();
                  if (String.isEmpty(demande.Contact.MobilePhone)) {
                  genForDemande.writeStringField('TypeLigne', 'Fixe');
                  genForDemande.writeNumberField('Ordre', demande.OrdreLigne__c);
                  genForDemande.writeStringField('NumLigne', demande.Contact.Phone);
                  }
                  else if (String.isEmpty(demande.Contact.Phone)) {
                  genForDemande.writeStringField('TypeLigne', 'Mobile');
                  genForDemande.writeNumberField('Ordre', demande.OrdreLigne__c);
                  genForDemande.writeStringField('NumLigne', demande.Contact.MobilePhone);
                  }
                 genForDemande.writeEndObject();
                 }            
                genForDemande.writeEndArray();  
                
               genForDemande.writeEndObject();               
              genForDemande.writeEndObject(); 
            
            genForDemande.writeStartObject();
            if (!String.isEmpty(demande.Contact_Sollicitant__c)) {
             demande.TypeContact__c = 'Demandeur';
             genForDemande.writeStringField('NatureContact', demande.TypeContact__c);
             } 
            genForDemande.writeNumberField('Ordre', 2); 
            
            if (String.isEmpty(demande.Contact_Sollicitant__r.Title)) {
            genForDemande.writeNullField('CodeFonction');
            } 
            else {
            genForDemande.writeStringField('CodeFonction', demande.Contact_Sollicitant__r.Title);
            }
             genForDemande.writeFieldName('IdContact'); 
             genForDemande.writeStartObject();                             
              genForDemande.writeStringField('IdContactRef', demande.Contact_Sollicitant__r.Id);
              if (String.isEmpty(demande.Technicien_sollicitant__c)) {
              genForDemande.writeNullField('IdContactInterneDemande');
              genForDemande.writeStringField('TypologieContact', 'Externe');
              } 
              else {
              genForDemande.writeStringField('IdContactInterneDemande', demande.Technicien_sollicitant__r.DkCode__c);
              genForDemande.writeStringField('TypologieContact', 'Ressource Dalkia');
              }
             genForDemande.writeEndObject();
             
             genForDemande.writeFieldName('EtatCivil');   
             genForDemande.writeStartObject();                     
              genForDemande.writeStringField('Civilite', demande.Contact_Sollicitant__r.Salutation);
              genForDemande.writeStringField('Prenom', demande.Contact_Sollicitant__r.FirstName);
              genForDemande.writeStringField('Nom', demande.Contact_Sollicitant__r.LastName);
             genForDemande.writeEndObject();
             
             genForDemande.writeFieldName('Adresse');
             genForDemande.writeStartObject();
              genForDemande.writeNullField('NumeroVoie');    
              
              if (!String.isEmpty(demande.Contact_Sollicitant__r.MailingStreet)) {  
              genForDemande.writeStringField('LibelleVoie', demande.Contact_Sollicitant__r.MailingStreet);
              }
              else {
               genForDemande.writeNullField('LibelleVoie');
              }  
              
              if (!String.isEmpty(demande.Contact_Sollicitant__r.MailingPostalCode)) {  
              genForDemande.writeStringField('CodePostal', demande.Contact_Sollicitant__r.MailingPostalCode);
              }
              else {
               genForDemande.writeNullField('CodePostal');
              }
              
              if (!String.isEmpty(demande.Contact_Sollicitant__r.MailingCity)) {  
              genForDemande.writeStringField('Ville', demande.Contact_Sollicitant__r.MailingCity);
              }
              else {
               genForDemande.writeNullField('Ville');
              }
              
              if (!String.isEmpty(demande.Contact_Sollicitant__r.MailingCountry)) {  
              genForDemande.writeStringField('Pays', demande.Contact_Sollicitant__r.MailingCountry);
              }
              else {
               genForDemande.writeNullField('Pays');
              }     
              
             genForDemande.writeEndObject();
             
             genForDemande.writeFieldName('Coordonnees');
             genForDemande.writeStartObject();                        
              genForDemande.writeStringField('Email', demande.Contact_Sollicitant__r.Email);
              genForDemande.writeFieldName('Ligne');
              genForDemande.writeStartArray();  
              if (!String.isEmpty(demande.Contact_Sollicitant__r.MobilePhone) && !String.isEmpty(demande.Contact_Sollicitant__r.Phone)) {
                genForDemande.writeStartObject();
                  genForDemande.writeStringField('TypeLigne', 'Mobile');
                  genForDemande.writeNumberField('Ordre', demande.OrdreLigne__c);
                  genForDemande.writeStringField('NumLigne', demande.Contact_Sollicitant__r.MobilePhone);
                genForDemande.writeEndObject();
                
                genForDemande.writeStartObject();
                 genForDemande.writeStringField('TypeLigne', 'Fixe');
                  genForDemande.writeNumberField('Ordre', 2);
                  genForDemande.writeStringField('NumLigne', demande.Contact_Sollicitant__r.Phone);
                genForDemande.writeEndObject();
               }
              else { 
                 genForDemande.writeStartObject();
                  if (String.isEmpty(demande.Contact.MobilePhone)) {
                  genForDemande.writeStringField('TypeLigne', 'Fixe');
                  genForDemande.writeNumberField('Ordre', demande.OrdreLigne__c);
                  genForDemande.writeStringField('NumLigne', demande.Contact_Sollicitant__r.Phone);
                  }
                  else if (String.isEmpty(demande.Contact.Phone)) {
                  genForDemande.writeStringField('TypeLigne', 'Mobile');
                  genForDemande.writeNumberField('Ordre', demande.OrdreLigne__c);
                  genForDemande.writeStringField('NumLigne', demande.Contact_Sollicitant__r.MobilePhone);
                  }
                 genForDemande.writeEndObject();
                 }            
                genForDemande.writeEndArray();  
                
               genForDemande.writeEndObject();               
              genForDemande.writeEndObject(); 
              
            genForDemande.writeEndArray(); 
            
            genForDemande.writeFieldName('ModaliteIntervention');
            genForDemande.writeStartObject();
             genForDemande.writeBooleanField('RendezVousRequis', demande.Rendez_vous_requis__c);
             if (demande.Date_souhaitee__c == Null) {
             genForDemande.writeNullField('DateFinSouhaitee');
             }
             else {  
             genForDemande.writeDateTimeField('DateFinSouhaitee', demande.Date_souhaitee__c);
             }         
            genForDemande.writeEndObject();
            
            genForDemande.writeFieldName('Hierarchie');
            genForDemande.writeStartObject();
             if (String.isEmpty(demande.ParentId)) {
             genForDemande.writeNullField('IdDemandeParente');
             genForDemande.writeNullField('NumeroDemandeParente');           
             } 
             else {
             genForDemande.writeStringField('IdDemandeParente', demande.Parent.Id);
             genForDemande.writeStringField('NumeroDemandeParente', demande.Parent.CaseNumber);
             }            
            genForDemande.writeEndObject();
            
            genForDemande.writeFieldName('Localisation');
            genForDemande.writeStartObject();
             genForDemande.writeFieldName('Site');
             genForDemande.writeStartObject();
              genForDemande.writeStringField('DkCodeEmplacement', demande.Emplacement__r.DKCode_Emplacement__c);
              genForDemande.writeStringField('LibelleEmplacement', demande.Emplacement__r.Name);
              genForDemande.writeFieldName('Adresse');
              //genForDemande.writeStartArray();
              genForDemande.writeStartObject();
               if (String.isEmpty(demande.Emplacement__r.DKCodeAdresse__c)) {
               genForDemande.writeNullField('DkCodeAdresse');
               } 
               else {
               genForDemande.writeStringField('DkCodeAdresse', demande.Emplacement__r.DKCodeAdresse__c);
               }               
                
               if (String.isEmpty(demande.Emplacement__r.TECH_Adresse__c)) {
               genForDemande.writeNullField('LibelleAdresse');
               } 
               else {
               genForDemande.writeStringField('LibelleAdresse', demande.Emplacement__r.TECH_Adresse__c);
               } 
              genForDemande.writeEndObject();
             //genForDemande.writeEndArray();
              
             genForDemande.writeFieldName('SousEmplacement');
             //genForDemande.writeStartArray();
             genForDemande.writeStartObject();
              if (String.isEmpty(demande.Emplacement__r.EmplacementSite__c)) {
              genForDemande.writeNullField('IdSousEmplacement');
              genForDemande.writeNullField('DkCodeSousEmplacement');
              genForDemande.writeNullField('LibelleSousEmplacement');
              } 
              else {
              genForDemande.writeStringField('IdSousEmplacement', demande.Emplacement__r.EmplacementSite__r.Id);
              genForDemande.writeStringField('DkCodeSousEmplacement', demande.Emplacement__r.EmplacementSite__r.DKCode_Emplacement__c);
              genForDemande.writeStringField('LibelleSousEmplacement', demande.Emplacement__r.EmplacementSite__r.Name);
              } 
             genForDemande.writeEndObject();
            //genForDemande.writeEndArray();
              
           genForDemande.writeEndObject();
          genForDemande.writeEndObject();
               
           genForDemande.writeFieldName('Metadonnee');
           genForDemande.writeStartObject();
            genForDemande.writeDateTimeField('DateCreation', demande.CreatedDate);
            genForDemande.writeDateTimeField('DateModification', demande.LastModifiedDate);
            if (String.isEmpty(demande.CreatedBy.DkCode__c)) {
            genForDemande.writeNullField('UtilisateurCreation');
            } 
            else {
            genForDemande.writeStringField('UtilisateurCreation', demande.CreatedBy.DkCode__c);
            }
            
            if (String.isEmpty(demande.LastModifiedBy.DkCode__c)) {
            genForDemande.writeNullField('UtilisateurModification');
            } 
            else {
            genForDemande.writeStringField('UtilisateurModification', demande.LastModifiedBy.DkCode__c);
            }

            genForDemande.writeNumberField('NombreRelance', demande.NombreRelance__c);
           genForDemande.writeEndObject();
    
       genForDemande.writeEndObject();
       jsonSForDemande = genForDemande.getAsString();
       System.debug('jsonSForDemande :' + jsonSForDemande);
       WebServiceCallForConnecteurDACRC__mdt demande_OT = WebServiceCallForConnecteurDACRC__mdt.getInstance('demande_OTCall');

        String scope = demande_OT.Scope__c;
        String apiKey = demande_OT.APIKey__c;
        String suffixeUrldemande = demande_OT.suffixeURLdemande__c;
       
        System.debug('site : '  + site);
        String endpointDemande = 'callout:URLAPIForConnecteurDACRC' + suffixeUrldemande;

        String authorization = 'Bearer ' + access_token;
        wsLog.Request__c = endpointDemande;

        Http httpForDemande = new Http();
        HttpRequest requestForDemande = new HttpRequest();
        
        try {
            requestForDemande.setEndpoint(endpointDemande);
            requestForDemande.setMethod('POST');
            requestForDemande.setTimeout(2 * 60 * 1000);
            requestForDemande.setHeader('scope', scope);
            requestForDemande.setHeader('x-api-key', apiKey);

            requestForDemande.setHeader('Authorization', authorization);
            requestForDemande.setHeader('Accept', 'application/json');
            requestForDemande.setHeader('TypeDemande', demande.Recordtype.Name);
            requestForDemande.setHeader('DkCodeEmplacement', site);
            requestForDemande.setHeader('NumeroDemande', demande.CaseNumberMSAD__c);
            requestForDemande.setBody(jsonSForDemande);
            System.debug('requestForDemande : '  + requestForDemande);
            
            HttpResponse responseForDemande = httpForDemande.send(requestForDemande);
            
            System.debug('getDemande.getStatusCode : '  + responseForDemande.getStatusCode());
            System.debug('getDemande.getBody : '  + responseForDemande.getBody());
            
            if(responseForDemande.getStatusCode() == 200) {
               
                wsLog.Response__c = responseForDemande.getBody();
                wsLog.CodeRetour__c = '' + responseForDemande.getStatusCode();
                demande.StatutRetourWebServiceMSAD__c = 'OK'; 
                demande.MessageRetourWebServiceMSAD__c = /*demandeWRA.message*/ responseForDemande.getBody();
                demande.MessageRetourWebServiceMSAD__c = demande.MessageRetourWebServiceMSAD__c + ' au Statut : ' +demande.Status;
                System.debug('demande.MessageRetourWebServiceMSAD__c : '  + demande.MessageRetourWebServiceMSAD__c);

            }
            else {

                wsLog.StatusCode__c = 'KO';
                wsLog.Response__c = responseForDemande.getBody();
                wsLog.CodeRetour__c = '' + responseForDemande.getStatusCode();
                demande.StatutRetourWebServiceMSAD__c = 'KO'; 
                demande.MessageRetourWebServiceMSAD__c = /*demandeWRA.message*/ responseForDemande.getBody();
                demande.MessageRetourWebServiceMSAD__c = demande.MessageRetourWebServiceMSAD__c + ' au Statut : ' +demande.Status;
                System.debug('demande.MessageRetourWebServiceMSAD__c : '  + demande.MessageRetourWebServiceMSAD__c);
            }
        }
        catch(exception e) {

            demande.StatutRetourWebServiceMSAD__c = 'KO'; 
            demande.MessageRetourWebServiceMSAD__c = e.getMessage();
            System.debug('exception getConsigne() ');
            System.debug(e.getMessage());
            wsLog.Response__c = e.getMessage();
            wsLog.StatusCode__c = 'KO';

        }
        
        finally {
            wsLog.Type__c = 'envoi de demande';
            wsLog.flux__c = 'sortant'; // 'entrant' ou 'sortant'
            wsLog.Endpoint__c = endpointDemande;
            insert wsLog;
        }

        //return demandeWrapper;
        update demande;
    }
    
    @TestVisible
    private static /*Demande_OrdreTravailWrapper*/ void createOrdreTravail(String access_token, Intervention__c ordreTravail) {
        Demande_OrdreTravailWrapper ordreTravailWrapper;
        webservicelog__c wsLog = new WebserviceLog__c();
        String jsonSForOrdreTravail;

        JSONGenerator genForOrdreTravail = JSON.createGenerator(true);
        
        genForOrdreTravail.writeStartObject(); 
       
        if (String.isEmpty(ordreTravail.InterventionNumberMSAD__c)) {
            genForOrdreTravail.writeNullField('NumeroOt');
            } 
            else {
            genForOrdreTravail.writeStringField('NumeroOt', ordreTravail.InterventionNumberMSAD__c);
            }

         if (String.isEmpty(ordreTravail.Typologie__c)) {
            genForOrdreTravail.writeNullField('TypeActivite');
            } 
            else {
            genForOrdreTravail.writeStringField('TypeActivite', ordreTravail.Typologie__c);
            }
            
           if (String.isEmpty(ordreTravail.SousTypologie__c)) {
            genForOrdreTravail.writeNullField('SousTypeActivite');
            } 
            else {
            genForOrdreTravail.writeStringField('SousTypeActivite', ordreTravail.SousTypologie__c);
            }   
        genForOrdreTravail.writeStringField('LibelleIntervention', ordreTravail.Name);
        genForOrdreTravail.writeStringField('Description', ordreTravail.Description__c);
        
        if (String.isEmpty(ordreTravail.RealisationPartielle__c)) {
            genForOrdreTravail.writeNullField('RealisationPartielle');
            } 
            else {
            genForOrdreTravail.writeStringField('RealisationPartielle', ordreTravail.RealisationPartielle__c);
            }  
        
        
       genForOrdreTravail.writeFieldName('Statut');
       genForOrdreTravail.writeStartObject();
        genForOrdreTravail.writeStringField('StatutOt', ordreTravail.Statut__c);
        if (ordreTravail.DateMajStatut__c== Null) {
            genForOrdreTravail.writeNullField('DateMajStatut');
           }
        else {  
            genForOrdreTravail.writeDateTimeField('DateMajStatut', ordreTravail.DateMajStatut__c);
          }
       genForOrdreTravail.writeEndObject(); 
       
       genForOrdreTravail.writeFieldName('Planning');
       genForOrdreTravail.writeStartObject();
        if (ordreTravail.DateSouhaiteeDebutIntervention__c == Null) {
            genForOrdreTravail.writeNullField('PrevisionDateDebut');
           }
           else {  
            genForOrdreTravail.writeDateTimeField('PrevisionDateDebut', ordreTravail.DateSouhaiteeDebutIntervention__c);
           } 
        if (ordreTravail.DateSouhaiteeFinIntervention__c == Null) {
            genForOrdreTravail.writeNullField('PrevisionDateFin');
           }
           else {  
            genForOrdreTravail.writeDateTimeField('PrevisionDateFin', ordreTravail.DateSouhaiteeFinIntervention__c);
           }   
         
         if (ordreTravail.DureeSouhaitee__c == Null) {
            genForOrdreTravail.writeNullField('PrevisionDuree');
           }
           else {  
            genForOrdreTravail.writeNumberField('PrevisionDuree', ordreTravail.DureeSouhaitee__c);
           }   
           
        if (ordreTravail.DatePlanifieeDebutIntervention__c == Null) {
            genForOrdreTravail.writeNullField('PlanificationDateDebut');
           }
           else {  
            genForOrdreTravail.writeDateTimeField('PlanificationDateDebut', ordreTravail.DatePlanifieeDebutIntervention__c);
           } 
         if (ordreTravail.DatePlanifieeFinIntervention__c == Null) {
            genForOrdreTravail.writeNullField('PlanificationDateFin');
           }
           else {  
            genForOrdreTravail.writeDateTimeField('PlanificationDateFin', ordreTravail.DatePlanifieeFinIntervention__c);
           }   
       genForOrdreTravail.writeEndObject(); 
          
      genForOrdreTravail.writeFieldName('AffectationRessource');
      genForOrdreTravail.writeStartArray();        
       genForOrdreTravail.writeStartObject();   
          if (String.isEmpty(ordreTravail.Technicien__r.DkCode__c)) {
            genForOrdreTravail.writeNullField('DkCodeIntervenant');
            } 
            else {
            genForOrdreTravail.writeStringField('DkCodeIntervenant', ordreTravail.Technicien__r.DkCode__c);
            } 
         
          if (String.isEmpty(ordreTravail.Matricule__c)) {
            genForOrdreTravail.writeNullField('MatriculeIntervenant');
            } 
            else {
            genForOrdreTravail.writeStringField('MatriculeIntervenant', ordreTravail.Matricule__c);
            }
            
           if (String.isEmpty(ordreTravail.CorpsMetier__c)) {
            genForOrdreTravail.writeNullField('CorpsDeMetier');
            } 
            else {
            genForOrdreTravail.writeStringField('CorpsDeMetier', ordreTravail.CorpsMetier__c);
            }   
            
            if (String.isEmpty(ordreTravail.TypeAffectation__c)) {
            genForOrdreTravail.writeNullField('TypeAffectation');
            } 
            else {
            genForOrdreTravail.writeStringField('TypeAffectation', ordreTravail.TypeAffectation__c);
            } 
                              
          if (String.isEmpty(ordreTravail.MotifDeplanification__c)) {
            genForOrdreTravail.writeNullField('MotifDePlanification');
            } 
            else {
            genForOrdreTravail.writeStringField('MotifDePlanification', ordreTravail.MotifDeplanification__c);
            }  
          
            genForOrdreTravail.writeFieldName('CompteRendu');
            genForOrdreTravail.writeStartObject();   
               if (String.isEmpty(ordreTravail.CommentaireClient__c)) {
                genForOrdreTravail.writeNullField('CommentaireClient');
                } 
                else {
                genForOrdreTravail.writeStringField('CommentaireClient', ordreTravail.CommentaireClient__c);
                }  
               
               if (String.isEmpty(ordreTravail.CommentaireInterne__c)) {
                genForOrdreTravail.writeNullField('CommentaireInterne');
                } 
                else {
                genForOrdreTravail.writeStringField('CommentaireInterne', ordreTravail.CommentaireInterne__c);
                }   
                
                if (ordreTravail.DateDebutIntervention__c == Null) {
                genForOrdreTravail.writeNullField('InterventionDateDebut');
               }
               else {  
                genForOrdreTravail.writeDateTimeField('InterventionDateDebut', ordreTravail.DateDebutIntervention__c);
               } 
               
               if (ordreTravail.DateFinIntervention__c == Null) {
                genForOrdreTravail.writeNullField('InterventionDateFin');
               }
               else {  
                genForOrdreTravail.writeDateTimeField('InterventionDateFin', ordreTravail.DateFinIntervention__c);
               } 
               
              genForOrdreTravail.writeFieldName('Analyse');
              genForOrdreTravail.writeStartObject();   
               if (String.isEmpty(ordreTravail.ProblemeRegle__c)) {
                genForOrdreTravail.writeNullField('MotifProblemeNonRegle');
                } 
                else {
                genForOrdreTravail.writeStringField('MotifProblemeNonRegle', ordreTravail.ProblemeRegle__c);
                } 
              genForOrdreTravail.writeEndObject();    
            genForOrdreTravail.writeEndObject(); 
         genForOrdreTravail.writeEndObject();      
        genForOrdreTravail.writeEndArray(); 
           
        genForOrdreTravail.writeFieldName('Site');
        genForOrdreTravail.writeStartObject();
           genForOrdreTravail.writeStringField('DkCodeEmplacement', ordreTravail.LibelleEmplacement__c);
           genForOrdreTravail.writeFieldName('SousEmplacement');
           genForOrdreTravail.writeStartObject();
              if (String.isEmpty(ordreTravail.LibelleSousEmplacement__c)) {
            genForOrdreTravail.writeNullField('DkCodeSousEmplacement');
            } 
            else {
            genForOrdreTravail.writeStringField('DkCodeSousEmplacement', ordreTravail.LibelleSousEmplacement__c);
            }  
           genForOrdreTravail.writeEndObject(); 
        genForOrdreTravail.writeEndObject(); 
              
                 
        genForOrdreTravail.writeFieldName('Demande');
        genForOrdreTravail.writeStartObject();
         genForOrdreTravail.writeStringField('NumeroDemande', ordreTravail.Demande__r.CaseNumberMSAD__c);
        genForOrdreTravail.writeEndObject();  
        
        genForOrdreTravail.writeFieldName('Metadonnees');
           genForOrdreTravail.writeStartObject();
            genForOrdreTravail.writeDateTimeField('DateCreation', ordreTravail.CreatedDate);
            if (String.isEmpty(ordreTravail.CreatedBy.DkCode__c)) {
            genForOrdreTravail.writeNullField('UtilisateurCreation');
            } 
            else {
            genForOrdreTravail.writeStringField('UtilisateurCreation', ordreTravail.CreatedBy.DkCode__c);
            }
            
            genForOrdreTravail.writeDateTimeField('DateModification', ordreTravail.LastModifiedDate);
            if (String.isEmpty(ordreTravail.LastModifiedBy.DkCode__c)) {
            genForOrdreTravail.writeNullField('UtilisateurModification');
            } 
            else {
            genForOrdreTravail.writeStringField('UtilisateurModification', ordreTravail.LastModifiedBy.DkCode__c);
            }
         genForOrdreTravail.writeEndObject();
         
         //genForOrdreTravail.writeStringField('Origine', ordreTravail.Origine__c);
        
           
           
                
          /*  
          if (String.isEmpty(ordreTravail.IdOT__c)) {
            genForOrdreTravail.writeNullField('IDOT');
            } 
            else {
            genForOrdreTravail.writeStringField('IDOT', ordreTravail.IdOT__c);
            }
            
         

           if (ordreTravail.Priorite__c == Null) {
            genForOrdreTravail.writeNullField('PRIORITE');
            } 
            else {
            genForOrdreTravail.writeNumberField('PRIORITE', ordreTravail.Priorite__c);
            }
            
           if (ordreTravail.DateSouhaiteeFinIntervention__c == Null) {
            genForOrdreTravail.writeNullField('DATEFINSOUHAITEE');
           }
          else {  
            genForOrdreTravail.writeDateTimeField('DATEFINSOUHAITEE', ordreTravail.DateSouhaiteeFinIntervention__c);
           }
           
           if (ordreTravail.DateAffectationOT__c == Null) {
            genForOrdreTravail.writeNullField('DATEAFFECOT');
           }
          else {  
            genForOrdreTravail.writeDateTimeField('DATEAFFECOT', ordreTravail.DateAffectationOT__c);
           }
           
           if (ordreTravail.DateDebutIntervention__c == Null) {
            genForOrdreTravail.writeNullField('RENDEZVOUSREQUIS');
           }
           else {  
            genForOrdreTravail.writeDateTimeField('RENDEZVOUSREQUIS', ordreTravail.DateDebutIntervention__c);
           }
                    
           if (ordreTravail.DateFinIntervention__c == Null) {
            genForOrdreTravail.writeNullField('DATEFININT');
           }
           else {  
            genForOrdreTravail.writeDateTimeField('DATEFININT', ordreTravail.DateFinIntervention__c);
           }
              
            if (ordreTravail.DureeIntervention__c == Null) {
            genForOrdreTravail.writeNullField('DUREEINT');
            } 
            else {
            genForOrdreTravail.writeNumberField('DUREEINT', ordreTravail.DureeIntervention__c);
            }
           
            if (ordreTravail.DureeDeplacement__c == Null) {
            genForOrdreTravail.writeNullField('DUREEDEP');
            } 
            else {
            genForOrdreTravail.writeNumberField('DUREEDEP', ordreTravail.DureeDeplacement__c);
            }
            
            if (ordreTravail.DureeGlobale__c == Null) {
            genForOrdreTravail.writeNullField('DUREEGLO');
            } 
            else {
            genForOrdreTravail.writeNumberField('DUREEGLO', ordreTravail.DureeGlobale__c);
            }
            
            if (ordreTravail.DateValidationMop__c == Null) {
            genForOrdreTravail.writeNullField('DATEVALIMOP');
           }
           else {  
            genForOrdreTravail.writeDateTimeField('DATEVALIMOP', ordreTravail.DateValidationMop__c);
           }
           
           if (ordreTravail.DateCloture__c == Null) {
            genForOrdreTravail.writeNullField('DATECLO');
           }
           else {  
            genForOrdreTravail.writeDateTimeField('DATECLO', ordreTravail.DateCloture__c);
           }
           
            if (String.isEmpty(ordreTravail.EnvoiCRClient__c)) {
            genForOrdreTravail.writeNullField('CRCLI');
            } 
            else {
            genForOrdreTravail.writeStringField('CRCLI', ordreTravail.EnvoiCRClient__c);
            }  
            
            if (String.isEmpty(ordreTravail.ProblemeRegle__c)) {
            genForOrdreTravail.writeNullField('PRO');
            } 
            else {
            genForOrdreTravail.writeStringField('PRO', ordreTravail.ProblemeRegle__c);
            }  
                       
            if (String.isEmpty(ordreTravail.CausePanne__c)) {
            genForOrdreTravail.writeNullField('PANNE');
            } 
            else {
            genForOrdreTravail.writeStringField('PANNE', ordreTravail.CausePanne__c);
            } 
                
            
            genForOrdreTravail.writeBooleanField('MULTI', ordreTravail.MultiIntervenant__c);   
            
            if (String.isEmpty(ordreTravail.LocalisationTechnique__c)) {
            genForOrdreTravail.writeNullField('LOC');
            } 
            else {
            genForOrdreTravail.writeStringField('LOC', ordreTravail.LocalisationTechnique__c);
            } 
            
            if (String.isEmpty(ordreTravail.RdvClient__c)) {
            genForOrdreTravail.writeNullField('RDVCLI');
            } 
            else {
            genForOrdreTravail.writeStringField('RDVCLI', ordreTravail.RdvClient__c);
            } 
            
            if (String.isEmpty(ordreTravail.SousTraitant__c)) {
            genForOrdreTravail.writeNullField('SOUSTRA');
            } 
            else {
            genForOrdreTravail.writeStringField('SOUSTRA', ordreTravail.SousTraitant__c);
            } 
            
            if (String.isEmpty(ordreTravail.Materiel__c)) {
            genForOrdreTravail.writeNullField('MAT');
            } 
            else {
            genForOrdreTravail.writeStringField('MAT', ordreTravail.Materiel__c);
            } 
            
            if (String.isEmpty(ordreTravail.CommentaireManager__c)) {
            genForOrdreTravail.writeNullField('COMMAN');
            } 
            else {
            genForOrdreTravail.writeStringField('COMMAN', ordreTravail.CommentaireManager__c);
            } 
            
            if (String.isEmpty(ordreTravail.CommentaireClient__c)) {
            genForOrdreTravail.writeNullField('COMCLI');
            } 
            else {
            genForOrdreTravail.writeStringField('COMCLI', ordreTravail.CommentaireClient__c);
            } 
            
            if (String.isEmpty(ordreTravail.CommentaireInterne__c)) {
            genForOrdreTravail.writeNullField('COMINT');
            } 
            else {
            genForOrdreTravail.writeStringField('COMINT', ordreTravail.CommentaireInterne__c);
            } 
            
            if (String.isEmpty(ordreTravail.Observation__c)) {
            genForOrdreTravail.writeNullField('OBSE');
            } 
            else {
            genForOrdreTravail.writeStringField('OBSE', ordreTravail.Observation__c);
            } 
            
            if (String.isEmpty(ordreTravail.MotifProbleme__c)) {
            genForOrdreTravail.writeNullField('MOPRO');
            } 
            else {
            genForOrdreTravail.writeStringField('MOPRO', ordreTravail.MotifProbleme__c);
            } 

            
            if (String.isEmpty(ordreTravail.GMAO__c)) {
            genForOrdreTravail.writeNullField('GMAO');
            } 
            else {
            genForOrdreTravail.writeStringField('GMAO', ordreTravail.GMAO__c);
            }
            
            if (String.isEmpty(ordreTravail.NumeroOTGmao__c)) {
            genForOrdreTravail.writeNullField('NUMOTGMAO');
            } 
            else {
            genForOrdreTravail.writeStringField('NUMOTGMAO', ordreTravail.NumeroOTGmao__c);
            }
            
            if (String.isEmpty(ordreTravail.NumeroOTParent__c)) {
            genForOrdreTravail.writeNullField('NUMOTPAR');
            } 
            else {
            genForOrdreTravail.writeStringField('NUMOTPAR', ordreTravail.NumeroOTParent__c);
            }
         */   
                                            
       genForOrdreTravail.writeEndObject();
       jsonSForOrdreTravail = genForOrdreTravail.getAsString();
       System.debug('jsonSForOrdreTravail :' + jsonSForOrdreTravail);
       WebServiceCallForConnecteurDACRC__mdt demande_OT = WebServiceCallForConnecteurDACRC__mdt.getInstance('demande_OTCall');

        String scope = demande_OT.Scope__c;
        String apiKey = demande_OT.APIKey__c;
        String suffixeUrlOT = demande_OT.suffixeURLOT__c;
        
        String endpointOrdreTravail = 'callout:URLAPIForConnecteurDACRC' + suffixeUrlOT;
        String authorization = 'Bearer ' + access_token;
        wsLog.Request__c = endpointOrdreTravail;

        Http httpForOrdreTravail = new Http();
        HttpRequest requestForOrdreTravail = new HttpRequest();

        
        try {
            requestForOrdreTravail.setEndpoint(endpointOrdreTravail);
            requestForOrdreTravail.setMethod('POST');
            requestForOrdreTravail.setTimeout(2 * 60 * 1000);
            requestForOrdreTravail.setHeader('scope', scope);
            requestForOrdreTravail.setHeader('x-api-key', apiKey);

            requestForOrdreTravail.setHeader('Authorization', authorization);
            requestForOrdreTravail.setHeader('Accept', 'application/json');
            requestForOrdreTravail.setBody(jsonSForOrdreTravail);
            System.debug('requestForOrdreTravail : '  + requestForOrdreTravail);
            
            HttpResponse responseForOrdreTravail = httpForOrdreTravail.send(requestForOrdreTravail);
            
            System.debug('getOrdreTravail.getStatusCode : '  + responseForOrdreTravail.getStatusCode());
            System.debug('getOrdreTravail.getBody : '  + responseForOrdreTravail.getBody());
            System.debug('ordreTravail.MessageRetourWebServiceMSAD__c : '  + ordreTravail.MessageRetourWebServiceMSAD__c);
            
            if(responseForOrdreTravail.getStatusCode() == 200) {
            
               System.debug('ordreTravailWrapper : '  + ordreTravailWrapper);
                wsLog.Response__c = responseForOrdreTravail.getBody();
                wsLog.CodeRetour__c = '' + responseForOrdreTravail.getStatusCode();
                ordreTravail.StatutRetourWebServiceMSAD__c = 'OK'; 
                ordreTravail.MessageRetourWebServiceMSAD__c = responseForOrdreTravail.getBody();
                ordreTravail.MessageRetourWebServiceMSAD__c = ordreTravail.MessageRetourWebServiceMSAD__c + ' au Statut : ' +ordreTravail.Statut__c;
                System.debug('ordreTravail.MessageRetourWebServiceMSAD__c : '  + ordreTravail.MessageRetourWebServiceMSAD__c);


            }
            else {
                wsLog.StatusCode__c = 'KO';
                wsLog.Response__c = responseForOrdreTravail.getBody();
                wsLog.CodeRetour__c = '' + responseForOrdreTravail.getStatusCode();
                ordreTravail.StatutRetourWebServiceMSAD__c = 'KO'; 
                ordreTravail.MessageRetourWebServiceMSAD__c = responseForOrdreTravail.getBody();
                ordreTravail.MessageRetourWebServiceMSAD__c = ordreTravail.MessageRetourWebServiceMSAD__c + ' au Statut : ' +ordreTravail.Statut__c;
                System.debug('ordreTravail.MessageRetourWebServiceMSAD__c : '  + ordreTravail.MessageRetourWebServiceMSAD__c);

            }
        }
        catch(exception e) {
            ordreTravail.StatutRetourWebServiceMSAD__c = 'KO'; 
            System.debug('exception getConsigne() ');
            System.debug(e.getMessage());
            wsLog.Response__c = e.getMessage();
            wsLog.StatusCode__c = 'KO';

        }
        
        finally {
            wsLog.Type__c = 'envoi ordre travail';
            wsLog.flux__c = 'sortant'; // 'entrant' ou 'sortant'
            wsLog.Endpoint__c = endpointOrdreTravail;
            insert wsLog;
        }

        //return ordreTravailWrapper ;
        update ordreTravail;
    }
    
    @future(callout=true)
    //add comments about source
    public static void sendCase_trigger(Id idDemande, String site)
    {
      sendCase(idDemande, site);
     }
     
    public static /*DemandeWrapper*/void  sendCase(Id idDemande, String site) {

    Demande_OrdreTravailWrapper demandeWrapper = new Demande_OrdreTravailWrapper();
    //consigneWrapper.isError = false;
    String accessToken = getToken(demandeWrapper);
    Case demande = getDemande(idDemande);

   // if (consigneWrapper.isError == false) {

        createDemande(accessToken, demande, site);

    //}
    //return demandeWrapper;
 }
 
    @future(callout=true)
    //add comments about source
    public static void sendOrdreTravail_trigger(Id idDemande)
    {
      sendOrdreTravail(idDemande);
     }
 
     public static /*DemandeWrapper*/void  sendOrdreTravail(Id idDemande) {
    Demande_OrdreTravailWrapper OTWrapper = new Demande_OrdreTravailWrapper();
    String accessToken = getToken(OTWrapper);
    List<Intervention__c> ListordreTravail = getOrdreTravail(idDemande);
    /// Faire une boucle sur les ordre travails recuperes soit 1 soit 2
    for (intervention__c ordreTravail : ListordreTravail) {
    //Intervention__c ordreTravail = ListordreTravail[0];
   // if (consigneWrapper.isError == false) {

        createOrdreTravail (accessToken, ordreTravail);
        // }
    }
    //return demandeWrapper;
 }
    

}