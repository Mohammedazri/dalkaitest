/** 
* @author Dona Kfoury
* @date 04/03/2020 
* @description class containing methods called that block all modifications related 
* @Test Class AP77_ContratFerme_Test
*/
public class AP77_ContratFerme {
    /** 
* @author Dona Kfoury 
* @date 04/03/2020 
* @check if we can delete equipe de contrat related to a contrat or the contrat is ferme
* @param contactList: map of Equipedecontrat__c
* @return void
*/
    public static void checkIfCanDeleteEuipeContrat(map<id,IntervenantSurContrat__c>mapOldMemmbres ){
        set<id> setMembreIds =  mapOldMemmbres.keyset();
        //query to get parent contract status
        List<IntervenantSurContrat__c> listOldMembres =[SELECT id, contrat__c,contrat__r.statut__c
                                                  FROM IntervenantSurContrat__c
                                                  WHERE id in:setMembreIds];
        for(IntervenantSurContrat__c myMembre:listOldMembres){
            if(myMembre.contrat__c != null && myMembre.Contrat__r.statut__c == Label.ContratFerme && mapOldMemmbres.containskey(myMembre.Id)){
                mapOldMemmbres.get(myMembre.Id).addError(label.AP77_ContratFerme);
            }
        }
    }
    
    /** 
* @author Dona Kfoury 
* @date 04/03/2020 
* @check if we can delete Document contractuel related to a contrat or the contrat is ferme
* @param contactList: map of Document_Contractuel__c
* @return void
*/
    public static void checkIfCanDeleteDocumentContractuel( map<id,Document_Contractuel__c>mapOldDocs ){
        set<id> setDocIds =  mapOldDocs.keyset();
        //query to get parent contract status
        List<Document_Contractuel__c> listDocs =[SELECT id, contrat__c,contrat__r.statut__c
                                                 FROM Document_Contractuel__c
                                                 WHERE id in:setDocIds];
        for(Document_Contractuel__c myDoc:listDocs){
            if(myDoc.contrat__c != null && myDoc.Contrat__r.statut__c == Label.ContratFerme && mapOldDocs.containskey(myDoc.Id)){
                mapOldDocs.get(myDoc.Id).addError(label.AP77_ContratFerme);
            }
        }
    }
    /** 
* @author Dona Kfoury 
* @date 04/03/2020 
* @check if we can delete the Ecosystem related to a contrat or the contrat is ferme
* @param contactList: map of EcosystemePartenaire__c
* @return void
*/  
    public static void checkIfCanDeleteEcosystemes( map<id,EcosystemePartenaire__c>mapOldEcos ){
        set<id> setEcoIds =  mapOldEcos.keyset();
        //query to get parent contract status
        List<EcosystemePartenaire__c> listEcos =[SELECT id, contrat__c,contrat__r.statut__c
                                                 FROM EcosystemePartenaire__c
                                                 WHERE id in:setEcoIds];
        for(EcosystemePartenaire__c myEco:listEcos){
            if(myEco.contrat__c != null && myEco.Contrat__r.statut__c == Label.ContratFerme && mapOldEcos.containskey(myEco.Id)){
                mapOldEcos.get(myEco.Id).addError(label.AP77_ContratFerme);
            }
        }
    }
    /** 
* @author Dona Kfoury 
* @date 04/03/2020 
* @check if we can delete the Budget related to a contrat or the contrat is ferme 
* @param contactList: map of Budget__c
* @return void
*/
    public static void checkIfCanDeleteBudgets( map<id,Budget__c>mapOldBudets ){
        set<id> setBudgetsIds =  mapOldBudets.keyset();
        //query to get parent contract status
        List<Budget__c> listBudgets =[SELECT id, NomContrat__c,NomContrat__r.statut__c
                                      FROM Budget__c
                                      WHERE id in:setBudgetsIds];
        for(Budget__c myBudget:listBudgets){
            if(myBudget.NomContrat__c != null && myBudget.NomContrat__r.statut__c == Label.ContratFerme && mapOldBudets.containskey(myBudget.Id)){
                mapOldBudets.get(myBudget.Id).addError(label.AP77_ContratFerme);
            }
        }
    }
    /** 
* @author Dona Kfoury 
* @date 04/03/2020 
* @check we can delete the LienContratTacheFinance related to a contrat or the contrat is ferme
* @param contactList: map of LienContratTacheFinance__c
* @return void
*/ 
    public static void checkIfCanDeleteLienContratTache( map<id,LienContratTacheFinance__c>mapOldLienContratTacheFinance ){
        set<id> setLCTFIds =  mapOldLienContratTacheFinance.keyset();
        //query to get parent contract status
        List<LienContratTacheFinance__c> listLiens =[SELECT id, contrat__c,contrat__r.statut__c
                                                     FROM LienContratTacheFinance__c
                                                     WHERE id in:setLCTFIds];
        for(LienContratTacheFinance__c myLien:listLiens){
            if(myLien.contrat__c != null && myLien.contrat__r.statut__c == Label.ContratFerme && mapOldLienContratTacheFinance.containskey(myLien.Id)){
                mapOldLienContratTacheFinance.get(myLien.Id).addError(label.AP77_ContratFerme);
            }
        }
    }
    /** 
* @author Dona Kfoury 
* @date 04/03/2020 
* @check if we can delete the Opp commerciale or Opp generée related to a contrat or the contrat is ferme
* @param contactList: map of Opportunity
* @return void
*/
    public static void checkIfCanDeleteOpportunity( map<id,Opportunity>mapOldOpp ){
        set<id> setOppIds =  mapOldOpp.keyset();
        //query to get parent contract status
        List<Opportunity> listOpps =[SELECT id, ContratOrigine__c,ContratOrigine__r.statut__c,Contrat_Genere_lookup__c , Contrat_Genere_lookup__r.DKCodeSurContrat__c
                                     FROM Opportunity
                                     WHERE id in:setOppIds];
        for(Opportunity myOpp:listOpps){
            if((myOpp.ContratOrigine__c != null && myOpp.ContratOrigine__r.statut__c == Label.ContratFerme && mapOldOpp.containskey(myOpp.Id))
               || (myOpp.Contrat_Genere_lookup__c!=null && myOpp.Contrat_Genere_lookup__r.DKCodeSurContrat__c<>null && mapOldOpp.containskey(myOpp.Id))){
                   mapOldOpp.get(myOpp.Id).addError(label.AP77_ContratFerme);
               }
        }
    }
    /** 
* @author Jacques Akiki 
* @date 04/03/2020 
* @check if Files and Notes related to a contrat can be deleted or the contrat is ferme
* @param contactList: map of ContentDocument
* @return void
*/
    public static void checkIfCanDeleteFile(map<id,ContentDocument>mapOldCD)
    {
        map<id,List<id>> mapLinkedIdCdl = new map<id,List<id>>();
        List<ContentDocumentLink> listCDL = [SELECT id,LinkedEntityId, LinkedEntity.Type, contentDocumentId FROM contentDocumentLink WHERE ContentDocumentId in:mapOldCD.keyset()];
        
        for(ContentDocumentLink cdl :listCDL)
        {
            if(cdl.LinkedEntity.Type =='Contrat__c')
            {
                if(!mapLinkedIdCdl.containsKey(cdl.LinkedEntityId))
                {
                    mapLinkedIdCdl.put(cdl.LinkedEntityId,new list<id>());
                }
                mapLinkedIdCdl.get(cdl.LinkedEntityId).add(cdl.contentDocumentId);
            }
        }
        addError(mapOldCD,null,mapLinkedIdCdl);
    }
    /** 
* @author Jacques Akiki 
* @date 04/03/2020 
* @check if Files and Notes related to a contrat can be created or the contrat is ferme
* @param contactList: map of ContentDocumentLink
* @return void
*/
    public static void checkIfCanCreateFile(map<id,ContentDocumentLink> mapidcdl)
    {
        map<id,List<id>> mapContFiles = new Map<id,List<id>>();
        
        for(ContentDocumentLink cdl : mapidcdl.values())
        {
            if(String.valueOf(mapidcdl.get(cdl.id).LinkedEntityId).left(3)=='a03')
            {
                if(!mapContFiles.containsKey(cdl.linkedEntityId))
                {
                    mapContFiles.put(cdl.linkedEntityId,new list<id>());
                }
                mapContFiles.get(cdl.linkedEntityId).add(cdl.id);
            }
        }
        addError(null,mapidcdl,mapContFiles);
    }
    /** 
* @author Jacques Akiki 
* @date 04/03/2020 
* @check if Files and Notes related to a contrat can be Edited or the contrat is ferme
* @param contactList: map of ContentDocument of old or new contrat
* @return void
*/
    public static void checkIfCanEditFileNote (map<id,ContentVersion> mapidCV)
    {
        map<id,id> mapcdidcvid = new map<id,id>();
        for(ContentVersion cv:mapidCV.values())
        {
            mapcdidcvid.put(cv.contentDocumentId,cv.id);
        }
        List<ContentDocumentLink> listCDL = [SELECT id,LinkedEntityId, LinkedEntity.Type, contentDocumentId FROM contentDocumentLink WHERE ContentDocumentId in:mapcdidcvid.keyset()];
        map<id,List<id>> mapContFiles = new Map<id,List<id>>();
        for(ContentDocumentLink cdl : listcdl)
        {
            if(cdl.linkedEntity.Type=='Contrat__c')
            {
                if(!mapContFiles.containsKey(cdl.linkedEntityId))
                {
                    mapContFiles.put(cdl.linkedEntityId,new list<id>());
                }
                mapContFiles.get(cdl.linkedEntityId).add(mapcdidcvid.get(cdl.contentDocumentId));
            }
        }
        addError(mapidCV,null,mapContFiles);
        
    }
    /** 
* @author Jacques Akiki 
* @date 04/03/2020 
* @check if Files and Notes related to a contrat can be Related to other Objects or the contrat is ferme
* @param contactList: map of ContentDocument of old or new contrat
* @return void
*/
    public static void checkIfCanEditFileNoteLink (map<id,ContentDocumentLink> mapidCD,map<id,ContentDocumentLink> mapidCDOld)
    {
        Map<id,List<id>> MapContIdDocId = new map<id,List<id>>();
        for(id cdlId : mapidCD.Keyset())
        { 
            if(String.valueOf(mapidCD.get(cdlId).LinkedEntityId).left(3)=='a03') 
            {
                if(!MapContIdDocId.containskey(mapidCD.get(cdlId).LinkedEntityId))
                {
                    MapContIdDocId.put(mapidCD.get(cdlId).LinkedEntityId,new list<id>());
                }
                MapContIdDocId.get(mapidCD.get(cdlId).LinkedEntityId).add(cdlId);
                
            }
            if(String.valueOf(mapidCDOld.get(cdlId).LinkedEntityId).left(3)=='a03')
            {
                if(!MapContIdDocId.containskey(mapidCDOld.get(cdlId).LinkedEntityId))
                {
                    MapContIdDocId.put(mapidCDOld.get(cdlId).LinkedEntityId,new List<id>());
                }
                MapContIdDocId.get(mapidCDOld.get(cdlId).LinkedEntityId).add(cdlId);
                
            }
        }
        addError(null,mapidCD,MapContIdDocId);
    }
    /** 
* @author Jacques Akiki 
* @date 06/03/2020 
* @technical function to add error on documents
* @param 3 maps
* @return void
*/ 
    private static void addError (map<id,SObject> mapidCD , map<id,contentDocumentLink> mapidCDL , Map<id,List<id>> MapContIdDocId)
    {
        if (MapContIdDocId<>NULL && MapContIdDocId.keyset().size()>0)
        {
            list<Contrat__c> listCont = [SELECT id,Statut__c FROM Contrat__c WHERE id in:MapContIdDocId.keyset() AND Statut__c =:Label.ContratFerme];
            for(Contrat__c cont : listCont)
            {
                for(id docId:MapContIdDocId.get(cont.id))
                {
                    if(mapidCD!=null && mapidCD.containskey(docId))
                    {
                        mapidCD.get(docId).addError(label.AP77_ContratFerme);
                    }
                    else if(mapidCDL!=null && mapidCDL.containskey(docId))
                    {
                        mapidCDL.get(docId).addError(label.AP77_ContratFerme);
                    }
                }
            }
        }
    }
    /** 
* @author Jacques Akiki 
* @date 11/06/2020 
* @check if Files and Notes related to a contrat can be Related to other Objects or the contrat is ferme
* @param mapOldContratContact: map of ContratContact__c that are being deleted
* @return void
*/  
    public static void checkIfCanDeleteContactContrat (map<id,ContratContact__c>mapOldContratContact)
    {
        set<id> setMembreIds =  mapOldContratContact.keyset();
        //query to get parent contract status
        List<ContratContact__c> listOldCC =[SELECT id, contrat__c,contrat__r.statut__c
                                            FROM ContratContact__c
                                            WHERE id in:setMembreIds];
        for(ContratContact__c cc:listOldCC)
        {
            if(cc.contrat__c != null && cc.Contrat__r.statut__c == Label.ContratFerme && mapOldContratContact.containskey(cc.Id))
            {
                mapOldContratContact.get(cc.Id).addError(label.AP77_ContratFerme);
            }
        }
    }
}