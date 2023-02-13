/**
* @author: Alain Ghoussoub -EI Technologies
* @date: 10/01/2019
* @description: Class qui gère le web service entrant Adresse
*/
global class WS03_AdressePartenaire {
    global class Adresse_Partenaire {
        webservice Header header; 
        webservice string DKCodePartenaire;//DKCodeSurPartenaire__c
        webservice string DKCodeSociete;
        webservice string utilisationFiliereCommerce;
        webservice string utilisationFiliereAchats;
        webservice string categorieSociete;
        webservice string naturePartenaire;
        webservice listeAdresses listeAdresses;
    }
    global class listeAdresses{ 
        webservice List<adresse> adresse;
    }
    global class adresse{
        webservice string DKCodeAdresse;//TO CREATE
        webservice boolean adressePrincipale;
        webservice string statutAdresse;//Statut_adresse_1__c
        webservice string precisionDestinataire;//to create
        webservice string precisionIdentificationAdresse;//to create
        webservice string numeroVoie;//BillingStreet
        webservice string typeDeVoie;//BillingStreet
        webservice string libelleVoie;//BillingStreet
        webservice string complementAdresse;//BillingStreet
        webservice string codePostal;//BillingPostalCode
        webservice string ville;//BillingCity
        webservice string pays;//BillingCountry
        webservice string telephone;//Phone
        webservice string fax;//Fax
        webservice string codeClientOracle;//NO?
        webservice string codeFournisseurOracle;//NO?
        webservice string referenceAdresseClient;//Reference_adresse__c
        webservice string referenceAdresseFournisseur;//NO?
        webservice boolean dematerialise;//NO?
        webservice listeAffacturages listeAffacturages;
        webservice listeMandataires listeMandataires;
        webservice metadonneesAdressePartenaire metadonneesAdressePartenaire;
    }
    global class listeAffacturages{
        webservice List<affacturage> affacturage;
    }
    global class listeMandataires{
        webservice List<mandataire> mandataire;
    }
    global class affacturage{
        webservice string DKCPartenaireAffacturage;
        webservice string DKCAdressePartenaireAffacturage;
        webservice boolean statutLienAffacturage;
    }
    global class mandataire{
        webservice string DKCPartenaireMandataire;
        webservice string DKCAdressePartenaireMandataire;
        webservice boolean statutLienMandataire; 
    }
    global class metadonneesAdressePartenaire{
        webservice datetime creationDate;//CreatedDate
        webservice string creationId;//CreatedBy
        webservice datetime updateDate;//LastModifiedDate
        webservice string updateId;//LastModifiedBy
        webservice datetime validationDate;
        webservice string validationId;
    }
    webservice static Response modifierAdressePartenaire(Adresse_Partenaire adresse_partenaire) {
        WebserviceLog__c ws = new WebserviceLog__c();
        ws.Request__c = adresse_partenaire+'';
        ws.Type__c = Label.WS_Adresse;
        ws.flux__c = Label.WSTypeFluxEntrant;
        insert ws;
        Response resp = new Response();
        resp.errorText = '';
        resp.error = false;
        resp.responseCode = Label.WS_Response_OK;
        Account accountToInsert = new Account();
        
        //délaration des champs WebServiceLog 
 		if(Adresse_Partenaire.header != null){
            if (Adresse_Partenaire.header.transactionId!=null) {
                ws.TransactionId__c = Adresse_Partenaire.header.transactionId;
            }
        }
        //Adresse_Partenaire
        if(String.isNotBlank(Adresse_Partenaire.DKCodePartenaire)){
            ws.DkCode__c= Adresse_Partenaire.DKCodePartenaire;
            List<account> accList = new List<Account>();
            accList = [Select id 
                       From account 
                       Where DKCodeSurPartenaire__c = : Adresse_Partenaire.DKCodePartenaire];
            if(accList != null && accList.size()>0){
                System.debug('Account exists');
                accountToInsert.id = accList[0].id;
            }
            else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += 'Le partenaire avec le DKCode ' + Adresse_Partenaire.DKCodePartenaire +' n\'existe pas dans C360 ' + '\n';
                resp.error = true;
            }
        }
        else{
            resp.responseCode = Label.WS_Response_KO;
            resp.errorText += Label.WS03_DKCodePartenaireOB + '\n';
            resp.error = true;
        }
        
        if(String.isNotBlank(Adresse_Partenaire.DKCodeSociete)){
            accountToInsert.DkCodeSociete__c = Adresse_Partenaire.DKCodeSociete;
            try{
                List<Account> accList = [Select id 
                                         From account 
                                         Where DKCodeSurPartenaire__c = : Adresse_Partenaire.DKCodeSociete];
                if(accList  != null && accList.size()>0){
                    accountToInsert.parentid  = accList[0].id;
                }
            }
            catch(Exception e){
                system.debug('Error' + e.getMessage());
            }
        }
        accountToInsert.Utilisation_filiere_Commerce__c = Label.WS03_Inactif;
        if(String.isNotBlank(Adresse_Partenaire.utilisationFiliereCommerce) && Adresse_Partenaire.utilisationFiliereCommerce=='true'){
            accountToInsert.Utilisation_filiere_Commerce__c = Label.WS03_Actif;
        }
        else{
            resp.responseCode = Label.WS_Response_KO;
            resp.errorText += Label.WS03_utilisationFiliereCommerceOB + '\n';
            resp.error = true;
        }
        accountToInsert.Utilisation_Filiere_Achat__c = false;
        if(String.isNotBlank(Adresse_Partenaire.utilisationFiliereAchats)){
            if(Adresse_Partenaire.utilisationFiliereAchats==Label.WS03_True){
                accountToInsert.Utilisation_Filiere_Achat__c = true;
                
            }
        }
        else{
            resp.responseCode = Label.WS_Response_KO;
            resp.errorText += Label.WS03_utilisationFiliereAchatsOB + '\n';
            resp.error = true;
        }
        
        if(String.isNotBlank(Adresse_Partenaire.categorieSociete)){
            accountToInsert.Categorie_partenaire__c = Adresse_Partenaire.categorieSociete;
        }
        
        if(String.isNotBlank(Adresse_Partenaire.naturePartenaire)){
            accountToInsert.NaturePartenaire__c = Adresse_Partenaire.naturePartenaire;
        }
        else{
            resp.responseCode = Label.WS_Response_KO;
            resp.errorText += Label.WS03_naturePartenaireOB + '\n';
            resp.error = true;
        }
        Boolean principal = false;
        String pays = '';
        String creationId = '';
        String updateId = '';
        String validationId = '';
        //listeAdresses
        if(Adresse_Partenaire.listeAdresses!=null && Adresse_Partenaire.listeAdresses.adresse != null){
            for(adresse add : Adresse_Partenaire.listeAdresses.adresse){
                if(add.adressePrincipale != null && add.adressePrincipale == true ){
                    principal = true;
                    if(String.isNotBlank(add.DKCodeAdresse)){
                        accountToInsert.DkCodeAdressePrincipale__c = add.DKCodeAdresse;
                    }
                    else{
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS03_DKCodeAdresseOB + '\n';
                        resp.error = true;
                    }
                    if(String.isNotBlank(add.statutAdresse)){
                        accountToInsert.Statut_adresse_1__c = add.statutAdresse;
                    }
                    else{
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS03_statutAdresseOB + '\n';
                        resp.error = true;
                    }
                    if(String.isNotBlank(add.precisionDestinataire)){
                        accountToInsert.PrecisionDestinataire__c = add.precisionDestinataire;
                    }
                    if(String.isNotBlank(add.precisionIdentificationAdresse)){
                        accountToInsert.PrecisionIdentificationAdresse__c = add.precisionIdentificationAdresse;
                    }
                    accountToInsert.BillingStreet = '';
                    if(add.numeroVoie != null){
                        accountToInsert.BillingStreet += add.numeroVoie + ' ';
                    }
                    if(add.typeDeVoie != null){
                        if(add.typeDeVoie == Label.WS03_Vide){
                            accountToInsert.BillingStreet = '';
                        }
                        else{
                            accountToInsert.BillingStreet += add.typeDeVoie + ' ';
                        }
                    }
                    if(String.isNotBlank(add.libelleVoie) || add.libelleVoie == ' '){
                        accountToInsert.BillingStreet += add.libelleVoie;
                    }
                    else{
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS03_libelleVoieOB + '\n';
                        resp.error = true;
                    }
                    if(String.isNotBlank(add.complementAdresse)){
                        accountToInsert.ComplementAdresse__c = add.complementAdresse;
                    }
                    if(String.isNotBlank(add.codePostal)){
                        accountToInsert.BillingPostalCode = add.codePostal;
                    }
                    else{
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS03_codePostalOB + '\n';
                        resp.error = true;
                    }
                    if(String.isNotBlank(add.ville)){
                        accountToInsert.BillingCity = add.ville;
                    }
                    else{
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS03_VilleOB + '\n';
                        resp.error = true;
                    }
                    if(String.isNotBlank(add.pays)){
                        pays = add.pays;
                    }
                    else{
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS03_PaysOB + '\n';
                        resp.error = true;
                    }
                    if(String.isNotBlank(add.telephone)){
                        accountToInsert.Phone = add.telephone;
                    }
                    if(String.isNotBlank(add.fax)){
                        accountToInsert.fax = add.fax;
                    }
                    if(String.isNotBlank(add.codeClientOracle)){
                        accountToInsert.Code_Client_Oracle__c = add.codeClientOracle;
                    }
                    if(String.isNotBlank(add.codeFournisseurOracle)){
                        //accountToInsert.Numero_fournisseur_DK_client__c = add.codeFournisseurOracle;
                    }
                    if(String.isNotBlank(add.referenceAdresseClient)){
                        accountToInsert.Reference_adresse__c = add.referenceAdresseClient;
                    }
                    if(String.isNotBlank(add.referenceAdresseFournisseur)){
                        //accountToInsert.Reference_adresse_2__c = add.referenceAdresseFournisseur;
                    }
                    if(add.dematerialise!=null){
                        accountToInsert.Dematerialise__c = add.dematerialise;
                    }
                    if(add.listeAffacturages!=null && add.listeAffacturages.affacturage != null){
                        //accountToInsert.?? = add.affacturage;
                        for(affacturage aff : add.listeAffacturages.affacturage){
                            //if(add.affacturage.DKCPartenaireAffacturage != null){
                            //accountToInsert.?? = add.affacturage.DKCPartenaireAffacturage;
                            //}
                            //else{
                            //resp.responseCode = 'KO';
                            //resp.errorText += 'Le champ DKCPartenaireAffacturage est obligatoire \n';
                            //resp.error = true;
                            //}
                            //if(add.affacturage.DKCAdressePartenaireAffacturage != null){
                            //accountToInsert.?? = add.affacturage.DKCAdressePartenaireAffacturage;
                            //}
                            //else{
                            //resp.responseCode = 'KO';
                            //resp.errorText += 'Le champ DKCAdressePartenaireAffacturage est obligatoire \n';
                            //resp.error = true;    
                            //}        
                            //if(add.affacturage.statutLienAffacturage != null){
                            //accountToInsert.?? = add.affacturage.statutLienAffacturage;
                            //}
                            //else{
                            //resp.responseCode = 'KO';
                            //resp.errorText += 'Le champ statutLienAffacturage est obligatoire \n';
                            //resp.error = true;    
                            //} 
                        }  
                    }
                    if(add.listeMandataires!=null && add.listeMandataires.mandataire != null ){
                        //for(mandataire aff : add.mandataire){
                        //if(add.mandataire.DKCPartenaireMandataire != null){
                        //accountToInsert.?? = add.mandataire.DKCPartenaireMandataire;
                        // }
                        // else{
                        //resp.responseCode = 'KO';
                        //resp.errorText += 'Le champ DKCPartenaireMandataire est obligatoire \n';
                        //resp.error = true;            
                        //}  
                        // if(add.mandataire.DKCAdressePartenaireMandataire != null){
                        //accountToInsert.?? = add.mandataire.DKCAdressePartenaireMandataire;
                        // }
                        // else{
                        //resp.responseCode = 'KO';
                        //resp.errorText += 'Le champ DKCAdressePartenaireMandataire est obligatoire \n';
                        //resp.error = true;            
                        //}    
                        // if(add.mandataire.statutLienMandataire != null){
                        //accountToInsert.?? = add.mandataire.statutLienMandataire;
                        // }
                        // else{
                        //resp.responseCode = 'KO';
                        //resp.errorText += 'Le champ statutLienMandataire est obligatoire \n';
                        //resp.error = true;             
                        // } 
                        // }
                    }
                    if(add.metadonneesAdressePartenaire!=null){
                        if(add.metadonneesAdressePartenaire.creationDate != null){
                            accountToInsert.AdresseCreationDate__c = add.metadonneesAdressePartenaire.creationDate;
                        }
                        else{
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS06_creationDateOB + '\n';
                            resp.error = true;
                        }
                        if(String.isNotBlank(add.metadonneesAdressePartenaire.creationId)){
                            creationId = add.metadonneesAdressePartenaire.creationId;
                        }
                        else{
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS06_creationId + '\n';
                            resp.error = true;
                        }
                        if(add.metadonneesAdressePartenaire.updateDate != null){
                            accountToInsert.AdresseUpdateDate__c = add.metadonneesAdressePartenaire.updateDate;
                        }
                        if(String.isNotBlank(add.metadonneesAdressePartenaire.updateId)){
                            updateId = add.metadonneesAdressePartenaire.updateId;
                        }
                        if(add.metadonneesAdressePartenaire.validationDate != null){
                            accountToInsert.AdresseValidationDate__c = add.metadonneesAdressePartenaire.validationDate;
                        }
                        if(String.isNotBlank(add.metadonneesAdressePartenaire.validationId)){
                            validationId = add.metadonneesAdressePartenaire.validationId;
                        }
                    }
                    else{
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS06_MetadonneesOB + '\n';
                        resp.error = true;
                    }
                }
                else{
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS03_adressePrincipaleOB + '\n';
                    resp.error = true;
                }
            }
            if(principal == true){
                List<Pays__c> paysList = new List<Pays__c>();
                if(pays != ''){
                    paysList = [SELECT id,Abreviation__c,Nom__c  from Pays__c where Abreviation__c = :pays];
                }
                if(paysList != null && paysList.size()>0){
                    accountToInsert.BillingCountry = paysList[0].Nom__c;
                }
                else{
                    accountToInsert.BillingCountry = pays;
                }
            }
            List<User> userMetadonne = new List<User>();
            userMetadonne = [SELECT id,name,ReferentielId__c 
                             FROM user 
                             WHERE ReferentielId__c = : creationId
                             OR ReferentielId__c = : updateId
                             OR ReferentielId__c = : validationId];
            if(creationId != ''){
                for(User userLoop : userMetadonne){
                    if(userLoop.ReferentielId__c == creationId){
                        accountToInsert.CreateId__c  = userLoop.id;  
                    }
                }
            }
            if(updateId != ''){
                for(User userLoop : userMetadonne){
                    if(userLoop.ReferentielId__c == updateId){
                        accountToInsert.updateId__c  = userLoop.id;  
                    }
                }
            }
            if(validationId != ''){
                for(User userLoop : userMetadonne){
                    if(userLoop.ReferentielId__c == validationId){
                        accountToInsert.validationId__c  = userLoop.id;  
                    }
                }
            }
        }
        ws.Response__c = resp+'';
        if(resp.error == true){
            ws.Statut__c = 'KO';
            ws.ErrorText__c = resp.errorText;
            if(ws.ErrorText__c != null && ws.ErrorText__c.length()>254){
                ws.ErrorText__c =  ws.ErrorText__c.substring(0,254);
            }
        }
        else{
            ws.Statut__c = 'OK';
        }
        upsert ws;
        if(principal == false){
            resp.error = false;
            resp.responseCode = Label.WS_Response_OK;
            resp.errorText += '';
            ws.Response__c = resp+'';
            update ws;
            return resp;
        }
        if(!resp.error && principal == true){
            try{
                update accountToInsert;
            }
            catch(Exception e){
                ws.Statut__c ='KO';
                ws.ErrorText__c = e.getMessage();
                if(ws.ErrorText__c != null && ws.ErrorText__c.length()>254){
                    ws.ErrorText__c =  ws.ErrorText__c.substring(0,254);
                }
                resp.error = true;
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS03_Error + e.getMessage() + '\n';
                System.debug('insertUpdateAdressePartenaire update error ' + e.getMessage());
                ws.Response__c = resp+ Label.WS03_AfterError + e.getMessage();
                update ws;
            }
        }
        return resp;
    }
}