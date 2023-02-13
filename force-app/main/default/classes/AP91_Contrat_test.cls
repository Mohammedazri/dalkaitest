/** 
* @author Jacques Akiki
* @date 03/09/2020 
* @description test Class AP91_Contrat
*/
@isTest
public class AP91_Contrat_test {
    static testMethod void testContrat(){
        Contrat__c cont = new Contrat__c();
        cont.Name = 'TEST';
        insert cont;
        list<ProjetFinance__c> listpf = new list<ProjetFinance__c>();
        list<TacheFinance__c> listTf = new list<TacheFinance__c>();
        list<LienContratTacheFinance__c> listLCT = new List<LienContratTacheFinance__c>();
        ProjetFinance__c pf = testUtils.createPF('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA12345', '1235464219');
        listpf.add(pf);
        ProjetFinance__c pf1 = testUtils.createPF('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA12346', '9876543210');
        listpf.add(pf1);
        ProjetFinance__c pf2 = testUtils.createPF('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA12347', '1122334455');
        listpf.add(pf2);
        ProjetFinance__c pf3 = testUtils.createPF('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA12348', '1122334456');
        listpf.add(pf3);
        ProjetFinance__c pf4 = testUtils.createPF('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA12349', '1122334457');
        listpf.add(pf4);
        insert listpf;
        
        TacheFinance__c tf = testUtils.createTF('TF', 'TF23456');
        listTf.add(tf);
        TacheFinance__c tf1 = testUtils.createTF('TF1', 'TF123456');
        listTf.add(tf1);
        TacheFinance__c tf2 = testUtils.createTF('TF2', 'TF223456');
        listTf.add(tf2);
        TacheFinance__c tf3 = testUtils.createTF('TF3', 'TF323456');
        listTf.add(tf3);
        TacheFinance__c tf4 = testUtils.createTF('TF4', 'TF423456');
        listTf.add(tf4);
        insert listTf;
        
        LienContratTacheFinance__c lct = testUtils.createLCT(cont.id, tf.id, pf.id);
        listLCT.add(lct);
        LienContratTacheFinance__c lct1 = testUtils.createLCT(cont.id, tf1.id, pf1.id);
        listLCT.add(lct1);
        LienContratTacheFinance__c lct2 = testUtils.createLCT(cont.id, tf2.id, pf1.id);
        listLCT.add(lct2);
        LienContratTacheFinance__c lct3 = testUtils.createLCT(cont.id, tf3.id, pf2.id);
        listLCT.add(lct3);
        LienContratTacheFinance__c lct4 = testUtils.createLCT(cont.id, tf4.id, pf2.id);
        listLCT.add(lct4);
        insert listLCT;
        test.startTest();
        list<LienContratTacheFinance__c> listLCTupdate = new List<LienContratTacheFinance__c>();
        lct2.ProjetFinance__c = pf3.id;
        listLCTupdate.add(lct2);
        lct4.ProjetFinance__c = pf4.id;
        listLCTupdate.add(lct4);
        update listLCTupdate;
        
        list<ProjetFinance__c> listPFupdate = new list<ProjetFinance__c>();
        pf2.Name = 'TESTPF2';
        pf3.dkCode__c = '';
        listPFupdate.add(pf2);
        listPFupdate.add(pf3);
        update listPFupdate;
        
        List<LienContratTacheFinance__c> listLCTdel = new List<LienContratTacheFinance__c>();
        listLCTdel.add(lct);
        listLCTdel.add(lct1);
        listLCTdel.add(lct2);
        listLCTdel.add(lct3);
        delete listLCTdel;
        delete lct4;
        test.stopTest();
        
    }
}