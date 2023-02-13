/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-Technologies
Description: Classe responsable de faire les web services explore et crée les pistes
Test Class: AP03_CallExplore_Test 84%
History
10/04/2018 Johny Kassis ajout des condition aux requettes des utilisateurs
--------------------------------------------------------------------------------------------------------------------------*/
public class AP03_CallExplore {
    public static list<WebserviceLog__c> Logslist=new list<WebserviceLog__c>();
    
    
     /*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-Technologies
Description: this function uses the functions CallExplorePromotion,CallExploreMarchePublic and CallExploreMouvement, gets 
             the lists of leads and it does an upsert using the function updateLead
Inputs: -
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/
    @Future(callout=true)
    public static void CallExplore()
    {
        List<Group> QueuesList=[SELECT id, DeveloperName
                                FROM Group
                                WHERE DeveloperName='SansAffectation' or DeveloperName='MultiAffectation' or DeveloperName='PisteNationale'];
        String SansAffectationId;
        String MultiAffectationId;
        String PisteNationaleId;
        for(Group thisGroup:QueuesList)
        {
            if( thisGroup.DeveloperName=='SansAffectation')
            {
                SansAffectationId=thisGroup.Id;
            }
            else if(thisGroup.DeveloperName=='MultiAffectation')
            {
                MultiAffectationId=thisGroup.Id;
            }
            else if(thisGroup.DeveloperName=='PisteNationale')
            {
                PisteNationaleId=thisGroup.Id;
            }
        }
        List<Lead>ListLeadForUpsert= new List<Lead>();
        Map<integer, list<lead>> MapNiveauLeads= new Map<integer, list<lead>>();
        MapNiveauLeads=CallExploreMarchePublic(SansAffectationId, MultiAffectationId,PisteNationaleId);
        
        if(MapNiveauLeads != null && MapNiveauLeads.size()>=1)
        {
            if(MapNiveauLeads.size()==1)
            {
                ListLeadForUpsert.addAll(MapNiveauLeads.get(1));
                ListLeadForUpsert.addAll(CallExplorePromotion(SansAffectationId, MultiAffectationId,PisteNationaleId));
                ListLeadForUpsert.addAll(CallExploreMouvement(SansAffectationId, MultiAffectationId,PisteNationaleId));
                if(ListLeadForUpsert.size() > 0)
                {
                    
                    string jsonString = JSON.serializePretty(ListLeadForUpsert );                   
                    updateLead(jsonString);
                }
            }
            else
            {
                system.debug('in size > 1');
                system.debug('$$$$niveau 1 size' + MapNiveauLeads.get(1).size());
                ListLeadForUpsert.addAll(MapNiveauLeads.get(1));
                ListLeadForUpsert.addAll(CallExplorePromotion(SansAffectationId, MultiAffectationId,PisteNationaleId));
                ListLeadForUpsert.addAll(CallExploreMouvement(SansAffectationId, MultiAffectationId,PisteNationaleId));
                system.debug('&&&ListLeadForUpsert' +ListLeadForUpsert);
                if(ListLeadForUpsert.size() > 0)
                {
                    
                    string jsonString = JSON.serializePretty(ListLeadForUpsert );  
                    updateLead(jsonString);
                }
                for(integer Niveau: MapNiveauLeads.keySet())
                {
                    if(Niveau!= 1)
                    {
                        ListLeadForUpsert= new List<Lead>();
                        ListLeadForUpsert.addAll(MapNiveauLeads.get(Niveau));
                        system.debug('&&&ListLeadForUpsert' +ListLeadForUpsert);
                        if(ListLeadForUpsert.size() > 0)
                        {
                            //Database.UpsertResult[] cr = Database.upsert(ListLeadForUpsert,Lead.Fields.Tech_Unique__c, false);
                            //system.debug('#### cr ' + cr);
                            string jsonString = JSON.serializePretty(ListLeadForUpsert );                   
                            updateLead(jsonString);
                            // we had to to this because the requirement was if 2 leads were correspondinf to 
                            //the same CLE_MARCHE_PUBLIC_EXPLORE the first one must be inserted in salesforce then  the second shoud update it
                            //to be able to follow the history of fields that are being updated
                        }
                    }
                }
                
            }
        }
        else
        {
            ListLeadForUpsert.addAll(CallExplorePromotion(SansAffectationId, MultiAffectationId,PisteNationaleId));
            ListLeadForUpsert.addAll(CallExploreMouvement(SansAffectationId, MultiAffectationId,PisteNationaleId));
            if(ListLeadForUpsert.size() > 0)
            {
                
                string jsonString = JSON.serializePretty(ListLeadForUpsert ); 
                updateLead(jsonString);
            }
        }
        insert(Logslist);
    }
    
     /*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-Technologies
Description: this function calls the webservice using the function DoCalloutMarchePublic in the class WS02_Explore_MarchePublic ,
              then uses the response of the webservice to create leads whose potential type (TypePotentiel__c) is 'Marchés publics' and return the list of leads
             
Inputs: String SansAffectationId, String MultiAffectationId,String PisteNationaleId
Returns: Map<integer, list<lead>>
----------------------------------------------------------------------------------------------------------------------------*/
    public static Map<integer, list<lead>> CallExploreMarchePublic(String SansAffectationId, String MultiAffectationId,String PisteNationaleId)
    {
        system.debug('in Marche public');
        
        Map<integer, list<lead>> MapNiveauLeads= new Map<integer, list<lead>>();
        
        WS02_Explore_MarchePublic.WS_Wrapper mywrapper=WS02_Explore_MarchePublic.DoCalloutMarchePublic();
        WS02_Explore_MarchePublic.RootObject TheRoot=mywrapper.RootObj;
        /*
        if(mywrapper.Log!=null)
        {
            Logslist.add(mywrapper.Log);
        }
        */
        try
        {
            if(TheRoot!= null)
            {
                Map<string, integer> MapMarcheNiveau= new Map<string, integer>();
                List<String> CollabolateurEmails= new List<String>();
                List<User> DACUsers= new List<User>();
                for(WS02_Explore_MarchePublic.Records thisRecord:TheRoot.records)
                {
                    if(thisRecord.EMAIL_COLLABORATEUR != null)
                        CollabolateurEmails.addAll(thisRecord.EMAIL_COLLABORATEUR);                
                }
                DACUsers=[SELECT id, Name, ProfileId, Email
                          FROM User
                          WHERE ProfileId=:Label.AgenceCommercialProfileId and IsActive=true and Email in:CollabolateurEmails];
                for(WS02_Explore_MarchePublic.Records thisRecord:TheRoot.records)
                {         
                    WS_endpoint__c myWs = WS_endpoint__c.getInstance('Explore Marchés Publics');
                    Lead theLead= new Lead();
                    theLead.Reference_explore__c=thisRecord.IDENTIFIANT_EXPLORE;
                    theLead.Lien_Explore__c=myWs.Lien_explore__c+ thisRecord.IDENTIFIANT+'&CleClient='+ myWs.Cle_Client__c;
                    if(thisRecord.OBJET!= null)
                    {
                        if(thisRecord.OBJET.length()>255)
                            theLead.Titre__c=(thisRecord.OBJET).substring(0, 255);
                        else
                            theLead.Titre__c=thisRecord.OBJET;
                    }
                    
                    if(thisRecord.TYPE_AVIS!= null)
                        theLead.Type_d_avis__c=EncodingUtil.urlDecode(thisRecord.TYPE_AVIS,'UTF-8') ;//s'assurer des valeurs possibles de la picklist
                    if(thisRecord.SOCIETES!= null && thisRecord.SOCIETES.size()>=1)
                    {
                        for(WS02_Explore_MarchePublic.SOCIETES thissociete: thisRecord.SOCIETES)
                        {
                            if(thissociete.ROLE=='DONNEUR ORDRE')
                            {
                                if(thissociete.SIRET!= null)
                                    theLead.SIRET__c=thissociete.SIRET;
                                theLead.LastName='Contact de la société '+ thissociete.RAISON_SOCIALE;
                                theLead.Company=thissociete.RAISON_SOCIALE;
                                theLead.Raison_sociale__c=thissociete.RAISON_SOCIALE;
                                theLead.Tech_IdentifiantSocieteExplore__c=thissociete.IDENTIFIANT_SOCIETE_EXPLORE;
                                if(thissociete.CODE_NAF!= null && thissociete.CODE_NAF<>'')
                                {
                                    theLead.CodeNAFPotentiel__c=thissociete.CODE_NAF;
                                    //Mapping_Segment_Client__c ThisMap=Mapping_Segment_Client__c.getInstance(thissociete.CODE_NAF.substring(0,2));
                                    CodeActiviteLocalSegment__c ThisMap=CodeActiviteLocalSegment__c.getInstance(thissociete.CODE_NAF);
                                    if(ThisMap != null)
                                    {
                                        //theLead.SegmentClient__c=ThisMap.Segment_Client__c;
                                        //theLead.SousSegmentClient__c=ThisMap.Sous_Segment_Client__c;
                                        // PJB 17/04/2019
                                        theLead.SegmentClient__c=ThisMap.Segment__c;
                                        theLead.SousSegmentClient__c=ThisMap.SousSegment__c;
                                    }
                                }
                                system.debug('*** thissociete.TEFEN ='+thissociete.TEFEN);
                                if(thissociete.TEFEN!= 'NN')
                                    theLead.Effectif__c=thissociete.TEFEN;
                                break;
                            }
                            theLead.LastName='Non disponible';
                        }
                    }
                    else
                    {
                        theLead.LastName='Non disponible';
                    }
                    theLead.Type_de_marche__c='Marché public';
                    if(thisRecord.MPC_DT_ECHEANCE != null && thisRecord.MPC_DT_ECHEANCE!='0001-01-01T00:00:00')
                    {
                        theLead.EcheanceMarche__c=date.valueOf(thisRecord.MPC_DT_ECHEANCE.substring(0, (thisRecord.MPC_DT_ECHEANCE).length() - 9));
                    }
                    
                    string PrestationValue='';
                    if(thisRecord.MPC_TYPE_PRESTATION != null)
                    {
                        for(WS02_Explore_MarchePublic.MPC_TYPE_PRESTATION thisPrestation:thisRecord.MPC_TYPE_PRESTATION)
                        {
                            PrestationValue+=thisPrestation.MPC_TYPE_PRESTATION_LIB+';';
                        }
                    }
                    
                    theLead.Prestation__c=PrestationValue.removeEnd(';');
                    if(thisRecord.DATE_PARUTION != null)
                        theLead.Date_de_parution__c=date.valueOf(thisRecord.DATE_PARUTION.substring(0, (thisRecord.DATE_PARUTION).length() - 9));
                    if(thisRecord.MPC_FORME_MARCHE!= null && thisRecord.MPC_FORME_MARCHE.size()>=1)
                        theLead.Forme_du_marche__c=thisRecord.MPC_FORME_MARCHE[0].MPC_FORME_MARCHE_LIB;
                    theLead.Renouvellement__c=thisRecord.MPC_RENOUVELLEMENT;
                    //surface on ne la fait pas
                    //a ajouter les 3 champs de identifiant apres que pj les cre
                    theLead.LeadSource='Explore';
                    theLead.TypePotentiel__c='Marchés publics';
                    theLead.Country='France';
                    if(thisRecord.LOCALISATIONS!= null && thisRecord.LOCALISATIONS.size()>=1)
                    {
                        for(WS02_Explore_MarchePublic.LOCALISATIONS thisLocalisation: thisRecord.LOCALISATIONS)
                        {
                            if(theLead.Localisation__c==null)
                            {
                                theLead.Localisation__c=thisLocalisation.DEPARTEMENT_LIB;
                            }
                            else if(!theLead.Localisation__c.contains(thisLocalisation.DEPARTEMENT_LIB))
                            {
                                theLead.Localisation__c+=';'+thisLocalisation.DEPARTEMENT_LIB;
                            }
                        }
                        theLead.City=thisRecord.LOCALISATIONS[0].COMMUNE;
                        theLead.PostalCode=thisRecord.LOCALISATIONS[0].CODE_POSTAL;
                        theLead.Street=thisRecord.LOCALISATIONS[0].ADRESSE1 + ' ' + thisRecord.LOCALISATIONS[0].ADRESSE2;
                        
                    }
                    //a ajouter les champs que PJ doit cree dans SF
                    theLead.Tech_IdentifiantExplore__c=thisRecord.IDENTIFIANT;//a ajouter apres l'owner Id
                    theLead.Tech_IdentifiantMarcheOPublicExplore__c=thisRecord.CLE_MARCHE_PUBLIC_EXPLORE;
                    theLead.Tech_Unique__c=thisRecord.CLE_MARCHE_PUBLIC_EXPLORE;
                    //update du champ owner Id selon les regles
                    theLead.RecordTypeId=Label.Lead_RT_PromotionEtMarche;
                    if(theLead.Localisation__c=='France')
                    {
                        theLead.OwnerId=PisteNationaleId;
                    }
                    else
                    {
                        List<String> ThisLeadCollabolateurEmailsList=thisRecord.EMAIL_COLLABORATEUR;
                        if(ThisLeadCollabolateurEmailsList!= null && ThisLeadCollabolateurEmailsList.size()>0)
                        {
                            Set<String> ThisLeadCollabolateurEmails=new Set<String>(ThisLeadCollabolateurEmailsList);
                            List<User> thisLeadDacUsers=new List<User>();
                            for(User thisUser:DACUsers)
                            {
                                if(ThisLeadCollabolateurEmails.contains(thisUser.Email))
                                {
                                    thisLeadDacUsers.add(thisUser);
                                }
                            }
                            
                            if(thisLeadDacUsers!= null && thisLeadDacUsers.size()>0)
                            {
                                if(thisLeadDacUsers.size()==1)
                                {
                                    //assign lead to the only user in the list
                                    theLead.OwnerId=thisLeadDacUsers[0].Id;
                                }
                                else
                                {
                                    //assign to queue "Multi Affectation"
                                    theLead.OwnerId=MultiAffectationId;
                                }
                            }
                            else
                            {
                                //assign to queue "Sans Affectation"
                                theLead.OwnerId=SansAffectationId;
                            }
                        }
                        else
                        {
                            //assign to queue "Sans Affectation"
                            theLead.OwnerId=SansAffectationId;
                        }
                    }
                    if (theLead.SegmentClient__c == null) {
                        //theLead.SegmentClient__c = 'Indéfini';
                        theLead.SegmentClient__c = 'SCL99';
                    }
                    if(MapMarcheNiveau.containsKey(thisRecord.CLE_MARCHE_PUBLIC_EXPLORE))
                    {
                        MapMarcheNiveau.put(thisRecord.CLE_MARCHE_PUBLIC_EXPLORE,MapMarcheNiveau.get(thisRecord.CLE_MARCHE_PUBLIC_EXPLORE)+1);
                    }
                    else
                    {
                        MapMarcheNiveau.put(thisRecord.CLE_MARCHE_PUBLIC_EXPLORE, 1);
                    }
                    
                    if(!MapNiveauLeads.containsKey(MapMarcheNiveau.get(thisRecord.CLE_MARCHE_PUBLIC_EXPLORE))){
                        MapNiveauLeads.put(MapMarcheNiveau.get(thisRecord.CLE_MARCHE_PUBLIC_EXPLORE), new list<Lead>());
                    }
                    MapNiveauLeads.get(MapMarcheNiveau.get(thisRecord.CLE_MARCHE_PUBLIC_EXPLORE)).add(theLead);
                    
                }
                
            }
        }
        catch(Exception e)
        {
            if(mywrapper.Log!=null)
            {
                mywrapper.Log.ErrorText__c = e.getStackTraceString() + ' // ' + e.getMessage();
            }
        }
        finally
        {
            if(mywrapper.Log!=null)
            {
                mywrapper.Log.Flux__c = 'sortant';
                Logslist.add(mywrapper.Log);
            }
        }
        
        system.debug('###MapNiveauLeads' + MapNiveauLeads);
        return MapNiveauLeads;
    }
    
