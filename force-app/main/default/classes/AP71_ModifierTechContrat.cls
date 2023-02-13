/**
*@author:Alain Ghoussoub
*@date 10/15/2019
*@description Met a jour le champ Tech_ModfierContrat__c
*/
public class AP71_ModifierTechContrat {
    public static void updateTechModifierContrat(List<Contrat__c> contList,Map<Id,Contrat__c> oldContMap){
        for(Contrat__c newCont : contList){
            Contrat__c oldCont = oldContMap.get(newCont.id);
            if(oldCont.Name != newCont.Name || 
              oldCont.Commentaire__c  != newCont.Commentaire__c  ||
              oldCont.Statut_Facturation__c != newCont.Statut_Facturation__c ||
              oldCont.ValidationDate__c != newCont.ValidationDate__c ||
              oldCont.MotifRejet__c  != newCont.MotifRejet__c  ||
              oldCont.FormeJuridique__c != newCont.FormeJuridique__c ||
              oldCont.Langue__c != newCont.Langue__c ||
              oldCont.Devise__c  != newCont.Devise__c  ||
              oldCont.Numdossier__c  != newCont.Numdossier__c  ||
              oldCont.EstContratNational__c != newCont.EstContratNational__c ||
              oldCont.NatureContrat__c  != newCont.NatureContrat__c  ||
              oldCont.OrigineContrat__c  != newCont.OrigineContrat__c  ||
              oldCont.Datevalidation__c != newCont.Datevalidation__c ||
              oldCont.Motif_fermeture_contrat__c  != newCont.Motif_fermeture_contrat__c  ||
              oldCont.Condition_de_fermeture__c  != newCont.Condition_de_fermeture__c  ||
              oldCont.DateFin__c != newCont.DateFin__c ||
              oldCont.ReportingContrat__c  != newCont.ReportingContrat__c  ||
              oldCont.TypeContrat__c  != newCont.TypeContrat__c  ||
              oldCont.ReconductionFaitAutorisee__c  != newCont.ReconductionFaitAutorisee__c  ||
              oldCont.OwnerId != newCont.OwnerId ||
              oldCont.UOPiloteContrat__c != newCont.UOPiloteContrat__c ){
                newCont.Tech_ModfierContrat__c = true;
            }
        }
    }
}