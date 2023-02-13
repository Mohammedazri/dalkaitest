/**
 *@author Alain Ghoussoub
 *@date 21/02/2019
 *@description Test class for LC41_EditAccount_Controller
 */
@isTest
public class LC41_EditAccount_Controller_TEST {
    @isTest
    public static void testController() {

        User u2 = testUtilsC360.CreateUser('standt18', 'user21111@testorg2.com', 'Testing2', Label.AdminProfileId, 'user2rrr@testorg2.com');
        u2.Code_d_Appartenance__c = 'OCECOM2';
        u2.BypassValidationRules__c = true;
        u2.BypassFilters__c = true;
        //PAD.PAD_BypassTrigger+=';AP45_Account;AP48_ContractCallouts';
        insert u2;

        System.runAs(u2){
            Account acc = testUtilsC360.createAccount('test', 'Lebanon', 'Public', Label.WS11_OUV, false, 'EDF', '345345', 'abcdef123');
            acc.Immatriculation_Legale__c = 'test';
            acc.LibelleEtablissement__c = 'test';
            insert acc;
            LC41_EditAccount_Controller.synchronizeAccount(acc.id);
        }
    }
}