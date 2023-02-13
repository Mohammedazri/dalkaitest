/** 
* @author Jacques Akiki
* @date 04/09/2020 
* @description test Class AP91_Contrat
*/
@isTest
public class Batch92_UpdatePFContrat_test {
    static testMethod void testContrat(){
        list<contrat__c> listcont = new List<Contrat__c>();
        Contrat__c cont = new Contrat__c(Name = 'TEST');
        listcont.add(cont);
        Contrat__c cont1 = new Contrat__c(Name = 'TEST11');
        listcont.add(cont1);
        insert listcont;
        ProjetFinance__c pf = testUtils.createPF('Test-PF', '1235464219');
        insert pf;
        TacheFinance__c tf = testUtils.createTF('Test-TF', 'TF23456');
        insert tf;
        LienContratTacheFinance__c lct = testUtils.createLCT(cont.id, tf.id, pf.id);
        insert lct;
        id BatchId = Database.executeBatch(new Batch92_UpdatePFContrat( ' limit 2'));

        
    }
}