     /*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-Technologies
Description: this function calls the webservice using the function DoCalloutPromotion in the class WS03_Explore_Promotion ,
              then uses the response of the webservice to create leads whose potential type (TypePotentiel__c) is 'Projet des promoteurs' and return the list of leads
Inputs: String SansAffectationId, String MultiAffectationId,String PisteNationaleId
Returns: List of leads
----------------------------------------------------------------------------------------------------------------------------*/
    public static List<Lead> CallExplorePromotion(String SansAffectationId, String MultiAffectationId,String PisteNationaleId)
    {
        system.debug('in promotion');
        List<Lead>ListLeadForUpsert= new List<Lead>();
        
        WS03_Explore_Promotion.WS_Wrapper mywrapper =WS03_Explore_Promotion.DoCalloutPromotion();
        WS03_Explore_Promotion.RootObject TheRoot=mywrapper.RootObj;
        
        try
        {
            if(TheRoot!= null)
            {
                List<String> CollabolateurEmails= new List<String>();
                List<User> DACUsers= new List<User>();
                for(WS03_Explore_Promotion.Records thisRecord:TheRoot.records)
                {   
                    if(thisRecord.EMAIL_COLLABORATEUR != null)
                        CollabolateurEmails.addAll(thisRecord.EMAIL_COLLABORATEUR);                
                }
                DACUsers=[SELECT id, Name, ProfileId, Email
                          FROM User
                          WHERE ProfileId=:Label.AgenceCommercialProfileId and IsActive=true and Email in:CollabolateurEmails];
                for(WS03_Explore_Promotion.Records thisRecord:TheRoot.records)
                {         
                    WS_endpoint__c myWs = WS_endpoint__c.getInstance('Explore Projet des promoteurs');
                    Lead theLead= new Lead();
                    theLead.Reference_explore__c=thisRecord.IDENTIFIANT_EXPLORE;
                    theLead.Lien_Explore__c=myWs.Lien_explore__c+thisRecord.IDENTIFIANT+'&CleClient='+ myWs.Cle_Client__c;
                    if(thisRecord.TITRE!= null)
                    {
                        if(thisRecord.TITRE.length()>255)
                            theLead.Titre__c=(thisRecord.TITRE).substring(0, 255);
                        else
                            theLead.Titre__c=thisRecord.TITRE;
                    }
                    WS03_Explore_Promotion.CONTACTS TheLeadContact=new WS03_Explore_Promotion.CONTACTS();
                    
                    if(thisRecord.CONTACTS!= null && thisRecord.CONTACTS.size()>=1)
                    {
                        TheLeadContact=thisRecord.CONTACTS[0];
                        for(WS03_Explore_Promotion.SOCIETES thissociete: thisRecord.SOCIETES)
                        {
                            if(thissociete.ROLE=='Maitre d\'ouvrage' && thissociete.SIRET==TheLeadContact.SIRET)
                            {
                                if(thissociete.SIRET!= null)
                                    theLead.SIRET__c=thissociete.SIRET;
                                if(thissociete.TEFEN!= 'NN' && thissociete.TEFEN!=null &&thissociete.TEFEN!='' )//ajouter pour tous les WS TEFEN
                                    theLead.Effectif__c=thissociete.TEFEN;
                                theLead.Company=thissociete.RAISON_SOCIALE;
                                theLead.Raison_sociale__c =thissociete.RAISON_SOCIALE;
                                theLead.Tech_IdentifiantSocieteExplore__c=thissociete.IDENTIFIANT_SOCIETE_EXPLORE;
                                
                                if(thissociete.CODE_NAF!= null && thissociete.CODE_NAF<>'')
                                {
                                    theLead.CodeNAFPotentiel__c=thissociete.CODE_NAF;
                                    //Mapping_Segment_Client__c ThisMap=Mapping_Segment_Client__c.getInstance(thissociete.CODE_NAF.substring(0,2));
                                    CodeActiviteLocalSegment__c ThisMap=CodeActiviteLocalSegment__c.getInstance(thissociete.CODE_NAF);
                                    if(ThisMap != null)
                                    {
                                        //theLead.SegmentClient__c=ThisMap.Segment_Client__c;
                                        //theLead.SousSegmentClient__c=ThisMap.Sous_Segment_Client__c;
                                        // PJB 17/04/2019
                                        theLead.SegmentClient__c=ThisMap.Segment__c;
                                        theLead.SousSegmentClient__c=ThisMap.SousSegment__c;
                                    }
                                }
                                break;
                            }
                        }
                        for(WS03_Explore_Promotion.SOCIETES thissociete: thisRecord.SOCIETES)
                        {
                            if(thissociete.ROLE=='Architecte')
                            {
                                theLead.Architecte__c=thissociete.RAISON_SOCIALE;
                                break;
                            }
                        }
                        
                        theLead.LastName=TheLeadContact.NOM_CONTACT;
                        theLead.Phone=TheLeadContact.LIGNE_DIRECTE;
                        theLead.Email=TheLeadContact.MAIL;
                        theLead.Salutation=TheLeadContact.CIVILITE_CONTACT;
                    }
                    if(theLead.LastName==null || theLead.LastName=='')
                    {
                        theLead.LastName='Non disponible';
                    }
                    theLead.EcheanceMarche__c=date.valueOf(thisRecord.DATE_ECHEANCE.substring(0, (thisRecord.DATE_ECHEANCE).length() - 9));
                    theLead.Date_de_parution__c=date.valueOf(thisRecord.DATE_DETECTION.substring(0, (thisRecord.DATE_DETECTION).length() - 9));
                    //theLead.Surface_terrain__c=Decimal.valueOf((thisRecord.SURFACE.substring(0, (thisRecord.SURFACE).length() - 3)).replaceAll( '\\s+', ''));
                    theLead.Surface_terrain__c=thisRecord.SURFACE.substring(0, (thisRecord.SURFACE).length() - 3).replaceAll( '\\s+', '');
                    theLead.LeadSource='Explore';
                    theLead.TypePotentiel__c='Projet des promoteurs';
                    
                    theLead.Country='France';
                    if(thisRecord.LOCALISATIONS_GEOGRAPHIQUES!= null && thisRecord.LOCALISATIONS_GEOGRAPHIQUES.size()>=1)
                    {
                        for(WS03_Explore_Promotion.LOCALISATIONS_GEOGRAPHIQUES thisLocalisation: thisRecord.LOCALISATIONS_GEOGRAPHIQUES)
                        {
                            if(theLead.Localisation__c==null)
                            {
                                theLead.Localisation__c=thisLocalisation.DEPARTEMENT_LIB;
                            }
                            else if(!theLead.Localisation__c.contains(thisLocalisation.DEPARTEMENT_LIB))
                            {
                                theLead.Localisation__c+=';'+thisLocalisation.DEPARTEMENT_LIB;
                            }
                        }
                        theLead.City=thisRecord.LOCALISATIONS_GEOGRAPHIQUES[0].COMMUNE;
                        theLead.PostalCode=thisRecord.LOCALISATIONS_GEOGRAPHIQUES[0].CODE_POSTAL;
                        theLead.Street=thisRecord.LOCALISATIONS_GEOGRAPHIQUES[0].ADRESSE1 + ' ' + thisRecord.LOCALISATIONS_GEOGRAPHIQUES[0].ADRESSE2;
                        //theLead.Adresse_1_du_lieu_dexecution__c=thisRecord.LOCALISATIONS_GEOGRAPHIQUES[0].DEPARTEMENT_LIB;
                    }
                    //a ajouter les champs que PJ doit cree dans SF
                    theLead.Tech_IdentifiantExplore__c=thisRecord.IDENTIFIANT;//a ajouter apres l'owner Id
                    theLead.Tech_Unique__c=thisRecord.IDENTIFIANT_EXPLORE;
                    if(thisRecord.COMMENTAIRE != null)
                    {
                        if((thisRecord.COMMENTAIRE).length()>255)
                        {
                            theLead.Descriptif__c=(thisRecord.COMMENTAIRE).substring(0, 255);
                        }
                        else
                        {
                            theLead.Descriptif__c=thisRecord.COMMENTAIRE;
                        }
                    }
                    theLead.RecordTypeId=Label.Lead_RT_PromotionEtMarche;
                    //update du champ owner Id selon les regles
                    if(theLead.Localisation__c=='France')
                    {
                        theLead.OwnerId=PisteNationaleId;
                    }
                    else
                    {
                        List<String> ThisLeadCollabolateurEmailsList=thisRecord.EMAIL_COLLABORATEUR;
                        if(ThisLeadCollabolateurEmailsList!= null && ThisLeadCollabolateurEmailsList.size()>0)
                        {
                            Set<String> ThisLeadCollabolateurEmails=new Set<String>(ThisLeadCollabolateurEmailsList);
                            List<User> thisLeadDacUsers=new List<User>();
                            for(User thisUser:DACUsers)
                            {
                                if(ThisLeadCollabolateurEmails.contains(thisUser.Email))
                                {
                                    thisLeadDacUsers.add(thisUser);
                                }
                            }
                            
                            if(thisLeadDacUsers!= null && thisLeadDacUsers.size()>0)
                            {
                                if(thisLeadDacUsers.size()==1)
                                {
                                    //assign lead to the only user in the list
                                    theLead.OwnerId=thisLeadDacUsers[0].Id;
                                }
                                else
                                {
                                    //assign to queue "Multi Affectation"
                                    theLead.OwnerId=MultiAffectationId;
                                }
                            }
                            else
                            {
                                //assign to queue "Sans Affectation"
                                theLead.OwnerId=SansAffectationId;
                            }
                        }
                        else
                        {
                            //assign to queue "Sans Affectation"
                            theLead.OwnerId=SansAffectationId;
                        }
                    }
                    if (theLead.SegmentClient__c == null) {
                        //theLead.SegmentClient__c = 'Indéfini';
                        theLead.SegmentClient__c = 'SCL99';
                    }
                    ListLeadForUpsert.add(theLead);          
                }
                system.debug('###ListLeadForUpsert' + ListLeadForUpsert);
                //upsert ListLeadForUpsert Tech_IdentifiantExplore__c;
            }
        }
        catch(Exception e)
        {
            if(mywrapper.Log!=null)
            {
                mywrapper.Log.ErrorText__c = e.getStackTraceString() + ' // ' + e.getMessage();
                
            }
        }
        finally
        {
            if(mywrapper.Log!=null)
            {
                mywrapper.Log.Flux__c = 'sortant';
                Logslist.add(mywrapper.Log);
            }
        }
        return ListLeadForUpsert;
    }
    
