/**
 * @author Salah Mansour Akridiss
 * @email salah.akridiss@ei-technologies.com
 * @create date 2022-08-18
 * @modify -
 * @desc Contrôleur du Lightning Web Component qui permet de faire le suivi des appels techniciens STI
 */
public with sharing class LWC06_GestionSTI_CTRL {
    /**
     * @description Methode qui nous permet de récupérer tous les champs d'une demande via son recordId
     * @param recordId 
     * @return         Case
     */
    static Case getDemande(String recordId) {
        return [SELECT Id, TotalProlongationSTI__c, HeureProchainAppelTechnicienSTI__c, OwnerId, EtapeSTI__c, ProlongationSTI__c, OKSTI__c, NbrKOTotalSTI__c, NbrKOActuelSTI__c, Duree_intervention__c, Duree_trajet_retour__c, Technicien__r.Name, Technicien__r.Phone FROM Case WHERE Id = :recordId WITH SECURITY_ENFORCED];
    }

    /**
     * @description Methode qui nous permet de mettre un nouveau KO sur la demande STI
     * @param recordId 
     * @return         void
     */
    @AuraEnabled
    public static void setKO(String recordId) {
        
        Case demande = getDemande(recordId);

        try {
            Id IdFDA_Temporaire = getQueueIdFromDeveloperName('FDA_TEMP');
            demande.NbrKOTotalSTI__c += 1;
            demande.NbrKOActuelSTI__c += 1;
            String AjoutProchainAppel = Label.LWC06_HeureProchainAppel;
            Integer AjoutProchainAppelInteger = integer.valueof(AjoutProchainAppel); 
            demande.HeureProchainAppelTechnicienSTI__c = System.Now().addMinutes(AjoutProchainAppelInteger);
            demande.OwnerId = IdFDA_Temporaire;
            update demande;
        } catch (Exception ex) {
            throw ex;
        }
    }

    /**
     * @description Methode qui nous permet de mettre un OK sur la demande STI
     * @param recordId 
     * @return         void
     */
    @AuraEnabled
    public static void setOK(String recordId) {
        Case demande = getDemande(recordId);

        try {
            if (demande.EtapeSTI__c == 'Durée globale' || demande.EtapeSTI__c == 'Durée trajet retour'){
                demande.OKSTI__c = true;
            	demande.NbrKOActuelSTI__c = 0;
            	demande.Motif_de_cloture__c = 'STI terminé';
                demande.HeureProchainAppelTechnicienSTI__c = null;
                
            }else if (demande.EtapeSTI__c ==  'Durée intervention') {
                
                Integer duree_trajet_retour = Integer.valueOf(demande.Duree_trajet_retour__c);
                demande.NbrKOTotalSTI__c = 0;
                demande.NbrKOActuelSTI__c = 0;
                demande.EtapeSTI__c = 'Durée trajet retour';
                demande.HeureProchainAppelTechnicienSTI__c = System.now().addMinutes(duree_trajet_retour);
                System.debug(demande.HeureProchainAppelTechnicienSTI__c);
                demande.OwnerId = getQueueIdFromDeveloperName('FDA_TEMP');
                
            }else {
                
                Integer duree_intervention = Integer.valueOf(demande.Duree_intervention__c);
                demande.NbrKOTotalSTI__c = 0;
                demande.NbrKOActuelSTI__c = 0;
                demande.EtapeSTI__c = 'Durée intervention';
                //demande.HeureProchainAppelTechnicienSTI__c = System.now() + (Integer.valueOf(demande.Duree_intervention__c) /1440);
                demande.HeureProchainAppelTechnicienSTI__c = System.now().addMinutes(duree_intervention);
                System.debug(demande.HeureProchainAppelTechnicienSTI__c);
                demande.OwnerId = getQueueIdFromDeveloperName('FDA_TEMP');
            }
            
            update demande;
        } catch (Exception ex) {
            throw ex;
        }
    }

    /**
     * @description Methode qui nous permet de récupérer le Id d'une File d'attente via son DeveloperName
     * @param developerName 
     * @return         Id
     */
    static Id getQueueIdFromDeveloperName(String developerName) {
        return [SELECT Id, DeveloperName FROM Group WHERE DeveloperName = :developerName LIMIT 1]?.Id;
    }

    /**
     * @description Methode qui nous permet de savoir si le composant STI doit être en lecture seule
     * @param Demande 
     * @return         Boolean
     */
    static Boolean isReadOnly(Case demande) {
        if(demande.OKSTI__c || demande.OwnerId.getSObjectType() == Group.SObjectType) {
            return true;
        }

        return false;
    }

    /**
     * @description Methode qui nous permet de mettre à jour le total de prolongation et définir la prolongation actuelle du STI
     * @param recordId
     * @param prolongation  
     * @return         void
     */
    @AuraEnabled
    public static void setProlongation(String recordId, String prolongation) {
        Case demande = getDemande(recordId);

        try {
            Integer minutesToAdd = Integer.valueOf(prolongation);
            Id IdFDA_Temporaire = getQueueIdFromDeveloperName('FDA_TEMP');
            demande.TotalProlongationSTI__c = demande.TotalProlongationSTI__c == null ? minutesToAdd : (demande.TotalProlongationSTI__c + minutesToAdd);
            demande.HeureProchainAppelTechnicienSTI__c = System.now().addMinutes(minutesToAdd);
            demande.OwnerId = IdFDA_Temporaire;
            demande.NbrKOActuelSTI__c = 0;

            update demande;
        } catch (Exception ex) {
            throw ex;
        }
    }

    /**
     * @description Methode qui nous permet de faire appel à notre WrapperResponse 
     *  afin de récupérer les informations nécessaire à l'affichage du composant STI
     * @param recordId 
     * @return         STIWrapperResponse
     */
    @AuraEnabled(cacheable=true)
    public static STIWrapperResponse getData(String recordId) {
        return new STIWrapperResponse(recordId);
    }

    @testVisible
    class STIWrapperResponse {
        @AuraEnabled
        public Case demande = new Case();

        @AuraEnabled
        public Boolean isReadOnly {get; set;}

        @AuraEnabled
        public Boolean showEmpreinte {get; set;}

        STIWrapperResponse(String recordId) {
            demande = getDemande(recordId);
            isReadOnly = isReadOnly(demande);
            showEmpreinte = demande.HeureProchainAppelTechnicienSTI__c == null || demande.HeureProchainAppelTechnicienSTI__c <= System.Now() ? false : true;
        }
    }
}