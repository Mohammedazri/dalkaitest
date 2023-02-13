/*--------------------------------------------------------------------------------------------------------------------------
   Author: Jimmy Khalil
   Company: EI-Technologies
   Description: Test Class pour AP105_Contact
   History
   <Date>      <Authors Name>   <Brief Description of Change>
   21/02/2022   Jimmy Khalil    Creation
   --------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class AP105_Contact_Test {
    @isTest
    public static void setContactMailPreferences_TEST(){
        account acc = testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        acc.StatutPartenaire__c = Label.WS11_OUV;
        insert acc;

        contact con = testUtils.CreateContact('test Contact 1', acc.id, null);
        con.Phone = '45245';
        insert con;

        con.Email = 'test@test.com';
        con.HasOptedOutOfEmail = true;
        con.Ne_Souhaite_pas_etre_enquete__c = true;
        con.NeSouhaitePasRecevoirNosPromotions__c = false;
        con.NeSouhaitePasRecevoirNosInvitations__c = false;

        update con;

        contact con1 = testUtils.CreateContact('test Contact 2', acc.id, null);
        con1.Phone = '45245';
        con1.Email = con.Email;
        insert con1;

        con1.Email = 'test@test1.com';
        update con1;

    }
}