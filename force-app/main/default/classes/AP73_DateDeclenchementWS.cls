/**
*@author:Alain Ghoussoub
*@date 16/1/2019
*@description Classe qui met a jour le champ date declenchement des ws partenaire, contrat et document contractuel
*/
public class AP73_DateDeclenchementWS {
    public static void updateDateDeclenchement(List<Account> accList){
        for(Account acc: accList){
            if(acc.IdExterne__c == false){
                acc.DateDeclenchement__c = System.now();
            }
            else{
                acc.IdExterne__c = false;
            }
        }
    }
}