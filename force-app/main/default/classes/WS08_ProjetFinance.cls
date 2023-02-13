/**
* @author: Alain Ghoussoub -EI Technologies
* @date: 10/01/2019
* @description: Class qui gère le web service entrant projet finance
*/
global class WS08_ProjetFinance {
    
    global class ProjetFinance{
        webservice Header header;
        webservice ProprietesProjetFinance proprietesProjetFinance;
        webservice LienProjetInvestissement lienProjetInvestissement;
        webservice List<LienSociete> listLienSociete; 
        webservice List<LienCentreFinance> listLienCentreFinance;
        webservice LienAffaire lienAffaire;
        webservice LienConfiguration lienConfiguration;
        webservice List<LienAffectation> listLienAffectation;
        webservice List<LienTaux> listLienTaux;
        webservice LienInformation lienInformation;
        webservice List<LienResponsable> listLienResponsable;
        webservice Metadonnees metadonnees;
    }
    global class ProprietesProjetFinance{
        webservice String dkProjet;
        webservice String libelleProjetFinance;
        webservice String commentaire;
        webservice String statutFinance;
        webservice String classeProjet;
        webservice DateTime dateDebut;
        webservice DateTime dateFin;
        webservice DateTime dateFermeture;
    }
    
    global class LienProjetInvestissement{
        webservice String tacheProjetParent;
        webservice String projetParent;
    }
    
    global class LienSociete{
        webservice String matriculeSociete;
        webservice String dkCodePartenaire;
        webservice DateTime dateDebut;
        webservice DateTime dateFin;  
    }
    global class LienCentreFinance{
        webservice String dkCodeCentreFinance;
        webservice DateTime dateDebut;
        webservice DateTime dateFin;
    }
    global class LienAffaire{
        webservice String dkCodeAffaire;
    }
    global class LienConfiguration{
        webservice String filiere;
        webservice String destinationDK;
        webservice List<TypeTacheAutorisee> listTypeTacheAutorisee;
        webservice String nature;
        webservice String gestionTravauxInterne;
        webservice String modeRestitutionTravauxInterne;
    }
    global class TypeTacheAutorisee{
        webservice String TypeTacheAutorisee;
    }
    
    global class LienAffectation{
        webservice String affectionCouts; 
        webservice DateTime dateDebut;
        webservice DateTime dateFin;
        webservice List<ProjetFinanceAffectation> listProjetFinanceAffectation;
    }
    
    global class ProjetFinanceAffectation{
        webservice String projetFinanceAffectation;
        webservice String tacheFinanceAffectation;
        webservice Double pourcentageAffectation;
    }
    global class LienTaux{
        webservice String tauxUniteOeuvre;
        webservice String baseUniteOeuvre;
        webservice DateTime dateDebut;
        webservice DateTime dateFin;
        
    }
    global class LienInformation{
        webservice String comiteEngagementUODalkia;
        webservice String comiteEngagementGroupe;
        webservice String reportingAffaire;
        webservice String reportingProjetFinance; 
    }
    global class LienResponsable{
        webservice String responsableProjetFinance; 
        webservice DateTime dateDebut;
        webservice DateTime dateFin;
    }
    global class Metadonnees{
        webservice DateTime creationDate;
        webservice String creationId;
        webservice DateTime updateDate;
        webservice String updateId;
        webservice DateTime validationDate;
        webservice String validationId;
    }
    
    webservice static Response insertUpdateProjetFinance(ProjetFinance projetFinance) {
        Response resp = new Response();
        resp.error = false;
        resp.responseCode = Label.WS_Response_OK;
        resp.errorText = '';
        WebserviceLog__c ws = new WebserviceLog__c();
        ws.Request__c = projetFinance+'';
        ws.Type__c = Label.WS08_ProjetFinance;
        ws.flux__c = Label.WSTypeFluxEntrant;
        insert ws;
        
        ProjetFinance__c projetFinanceToInsert = new ProjetFinance__c();
        
        //délaration des champs WebServiceLog 
        if(ProjetFinance.header != null){
            if (ProjetFinance.header.transactionId!=null) {
                ws.TransactionId__c = ProjetFinance.header.transactionId;
            }
        }
        
        //ProprietesProjetFinance
        if(projetFinance.ProprietesProjetFinance != null ){
            if(String.isNotBlank(projetFinance.ProprietesProjetFinance.dkProjet)){
                projetFinanceToInsert.DkCode__c = projetFinance.ProprietesProjetFinance.dkProjet;
                ws.DkCode__c= ProjetFinance.ProprietesProjetFinance.dkProjet; 
            }else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS08_dkProjetOB + '\n';
                resp.error = true;
            }
            if(String.isNotBlank(projetFinance.ProprietesProjetFinance.libelleProjetFinance)){
                projetFinanceToInsert.Libelle__c = projetFinance.ProprietesProjetFinance.libelleProjetFinance;
                String tempName = projetFinance.ProprietesProjetFinance.libelleProjetFinance;
                if(tempName != null){
                    if(tempName.length()>80){
                        tempName =  tempName.substring(0,80);
                    }
                }
                projetFinanceToInsert.Name = tempName;
            }
            else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS08_libelleProjetFinanceOB + '\n';
                resp.error = true;
            }
            if(String.isNotBlank(projetFinance.ProprietesProjetFinance.commentaire)){
                projetFinanceToInsert.Commentaire__c = projetFinance.ProprietesProjetFinance.commentaire;
            }
            if(String.isNotBlank(projetFinance.ProprietesProjetFinance.statutFinance)){
                projetFinanceToInsert.StatutFinance__c = projetFinance.ProprietesProjetFinance.statutFinance;
            }else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS08_statutFinanceOB + '\n';
                resp.error = true;
            }
            if(String.isNotBlank(projetFinance.ProprietesProjetFinance.classeProjet)){
                projetFinanceToInsert.ClasseProjet__c = projetFinance.ProprietesProjetFinance.classeProjet;
            }else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS08_classeProjetOB + '\n';
                resp.error = true;
            }
            if(projetFinance.ProprietesProjetFinance.dateDebut != null){
                projetFinanceToInsert.DateDebut__c = projetFinance.ProprietesProjetFinance.dateDebut;
            }else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS08_dateDebutOB + '\n';
                resp.error = true;
            }
            if(projetFinance.ProprietesProjetFinance.dateFin != null){
                projetFinanceToInsert.DateFin__c = projetFinance.ProprietesProjetFinance.dateFin;
            }
            if(projetFinance.ProprietesProjetFinance.dateFermeture != null){
                projetFinanceToInsert.DateFermeture__c = projetFinance.ProprietesProjetFinance.dateFermeture;
            }
        }else{
            resp.responseCode = Label.WS_Response_KO;
            resp.errorText += Label.WS08_ProprietesProjetFinanceOB + '\n';
            resp.error = true;
        }
        
        //LienSociete
        if(projetFinance.listLienSociete !=null && projetFinance.listLienSociete.size()>0){ 
            LienSociete recentLS ;
            
            for ( LienSociete ls : projetFinance.listLienSociete){
                if ( recentLS == null && ls.dateDebut!=null){
                    recentLS = ls;
                }else if (ls.dateDebut !=null) {
                    if ( ls.dateDebut > recentLS.dateDebut){
                        recentLS = ls;
                    }
                }
            }
            if ( recentLS !=null && recentLS.dateDebut!=null && String.isNotBlank(recentLS.dkCodePartenaire)){ 
                List<Account> accList = [SELECT id, name, DKCodeSurPartenaire__c 
                                         FROM Account
                                         WHERE DKCodeSurPartenaire__c =:recentLS.dkCodePartenaire limit 1]; 
                if(accList != null && acclist.size()>0){
                    projetFinanceToInsert.Societe__c = accList[0].ID; 
                }
                
            }
            else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS08recentLSOB + '\n';
                resp.error = true;
            }
            
        }else{
            resp.responseCode = Label.WS_Response_KO;
            resp.errorText += Label.WS08_listLienSocieteOB + '\n';
            resp.error = true;
        }
        
        //LienCentreFinance
        if(projetFinance.listLienCentreFinance !=null && projetFinance.listLienCentreFinance.size()>0){ 
            LienCentreFinance recentCF ;
            
            for ( LienCentreFinance cf : projetFinance.listLienCentreFinance){
                if ( recentCF == null && cf.dateDebut!=null){
                    recentCF = cf;
                }else if (cf.dateDebut !=null) {
                    if ( cf.dateDebut > recentCF.dateDebut){
                        recentCF = cf;
                    }
                    
                }
            }
            if ( recentCF !=null && recentCF.dateDebut!=null && String.isNotBlank(recentCF.dkCodeCentreFinance)){ 
                List<CentreFinance__c> listCF = new List<CentreFinance__c>();
                listCF =  [SELECT id, name, DkCode__c 
                           FROM CentreFinance__c 
                           WHERE DkCode__c =:recentCF.dkCodeCentreFinance limit 1];
                if(listCF != null && listCF.size()>0){
                    projetFinanceToInsert.CentreFinance__c = listCF[0].ID; 
                }
            }else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS08_recentCFOB + '\n';
                resp.error = true;
            }
            
        }else{
            resp.responseCode = Label.WS_Response_KO;
            resp.errorText += Label.WS08_listLienCentreFinanceOB + '\n';
            resp.error = true;
        }
        
        //LienAffaire
        if(projetFinance.lienAffaire!=null){
            if(String.isNotBlank(projetFinance.lienAffaire.dkCodeAffaire)){
                List<Affaire__c> listAff = new List<Affaire__c>();
                listAff = [ SELECT id, name, DkCode__c 
                           FROM Affaire__c 
                           WHERE DkCode__c =:projetFinance.lienAffaire.dkCodeAffaire limit 1];
                if(listAff != null && listAff.size()>0){
                    projetFinanceToInsert.Affaire__c = listAff[0].id;
                }
            }else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS08_dkCodeAffaireOB + '\n';
                resp.error = true;
            }
        }
        
        //LienResponsable
        if(projetFinance.listLienResponsable !=null && projetFinance.listLienResponsable.size()>0){ 
            LienResponsable recentLR ;
            
            for ( LienResponsable lr : projetFinance.listLienResponsable){
                if ( recentLR == null && lr.dateDebut!=null){
                    recentLR = lr;
                }else if (lr.dateDebut !=null) {
                    if ( lr.dateDebut > recentLR.dateDebut){
                        recentLR = lr;
                    }
                    
                }
            }
            if ( recentLR !=null && recentLR.dateDebut!=null && String.isNotBlank(recentLR.responsableProjetFinance)){ 
                List<User> userList = new List<User>();
                userList = [ select id,name,DkCode__c from user where DkCode__c = :recentLR.responsableProjetFinance LIMIT 1];
                if(userList != null && userList.size()>0){
                    projetFinanceToInsert.Responsable__c = userList[0].ID; 
                }
            }else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS08_recentLROB + '\n';
                resp.error = true;
            }
            
        }else{
            resp.responseCode = Label.WS_Response_KO;
            resp.errorText += Label.WS08_listLienResponsableOB + '\n';
            resp.error = true;
        }
        
        //METADONNES
        if(projetFinance.Metadonnees !=null){
            
            if(projetFinance.Metadonnees.creationDate !=null){
                projetFinanceToInsert.CreateDate__c = projetFinance.Metadonnees.creationDate;
            }else {
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS06_creationDateOB + '\n';
                resp.error = true;
            }
            
            List<User> userMetadonne = new List<User>();
            userMetadonne = [SELECT id,name,ReferentielId__c 
                             FROM user 
                             WHERE ReferentielId__c = : projetFinance.Metadonnees.creationId
                             OR ReferentielId__c = : projetFinance.Metadonnees.updateId
                             OR ReferentielId__c = : projetFinance.Metadonnees.validationId];
            
            if(String.isNotBlank(projetFinance.Metadonnees.creationId )){
                for(User userLoop : userMetadonne){
                    if(userLoop.ReferentielId__c == projetFinance.Metadonnees.creationId){
                        projetFinanceToInsert.CreateId__c  = userLoop.id;  
                    }
                }
            }else {
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS06_creationId + '\n';
                resp.error = true;
            } 
            if(projetFinance.Metadonnees.updateDate !=null){
                projetFinanceToInsert.UpdateDate__c = projetFinance.Metadonnees.updateDate;
            }
            if(String.isNotBlank(projetFinance.Metadonnees.updateId)){
                for(User userLoop : userMetadonne){
                    if(userLoop.ReferentielId__c == projetFinance.Metadonnees.updateId){
                        projetFinanceToInsert.UpdateId__c  = userLoop.id;  
                    }
                }
            }
            if(projetFinance.Metadonnees.validationDate !=null){
                projetFinanceToInsert.ValidationDate__c = projetFinance.Metadonnees.validationDate;
            }
            if(String.isNotBlank(projetFinance.Metadonnees.ValidationId)){
                for(User userLoop : userMetadonne){
                    if(userLoop.ReferentielId__c == projetFinance.Metadonnees.ValidationId){
                        projetFinanceToInsert.ValidationId__c  = userLoop.id;  
                    }
                }
            }
            
        }else {
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
                upsert projetFinanceToInsert DkCode__c;
            }
            catch(Exception e){
                ws.Statut__c ='KO';
                ws.ErrorText__c = e.getMessage();
                if(ws.ErrorText__c != null && ws.ErrorText__c.length()>254){
                    ws.ErrorText__c =  ws.ErrorText__c.substring(0,254);
                }
                resp.error = true;
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS08_Error + e.getMessage() + '\n';
                ws.Response__c = resp+ Label.WS08_AfterError + e.getMessage();
                update ws;
            }
        }
        
        return resp;
    }
}