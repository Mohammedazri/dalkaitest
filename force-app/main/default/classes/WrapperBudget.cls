/** 
* @author Jacques Akiki
* @date 07/07/2020 
* @Wrapper Class that Englobes the sums of budgets
* @Test Class LC69_BudgetCadreCalcule_test 100%
*/
public class WrapperBudget {
    @AuraEnabled   
    public String NomBudget;		
    @AuraEnabled   
    public String Annee;
    @AuraEnabled   
    public decimal CABP1;
    @AuraEnabled   
    public decimal CABP2;
    @AuraEnabled   
    public decimal CABP3;
    @AuraEnabled   
    public decimal CABP4;
    @AuraEnabled   
    public decimal CABP6;
    @AuraEnabled   
    public decimal MBBP1;
    @AuraEnabled   
    public decimal MBBP2;
    @AuraEnabled   
    public decimal MBBP3;
    @AuraEnabled   
    public decimal MBBP4;
    @AuraEnabled   
    public decimal MBBP6;
    @AuraEnabled   
    public decimal BNMNP2;
    @AuraEnabled   
    public decimal BNMNP3;
    @AuraEnabled   
    public decimal BNMNP6;
    @AuraEnabled   
    public decimal BNMNPtot;
    @AuraEnabled   
    public decimal totCAP1234;
    @AuraEnabled   
    public decimal totMBP1234;
    @AuraEnabled   
    public String ErrorMessage;

    public WrapperBudget()
    {
    }
}