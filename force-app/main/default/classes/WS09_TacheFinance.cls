/**
* @author: Alain Ghoussoub -EI Technologies
* @date: 10/01/2019
* @description: Class qui gère le web service entrant tache finance
*/
global class WS09_TacheFinance {
    global class TacheFinance {
        webservice Header header;
        webservice ProprietesTacheFinance proprietesTacheFinance;
        webservice LienProjetFinance lienProjetFinance;
        webservice List<LienSee> lienSee;
        webservice List<LienSite> lienSite;
        webservice Metadonnees metadonnees;
    }
    global class ProprietesTacheFinance{
        webservice String dkCodeTache;
        webservice String libelle;
        webservice String commentaire;
        webservice String statutFinance;
        webservice String typeTache;
        webservice String modeGestion;
        webservice Double montantPrevisionnelRecettes;
        webservice Double montantPrevisionnelCouts;
        webservice DateTime dateDebut;
        webservice DateTime dateFinPrevisionnelle;
        webservice DateTime dateFin;
        webservice DateTime dateFermeture;
    }
    global class LienProjetFinance{
        webservice String dkCodeProjet;
    }
    global class LienSee{
        webservice String dkCodeSee;
    }
    global class LienSite{
        webservice String site;
    }
    global class Metadonnees{
        webservice DateTime creationDate;
        webservice String creationId;
        webservice DateTime updateDate;
        webservice String updateId;
        webservice DateTime validationDate;
        webservice String validationId;
    }
    webservice static Response insertUpdateTacheFinance(TacheFinance tacheFinance) {
        Response resp = new Response();
        resp.error = false;
        resp.responseCode = Label.WS_Response_OK;
        resp.errorText = '';
        WebserviceLog__c ws = new WebserviceLog__c();
        ws.Request__c = tacheFinance+'';
        ws.Type__c = Label.WS_TacheFinance;
        ws.flux__c = Label.WSTypeFluxEntrant;
        boolean counted = true;
        try{
            Database.insert(ws, false);
        }
        catch(Exception e){
            System.debug('exception ' + e);
        }
        
        TacheFinance__c tacheFinanceToInsert = new TacheFinance__c();
        
        //délaration des champs WebServiceLog 
        if(TacheFinance.header != null){
            if (TacheFinance.header.transactionId!=null) {
                ws.TransactionId__c = TacheFinance.header.transactionId;
            }
        }
        
        //ProprietesTacheFinance
        if(tacheFinance.ProprietesTacheFinance != null )
        {
            if(String.isNotBlank(tacheFinance.ProprietesTacheFinance.dkCodeTache)){
                tacheFinanceToInsert.DkCode__c = tacheFinance.ProprietesTacheFinance.dkCodeTache;
                ws.DkCode__c= TacheFinance.ProprietesTacheFinance.dkCodeTache;  
            }else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS09_dkCodeTacheOB + '\n';
                resp.error = true;
            }
            
            if(String.isNotBlank(tacheFinance.ProprietesTacheFinance.libelle)){
                tacheFinanceToInsert.Libelle__c = tacheFinance.ProprietesTacheFinance.libelle;
                
                String tempName = tacheFinance.ProprietesTacheFinance.libelle;
                if(tempName != null){
                    if(tempName.length()>80){
                        tempName =  tempName.substring(0,80);
                    }
                }
                tacheFinanceToInsert.Name = tempName;
            }
            else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS09_libelleOB + '\n';
                resp.error = true;
            }
            
            if(String.isNotBlank(tacheFinance.ProprietesTacheFinance.commentaire)){
                tacheFinanceToInsert.Commentaire__c = tacheFinance.ProprietesTacheFinance.commentaire;
            }
            
            if(String.isNotBlank(tacheFinance.ProprietesTacheFinance.statutFinance)){
                tacheFinanceToInsert.StatutFinance__c = tacheFinance.ProprietesTacheFinance.statutFinance;
            }
            else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS09_statutFinanceOB + '\n';
                resp.error = true;
            }
            
            if(String.isNotBlank(tacheFinance.ProprietesTacheFinance.typeTache)){
                Set<String> typeTacheAllowed = new Set<String>();
                String typesAllowed = Label.TypeTachePermises;
                if(typesAllowed != null){
                    for(String str : typesAllowed.split(' ')){
                        typeTacheAllowed.add(str);
                    }
                }
                if(typeTacheAllowed.contains(tacheFinance.ProprietesTacheFinance.typeTache)){
                    tacheFinanceToInsert.TypeTache__c = tacheFinance.ProprietesTacheFinance.typeTache;
                }
                else{
                    counted = false;
                }
            }
            else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS09_typeTacheOB + '\n';
                resp.error = true;
            }
            
            if(String.isNotBlank(tacheFinance.ProprietesTacheFinance.modeGestion)){
                tacheFinanceToInsert.ModeGestion__c = tacheFinance.ProprietesTacheFinance.modeGestion;
            }
            
            if(tacheFinance.ProprietesTacheFinance.montantPrevisionnelRecettes != null){
                tacheFinanceToInsert.MontantPrevisionnelRecettes__c = tacheFinance.ProprietesTacheFinance.montantPrevisionnelRecettes;
            }
            
            if(tacheFinance.ProprietesTacheFinance.montantPrevisionnelCouts != null){
                tacheFinanceToInsert.MontantPrevisionnelCouts__c = tacheFinance.ProprietesTacheFinance.montantPrevisionnelCouts;
            }
            
            if(tacheFinance.ProprietesTacheFinance.dateDebut != null){
                tacheFinanceToInsert.DateDebut__c = tacheFinance.ProprietesTacheFinance.dateDebut;
            }else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS09_dateDebutOB + '\n';
                resp.error = true;
            }
            
            if(tacheFinance.ProprietesTacheFinance.dateFinPrevisionnelle != null){
                tacheFinanceToInsert.DateFinPrevisionnelle__c = tacheFinance.ProprietesTacheFinance.dateFinPrevisionnelle;
            }
            
            if(tacheFinance.ProprietesTacheFinance.dateFin != null){
                tacheFinanceToInsert.DateFin__c = tacheFinance.ProprietesTacheFinance.dateFin;
            }
            
            if(tacheFinance.ProprietesTacheFinance.dateFermeture != null){
                tacheFinanceToInsert.DateFermeture__c = tacheFinance.ProprietesTacheFinance.dateFermeture;
            }
            
        }else
        {
            resp.responseCode = Label.WS_Response_KO;
            resp.errorText += Label.WS09_ProprietesTacheFinanceOB + '\n';
            resp.error = true;
        }
        
        //LienProjetFinance
        if(tacheFinance.LienProjetFinance != null){
            if(String.isNotBlank(tacheFinance.LienProjetFinance.dkCodeProjet)){
                List<ProjetFinance__c> projList = new List<ProjetFinance__c>();
                projList = [ SELECT id, name, DkCode__c 
                            FROM ProjetFinance__c 
                            WHERE DkCode__c =:tacheFinance.LienProjetFinance.dkCodeProjet limit 1];
                if(projList != null && projList.size()>0){
                    tacheFinanceToInsert.ProjetFinance__c = projList[0].id;
                }
                else{
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS09_dkCodeProjet1 + tacheFinance.LienProjetFinance.dkCodeProjet+ Label.WS09_dkCodeProjet2 + '\n';
                    resp.error = true;
                }
            }else
            {
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS09_dkCodeProjetOB + '\n';
                resp.error = true;
            }
        }else
        {
            resp.responseCode = Label.WS_Response_KO;
            resp.errorText += Label.WS09_LienProjetFinanceOB + '\n';
            resp.error = true;
        }
        
        //METADONNES
        if(tacheFinance.Metadonnees !=null){
            
            if(tacheFinance.Metadonnees.creationDate !=null){
                tacheFinanceToInsert.CreateDate__c = tacheFinance.Metadonnees.creationDate;
            }else {
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS06_creationDateOB + '\n';
                resp.error = true;
            } 
            
            List<User> userMetadonne = new List<User>();
            userMetadonne = [SELECT id,name,ReferentielId__c 
                             FROM user 
                             WHERE ReferentielId__c = : tacheFinance.Metadonnees.creationId
                             OR ReferentielId__c = : tacheFinance.Metadonnees.updateId
                             OR ReferentielId__c = : tacheFinance.Metadonnees.validationId];
            if(String.isNotBlank(tacheFinance.Metadonnees.creationId )){
                for(User userLoop : userMetadonne){
                    if(userLoop.ReferentielId__c == tacheFinance.Metadonnees.creationId){
                        tacheFinanceToInsert.CreateId__c  = userLoop.id;  
                    }
                }
            }else {
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS06_creationId + '\n';
                resp.error = true;
            } 
            
            if(tacheFinance.Metadonnees.updateDate !=null){
                tacheFinanceToInsert.UpdateDate__c = tacheFinance.Metadonnees.updateDate;
            }
            
            if(String.isNotBlank(tacheFinance.Metadonnees.updateId)){
                for(User userLoop : userMetadonne){
                    if(userLoop.ReferentielId__c == tacheFinance.Metadonnees.updateId){
                        tacheFinanceToInsert.UpdateId__c  = userLoop.id;  
                    }
                }
                
            }
            
            if(tacheFinance.Metadonnees.validationDate !=null){
                tacheFinanceToInsert.ValidationDate__c = tacheFinance.Metadonnees.validationDate;
            }
            
            if(String.isNotBlank(tacheFinance.Metadonnees.ValidationId)){
                for(User userLoop : userMetadonne){
                    if(userLoop.ReferentielId__c == tacheFinance.Metadonnees.ValidationId){
                        tacheFinanceToInsert.ValidationId__c  = userLoop.id;  
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
                if(counted == true){
                    upsert tacheFinanceToInsert DkCode__c;
                }
            }
            catch(Exception e){
                ws.Statut__c ='KO';
                ws.ErrorText__c = e.getMessage();
                if(ws.ErrorText__c != null && ws.ErrorText__c.length()>254){
                    ws.ErrorText__c =  ws.ErrorText__c.substring(0,254);
                }
                resp.error = true;
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS09_Error + e.getMessage() + '\n';
                ws.Response__c = resp+ Label.WS09_AfterError + e.getMessage();
                update ws;
            }
        }
        
        return resp;
    }
}