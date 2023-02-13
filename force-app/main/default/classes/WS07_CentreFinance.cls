/**
* @author: Alain Ghoussoub -EI Technologies
* @date: 10/01/2019
* @description: Class qui gère le web service entrant centre finance
*/
global class WS07_CentreFinance {
    
    global class CentreFinance {
        webservice Header header; 
        webservice ProprietesCentreFinance proprietesCentreFinance;
        webservice List<LienParent> lienParent;  
        webservice List<UODalkia> listUODalkia;  
        webservice list<Responsable> listResponsable;
        webservice Metadonnees metadonnees;
    }
    
    global class ProprietesCentreFinance{
        webservice String dkCentreFinance;
        webservice String libelleCentreFinance;
        webservice String commentaire;
        webservice Integer controleNiveau;
        webservice String statutFinance;
        webservice DateTime dateDebut;
        webservice DateTime dateFin;
        webservice DateTime dateFermeture;
        webservice String acronymeSigle;
        webservice Boolean estUODalkia;
        webservice String categorieUODalkia;
        webservice Boolean imputationsOperationnelles;
        webservice String reportingCentreFinance; 
    }
    
    global class LienParent{
        webservice String centreParent;
        webservice DateTime dateDebut;
        webservice DateTime dateFin;
    }
    global class UODalkia{
        webservice String UODalkia; 
        webservice DateTime dateDebut;
        webservice DateTime dateFin;
    }
    global class Responsable{
        webservice String responsable;
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
    
    
    webservice static Response insertUpdateCentreFinance(CentreFinance centreFinance) {
        Response resp = new Response();
        resp.error = false;
        resp.responseCode = Label.WS_Response_OK;
        resp.errorText = '';
        WebserviceLog__c ws = new WebserviceLog__c();
        ws.Request__c = CentreFinance+'';
        ws.Type__c = Label.WS_CentreFinance;
        ws.flux__c = Label.WSTypeFluxEntrant;
        String dkCodeCF = '';
        
        try{
            Database.insert(ws, false);
        }
        catch(Exception e){
            System.debug('exception [CentreFinance]' + e);
        }
        
        CentreFinance__c centreFinanceToInsert = new CentreFinance__c();
        
        //Header
        if(CentreFinance.header != null){
            if (CentreFinance.header.transactionId!=null) {
                ws.TransactionId__c = CentreFinance.header.transactionId;
            }
        }
        
        //proprietesCentreFinance
        if(centreFinance.proprietesCentreFinance !=null){
            if(String.isNotBlank(centreFinance.proprietesCentreFinance.dkCentreFinance )){
                centreFinanceToInsert.DkCode__c = centreFinance.proprietesCentreFinance.dkCentreFinance;
                ws.DkCode__c= CentreFinance.ProprietesCentreFinance.dkCentreFinance;  
                dkCodeCF = CentreFinance.ProprietesCentreFinance.dkCentreFinance;
            }
            else {
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS07_dkCentreFinanceOB + '\n';
                resp.error = true;
            }            
            if(String.isNotBlank(centreFinance.proprietesCentreFinance.libelleCentreFinance )){
                centreFinanceToInsert.Libelle__c = centreFinance.proprietesCentreFinance.libelleCentreFinance;
                String tempName = centreFinance.proprietesCentreFinance.libelleCentreFinance;
                if(tempName != null){
                    if(tempName.length()>80){
                        tempName =  tempName.substring(0,80);
                    }
                }
                centreFinanceToInsert.Name = tempName;
            }
            else {
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS07_libelleCentreFinanceOB + '\n';
                resp.error = true;
            }
            if(String.isNotBlank(centreFinance.proprietesCentreFinance.commentaire)){
                centreFinanceToInsert.Commentaire__c = centreFinance.proprietesCentreFinance.commentaire;
            }
            if(centreFinance.proprietesCentreFinance.controleNiveau !=null){
                centreFinanceToInsert.ControleNiveau__c = centreFinance.proprietesCentreFinance.controleNiveau;
            }
            else {
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS07_controleNiveauOB + '\n';
                resp.error = true;
            }
            if(String.isNotBlank(centreFinance.proprietesCentreFinance.statutFinance)){
                centreFinanceToInsert.StatutFinance__c = centreFinance.proprietesCentreFinance.statutFinance;
            }
            else {
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS07_statutFinanceOB + '\n';
                resp.error = true;
            }
            if(centreFinance.proprietesCentreFinance.dateDebut !=null){
                centreFinanceToInsert.DateDebut__c = centreFinance.proprietesCentreFinance.dateDebut;
            }
            else {
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS07_dateDebutOB + '\n';
                resp.error = true;
            }
            if(centreFinance.proprietesCentreFinance.dateFin !=null){
                centreFinanceToInsert.DateFin__c = centreFinance.proprietesCentreFinance.dateFin;
            }
            if(centreFinance.proprietesCentreFinance.dateFermeture !=null){
                centreFinanceToInsert.DateFermeture__c = centreFinance.proprietesCentreFinance.dateFermeture;
            }
            if(String.isNotBlank(centreFinance.proprietesCentreFinance.acronymeSigle)){
                centreFinanceToInsert.AcronymeSigle__c = centreFinance.proprietesCentreFinance.acronymeSigle;
            }
            if(centreFinance.proprietesCentreFinance.estUODalkia !=null){
                centreFinanceToInsert.EstUODalkia__c = centreFinance.proprietesCentreFinance.estUODalkia;
            }
            else {
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS07_estUODalkiaOB + '\n';
                resp.error = true;
            }
            if(String.isNotBlank(centreFinance.proprietesCentreFinance.categorieUODalkia)){
                centreFinanceToInsert.CategorieUODalkia__c = centreFinance.proprietesCentreFinance.categorieUODalkia;
            }
            if(centreFinance.proprietesCentreFinance.imputationsOperationnelles !=null){
                centreFinanceToInsert.ImputationsOperationnelles__c = centreFinance.proprietesCentreFinance.imputationsOperationnelles;
            }
            else {
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS07_imputationsOperationnellesOB + '\n';
                resp.error = true;
            }
            if(String.isNotBlank(centreFinance.proprietesCentreFinance.reportingCentreFinance)){
                centreFinanceToInsert.ReportingCentreFinance__c = centreFinance.proprietesCentreFinance.reportingCentreFinance;
            }
        }
        else {
            resp.responseCode = Label.WS_Response_KO;
            resp.errorText += Label.WS07_proprietesCentreFinanceOB + '\n';
            resp.error = true;
        }
        
        //lienParent
        if(centreFinance.lienParent !=null && centreFinance.lienParent.size()>0){ 
            LienParent recentLP ;
            for ( LienParent lp : centreFinance.lienParent){
                if ( recentLP == null && lp.dateDebut!=null){
                    recentLP = lp;
                }
                else if (lp.dateDebut !=null) {
                    if ( lp.dateDebut > recentLP.dateDebut){
                        recentLP = lp;
                    }
                    
                }
            }
            if ( recentLP !=null && recentLP.dateDebut!=null && String.isNotBlank(recentLP.centreParent)){ 
                if(dkCodeCF == recentLP.centreParent){
                    centreFinanceToInsert.Parent__c = null;
                }
                else{
                    List<CentreFinance__c> listCentreFinance = new List<CentreFinance__c>();
                    listCentreFinance = [ SELECT id, name, DkCode__c 
                                         FROM CentreFinance__c 
                                         WHERE DkCode__c =:recentLP.centreParent limit 1]; 
                    if(listCentreFinance != null && listCentreFinance.size()>0){
                        centreFinanceToInsert.Parent__c = listCentreFinance[0].ID; 
                    }
                    else{
                        resp.responseCode = Label.WS_Response_KO + '\n';
                        resp.errorText += Label.WS07_CPInexistant +recentLP.centreParent+ Label.WS07_CPInexistant2;
                        resp.error = true;
                    }
                }
            }
            else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS07_recentLPOB + '\n';
                resp.error = true;
            }
            
        } 
        
        // UO_DALKIA
        if(centreFinance.listUODalkia !=null && centreFinance.listUODalkia.size()>0){ 
            UODalkia recentUOD ;
            for ( UODalkia UOD : centreFinance.listUODalkia){
                if ( recentUOD == null && UOD.dateDebut!=null){
                    recentUOD = UOD;
                }else if (UOD.dateDebut !=null) {
                    if ( UOD.dateDebut > recentUOD.dateDebut){
                        recentUOD = UOD;
                    }
                }
            }
            if ( recentUOD !=null && recentUOD.dateDebut!=null && String.isNotBlank(recentUOD.UODalkia)){
                if(dkCodeCF == recentUOD.UODalkia){
                    centreFinanceToInsert.UODalkia__c = null;
                }
                else{
                    List<CentreFinance__c> listCentreFinance = new List<CentreFinance__c>();
                    listCentreFinance = [ SELECT id, name, DkCode__c 
                                         FROM CentreFinance__c 
                                         WHERE DkCode__c =:recentUOD.UODalkia limit 1]; 
                    if(listCentreFinance != null && listCentreFinance.size()>0){
                        centreFinanceToInsert.UODalkia__c = listCentreFinance[0].ID; 
                    }
                }
            }
            else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS07_recentUODOB + '\n';
                resp.error = true;
            }
        } 
        else {
            resp.responseCode = Label.WS_Response_KO;
            resp.errorText += Label.WS07_listUODalkiaOB + '\n';
            resp.error = true;
        }
        
        //listResponsable
        if(centreFinance.listResponsable !=null && centreFinance.listResponsable.size()>0){ 
            Responsable recentR;
            for(Responsable res : centreFinance.listResponsable){
                if(recentR == null && res.dateDebut!=null){
                    recentR = res;
                }else if (res.dateDebut !=null) {
                    if(res.dateDebut > recentR.dateDebut){
                        recentR = res;
                    }
                }
            }
            if(recentR !=null && recentR.dateDebut!=null && String.isNotBlank(recentR.responsable)){ 
                List<User> userList = new List<User>();
                userList = [ SELECT id, name, DkCode__c 
                            FROM User 
                            WHERE DkCode__c =:recentR.responsable limit 1];
                if(userList != null && userList.size() > 0){
                    centreFinanceToInsert.Responsable__c = userList[0].ID;
                }
            }
            else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS07_responsableAffaireOB + '\n';
                resp.error = true;
            }
        } 
        
        //METADONNES
        if(CentreFinance.Metadonnees !=null){
            
            if(CentreFinance.Metadonnees.creationDate !=null){
                centreFinanceToInsert.CreateDate__c = CentreFinance.Metadonnees.creationDate;
            }else {
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS06_creationDateOB + '\n';
                resp.error = true;
            } 
            List<User> userMetadonne = new List<User>();
            userMetadonne = [SELECT id,name,ReferentielId__c 
                             FROM user 
                             WHERE ReferentielId__c = : CentreFinance.Metadonnees.creationId
                             OR ReferentielId__c = : CentreFinance.Metadonnees.updateId
                             OR ReferentielId__c = : CentreFinance.Metadonnees.validationId];
            if(String.isNotBlank(CentreFinance.Metadonnees.creationId)){
                for(User userLoop : userMetadonne){
                    if(userLoop.ReferentielId__c == CentreFinance.Metadonnees.creationId){
                        centreFinanceToInsert.CreateId__c  = userLoop.id;  
                    }
                }
            }else {
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS06_creationId + '\n';
                resp.error = true;
            } 
            if(CentreFinance.Metadonnees.updateDate !=null){
                centreFinanceToInsert.UpdateDate__c = CentreFinance.Metadonnees.updateDate;
            }
            if(String.isNotBlank(CentreFinance.Metadonnees.updateId)){
                for(User userLoop : userMetadonne){
                    if(userLoop.ReferentielId__c == CentreFinance.Metadonnees.updateId){
                        centreFinanceToInsert.UpdateId__c  = userLoop.id;  
                    }
                }
            }
            if(CentreFinance.Metadonnees.validationDate !=null){
                centreFinanceToInsert.ValidationDate__c = CentreFinance.Metadonnees.validationDate;
            }
            if(String.isNotBlank(CentreFinance.Metadonnees.ValidationId )){
                for(User userLoop : userMetadonne){
                    if(userLoop.ReferentielId__c == CentreFinance.Metadonnees.ValidationId){
                        centreFinanceToInsert.ValidationId__c  = userLoop.id;  
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
                upsert centreFinanceToInsert DkCode__c;
            }
            catch(Exception e){
                ws.Statut__c ='KO';
                ws.ErrorText__c = e.getMessage();
                if(ws.ErrorText__c != null && ws.ErrorText__c.length()>254){
                    ws.ErrorText__c =  ws.ErrorText__c.substring(0,254);
                }
                resp.error = true;
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS07_Error + e.getMessage() + '\n';
                ws.Response__c = resp+ Label.WS07_AfterError + e.getMessage();
                update ws;
            }
        }
        return resp;
    }
    
}