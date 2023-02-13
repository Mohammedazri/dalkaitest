/**
* @author: Alain Ghoussoub -EI Technologies
* @date: 10/01/2019
* @description: Class qui gère le web service entrant affaire
*/
global class WS06_Affaire { 
    global class Affaire {
        webservice Header header;
        webservice ProprietesAffaire proprietesAffaire;
        webservice List<LienDas> lienDas;
        webservice List<LienResponsable> lienResponsable;
        webservice List<LienReportingProjetFinance> lienReportingProjetFinance;
        webservice List<LienReportingSee> lienReportingSee;
        webservice List<LienContrats> lienContrats;
        webservice Metadonnees metadonnees;
    }
    global class ProprietesAffaire{
        webservice String dkCodeAffaire;
        webservice String libelle;
        webservice String commentaire;
        webservice String statutFinance;
        webservice DateTime dateDebut;
        webservice DateTime dateFin;
        webservice DateTime dateFermeture;
        webservice String UODalkiaPilote;
        webservice String localisationAffaire;
        webservice String reportingAffaire;
    }
    global class LienDas{
        webservice String dasDalkia;
        webservice DateTime dateDebut;
        webservice DateTime dateFin;
    }
    global class LienResponsable{
        webservice String responsableAffaire;
        webservice DateTime dateDebut;
        webservice DateTime dateFin;
    }
    global class LienReportingProjetFinance{
        webservice String reportingProjetFinance;
    }
    global class LienReportingSee{
        webservice String reportingSee;
    }
    global class LienContrats{
        webservice String dkCodeContrat;
    }
    global class Metadonnees{
        webservice DateTime creationDate;
        webservice String creationId;
        webservice DateTime updateDate;
        webservice String updateId;
        webservice DateTime validationDate;
        webservice String validationId;
    }
    webservice static Response insertUpdateAffaire(Affaire affaire) {
        Response resp = new Response();
        resp.error = false;
        resp.responseCode = Label.WS_Response_OK;
        resp.errorText = '';
        WebserviceLog__c ws = new WebserviceLog__c();
        ws.Request__c = affaire+'';
        ws.Type__c = Label.WS_Affaire;
        ws.flux__c = Label.WSTypeFluxEntrant;
        insert ws;
        
        Affaire__c affaireToInsert = new Affaire__c();
        
        //Header
        if(Affaire.header != null){
            if (Affaire.header.transactionId!=null) {
                ws.TransactionId__c = Affaire.header.transactionId;
            }
        }
        
        //ProprietesAffaire
        if( Affaire.ProprietesAffaire != null){
            if(String.isNotBlank(Affaire.ProprietesAffaire.dkCodeAffaire)){
                affaireToInsert.DkCode__c = Affaire.ProprietesAffaire.dkCodeAffaire;
                ws.DkCode__c= Affaire.ProprietesAffaire.dkCodeAffaire;   
            }
            else {
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS06_dkCodeAffaireOB + '\n';
                resp.error = true;
            }
            if(String.isNotBlank(Affaire.ProprietesAffaire.libelle)){
                affaireToInsert.Libelle__c = Affaire.ProprietesAffaire.libelle;
                String tempName = Affaire.ProprietesAffaire.libelle;
                if(tempName != null){
                    if(tempName.length()>80){
                        tempName =  tempName.substring(0,80);
                    }
                }
                affaireToInsert.Name = tempName;
            }
            else {
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS06_libelleOB + '\n';
                resp.error = true;
            }
            if(String.isNotBlank(Affaire.ProprietesAffaire.commentaire)){
                affaireToInsert.Commentaire__c = Affaire.ProprietesAffaire.commentaire;
            }
            if(String.isNotBlank(Affaire.ProprietesAffaire.statutFinance)){
                affaireToInsert.StatutFinance__c = Affaire.ProprietesAffaire.statutFinance;
            }
            else {
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS06_statutFinanceOB + '\n';
                resp.error = true;
            }
            if(Affaire.ProprietesAffaire.dateDebut !=null){
                affaireToInsert.DateDebut__c = Affaire.ProprietesAffaire.dateDebut;
            }
            if(Affaire.ProprietesAffaire.dateFin !=null){
                affaireToInsert.DateFin__c = Affaire.ProprietesAffaire.dateFin;
            }
            if(Affaire.ProprietesAffaire.dateFermeture !=null){
                affaireToInsert.DateFermeture__c = Affaire.ProprietesAffaire.dateFermeture;
            }
            if(String.isNotBlank(Affaire.ProprietesAffaire.UODalkiaPilote)){
                List<CentreFinance__c> centreFinanceList = new List<CentreFinance__c>();
                centreFinanceList = [ SELECT id, name, DkCode__c 
                                     FROM CentreFinance__c 
                                     WHERE DkCode__c = :Affaire.ProprietesAffaire.UODalkiaPilote limit 1];
                if(centreFinanceList != null && centreFinanceList.size()>0){
                    affaireToInsert.UODalkiaPilote__c = centreFinanceList[0].Id;
                }
            }
            else {
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS06_UODalkiaPiloteOB + '\n';
                resp.error = true;
            }
            if(String.isNotBlank(Affaire.ProprietesAffaire.localisationAffaire)){
                //affaireToInsert.LocalisationAffaire__c = Affaire.ProprietesAffaire.localisationAffaire;
            }
            if(String.isNotBlank(Affaire.ProprietesAffaire.reportingAffaire )){
                affaireToInsert.ReportingAffaire__c = Affaire.ProprietesAffaire.reportingAffaire;
            }
        }
        else {
            resp.responseCode = Label.WS_Response_KO;
            resp.errorText += Label.WS06_ProprietesAffaireOB + '\n';
            resp.error = true;
        }
        
        //LienDas
        if(Affaire.LienDas !=null && Affaire.LienDas.size()>0){ 
            LienDas recentLD ;
            for ( LienDas ld : Affaire.LienDas  ){
                if ( recentLD == null && ld.dateDebut!=null ){
                    recentLD = ld;
                }
                else if (ld.dateDebut !=null) {
                    if ( ld.dateDebut > recentLD.dateDebut){
                        recentLD =ld;
                    }
                    
                }
            }
            if ( recentLD !=null && recentLD.dateDebut!=null){
                affaireToInsert.DAS__c = recentLD.dasDalkia;
                
            }
            else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS06_dateDebutDASOB + '\n';
                resp.error = true;
            }
        } 
        else {
            resp.responseCode = Label.WS_Response_KO;
            resp.errorText += Label.WS06_LienDasOB + '\n';
            resp.error = true;
        }
        
        //LienResponsable
        if(Affaire.LienResponsable !=null && Affaire.LienResponsable.size()>0){ 
            LienResponsable recentLR ;
            for ( LienResponsable lr : Affaire.LienResponsable){
                if ( recentLR == null && lr.dateDebut!=null ){
                    recentLR = lr;
                }else if (lr.dateDebut !=null) {
                    if ( lr.dateDebut > recentLR.dateDebut){
                        recentLR = lr;
                    }
                    
                }
            }
            if (recentLR !=null && recentLR.dateDebut!=null && String.isNotBlank(recentLR.responsableAffaire)){ 
                List<User> userList = new List<User>();
                userList = [ SELECT id, name, DkCode__c 
                            FROM User 
                            WHERE DkCode__c =:recentLR.responsableAffaire limit 1]; 
                if(userList != null && userList.size()>0){
                    affaireToInsert.Responsable__c = userList[0].ID; 
                }
            }
            else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS06_LROB + '\n';
                resp.error = true;
            }
        } 
        else {
            resp.responseCode = Label.WS_Response_KO;
            resp.errorText += Label.WS06_LienResponsableOB + '\n';
            resp.error = true;
        }
        
        //LienContrat
        if(Affaire.LienContrats !=null && Affaire.LienContrats[0] !=null){
            // affaireToInsert.?? =  Affaire.LienContrats[0];
            // pj: on le map pas
        }
        
        //Metadonnées
        if(Affaire.Metadonnees !=null){
            if(Affaire.Metadonnees.creationDate !=null){
                affaireToInsert.CreateDate__c = Affaire.Metadonnees.creationDate;
            }else {
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS06_creationDateOB + '\n';
                resp.error = true;
            } 
            List<User> userMetadonne = new List<User>();
            userMetadonne = [SELECT id,name,ReferentielId__c 
                             FROM user 
                             WHERE ReferentielId__c = : Affaire.Metadonnees.creationId
                             OR ReferentielId__c = : Affaire.Metadonnees.updateId
                             OR ReferentielId__c = : Affaire.Metadonnees.validationId];
            if(String.isNotBlank(Affaire.Metadonnees.creationId)){
                for(User userLoop : userMetadonne){
                    if(userLoop.ReferentielId__c == Affaire.Metadonnees.creationId){
                        affaireToInsert.CreateId__c  = userLoop.id;  
                    }
                }
            }
            else {
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS06_creationId + '\n';
                resp.error = true;
            } 
            if(Affaire.Metadonnees.updateDate !=null){
                //affaireToInsert.LastModifiedDate = Affaire.Metadonnees.updateDate;
                affaireToInsert.UpdateDate__c = Affaire.Metadonnees.updateDate;
            }
            if(String.isNotBlank(Affaire.Metadonnees.updateId)){
                for(User userLoop : userMetadonne){
                    if(userLoop.ReferentielId__c == Affaire.Metadonnees.updateId){
                        affaireToInsert.UpdateId__c  = userLoop.id;  
                    }
                }
            }
            if(Affaire.Metadonnees.validationDate !=null){
                affaireToInsert.ValidationDate__c = Affaire.Metadonnees.validationDate;
            }
            if(String.isNotBlank(Affaire.Metadonnees.ValidationId)){
                for(User userLoop : userMetadonne){
                    if(userLoop.ReferentielId__c == Affaire.Metadonnees.ValidationId){
                        affaireToInsert.ValidationId__c  = userLoop.id;  
                    }
                }
            }
        }
        else {
            resp.responseCode = Label.WS_Response_KO;
            resp.errorText += Label.WS06_MetadonneesOB + '\n';
            resp.error = true;
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
        update ws;
        if(!resp.error){
            try{
                upsert affaireToInsert DkCode__c;
            }
            catch(Exception e){
                ws.Statut__c ='KO';
                ws.ErrorText__c = e.getMessage();
                if(ws.ErrorText__c != null && ws.ErrorText__c.length()>254){
                    ws.ErrorText__c =  ws.ErrorText__c.substring(0,254);
                }
                resp.error = true;
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS06_Error + e.getMessage() + '\n';
                ws.Response__c = resp+ Label.WS06_AfterError + e.getMessage();
                update ws;
            }
        }
        return resp;
    }
}