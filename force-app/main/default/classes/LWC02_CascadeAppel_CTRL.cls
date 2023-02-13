/**
 * @author Salah Mansour Akridiss
 * @email salah.akridiss@ei-technologies.com
 * @create date 2022-04-14
 * @modify -
 * @desc Contrôleur du Lightning Web Component qui permet de récupérer les consignes via appel du WS ou consignes manuels en plus de la mise à jour des données.
 */
public with sharing class LWC02_CascadeAppel_CTRL {

    // Map permettant de mapper le RecordType.DeveloperName avec les valeurs attendues par le service web
    static final Map<String, String> TRANSCODAGE_RECORDTYPE = new Map<String, String>{'Demande_de_STI' => 'sti',
                                                                                      'Demande_de_depannage' => 'incidentAlarme',
                                                                                     'Demande_d_encadrement' => 'encadrement'};                                       

    static final Id RT_ConsigneAuto = Schema.SObjectType.Consigne__c.getRecordTypeInfosByDeveloperName()
                            .get('Consignes_Automatique').getRecordTypeId();
        
    static final Id RT_ConsigneManuelle = Schema.SObjectType.Consigne__c.getRecordTypeInfosByDeveloperName()
                            .get('Consignes_Manuelle').getRecordTypeId();
    
    /**
     * @description Methode qui permet récupérer une liste de consignes via recordId (recordId représente ID d'une Case)
     * @param recordId 
     * @return  List<Consigne__c>
     */                                                                  
    static List<Consigne__c> getConsignes(String recordId) {
        return [SELECT Id, Demande__c, Nom_du_technicien__c, toLabel(TypeRessource__c), IdSIA__c, RecordType.DeveloperName, Delai__c, N_ordre__c, Numero_de_telephone__c, Matricule__c, Reponse__c, estHistorique__c, Urgence__c
                FROM Consigne__c 
                WHERE Demande__c = :recordId 
                AND ((Reponse__c = 'Non Contacté' AND RecordTypeId = :RT_ConsigneManuelle)
                         OR (estHistorique__c = false AND RecordTypeId = :RT_ConsigneAuto AND Reponse__c = 'Non Contacté'))
                    ORDER BY N_ordre__c asc NULLS LAST];
    }

    /**
     * @description Methode qui permet de savoir si on affiche ou non le bouton qui permet de faire un call à la cascade d'appel
     * @param recordId 
     * @return         Boolean
     */
    @testVisible
    static Boolean showButtonCascade(String recordId) {
        Case demande = getDemande(recordId);
        Map<String, String> mapStatusName = new Map<String, String> {'A filtrer' => 'A filtrer','Attribuée' => 'Attribuée', 'Clôturée' => 'Clôturée'};
                
        if(mapStatusName.get(demande?.Status) != null)
            return false;
        
        if(demande?.OwnerId.getSObjectType() == Group.SObjectType) {
            // List<Group> listQueues = [SELECT Id, DeveloperName FROM Group WHERE Id = :demande.OwnerId AND DeveloperName = 'FDA_CRC'];
            // if(!listQueues.isEmpty())
            return false;
        }

        return true;
    }

    /***    
     * @description Methode qui permet de récupérer la Layout des Consignes Manuelles
     * @param 
     * @return               String
     */
    @AuraEnabled(cacheable=true)
    public static String getLayoutMetadata(){
        String objectName = 'Consigne__c';
        String layout = 'Présentation Consigne Manuelle';

        string layoutName = String.format('{0}-{1}', new String[]{objectName, layout});
        List<Metadata.Metadata> layouts = Metadata.Operations.retrieve(Metadata.MetadataType.Layout, new List<String> {layoutName});
        Metadata.Layout layoutMd = (Metadata.Layout)layouts.get(0);
        return JSON.serialize(layoutMd);    
    }
    

    /***    
     * @description Methode qui permet de recupérer liste des consignes automatiques à mettre en Historique d'une demande donnée
     * @param 
     * @return               List<Consigne__c>
     */
    static List<Consigne__c> resetConsignesAutomatique(String recordId) {
        List<Consigne__c> listeConsignes = [SELECT Id, estHistorique__c, Reponse__c, Urgence__c FROM Consigne__c WHERE Demande__c = :recordId 
                                                                                                        AND estHistorique__c = false 
                                                                                                        AND RecordTypeId = :RT_ConsigneAuto];
        for (Consigne__c consigne : listeConsignes) {
            consigne.estHistorique__c = true;
        }

        return listeConsignes;
    }
    
    /***    
     * @description Methode qui permet de sauvgarder les modifications apportées sur le Lightning Web Component
     * @param listeConsignes 
     * @return               Boolean
     */
    @AuraEnabled
    public static Boolean saveConsignes(List<Consigne__c> listeConsignes){
        Map<Id, Consigne__c> mapConsignes = new Map<Id, Consigne__c>(listeConsignes);
        Consigne__c consigne = new Consigne__c();
        boolean saved = false;

        if (!mapConsignes.isEmpty()) {
            system.debug('save Consignes :' +mapConsignes);
            for (consigne__c c : mapConsignes.values()) { 
               if (c.Reponse__c == 'Différé') {
                   break;
                }
              else
                try{
                   update mapConsignes.values();
                    saved = true;
                } catch(Exception e){
                    throw e;
                }
         }  
        }

        return saved;
    }
    
    @AuraEnabled
    public static Boolean saveConsignesForDiffere(List<Consigne__c> listeConsignes){
        Map<Id, Consigne__c> mapConsignes = new Map<Id, Consigne__c>(listeConsignes);
        Consigne__c consigne = new Consigne__c();
        boolean saved = false;

        if (!mapConsignes.isEmpty()) {

            for (consigne__c c : mapConsignes.values()) { 

               if (c.Reponse__c == 'Différé' && c.Urgence__c != 'Très urgent') {

                try{
                   update mapConsignes.values();
                    saved = true;
                } catch(Exception e){
                    throw e;
                }
         }  
        }
      }
        return saved;
    
  }
    /**
     * @description Methode qui permet de recupérer les champs d'une demande
     * @param recordId 
     * @return         Case
     */
    @testVisible
    static Case getDemande(String recordId) {
        return [SELECT Id, RecordType.DeveloperName, Technicien__c, Emplacement__c, Emplacement__r.DKCode_Emplacement__c, Status, OwnerId FROM Case WHERE Id = :recordId]; 
    }

    /**
     * @description Methode qui permet de renseigner le champ User sur Consigne si celui-ci est trouvé
     * @param mapDKConsignes (DKCode => Consigne)
     * @return               List<Consigne__c>
     */
    @testVisible
    static List<Consigne__c> getConsigneUsers(Map<String, List<Consigne__c>> mapDKConsignes) {
        List<User> listUsers = new List<User>();
        List<Consigne__c> returnedConsignes = new List<Consigne__c>();
        listUsers = [SELECT Id, Name, DkCode__c FROM User WHERE DkCode__c IN :mapDKConsignes.KeySet()];
        if(!listUsers.isEmpty()) {
            for(User user : listUsers) {
                List<Consigne__c> listeConsignes = mapDKConsignes.get(user.DkCode__c);
                for (Consigne__c tempConsigne : listeConsignes) {
                    tempConsigne.User__c = user.Id;
                    tempConsigne.Nom_du_technicien__c = user.Name;
                    returnedConsignes.add(tempConsigne);
                }
            }
        }
        return returnedConsignes;
    }

    /**
     * @description Methode qui permet d'avoir tous les IdSIA d'une demande
     * @param List<Consigne__c> 
     * @return         List<String>
     */
    static List<String> getIdSIAs(List<Consigne__c> listConsignes) {
        Set<String> setIdSIAs = new Set<String>();

        if(!listConsignes.isEmpty()) {
            for (Consigne__c consigne : listConsignes) {
                setIdSIAs.add(consigne.IdSIA__c);
            }
        }
        return new List<String>(setIdSIAs);
    }

    /**
     * @description Methode qui permet d'appeler le WebService AP115_Consigne et créer les consignes retournées
     * @param recordId 
     * @return         Boolean
     */
    @AuraEnabled
    public static Boolean callWebServiceCascadeAppel(String recordId){
        List<Consigne__c> listeConsignes = new List<Consigne__c>();
        Case demande = getDemande(recordId);
        Boolean saved = false;

        if(demande != null) {
            String typeDemande = TRANSCODAGE_RECORDTYPE.get(demande.RecordType.DeveloperName);
            String dateDemande = String.ValueOf(System.Now().format('yyyy-MM-dd\'T\'HH:mm:ss'));
            String site = demande.Emplacement__c != null ? demande.Emplacement__r.DKCode_Emplacement__c : null;

            if(Test.isRunningTest()) {
                dateDemande = 'testDate';
                site = 'DKSource';
                typeDemande = 'sti';
            }
            
            AP115_Consigne.ConsigneWrapper webServiceConsignes = (typeDemande == null || dateDemande == null || site == null) ? null : AP115_Consigne.calloutConsigne(dateDemande, site, typeDemande);
            if(webServiceConsignes?.consignes != null) {
                
                Boolean planificateur = webServiceConsignes.presencePlanificateur;
                Map<String, List<Consigne__c>> mapDKConsignes = new Map<String, List<Consigne__c>>();

                for(AP115_Consigne.cls_consignes consigne : webServiceConsignes.consignes) {
                    String typeRessource;
                    if(consigne.typeRessource == null) {
                        typeRessource = planificateur ? 'P' : null;
                    } else {
                        typeRessource = String.ValueOf(consigne.typeRessource);
                    }

                    Consigne__c tempConsigne = new Consigne__c();
                        tempConsigne.IdSIA__c = consigne.idSIA;
                        tempConsigne.N_ordre__c = consigne.numero;
                        tempConsigne.Matricule__c = consigne.matricule;
                        tempConsigne.Delai__c = consigne.delai;
                        tempConsigne.TypeRessource__c = typeRessource;
                        tempConsigne.Numero_de_telephone__c = consigne.numeroAppel;
                        tempConsigne.Reponse__c = 'Non contacté';
                        tempConsigne.Est_remplacant__c = consigne.isRemplacant == null ? false : (Boolean) consigne.isRemplacant;
                        tempConsigne.RecordTypeId = RT_ConsigneAuto;
                        tempConsigne.Nom_du_technicien__c = consigne.denomination;
                        tempConsigne.Demande__c = recordId;
                        tempConsigne.estHistorique__c = false;
                    if(consigne.dkCodeRessource != null) {
                        if(mapDKConsignes.containsKey(consigne.dkCodeRessource)) {
                            List<Consigne__c> tempListeConsignes = mapDKConsignes.get(consigne.dkCodeRessource);
                            tempListeConsignes.add(tempConsigne);
                            mapDKConsignes.put(consigne.dkCodeRessource, tempListeConsignes);
                        } else {
                            List<Consigne__c> newListeConsignes = new List<Consigne__c>();
                            newListeConsignes.add(tempConsigne);
                            mapDKConsignes.put(consigne.dkCodeRessource, newListeConsignes);
                        }
                    }else {
                        listeConsignes.add(tempConsigne);
                    }
                }

                if (webServiceConsignes?.isError) {
                    throw new TimeoutException('Un problème technique est survenu, si ça persiste, veuillez contacter votre administrateur!');
                }

                if(!mapDKConsignes.isEmpty()) {
                    listeConsignes.addAll(getConsigneUsers(mapDKConsignes));
                }
            }

            List<Consigne__c> oldConsignesAutomatiques = resetConsignesAutomatique(recordId);
            listeConsignes.addAll(oldConsignesAutomatiques);
            
            if(!listeConsignes.isEmpty()) {                    
                try{
                    upsert listeConsignes;
                    if(oldConsignesAutomatiques.size() == listeConsignes.size()) {
                        saved = false;
                    } else {
                        saved = true;
                    }
                } catch(Exception ex){
                    saved = false;
                    System.debug('Error inserting Consigne: ' + ex);
                }
            }
        }

        return saved;
    }

    /**
     * @description Methode qui nous permet de faire appel à notre WrapperResponse 
     *  afin de récupérer la liste des consignes et vérifier si le bouton qui fait appel au WS sera grisé ou pas
     *  au chargement du component LWC
     * @param recordId 
     * @return         CascadeAppelWrapperResponse
     */
    @AuraEnabled(cacheable=true)
    public static CascadeAppelWrapperResponse getData(String recordId) {
        return new CascadeAppelWrapperResponse(recordId);
    }

    @testVisible
    class CascadeAppelWrapperResponse {
        @AuraEnabled
        public List<Consigne__c> listConsignes{get;set;}

        @AuraEnabled
        public Boolean isReadOnly = false;

        @AuraEnabled
        public List<String> listeIdSIA {get;set;}

        @AuraEnabled
        public String recordTypeId_Manuelle;

        @AuraEnabled
        public String caseRecordTypeName;


        CascadeAppelWrapperResponse(String recordId) {
            listConsignes = getConsignes(recordId);
            isReadOnly = !showButtonCascade(recordId);
            listeIdSIA = getIdSIAs(listConsignes);
            recordTypeId_Manuelle = RT_ConsigneManuelle;
            Case demande = getDemande(recordId);
            caseRecordTypeName = demande.RecordType.DeveloperName;
        }
    }

    class TimeoutException extends Exception {}
}