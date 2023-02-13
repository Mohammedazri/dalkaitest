global class WS01_BaseSirene {
    
    global class Partenaire{
        webservice String dkPartenaire;
        webservice Etablissement etablissement;
    }
    
    global class Etablissement{
        webservice String immatriculationLegale;
        webservice String libelleEtablissement;
        webservice String denominationCommerciale;
        webservice Boolean siegeSocialPartenaire;
        webservice String effectifSalarie;
        webservice DateTime dateDebut;
        webservice DateTime dateFin;
        webservice String etatAdministratifEtablissement;
        webservice String codeActiviteLocal;
        webservice String Segment; // added by Jacques Akiki 13-06-19
        webservice String SousSegment;// added by Jacques Akiki 13-06-19
        webservice Societe societe;
        webservice List<Adresse> adresse;
    }
    
    global class Societe{
        webservice String immatriculationLegale;
        webservice String denominationUniteLegale;
        webservice String nomNaissance;
        webservice String nomUsage;
        webservice String prenoms;
        webservice String acronymeSigleSociete;
        webservice String lieuImmatriculationLegale;
        webservice String formeJuridiqueInsee;
        webservice String codeActiviteLocal;
        webservice String RNA;
        webservice String etatAdmin;
        webservice String nicSiege;
    }
    
    global class Adresse{
        webservice String precisionIdentificationAdresse;
        webservice String numeroVoie;
        webservice String typeDeVoie;
        webservice String libelleVoie;
        webservice String complementAdresse;
        webservice String codePostal;
        webservice String ville;
        webservice String pays;
    }
    
    public static String CallBaseSiren(string SIRET){
        
        Blob authToEncode = Blob.valueOf(Label.client_id_sirene + ':' + Label.client_secret_sirene);
        String authInHeader = 'Basic ' + EncodingUtil.base64Encode(authToEncode);
        System.debug('authInHeader ' + authInHeader);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(Label.endpoint_token_sirene);
        request.setMethod('POST');
        request.setHeader('Authorization', authInHeader);
        request.setHeader('Content-Type', Label.Content_Type);
        String reqBody='grant_type=client_credentials';
        request.setBody(reqBody);
        System.debug('tokenRequest'+request);
        HttpResponse response = http.send(request);
        System.debug('response : ' + response.getBody());
        Token tok = new Token();
        tok = Token.parse(response.getBody());
        System.debug('Response.getToken : ' + tok);
        
        String myWs = Label.endpoint_WS_sirene;
        string endpoint = myWs + SIRET;
        system.debug('endpoint ' + endpoint);
        Http http1 = new Http();
        HttpRequest request1 = new HttpRequest();
        request1.setEndpoint(endpoint);
        request1.setMethod('GET');
        if(!Test.isRunningTest())
        {
            request1.setHeader('Authorization', tok.access_token);
        }
        request1.setHeader('x-api-key', Label.x_api_key_sirene);
        request1.setHeader('scope', Label.scope_sirene);
        system.debug('request1 ' + request1);
        HttpResponse retVal= http1.send(request1);        
        string responseBody=retVal.getBody();
        system.debug('responseBody ' + responseBody);
        return responseBody;
        //return (Partenaire) System.JSON.deserialize(responseBody, Partenaire.class);
    }
    
    public static String DoCalloutAndRteurnInfos(string SIRET)
    {
        try{
            String myObject = CallBaseSiren(SIRET);
            /*Modif by Jacques Akiki 13-06-19*/
            Partenaire part = (Partenaire)JSON.deserialize(myObject, Partenaire.class);
            String codeActLocal =part.etablissement.codeActiviteLocal.remove('.'); // remove the dot by the WS
                        system.debug('.........................'+codeActLocal);
            List<CodeActiviteLocalSegment__c> listCALS = [SELECT CodeActiviteLocal__c,Libelle__c,Segment__c,SousSegment__c
                                                          FROM CodeActiviteLocalSegment__c
                                                          WHERE CodeActiviteLocal__c=:codeActLocal];
            if(listCALS!=NULL && listCALS.size()>0 && listCALS[0]!=NULL && listCALS[0].Segment__c!=NULL && !listCALS[0].Segment__c.contains(',')){
                part.etablissement.Segment = listCALS[0].Segment__c;
            }
            else{
                part.etablissement.Segment = ''; 
            }
            Map<String,String> segmentLabelValue = new Map<String,String>();
            Schema.DescribeFieldResult fieldResultSeg = Account.Segment_client__c.getDescribe();
            List<Schema.PicklistEntry> valuesSeg = fieldResultSeg.getPicklistValues();
            for( Schema.PicklistEntry v : valuesSeg) {
                segmentLabelValue.put(v.getValue(),v.getLabel());        
            }
            if(listCALS!=NULL && listCALS.size()>0 && listCALS[0]!=NULL && listCALS[0].SousSegment__c!=NULL && !listCALS[0].SousSegment__c.contains(',') && !listCALS[0].SousSegment__c.contains('-')){
                part.etablissement.SousSegment = listCALS[0].SousSegment__c;
            }
            else{
                part.etablissement.SousSegment = ''; 
            }
            part.etablissement.Segment = segmentLabelValue.get(part.etablissement.Segment);
            Map<String,String> sousSegmentLabelValue = new Map<String,String>();
            Schema.DescribeFieldResult fieldResultSousSeg = Account.Sous_segment_client__c.getDescribe();
            List<Schema.PicklistEntry> valuesSousSeg = fieldResultSousSeg.getPicklistValues();
            for( Schema.PicklistEntry v : valuesSousSeg) {
                sousSegmentLabelValue.put(v.getValue(),v.getLabel());      
            }
            part.etablissement.SousSegment = sousSegmentLabelValue.get(part.etablissement.SousSegment);
            Pays__c pays = [SELECT Abreviation__c,Nom__c 
                           FROM Pays__c 
                           WHERE Abreviation__c	= :part.etablissement.adresse[0].pays];
            part.etablissement.adresse[0].pays = pays.Nom__c;
            myObject = JSON.serialize(part) ;
            
              /*End Modif*/
            system.debug('myObject ' + myObject);
            if(myObject!=null)
            {
                return myObject;
            }
            else
            {
                return null;
            }
        }
        catch (Exception e)
        {
            system.debug('in catch ' + e);
            return null;
        }
    }
    @ future(callout=true)
        public static void DoCallout(string SIRET, id myaccountId)
    {
        try{
            String myObject = CallBaseSiren(SIRET);
            Partenaire result = (Partenaire) System.JSON.deserialize(myObject, Partenaire.class);
            system.debug('myObject' + myObject);
            system.debug('etablissement'+ result.etablissement);
            
            account acc=[SELECT id, Name, LibelleEtablissement__c,Sigle__c,Siege_social_partenaire__c,SIRET__c,Code_NAF__c,Effectif__c,Enseigne__c,BillingStreet,BillingPostalCode,BillingCity,BillingCountry,ComplementAdresse__c,PrecisionIdentificationAdresse__c
                         FROM Account 
                         WHERE id=:myaccountId];
            if(result.etablissement != null)
            {
                acc.Name = result.etablissement.libelleEtablissement;
                //acc.LibelleEtablissement__c = result.etablissement.libelleEtablissement;
                acc.Siege_social_partenaire__c = result.etablissement.siegeSocialPartenaire;
                acc.SIRET__c = result.etablissement.immatriculationLegale;
                acc.Code_NAF__c = result.etablissement.codeActiviteLocal;
                acc.Effectif__c = result.etablissement.effectifSalarie;
                acc.Enseigne__c = result.etablissement.denominationCommerciale;
                acc.BillingStreet = result.etablissement.adresse[0].numeroVoie + result.etablissement.adresse[0].typeDeVoie + result.etablissement.adresse[0].libelleVoie;
                acc.BillingPostalCode =  result.etablissement.adresse[0].codePostal;
                acc.BillingCity = result.etablissement.adresse[0].ville;
                acc.BillingCountry = result.etablissement.adresse[0].pays;
                acc.ComplementAdresse__c = result.etablissement.adresse[0].complementAdresse;
                acc.PrecisionIdentificationAdresse__c = result.etablissement.adresse[0].precisionIdentificationAdresse;
                List<Account> listAcc = new List<Account>();
                listAcc.add(acc); 
                AP45_AccountCallouts.CreerPartenaireIdExterne(JSON.serialize(listAcc));
            }
            else
            {
                system.debug('aucun account dans base sirene a ce siret');
            }
        }
        catch (Exception e)
        {
            system.debug('in catch ' + e);
        }
    }
}