     /*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-Technologies
Description:  this function calls the webservice using the function DoCalloutMouvement in the class WS04_Explore_Mouvements ,
              then uses the response of the webservice to create leads whose potential type (TypePotentiel__c) is 'Mouvement des utilisateurs' and return the list of leads
Inputs: String SansAffectationId, String MultiAffectationId,String PisteNationaleId
Returns: List of Lead
----------------------------------------------------------------------------------------------------------------------------*/
    public static List<Lead> CallExploreMouvement(String SansAffectationId, String MultiAffectationId,String PisteNationaleId)
    {
        system.debug('in Mouvement');
        List<Lead>ListLeadForUpsert= new List<Lead>();
        WS04_Explore_Mouvements.WS_Wrapper mywrapper=WS04_Explore_Mouvements.DoCalloutMouvement();
        WS04_Explore_Mouvements.RootObject TheRoot=mywrapper.RootObj;

        try
        {
            if(TheRoot!= null)
            {
                List<String> CollabolateurEmails= new List<String>();
                List<User> DACUsers= new List<User>();
                for(WS04_Explore_Mouvements.Records thisRecord:TheRoot.records)
                {
                    if(thisRecord.EMAIL_COLLABORATEUR != null)
                        CollabolateurEmails.addAll(thisRecord.EMAIL_COLLABORATEUR);                
                }
                DACUsers=[SELECT id, Name, ProfileId, Email
                          FROM User
                          WHERE ProfileId=:Label.AgenceCommercialProfileId and IsActive=true and Email in:CollabolateurEmails];
                for(WS04_Explore_Mouvements.Records thisRecord:TheRoot.records)
                {          
                    WS_endpoint__c myWs = WS_endpoint__c.getInstance('Explore Mouvements utilisateurs');
                    Lead theLead= new Lead();
                    theLead.Reference_explore__c=thisRecord.IDENTIFIANT_EXPLORE;
                    theLead.Lien_Explore__c=myWs.Lien_explore__c+thisRecord.IDENTIFIANT+'&CleClient='+ myWs.Cle_Client__c;
                    if(thisRecord.TITRE!= null)
                    {
                        if(thisRecord.TITRE.length()>255)
                            theLead.Titre__c=(thisRecord.TITRE).substring(0, 255);
                        else
                            theLead.Titre__c=thisRecord.TITRE;
                    }
                    WS04_Explore_Mouvements.CONTACTS TheLeadContact=new WS04_Explore_Mouvements.CONTACTS();
                    if(thisRecord.CONTACTS!= null)
                    {
                        TheLeadContact=thisRecord.CONTACTS[0];
                        for(WS04_Explore_Mouvements.SOCIETES thissociete: thisRecord.SOCIETES)
                        {
                            if(thissociete.ROLE=='Maitre d\'ouvrage' && thissociete.SIRET==TheLeadContact.SIRET)
                            {
                                if(thissociete.SIRET!= null)
                                    theLead.SIRET__c=thissociete.SIRET;
                                theLead.Tech_IdentifiantSocieteExplore__c=thissociete.IDENTIFIANT_SOCIETE_EXPLORE;
                                theLead.Company=thissociete.RAISON_SOCIALE;
                                theLead.Raison_sociale__c =thissociete.RAISON_SOCIALE;
                                system.debug('%%%thissociete.CODE_NAF ' + thissociete.CODE_NAF);
                                if(thissociete.CODE_NAF!= null && thissociete.CODE_NAF<>'')
                                {
                                    theLead.CodeNAFPotentiel__c=thissociete.CODE_NAF;
                                    //Mapping_Segment_Client__c ThisMap=Mapping_Segment_Client__c.getInstance(thissociete.CODE_NAF.substring(0,2));
                                    CodeActiviteLocalSegment__c ThisMap=CodeActiviteLocalSegment__c.getInstance(thissociete.CODE_NAF);
                                    if(ThisMap != null)
                                    {
                                        //theLead.SegmentClient__c=ThisMap.Segment_Client__c;
                                        //theLead.SousSegmentClient__c=ThisMap.Sous_Segment_Client__c;
                                        // PJB 17/04/2019
                                        theLead.SegmentClient__c=ThisMap.Segment__c;
                                        theLead.SousSegmentClient__c=ThisMap.SousSegment__c;
                                    }
                                }
                                break;
                            }
                        }
                        for(WS04_Explore_Mouvements.SOCIETES thissociete: thisRecord.SOCIETES)
                        {
                            if(thissociete.ROLE=='Architecte')
                            {
                                theLead.Architecte__c=thissociete.RAISON_SOCIALE;
                                break;
                            }
                        }
                        
                        //theLead.Title=TheLeadContact.CIVILITE_CONTACT;
                        theLead.LastName=TheLeadContact.NOM_CONTACT;
                        theLead.Phone=TheLeadContact.LIGNE_DIRECTE;
                        theLead.Email=TheLeadContact.MAIL;
                        theLead.Salutation=TheLeadContact.CIVILITE_CONTACT;
                        
                    }
                    else
                    {
                        theLead.LastName='Non disponible';
                    }
                    //theLead.Surface_terrain__c=Decimal.valueOf((thisRecord.SURFACE.substring(0, (thisRecord.SURFACE).length() - 3)).replaceAll( '\\s+', ''));
                    theLead.Surface_terrain__c=thisRecord.SURFACE.substring(0, (thisRecord.SURFACE).length() - 3).replaceAll( '\\s+', '');
                    theLead.Nombre_poste__c=thisRecord.NB_POSTES;
                    theLead.Debut_travaux__c=thisRecord.DATE_OUVERTURE_CHANTIER;
                    theLead.Date_de_parution__c=date.valueOf(thisRecord.DATE_DETECTION.substring(0, (thisRecord.DATE_DETECTION).length() - 9));
                    //raison sociale?
                    //CP
                    //Ville
                    //Tel
                    //Identifiant
                    //Identifiant unique explore
                    theLead.LeadSource='Explore';
                    theLead.Nature_du_mouvement__c=thisRecord.TYPE_PROJET;
                    theLead.TypePotentiel__c='Mouvement des utilisateurs';
                    
                    theLead.Country='France';
                    if(thisRecord.LOCALISATIONS_GEOGRAPHIQUES!= null)
                    {
                        for(WS04_Explore_Mouvements.LOCALISATIONS_GEOGRAPHIQUES thisLocalisation: thisRecord.LOCALISATIONS_GEOGRAPHIQUES)
                        {
                            if(theLead.Localisation__c==null)
                            {
                                theLead.Localisation__c=thisLocalisation.DEPARTEMENT_LIB;
                            }
                            else  if(!theLead.Localisation__c.contains(thisLocalisation.DEPARTEMENT_LIB))
                            {
                                theLead.Localisation__c+=';'+thisLocalisation.DEPARTEMENT_LIB;
                            }
                        }
                        theLead.City=thisRecord.LOCALISATIONS_GEOGRAPHIQUES[0].COMMUNE;
                        theLead.PostalCode=thisRecord.LOCALISATIONS_GEOGRAPHIQUES[0].CODE_POSTAL;
                        theLead.Street=thisRecord.LOCALISATIONS_GEOGRAPHIQUES[0].ADRESSE1 + ' ' + thisRecord.LOCALISATIONS_GEOGRAPHIQUES[0].ADRESSE2;
                        //theLead.Adresse_1_du_lieu_dexecution__c=thisRecord.LOCALISATIONS_GEOGRAPHIQUES[0].DEPARTEMENT_LIB;
                    }
                    //a ajouter les champs que PJ doit cree dans SF
                    theLead.Tech_IdentifiantExplore__c=thisRecord.IDENTIFIANT;//a ajouter apres l'owner Id
                    theLead.Tech_Unique__c=thisRecord.IDENTIFIANT_EXPLORE;
                    if(thisRecord.COMMENTAIRE != null)
                    {
                        if((thisRecord.COMMENTAIRE).length()>255)
                        {
                            theLead.Descriptif__c=(thisRecord.COMMENTAIRE).substring(0, 255);
                        }
                        else
                        {
                            theLead.Descriptif__c=thisRecord.COMMENTAIRE;
                        }
                    }
                    theLead.RecordTypeId=Label.Lead_RT_Mouvement;
                    //update du champ owner Id selon les regles
                    if(theLead.Localisation__c=='France')
                    {
                        theLead.OwnerId=PisteNationaleId;
                    }
                    else
                    {
                        List<String> ThisLeadCollabolateurEmailsList=thisRecord.EMAIL_COLLABORATEUR;                    
                        if(ThisLeadCollabolateurEmailsList!= null && ThisLeadCollabolateurEmailsList.size()>0)
                        {
                            Set<String> ThisLeadCollabolateurEmails=new Set<String>(ThisLeadCollabolateurEmailsList);
                            List<User> thisLeadDacUsers=new List<User>();
                            for(User thisUser:DACUsers)
                            {
                                if(ThisLeadCollabolateurEmails.contains(thisUser.Email))
                                {
                                    thisLeadDacUsers.add(thisUser);
                                }
                            }
                            //system.debug('###thisLeadDacUsers' + thisLeadDacUsers);
                            if(thisLeadDacUsers!= null && thisLeadDacUsers.size()>0)
                            {
                                if(thisLeadDacUsers.size()==1)
                                {
                                    //assign lead to the only user in the list
                                    theLead.OwnerId=thisLeadDacUsers[0].Id;
                                }
                                else
                                {
                                    //assign to queue "Multi Affectation"
                                    theLead.OwnerId=MultiAffectationId;
                                }
                            }
                            else
                            {
                                //assign to queue "Sans Affectation"
                                theLead.OwnerId=SansAffectationId;
                            }
                        }
                        else
                        {
                            //assign to queue "Sans Affectation"
                            theLead.OwnerId=SansAffectationId;
                        }
                    }
                    if (theLead.SegmentClient__c == null) {
                        //theLead.SegmentClient__c = 'Indéfini';
                        theLead.SegmentClient__c = 'SCL99';
                    }
                    ListLeadForUpsert.add(theLead);            
                }
                //upsert ListLeadForUpsert Tech_IdentifiantExplore__c;
            }
        }
        catch(Exception e)
        {
            if(mywrapper.Log!=null)
            {
                mywrapper.Log.ErrorText__c = e.getStackTraceString() + ' // ' + e.getMessage();
                
            }
        }
        finally
        {
            if(mywrapper.Log!=null)
            {
                mywrapper.Log.Flux__c = 'sortant';
                Logslist.add(mywrapper.Log);
            }
        }
        system.debug('###ListLeadForUpsert' + ListLeadForUpsert);
        return ListLeadForUpsert;
    }
    
     /*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-Technologies
Description: this function is used to upsert the leads after deserializing the input string
Inputs: string jsonString
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/
    public static void updateLead(string jsonString){
        list<Lead> ListLeadForUpsert =  (list<Lead>)JSON.deserializeStrict(jsonString, list<Lead>.class);
        system.debug('before update');
        for(Lead L : ListLeadForUpsert)
        {
            if (L.LastName == null)
            {
                L.LastName = 'Non disponible'; 
            }
        }
        Database.UpsertResult[] results = Database.upsert(ListLeadForUpsert,Lead.Fields.Tech_Unique__c, false);
        List<String> listStr = new List<String>();
        for(Integer i=0;i<results.size();i++){
            if (!results.get(i).isSuccess()){
                Database.Error err = results.get(i).getErrors().get(0);
                System.debug('Error - '+err.getMessage() + '\nStatus Code : '+err.getStatusCode()+'\n Fields : '+err.getFields() +'\n Unique ID : '+ListLeadForUpsert[i].Tech_Unique__c);
            	listStr.add(ListLeadForUpsert[i].Tech_Unique__c);
            }
        }
        Integer Success = results.size() - listStr.size(); 
       System.debug('Taux de succès... '+Success+' / '+results.size()); 
    }
}