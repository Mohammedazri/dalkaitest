/**
*@author:Alain Ghoussoub 
*@date 30/9/2019
*@description WS exposé de parametrage de picklist
*/
global class WS12_Parametrage {
    global class JeuDeValeur{ 
        webservice Header header;
        webservice String nomJeuDeValeur;
        webservice String libelle;
        webservice List<Valeurs> valeurs;
    }
    global class Valeurs{
        webservice String code;
        webservice Boolean activite;
        webservice DateTime dateDebut;
        webservice DateTime dateFin;
        webservice Boolean valeurParDefault;
        webservice Integer numeroOrdre;
        webservice String jvParent;
        webservice List<ValeurParent> valeurParent;
        webservice List<Description> description;
    }
    global class ValeurParent{
        webservice String codeParent;
        webservice String jvGrandParent;
        webservice List<ValeurGrandParent> valeurGrandParent;
    }
    global class Description{
        webservice String codeLangue;
        webservice String description;
    }
    global class ValeurGrandParent{
        webservice String codeGrandParent;
    }
    webservice static Response insertUpdateValues(JeuDeValeur jdv) {
        Response resp = new Response();
        resp.error = false;
        resp.responseCode = 'OK';
        resp.errorText = '';
        WebserviceLog__c ws = new WebserviceLog__c();
        ws.Request__c = jdv+'';
        ws.Type__c = 'insertUpdateValues';
        ws.flux__c = 'entrant';
        List<HistoriqueParametrage__c> listHistToInsert = new List<HistoriqueParametrage__c> ();
        if(jdv.valeurs != null){
            for(Valeurs val : jdv.valeurs){
                HistoriqueParametrage__c hist = new HistoriqueParametrage__c();
                if(String.isNotBlank(jdv.nomJeuDeValeur)){
                    hist.NomJeuValeurs__c = jdv.nomJeuDeValeur;
                }
                else{
                    resp.responseCode = 'KO';
                    resp.errorText += 'Le champ nomJeuDeValeur est obligatoire \n';
                    resp.error = true;
                }
                if(String.isNotBlank(jdv.libelle)){
                    hist.Libelle__c = jdv.libelle;
                }
                else{
                    resp.responseCode = 'KO';
                    resp.errorText += 'Le champ libelle est obligatoire \n';
                    resp.error = true;
                }
                if(String.isNotBlank(val.code)){
                    hist.code__c = val.code;
                }
                else{
                    resp.responseCode = 'KO';
                    resp.errorText += 'Le champ code est obligatoire \n';
                    resp.error = true;
                }
                if(val.activite != null){
                    if(val.activite == true){
                        hist.Activite__c = 'VRAI';
                    }
                    else{
                        hist.Activite__c = 'FAUX';
                    }
                }
                else{
                    resp.responseCode = 'KO';
                    resp.errorText += 'Le champ activite est obligatoire \n';
                    resp.error = true;
                }
                if(val.dateDebut != null){
                    Date dateDebut = date.newinstance(val.dateDebut.year(), val.dateDebut.month(), val.dateDebut.day());
                    hist.DateDebut__c = dateDebut;
                }
                if(val.dateFin != null){
                    Date dateFin = date.newinstance(val.dateFin.year(), val.dateFin.month(), val.dateFin.day());
                    hist.DateFin__c = dateFin;
                }
                if(val.valeurParDefault != null){
                    hist.ValeurParDefaut__c = val.valeurParDefault;
                }
                if(val.numeroOrdre != null){
                    hist.NumeroOrdre__c = val.numeroOrdre;
                }
                if(String.isNotBlank(val.jvParent)){
                    hist.JVParent__c = val.jvParent;
                }
                if(val.valeurParent != null){
                    for(ValeurParent vp : val.valeurParent){
                        if(String.isNotBlank(vp.codeParent)){
                            hist.CodeParent__c += vp.codeParent + ',';
                        }
                        else{
                            resp.responseCode = 'KO';
                            resp.errorText += 'Le champ codeParent est obligatoire \n';
                            resp.error = true;
                        }
                        if(String.IsNotBlank(vp.jvGrandParent) || vp.valeurGrandParent != null){
                            hist.GrandParent__c = true;
                        }
                    }
                    if(String.isNotBlank(hist.CodeParent__c)){
                        hist.CodeParent__c = hist.CodeParent__c.removeEnd(',');
                    }
                }
                listHistToInsert.add(hist);
            }
        }
        else{
            resp.responseCode = 'KO';
            resp.errorText += 'Le champ valeurs est obligatoire \n';
            resp.error = true;
        }
        ws.Response__c = resp+'';
        upsert ws;
        if(!resp.error){
            try{
                insert listHistToInsert;
            }
            catch(Exception e){
                resp.error = true;
                resp.responseCode = 'KO';
                resp.errorText += 'insertUpdateValues error ' + e.getMessage();
                System.debug('insertUpdateValues error ' + e.getMessage());
                ws.Response__c = resp+' -  after error in upsert values ' + e.getMessage();
                upsert ws;
            }
        }
        return resp;
    }
}