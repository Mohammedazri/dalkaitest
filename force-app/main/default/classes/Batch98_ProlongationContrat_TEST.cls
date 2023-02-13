/** 
* @author Alain Ghoussoub
* @date 15/10/2020 
* @description test Class Batch98_ProlongationContrat
*/
@isTest
public class Batch98_ProlongationContrat_TEST {
    static testMethod void testContrat(){
        list<contrat__c> listcont = new List<Contrat__c>();
        Contrat__c cont = new Contrat__c(Name = 'TEST');
        cont.DureeProlongationTotale__c = 0;
        listcont.add(cont);
        Contrat__c cont1 = new Contrat__c(Name = 'TEST11');
        cont1.DureeProlongationTotale__c = 0;
        listcont.add(cont1);
        insert listcont;
        id BatchId = Database.executeBatch(new Batch98_ProlongationContrat());
    }
}