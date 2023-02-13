/**
* @author: Alain Ghoussoub -EI Technologies
* @date: 10/01/2019
* @description: Class qui gère le web service entrant Organisation
*/
global class WS10_Organisation {
    global class Organisation { 
        webservice Header header;
        webservice ProprietesOrganisation proprietesOrganisation;
        webservice List<LienParent> lienParent;
        //webservice LienStructure LienStructure;
        webservice List<LienResponsable> lienResponsable;
        webservice Metadonnees metadonnees;
    }
    global class ProprietesOrganisation{
        webservice String dkCodeOrganisation;
        webservice String libelle;
        webservice String commentaire;
        webservice Integer controleNiveau;
        webservice String statutOrganisation;
        webservice DateTime dateDebut;
        webservice DateTime dateFin;
        webservice String acronymeSigle;
        webservice Boolean estUODalkia;
        webservice String UODalkia;
        webservice Boolean estGroupeExploitation;
        webservice String reportingOrganisation;
    }
    global class LienParent{
        webservice String organisationParente;
        webservice DateTime dateDebut;
        webservice DateTime dateFin;
    }
    /*global class LienStructure{ 
        webservice String UO;
        webservice String UE;
    }*/
    global class LienResponsable{
        webservice String responsableOrganisation;
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
    webservice static Response insertUpdateOrganisation(Organisation org) {
        Response resp = new Response();
        resp.error = false;
        resp.responseCode = Label.WS_Response_OK;
        resp.errorText = '';
        WebserviceLog__c ws = new WebserviceLog__c();
        ws.Request__c = org+'';
        ws.Type__c = Label.WS_Organisation;
        ws.flux__c = Label.WSTypeFluxEntrant;
        Boolean dkCodeExiste = false;
        String dkCode = '';
        Agence__c agence = new Agence__c();
        List<HistoriqueReferentiel__c> listHistToInsert = new List<HistoriqueReferentiel__c> ();
        //Header
        if(org.Header != null){
            if (org.Header.transactionId!=null) {
                ws.TransactionId__c = org.Header.transactionId;
            }
        }
        //ProprietesOrganisation
        if(org.proprietesOrganisation != null){
            if(String.isNotBlank(org.proprietesOrganisation.dkCodeOrganisation)){
                ws.DkCode__c= org.proprietesOrganisation.dkCodeOrganisation; 
                List<Agence__c> listAgence = new List<Agence__c>();
                listAgence = [Select id,name,Code_Agence__c,Libelle__c
                              From Agence__c
                              Where DkCode__c = :org.proprietesOrganisation.dkCodeOrganisation];
                if(listAgence != null && listAgence.size()>0){
                    agence = listAgence[0];
                    dkCodeExiste = true;
                }
                dkCode = org.proprietesOrganisation.dkCodeOrganisation;
                agence.DkCode__c = org.proprietesOrganisation.dkCodeOrganisation;
            }
            else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS11_dkCodeOrganisationOB + '\n';
                resp.error = true;
            }
            if(String.isNotBlank(org.proprietesOrganisation.libelle)){
                String temp = org.proprietesOrganisation.libelle;
                if(org.proprietesOrganisation.libelle.length()>80){
                    if(temp != null){
                        temp = temp.substring(0,80);
                    }
                }
                agence.Name = temp;
                agence.Libelle__c = org.proprietesOrganisation.libelle;
            }
            else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS11_libelleOB + '\n';
                resp.error = true;
            }
            if(String.isNotBlank(org.proprietesOrganisation.commentaire)){
                agence.Commentaire__c = org.proprietesOrganisation.commentaire;
            }
            if(org.proprietesOrganisation.controleNiveau!=null){
                agence.Niveau__c = org.proprietesOrganisation.controleNiveau+'';
            }
            else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS11_controleNiveauOB + '\n';
                resp.error = true;
            }
            if(String.isNotBlank(org.proprietesOrganisation.statutOrganisation)){
                agence.Statut__c = org.proprietesOrganisation.statutOrganisation;
            }
            else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS11_statutOrganisationOB + '\n';
                resp.error = true;
            }
            if(org.proprietesOrganisation.dateDebut!=null){
                agence.DateDebut__c = org.proprietesOrganisation.dateDebut;
            }
            else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS11_DateDebutOB + '\n';
                resp.error = true;
            }
            if(org.proprietesOrganisation.dateFin!=null){
                agence.DateFin__c = org.proprietesOrganisation.dateFin;
            }
            if(String.isNotBlank(org.proprietesOrganisation.acronymeSigle)){
                agence.Code_Agence__c = org.proprietesOrganisation.acronymeSigle;
            }
            else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS11_acronymeSigleOB + '\n';
                resp.error = true;
            }
            if(org.proprietesOrganisation.estUODalkia!=null){
                agence.EstUODalkia__c = org.proprietesOrganisation.estUODalkia;
            }
            else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS11_estUODalkiaOB + '\n';
                resp.error = true;
            }
            if(String.isNotBlank(org.proprietesOrganisation.UODalkia)){
                List<CentreFinance__c> listCf = new List<CentreFinance__c>();
                listCf = [Select id,DkCode__c 
                          FROM CentreFinance__c 
                          WHERE DkCode__c = : org.proprietesOrganisation.UODalkia];
                if(listCf != null && listCf.size()>0){
                    agence.CentreFinance__c = listCf[0].id;
                }
            }
            else{
                if(org.proprietesOrganisation.estUODalkia!=null && org.proprietesOrganisation.estUODalkia){
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS11_UODalkiaOB + '\n';
                    resp.error = true; 
                }
            }
            if(org.proprietesOrganisation.estGroupeExploitation!=null){
                agence.EstGroupeExploitation__c = org.proprietesOrganisation.estGroupeExploitation;
            }
            else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS11_estGroupeExploitationOB + '\n';
                resp.error = true;
            }
        }
        else{
            resp.responseCode = Label.WS_Response_KO;
            resp.errorText += Label.WS11_proprietesOrganisationOB + '\n';
            resp.error = true;
        }    
        //LienParent
        if(org.lienParent!=null && !dkcodeExiste){//insert
            String dkCodeParent = '';
            for(LienParent lp : org.lienParent){
                if(lp.dateDebut!=null){
                    if(lp.dateDebut <= System.today()){
                        dkcodeParent = lp.organisationParente;
                        if(lp.dateFin!=null && lp.dateFin >= System.today()){
                            dkcodeParent = lp.organisationParente;
                        }
                    }
                }
                else{
                    resp.responseCode = Label.WS_Response_KO;
                    resp.error = true;
                }
            }
            if(String.isNotBlank(dkcodeParent)){
                List<Agence__c> agList = new List<Agence__c>();
                agList = [Select id,name,DkCode__c
                          From Agence__c
                          Where DkCode__c = :dkcodeParent];
                if(agList != null && agList.size()>0){
                    agence.Agence_Parent__c = agList[0].id;
                }
            }
            else if(org.proprietesOrganisation.statutOrganisation != 'OUV'){
                try{
                    List<HistoriqueReferentiel__c> listOldHistorique = [Select id,name
                                                                        From HistoriqueReferentiel__c
                                                                        Where Objet__c= :Label.WS11_Organisation
                                                                        And Dkcode__c = :dkCode
                                                                        And Champ__c = :Label.WS11_Parent];
                    delete listOldHistorique;
                }
                catch(Exception e){
                    System.debug('Exception in old hisotrique logic for dkcode: ' + dkCode + ' ' + e);
                }
                String dkCodeParentHist = '';
                if(dkcodeParent == ''){
                for(LienParent lp : org.lienParent){
                    dkCodeParentHist = lp.organisationParente;
                    HistoriqueReferentiel__c historique = new HistoriqueReferentiel__c();
                    historique.Objet__c = Label.WS11_Organisation;
                    if(dkCode != null){
                        historique.DkCode__c = dkCode;
                    }
                    else{
                        historique.DkCode__c = '';
                    }
                    historique.Champ__c = Label.WS11_Parent;
                    if(dkCodeParentHist != null){
                        historique.Valeur__c = dkCodeParentHist;
                    }
                    else{
                        historique.Valeur__c = '';
                    }
                    Date myDate = Date.newInstance(2099, 01, 01);
                    Time myTime = Time.newInstance(9, 11, 44, 88);
                    DateTime dt = DateTime.newInstance(myDate, myTime);
                    if(lp.dateDebut != null){
                        historique.DateDebut__c = lp.dateDebut;
                    }
                    else{
                        historique.DateDebut__c = dt;
                    }
                    if(lp.dateFin != null){
                        historique.DateFin__c = lp.dateFin;
                    }
                    else{
                        historique.DateFin__c = dt;
                    }
                    listHistToInsert.add(historique);
                }
                }
            }
            else if(org.proprietesOrganisation.statutOrganisation == Label.WS11_OUV){
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS11_organisationParenteOB + '\n';
                resp.error = true;
            }
        }
        else if(org.lienParent!=null && dkcodeExiste){//update
            String dkCodeParent = '';
            for(LienParent lp : org.lienParent){
                if(lp.dateDebut!=null){
                    if(lp.dateDebut <= System.today()){
                        dkcodeParent = lp.organisationParente;
                        if(lp.dateFin!=null && lp.dateFin >= System.today()){
                            dkcodeParent = lp.organisationParente;
                        }
                    }
                }
                else{
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS11_organisationParenteOB + '\n';
                    resp.error = true;
                }
            }
            if(String.isNotBlank(dkcodeParent)){
                List<Agence__c> agList = new List<Agence__c>();
                agList = [Select id,name,DkCode__c
                          From Agence__c
                          Where DkCode__c = :dkcodeParent];
                if(agList != null && agList.size()>0){
                    agence.Agence_Parent__c = agList[0].id;
                }
            }
            else if(org.proprietesOrganisation.statutOrganisation == Label.WS11_OUV){
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS11_organisationParenteOB + '\n';
                resp.error = true;
            }
            try{
                List<HistoriqueReferentiel__c> listOldHistorique = [Select id,name
                                                                    From HistoriqueReferentiel__c
                                                                    Where Objet__c=:Label.WS11_Organisation
                                                                    And Dkcode__c = :dkCode
                                                                    And Champ__c = :Label.WS11_Parent];
                delete listOldHistorique;
            }
            catch(Exception e){
                System.debug('Exception in old hisotrique logic for dkcode: ' + dkCode + ' ' + e);
            }
            if(dkcodeParent == ''){
            for(LienParent lp : org.lienParent){
                dkCodeParent = lp.organisationParente;
                HistoriqueReferentiel__c historique = new HistoriqueReferentiel__c();
                historique.Objet__c = Label.WS11_Organisation;
                if(dkCode != null){
                    historique.DkCode__c = dkCode;
                }
                else{
                    historique.DkCode__c = '';
                }
                historique.Champ__c = Label.WS11_Parent;
                if(dkCodeParent != null){
                    historique.Valeur__c = dkCodeParent;
                }
                else{
                    historique.Valeur__c = '';
                }
                Date myDate = Date.newInstance(2099, 01, 01);
                Time myTime = Time.newInstance(9, 11, 44, 88);
                DateTime dt = DateTime.newInstance(myDate, myTime);
                if(lp.dateDebut != null){
                    historique.DateDebut__c = lp.dateDebut;
                }
                else{
                    historique.DateDebut__c = dt;
                }
                if(lp.dateFin != null){
                    historique.DateFin__c = lp.dateFin;
                }
                else{
                    historique.DateFin__c = dt;
                }
                listHistToInsert.add(historique);
            }
            }
        }
        //LienResponsable
        if(org.lienResponsable!=null){
            String dkCodeResp = '';
            for(LienResponsable lp : org.lienResponsable){
                if(lp.dateDebut!=null){
                    if(lp.dateDebut <= System.today()){
                        dkCodeResp = lp.responsableOrganisation;
                        if(lp.dateFin!=null && lp.dateFin >= System.today()){
                            dkCodeResp = lp.responsableOrganisation;
                        }
                    }
                }
                else{
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS11_lienParentdateDebut + '\n';
                    resp.error = true;
                }
            }
            if(String.isNotBlank(dkCodeResp)){
                List<User> userList = new List<User>();
                userList = [ select id,name,dkcode__c  from user where dkcode__c  = :dkCodeResp LIMIT 1 ];
                if(userList != null && userList.size()>0){
                    agence.responsable__c = userList[0].Id;
                }
                try{
                    List<HistoriqueReferentiel__c> listOldHistorique = [Select id,name
                                                                        From HistoriqueReferentiel__c
                                                                        Where Objet__c= :Label.WS11_Organisation
                                                                        And Dkcode__c = :dkCode
                                                                        And Champ__c = :Label.WS11_Responsable];
                    if(listOldHistorique.size()>0){
                        delete listOldHistorique;
                    }
                }
                catch(Exception e){
                    System.debug('Exception in old hisotrique logic for dkcode: ' + dkCode + ' ' + e);
                }
            }
            else if(org.proprietesOrganisation.statutOrganisation != Label.WS11_OUV){
                try{
                    List<HistoriqueReferentiel__c> listOldHistorique = [Select id,name
                                                                        From HistoriqueReferentiel__c
                                                                        Where Objet__c= :Label.WS11_Organisation
                                                                        And Dkcode__c = :dkCode
                                                                        And Champ__c = :Label.WS11_Responsable];
                    if(listOldHistorique.size()>0){
                        delete listOldHistorique;
                    }
                }
                catch(Exception e){
                    System.debug('Exception in old hisotrique logic for dkcode: ' + dkCode + ' ' + e);
                }
                
                String dkCodeParentHist = '';
                for(LienResponsable lp : org.lienResponsable){
                    dkCodeParentHist = lp.responsableOrganisation;
                    HistoriqueReferentiel__c historique = new HistoriqueReferentiel__c();
                    historique.Objet__c = Label.WS11_Organisation;
                    if(dkCode != null){
                        historique.DkCode__c = dkCode;
                    }
                    else{
                        historique.DkCode__c = '';
                    }
                    historique.Champ__c = Label.WS11_Responsable;
                    if(dkCodeParentHist != null){
                        historique.Valeur__c = dkCodeParentHist;
                    }
                    else{
                        historique.Valeur__c = '';
                    }
                    Date myDate = Date.newInstance(2099, 01, 01);
                    Time myTime = Time.newInstance(9, 11, 44, 88);
                    DateTime dt = DateTime.newInstance(myDate, myTime);
                    if(lp.dateDebut != null){
                        historique.DateDebut__c = lp.dateDebut;
                    }
                    else{
                        historique.DateDebut__c = dt;
                    }
                    if(lp.dateFin != null){
                        historique.DateFin__c = lp.dateFin;
                    }
                    else{
                        historique.DateFin__c = dt;
                    }
                    listHistToInsert.add(historique);
                }
            }
            else if(org.proprietesOrganisation.statutOrganisation == Label.WS11_OUV){
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS11_responsableOrganisationOB + '\n';
                resp.error = true;
            }
        }
        else{
            resp.responseCode = Label.WS_Response_KO;
            resp.errorText += Label.WS11_lienResponsableOB + '\n';
            resp.error = true;
        }
        //Metadonnees
        if(org.metadonnees != null ){
            if(org.metadonnees.creationDate != null ){
                agence.CreateDate__c = org.metadonnees.creationDate;
            }
            else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS06_creationDateOB + '\n';
                resp.error = true;
            }
            List<User> userMetadonne = new List<User>();
            userMetadonne = [SELECT id,name,ReferentielId__c 
                             FROM user 
                             WHERE ReferentielId__c = : org.Metadonnees.creationId
                             OR ReferentielId__c = : org.Metadonnees.updateId
                             OR ReferentielId__c = : org.Metadonnees.validationId];
            if(org.metadonnees.creationId != null ){
                for(User userLoop : userMetadonne){
                    if(userLoop.ReferentielId__c == org.Metadonnees.creationId){
                        agence.CreateId__c  = userLoop.id;  
                    }
                }
            }
            else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS06_creationId + '\n';
                resp.error = true;
            }
            if(org.metadonnees.updateDate != null){
                agence.UpdateDate__c = org.metadonnees.updateDate;
            }
            if(org.metadonnees.updateId != null){
                for(User userLoop : userMetadonne){
                    if(userLoop.ReferentielId__c == org.Metadonnees.updateId){
                        agence.UpdateId__c  = userLoop.id;  
                    }
                }
            }
            if(org.metadonnees.validationDate != null){
                agence.ValidationDate__c = org.metadonnees.validationDate;
            }
            if(org.metadonnees.validationId != null){
                for(User userLoop : userMetadonne){
                    if(userLoop.ReferentielId__c == org.Metadonnees.ValidationId){
                        agence.ValidationId__c  = userLoop.id;  
                    }
                }
            }
        }
        else{
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
        upsert ws;
        if(!resp.error){
            try{
                insert listHistToInsert;
                if(dkCodeExiste){
                    update agence;
                }
                else{
                    insert agence;
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
                resp.errorText += Label.WS10_Error + e.getMessage() + '\n';
                System.debug('insertUpdateOrganisation error ' + e.getMessage());
                ws.Response__c = resp+ Label.WS11_AfterError + e.getMessage();
                upsert ws;
            }
        }
        return resp;
    }
}