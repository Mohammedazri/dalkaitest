@isTest
public class AP72_Contact_Test {
    static testMethod void tesUpdateSatisfactionDuClient(){
        
        //create account
        account myaccount= testUtils.createAccount(label.AP72_NameAccountTechnique, 'Lebanon', 'Privé');
        myaccount.Lieu_immatriculation_legale__c = 'test';
        insert myaccount;
        
        //create account
        contact mycontact = testUtils.createContact(label.AP72_LastNameContactTechnique, myaccount.Id, null);
        mycontact.email=label.AP72_EmailContactTechnique;
        insert mycontact;
        
        Test.startTest();
        try{
            delete mycontact;
        }
        catch(exception e){
            string errorMsg = e.getMessage();
            system.assertEquals(true, errorMsg.contains(Label.AP72_ErrorContactTechnique));
            try{
                delete myaccount;
            }
            catch(exception e2){
                string errorMsg2 = e2.getMessage();
                system.assertEquals(true, errorMsg2.contains(Label.AP72_ErrorAccountTechnique));
            }
        }
        Test.stopTest();
    }
    
    
}