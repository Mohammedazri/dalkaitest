/**
 *@author Alain Ghoussoub
 *@date 8/20/2019
 *@description Update the field 'Type de contrat' depending on the fields ContratCadre__c  && EstContratcadre__c
 *@Test Class: AP68_UpdateTypeContrat_TEST
 *@Coverage: 84%
 */
public class AP68_UpdateTypeContrat {
    public static void UpdateContrats(List<Contrat__c> contList){
        for(Contrat__c cont : contList) {
            //17/02/2023: C360-922 Added by Jimmy, we update the field TypeContrat__c if DKCodeSurContrat__c is blank (on creation and update from opportunity before syncro)
            if(String.isBlank(cont.DKCodeSurContrat__c)) {
                if(cont.ContratCadre__c != null && cont.EstContratcadre__c == false) {
                    if(cont.NatureContratCadre__c == 'Réseau' || cont.NatureContratCadre__c == 'SPU') {
                        cont.TypeContrat__c = 'DEP';
                    } else {
                        cont.TypeContrat__c = 'IND';
                    }
                }
                if(cont.ContratCadre__c == null && cont.EstContratcadre__c == false) {
                    cont.TypeContrat__c = 'IND';
                }
                if(cont.ContratCadre__c == null && cont.EstContratcadre__c == true) {
                    if(cont.NatureContratCadre__c == 'Réseau' || cont.NatureContratCadre__c == 'SPU') {
                        cont.TypeContrat__c = 'MAI';
                    } else {
                        cont.TypeContrat__c = 'IND';
                    }
                }
            }
        }
    }
}