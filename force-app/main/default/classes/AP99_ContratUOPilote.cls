/**
*@author Charbel Khoury Hanna
*@date 06/23/2021
*@description MAJ du UOPiloteContrat__c avec la valeur du centre finance relié à la région du contrat
*@test class: AP99_ContratUOPilote_Test
*/
public class AP99_ContratUOPilote {

    public static void updateUOPilote(List<Contrat__c> contrats){
        for(Contrat__c cont: contrats)
        {
            cont.UOPiloteContrat__c =cont.techCentreFinance__c;
        }
    }
}