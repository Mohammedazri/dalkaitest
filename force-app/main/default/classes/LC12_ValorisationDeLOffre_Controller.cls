/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-Technologies
Description: Apex controller for the lightning component  LC12_ValorisationDeLOffre  used on the Fiche de synthése layout
which is responsible of the section => Valorisation de l'offre
Test Class: LC12_ValorisationOffre_Controller_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
24/07/2018   Johny Kassis    Added the sections where the field Budget_Realise__c is Used.
03/09/2018   Rita MATTAR     Added the function GetConditionDeReferenceSelected
--------------------------------------------------------------------------------------------------------------------------*/
public without sharing class LC12_ValorisationDeLOffre_Controller {
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-Technologies
Description: this function gets the values and the labels of the picklist field ConditionsDeReference__c using the class PicklistOption
Inputs: -
Returns: List of PicklistOption
----------------------------------------------------------------------------------------------------------------------------*/
    @AuraEnabled
    public static List<string> GetConditionDeReferencePicklistValues(){
        
        List<string> options = new List<string>();// List used to return the value of the picklist field ConditionsDeReference__c
        Schema.DescribeFieldResult fieldResult = fiche_de_synthese__c.ConditionsDeReference__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues(); // retrieve all the values of the picklist ConditionsDeReference__c
        
        for(Schema.PicklistEntry f : ple) {
            options.add(f.getValue());// add the values to the list
        }
        
        return options;
    }
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-Technologies
Description: class used to send and display the values and labels of the picklist field
----------------------------------------------------------------------------------------------------------------------------*/
    public class PicklistOption {
        @AuraEnabled
        public string OptionLabel;// variable used to store the label
        @AuraEnabled
        public string OptionApiName;// Variable used to store the Api name
        
        //Class Constructor
        public PicklistOption(string OptionLabel, string OptionApiName){
            this.OptionLabel = OptionLabel;
            this.OptionApiName = OptionApiName;
        }
    }
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: Function used to set the wrapper with the proper values and return it when the value "Budget" is chosen
Inputs: Id
Returns: Wrapper_FDSValOffre
----------------------------------------------------------------------------------------------------------------------------*/
    
    @AuraEnabled
    public static Wrapper_FDSValOffre  LoadWrapperBudget(Id FicheId){
        
        // query all the needed fields of the Fiche_de_synthese__c
        Fiche_de_synthese__c ficheDeSynt = [SELECT Id,OffreA1P1VentesServices__c,OffreA1P1MargeBrute__c,OffreA1P1MargeBruteSurCA__c,budget__r.BudgetNP1VentesServices__c,budget__r.BudgetNP1MargeBrute__c,budget__r.BudgetNP1MargeBruteSurCA__c,BudgetNP1CaEcart__c,BudgetNP1MbEcart__c,BudgetNP1MbCaEcart__c,
                                            OffreA1P2VentesServices__c,OffreA1P2MargeBrute__c,OffreA1P2MargeBruteSurCA__c,budget__r.BudgetNP2VentesServices__c,budget__r.BudgetNP2MargeBrute__c,budget__r.BudgetNP2MargeBruteSurCA__c,BudgetNP2CaEcart__c,BudgetNP2MbEcart__c,BudgetNP2MbCaEcart__c,
                                            OffreA1P3VentesServices__c,OffreA1P3MargeBrute__c,OffreA1P3MargeBruteSurCA__c,budget__r.BudgetNP3VentesServices__c,budget__r.BudgetNP3MargeBrute__c,budget__r.BudgetNP3MargeBruteSurCA__c,BudgetNP3CaEcart__c,BudgetNP3MbEcart__c,BudgetNP3MbCaEcart__c,
                                            OffreA1P4VentesServices__c,OffreA1P4MargeBrute__c,OffreA1P4MargeBruteSurCA__c,budget__r.BudgetNP4VentesServices__c,budget__r.BudgetNP4MargeBrute__c,budget__r.BudgetNP4MargeBruteSurCA__c,BudgetNP4CaEcart__c,BudgetNP4MbEcart__c,BudgetNP4MbCaEcart__c,
                                            OffreA1P6VentesServices__c,OffreA1P6MargeBrute__c,OffreA1P6MargeBruteSurCA__c,budget__r.BudgetNP6VentesServices__c,budget__r.BudgetNP6MargeBrute__c,budget__r.BudgetNP6MargeBruteSurCA__c,BudgetNP6CaEcart__c,BudgetNP6MbEcart__c,BudgetNP6MbCaEcart__c,
                                            OffreA1SousTotP1234CaOf__c,OffreA1SousTotP1234MbOf__c,OffreA1SousTotP1234MbCaOf__c,BudgetNSousTotP1234CaRef__c,BudgetNSousTotP1234MbRef__c,BudgetNSousTotP1234MbCaRef__c,BudgetNSousTotP1234CaEcart__c,BudgetNSousTotP1234MbEcart__c,BudgetNSousTotP1234MbCaEcart__c,
                                            OffreA1BklgHorsP6CaOf__c,OffreA1BklgHorsP6MbOf__c,OffreA1BklgHorsP6MbCaOf__c,BudgetNBklgHorsP6CaOf__c,BudgetNBklgHorsP6MbRef__c,BudgetNBklgHorsP6MbCaRef__c,BudgetNBklgHorsP6CaEcart__c,BudgetNBklgHorsP6MbEcart__c,BudgetNBklgHorsP6MbCaEcart__c,
                                            OffreA1BklgAvecP6CaOf__c,OffreA1BklgAvecP6MbOf__c,OffreA1BklgAvecP6MbCaOf__c,BudgetNBklgAvecP6CaOf__c,BudgetNBklgAvecP6MbRef__c,BudgetNBklgAvecP6MbCaRef__c,BudgetNBklgAvecP6CaEcart__c,BudgetNBklgAvecP6MbEcart__c,BudgetNBklgAvecP6MbCaEcart__c,
                                            CommentairesValorisationOffre__c,ValorisationMainOeuvre__c,DontInvestissementP4__c,Investissements__c,DontInvestissement1ereAnnee__c ,
                                            OffreA1SousTotP12346CaOf__c, OffreA1SousTotP12346MbOf__c, OffreA1SousTotP12346MbCaOf__c, BudgetNSousTotP12346CaRef__c, BudgetNSousTotP12346MbRef__c, BudgetNSousTotP12346MbCaRef__c	,BudgetNSousTotP12346CaEcart__c, BudgetNSousTotP12346MbEcart__c, BudgetNSousTotP12346MbCaEcart__c,
                                            Opportunit_commerciale__r.Tech_CdtRefSelectionnee__c ,ConditionsDeReference__c,BypassVR__c
                                            FROM Fiche_de_synthese__c
                                            WHERE  ID= :FicheId]; 
        
        
        Opportunity opp = [select id, Tech_CdtRefSelectionnee__c from Opportunity where id =:ficheDeSynt.Opportunit_commerciale__r.id];
        if(opp.Tech_CdtRefSelectionnee__c != Label.LC12_Budget) {
            opp.Tech_CdtRefSelectionnee__c = Label.LC12_Budget;
            update opp;
            ficheDeSynt.ConditionsDeReference__c = Label.LC12_Budget;
            ficheDeSynt.BypassVR__c = !ficheDeSynt.BypassVR__c;
            update ficheDeSynt;
        }
        
        Wrapper_FDSValOffre wrp1 = new Wrapper_FDSValOffre();// wrapper used to return the values of the table to the component
        
        wrp1.CurrentFiche = ficheDeSynt;
        
        // Load the Values of the first Line in the table using the function LoadFieldsP1
        LoadFieldsP1(wrp1, ficheDeSynt.OffreA1P1VentesServices__c, ficheDeSynt.OffreA1P1MargeBrute__c, ficheDeSynt.OffreA1P1MargeBruteSurCA__c, ficheDeSynt.budget__r.BudgetNP1VentesServices__c,  ficheDeSynt.budget__r.BudgetNP1MargeBrute__c,  ficheDeSynt.budget__r.BudgetNP1MargeBruteSurCA__c,  ficheDeSynt.BudgetNP1CaEcart__c,  ficheDeSynt.BudgetNP1MbEcart__c,  ficheDeSynt.BudgetNP1MbCaEcart__c);
        // Load the Values of the second Line in the table using the function LoadFieldsP2
        LoadFieldsP2(wrp1, ficheDeSynt.OffreA1P2VentesServices__c, ficheDeSynt.OffreA1P2MargeBrute__c, ficheDeSynt.OffreA1P2MargeBruteSurCA__c, ficheDeSynt.budget__r.BudgetNP2VentesServices__c,  ficheDeSynt.budget__r.BudgetNP2MargeBrute__c,  ficheDeSynt.budget__r.BudgetNP2MargeBruteSurCA__c,  ficheDeSynt.BudgetNP2CaEcart__c,  ficheDeSynt.BudgetNP2MbEcart__c,  ficheDeSynt.BudgetNP2MbCaEcart__c);
        // Load the Values of the third Line in the table using the function LoadFieldsP3
        LoadFieldsP3(wrp1, ficheDeSynt.OffreA1P3VentesServices__c, ficheDeSynt.OffreA1P3MargeBrute__c, ficheDeSynt.OffreA1P3MargeBruteSurCA__c, ficheDeSynt.budget__r.BudgetNP3VentesServices__c,  ficheDeSynt.budget__r.BudgetNP3MargeBrute__c,  ficheDeSynt.budget__r.BudgetNP3MargeBruteSurCA__c,  ficheDeSynt.BudgetNP3CaEcart__c,  ficheDeSynt.BudgetNP3MbEcart__c,  ficheDeSynt.BudgetNP3MbCaEcart__c);
        // Load the Values of the forth Line in the table using the function LoadFieldsP4
        LoadFieldsP4(wrp1, ficheDeSynt.OffreA1P4VentesServices__c, ficheDeSynt.OffreA1P4MargeBrute__c, ficheDeSynt.OffreA1P4MargeBruteSurCA__c, ficheDeSynt.budget__r.BudgetNP4VentesServices__c,  ficheDeSynt.budget__r.BudgetNP4MargeBrute__c,  ficheDeSynt.budget__r.BudgetNP4MargeBruteSurCA__c,  ficheDeSynt.BudgetNP4CaEcart__c,  ficheDeSynt.BudgetNP4MbEcart__c,  ficheDeSynt.BudgetNP4MbCaEcart__c);
        // Load the Values of the fifth  Line in the table using the function LoadFieldsP6
        LoadFieldsP6(wrp1, ficheDeSynt.OffreA1P6VentesServices__c, ficheDeSynt.OffreA1P6MargeBrute__c, ficheDeSynt.OffreA1P6MargeBruteSurCA__c, ficheDeSynt.budget__r.BudgetNP6VentesServices__c,  ficheDeSynt.budget__r.BudgetNP6MargeBrute__c,  ficheDeSynt.budget__r.BudgetNP6MargeBruteSurCA__c,  ficheDeSynt.BudgetNP6CaEcart__c,  ficheDeSynt.BudgetNP6MbEcart__c,  ficheDeSynt.BudgetNP6MbCaEcart__c);
        // Load the Values of the sixth Line in the table using the function LoadFieldsSousTotP1234
        LoadFieldsSousTotP1234(wrp1, ficheDeSynt.OffreA1SousTotP1234CaOf__c, ficheDeSynt.OffreA1SousTotP1234MbOf__c, ficheDeSynt.OffreA1SousTotP1234MbCaOf__c, ficheDeSynt.BudgetNSousTotP1234CaRef__c,  ficheDeSynt.BudgetNSousTotP1234MbRef__c,  ficheDeSynt.BudgetNSousTotP1234MbCaRef__c,  ficheDeSynt.BudgetNSousTotP1234CaEcart__c,  ficheDeSynt.BudgetNSousTotP1234MbEcart__c,  ficheDeSynt.BudgetNSousTotP1234MbCaEcart__c);
        // Load the Values of the seventh Line in the table using the function LoadFieldsSousTotP6
        LoadFieldsSousTotP6(wrp1, ficheDeSynt.OffreA1SousTotP12346CaOf__c, ficheDeSynt.OffreA1SousTotP12346MbOf__c, ficheDeSynt.OffreA1SousTotP12346MbCaOf__c, ficheDeSynt.BudgetNSousTotP12346CaRef__c,  ficheDeSynt.BudgetNSousTotP12346MbRef__c,  ficheDeSynt.BudgetNSousTotP12346MbCaRef__c,  ficheDeSynt.BudgetNSousTotP12346CaEcart__c,  ficheDeSynt.BudgetNSousTotP12346MbEcart__c,  ficheDeSynt.BudgetNSousTotP12346MbCaEcart__c);
        // Load the Values of the eighth  Line in the table using the function LoadFieldsBklgHorsP6
        LoadFieldsBklgHorsP6(wrp1, ficheDeSynt.OffreA1BklgHorsP6CaOf__c, ficheDeSynt.OffreA1BklgHorsP6MbOf__c, ficheDeSynt.OffreA1BklgHorsP6MbCaOf__c, ficheDeSynt.BudgetNBklgHorsP6CaOf__c, ficheDeSynt.BudgetNBklgHorsP6MbRef__c, ficheDeSynt.BudgetNBklgHorsP6MbCaRef__c, ficheDeSynt.BudgetNBklgHorsP6CaEcart__c, ficheDeSynt.BudgetNBklgHorsP6MbEcart__c, ficheDeSynt.BudgetNBklgHorsP6MbCaEcart__c );
        // Load the Values of the nineth Line in the table using the function LoadFieldsBklgAvecP6
        LoadFieldsBklgAvecP6(wrp1, ficheDeSynt.OffreA1BklgAvecP6CaOf__c, ficheDeSynt.OffreA1BklgAvecP6MbOf__c, ficheDeSynt.OffreA1BklgAvecP6MbCaOf__c, ficheDeSynt.BudgetNBklgAvecP6CaOf__c, ficheDeSynt.BudgetNBklgAvecP6MbRef__c, ficheDeSynt.BudgetNBklgAvecP6MbCaRef__c, ficheDeSynt.BudgetNBklgAvecP6CaEcart__c, ficheDeSynt.BudgetNBklgAvecP6MbEcart__c, ficheDeSynt.BudgetNBklgAvecP6MbCaEcart__c );
        
        return wrp1;
    }
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: Function used to set the wrapper with the proper values and return it when the value "Réalisé N-1" is chosen
Inputs: Id
Returns: Wrapper_FDSValOffre
----------------------------------------------------------------------------------------------------------------------------*/
    
    @AuraEnabled
    public static Wrapper_FDSValOffre  LoadWrapperRealise(Id FicheId){
        system.debug('FicheId' + FicheId);
        // query all the needed fields of the Fiche_de_synthese__c
        Fiche_de_synthese__c ficheDeSynt = [SELECT Id, OffreA1P1VentesServices__c, OffreA1P1MargeBrute__c, OffreA1P1MargeBruteSurCA__c, Budget_Realise__r.RealiseNP1VentesServices__c, Budget_Realise__r.RealiseNP1MargeBrute__c, Budget_Realise__r.RealiseNP1MargeBruteSurCA__c, RealiseNMoins1P1CaEcart__c, RealiseNMoins1P1MbEcart__c, RealiseNMoins1P1MbCaEcart__c,
                                            OffreA1P2VentesServices__c, OffreA1P2MargeBrute__c, OffreA1P2MargeBruteSurCA__c, Budget_Realise__r.RealiseNP2VentesServices__c, Budget_Realise__r.RealiseNP2MargeBrute__c, Budget_Realise__r.RealiseNP2MargeBruteSurCA__c, RealiseNMoins1P2CaEcart__c, RealiseNMoins1P2MbEcart__c, RealiseNMoins1P2MbCaEcart__c,
                                            OffreA1P3VentesServices__c, OffreA1P3MargeBrute__c, OffreA1P3MargeBruteSurCA__c, Budget_Realise__r.RealiseNP3VentesServices__c, Budget_Realise__r.RealiseNP3MargeBrute__c, Budget_Realise__r.RealiseNP3MargeBruteSurCA__c, RealiseNMoins1P3CaEcart__c, RealiseNMoins1P3MbEcart__c, RealiseNMoins1P3MbCaEcart__c,
                                            OffreA1P4VentesServices__c, OffreA1P4MargeBrute__c, OffreA1P4MargeBruteSurCA__c, Budget_Realise__r.RealiseNP4VentesServices__c, Budget_Realise__r.RealiseNP4MargeBrute__c, Budget_Realise__r.RealiseNP4MargeBruteSurCA__c, RealiseNMoins1P4CaEcart__c, RealiseNMoins1P4MbEcart__c, RealiseNMoins1P4MbCaEcart__c,
                                            OffreA1P6VentesServices__c, OffreA1P6MargeBrute__c, OffreA1P6MargeBruteSurCA__c, Budget_Realise__r.RealiseNP6VentesServices__c, Budget_Realise__r.RealiseNP6MargeBrute__c, Budget_Realise__r.RealiseNP6MargeBruteSurCA__c, RealiseNMoins1P6CaEcart__c, RealiseNMoins1P6MbEcart__c, RealiseNMoins1P6MbCaEcart__c,
                                            OffreA1SousTotP1234CaOf__c, OffreA1SousTotP1234MbOf__c, OffreA1SousTotP1234MbCaOf__c, RealiseNMoins1SousTotP1234CaRef__c, RealiseNMoins1SousTotP1234MbRef__c, RealiseNMoins1SousTotP1234MbCaRef__c, RealiseNMoins1SousTotP1234CaEcart__c, RealiseNMoins1SousTotP1234MbEcart__c, RealiseNMoins1SousTotP1234MbCaEcart__c,
                                            OffreA1BklgHorsP6CaOf__c, OffreA1BklgHorsP6MbOf__c, OffreA1BklgHorsP6MbCaOf__c, RealiseNMoins1BklgHorsP6CaOf__c, RealiseNMoins1BklgHorsP6MbRef__c, RealiseNMoins1BklgHorsP6MbCaRef__c, RealiseNMoins1BklgHorsP6CaEcart__c, RealiseNMoins1BklgHorsP6MbEcart__c, RealiseNMoins1BklgHorsP6MbCaEcart__c,
                                            OffreA1BklgAvecP6CaOf__c, OffreA1BklgAvecP6MbOf__c, OffreA1BklgAvecP6MbCaOf__c, RealiseNMoins1BklgAvecP6CaOf__c, RealiseNMoins1BklgAvecP6MbRef__c, RealiseNMoins1BklgAvecP6MbCaRef__c, RealiseNMoins1BklgAvecP6CaEcart__c, RealiseNMoins1BklgAvecP6MbEcart__c, RealiseNMoins1BklgAvecP6MbCaEcart__c,
                                            CommentairesValorisationOffre__c, ValorisationMainOeuvre__c, DontInvestissementP4__c, Investissements__c, DontInvestissement1ereAnnee__c,
                                            OffreA1SousTotP12346CaOf__c, OffreA1SousTotP12346MbOf__c, OffreA1SousTotP12346MbCaOf__c, RealiseNMoins1SousTotP12346CaRef__c, RealiseNMoins1SousTotP12346MbRef__c, RealiseNMoins1SousTotP12346MbCaRef__c, RealiseNMoins1SousTotP12346CaEcart__c, RealiseNMoins1SousTotP12346MbEcart__c, RealiseNMoins1SousTotP12346MbCaEcart__c,
                                            Opportunit_commerciale__r.Tech_CdtRefSelectionnee__c, ConditionsDeReference__c, BypassVR__c
                                            FROM Fiche_de_synthese__c
                                            WHERE ID = :FicheId];
        
        Opportunity opp = [select id, Tech_CdtRefSelectionnee__c from Opportunity where id =:ficheDeSynt.Opportunit_commerciale__r.id];
        if(opp.Tech_CdtRefSelectionnee__c != Label.LC12_Realise) {
            opp.Tech_CdtRefSelectionnee__c = Label.LC12_Realise;
            update opp;
            ficheDeSynt.ConditionsDeReference__c = opp.Tech_CdtRefSelectionnee__c;
            ficheDeSynt.BypassVR__c = !ficheDeSynt.BypassVR__c;
            update ficheDeSynt;
        }
        
        Wrapper_FDSValOffre wrp1 = new Wrapper_FDSValOffre();// wrapper used to return the values of the table to the component
        
        wrp1.CurrentFiche = ficheDeSynt;
        
        // Load the Values of the first Line in the table using the function LoadFieldsP1
        LoadFieldsP1(wrp1, ficheDeSynt.OffreA1P1VentesServices__c, ficheDeSynt.OffreA1P1MargeBrute__c, ficheDeSynt.OffreA1P1MargeBruteSurCA__c, ficheDeSynt.Budget_Realise__r.RealiseNP1VentesServices__c,  ficheDeSynt.Budget_Realise__r.RealiseNP1MargeBrute__c,  ficheDeSynt.Budget_Realise__r.RealiseNP1MargeBruteSurCA__c,  ficheDeSynt.RealiseNMoins1P1CaEcart__c,  ficheDeSynt.RealiseNMoins1P1MbEcart__c,  ficheDeSynt.RealiseNMoins1P1MbCaEcart__c);
        // Load the Values of the second Line in the table using the function LoadFieldsP2
        LoadFieldsP2(wrp1, ficheDeSynt.OffreA1P2VentesServices__c, ficheDeSynt.OffreA1P2MargeBrute__c, ficheDeSynt.OffreA1P2MargeBruteSurCA__c, ficheDeSynt.Budget_Realise__r.RealiseNP2VentesServices__c,  ficheDeSynt.Budget_Realise__r.RealiseNP2MargeBrute__c,  ficheDeSynt.Budget_Realise__r.RealiseNP2MargeBruteSurCA__c,  ficheDeSynt.RealiseNMoins1P2CaEcart__c,  ficheDeSynt.RealiseNMoins1P2MbEcart__c,  ficheDeSynt.RealiseNMoins1P2MbCaEcart__c);
        // Load the Values of the third Line in the table using the function LoadFieldsP3
        LoadFieldsP3(wrp1, ficheDeSynt.OffreA1P3VentesServices__c, ficheDeSynt.OffreA1P3MargeBrute__c, ficheDeSynt.OffreA1P3MargeBruteSurCA__c, ficheDeSynt.Budget_Realise__r.RealiseNP3VentesServices__c,  ficheDeSynt.Budget_Realise__r.RealiseNP3MargeBrute__c,  ficheDeSynt.Budget_Realise__r.RealiseNP3MargeBruteSurCA__c,  ficheDeSynt.RealiseNMoins1P3CaEcart__c,  ficheDeSynt.RealiseNMoins1P3MbEcart__c,  ficheDeSynt.RealiseNMoins1P3MbCaEcart__c);
        // Load the Values of the forth Line in the table using the function LoadFieldsP4
        LoadFieldsP4(wrp1, ficheDeSynt.OffreA1P4VentesServices__c, ficheDeSynt.OffreA1P4MargeBrute__c, ficheDeSynt.OffreA1P4MargeBruteSurCA__c, ficheDeSynt.Budget_Realise__r.RealiseNP4VentesServices__c,  ficheDeSynt.Budget_Realise__r.RealiseNP4MargeBrute__c,  ficheDeSynt.Budget_Realise__r.RealiseNP4MargeBruteSurCA__c,  ficheDeSynt.RealiseNMoins1P4CaEcart__c,  ficheDeSynt.RealiseNMoins1P4MbEcart__c,  ficheDeSynt.RealiseNMoins1P4MbCaEcart__c);
        // Load the Values of the fifth  Line in the table using the function LoadFieldsP6
        LoadFieldsP6(wrp1, ficheDeSynt.OffreA1P6VentesServices__c, ficheDeSynt.OffreA1P6MargeBrute__c, ficheDeSynt.OffreA1P6MargeBruteSurCA__c, ficheDeSynt.Budget_Realise__r.RealiseNP6VentesServices__c,  ficheDeSynt.Budget_Realise__r.RealiseNP6MargeBrute__c,  ficheDeSynt.Budget_Realise__r.RealiseNP6MargeBruteSurCA__c,  ficheDeSynt.RealiseNMoins1P6CaEcart__c,  ficheDeSynt.RealiseNMoins1P6MbEcart__c,  ficheDeSynt.RealiseNMoins1P6MbCaEcart__c);
        // Load the Values of the sixth Line in the table using the function LoadFieldsSousTotP1234
        LoadFieldsSousTotP1234(wrp1, ficheDeSynt.OffreA1SousTotP1234CaOf__c, ficheDeSynt.OffreA1SousTotP1234MbOf__c, ficheDeSynt.OffreA1SousTotP1234MbCaOf__c, ficheDeSynt.RealiseNMoins1SousTotP1234CaRef__c,  ficheDeSynt.RealiseNMoins1SousTotP1234MbRef__c,  ficheDeSynt.RealiseNMoins1SousTotP1234MbCaRef__c,  ficheDeSynt.RealiseNMoins1SousTotP1234CaEcart__c,  ficheDeSynt.RealiseNMoins1SousTotP1234MbEcart__c,  ficheDeSynt.RealiseNMoins1SousTotP1234MbCaEcart__c);
        // Load the Values of the seventh Line in the table using the function LoadFieldsSousTotP6
        LoadFieldsSousTotP6(wrp1, ficheDeSynt.OffreA1SousTotP12346CaOf__c, ficheDeSynt.OffreA1SousTotP12346MbOf__c, ficheDeSynt.OffreA1SousTotP12346MbCaOf__c, ficheDeSynt.RealiseNMoins1SousTotP12346CaRef__c,  ficheDeSynt.RealiseNMoins1SousTotP12346MbRef__c,  ficheDeSynt.RealiseNMoins1SousTotP12346MbCaRef__c,  ficheDeSynt.RealiseNMoins1SousTotP12346CaEcart__c,  ficheDeSynt.RealiseNMoins1SousTotP12346MbEcart__c,  ficheDeSynt.RealiseNMoins1SousTotP12346MbCaEcart__c);
        // Load the Values of the eighth  Line in the table using the function LoadFieldsBklgHorsP6
        LoadFieldsBklgHorsP6(wrp1, ficheDeSynt.OffreA1BklgHorsP6CaOf__c,  ficheDeSynt.OffreA1BklgHorsP6MbOf__c,  ficheDeSynt.OffreA1BklgHorsP6MbCaOf__c,  ficheDeSynt.RealiseNMoins1BklgHorsP6CaOf__c, ficheDeSynt.RealiseNMoins1BklgHorsP6MbRef__c, ficheDeSynt.RealiseNMoins1BklgHorsP6MbCaRef__c, ficheDeSynt.RealiseNMoins1BklgHorsP6CaEcart__c, ficheDeSynt.RealiseNMoins1BklgHorsP6MbEcart__c, ficheDeSynt.RealiseNMoins1BklgHorsP6MbCaEcart__c );
        // Load the Values of the nineth Line in the table using the function LoadFieldsBklgAvecP6
        LoadFieldsBklgAvecP6(wrp1, ficheDeSynt.OffreA1BklgAvecP6CaOf__c, ficheDeSynt.OffreA1BklgAvecP6MbOf__c, ficheDeSynt.OffreA1BklgAvecP6MbCaOf__c, ficheDeSynt.RealiseNMoins1BklgAvecP6CaOf__c, ficheDeSynt.RealiseNMoins1BklgAvecP6MbRef__c, ficheDeSynt.RealiseNMoins1BklgAvecP6MbCaRef__c, ficheDeSynt.RealiseNMoins1BklgAvecP6CaEcart__c, ficheDeSynt.RealiseNMoins1BklgAvecP6MbEcart__c, ficheDeSynt.RealiseNMoins1BklgAvecP6MbCaEcart__c );
        
        return wrp1;
    }
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: Function used to set the wrapper with the proper values and return it when the value "Saisie" is chosen
Inputs: Id
Returns: Wrapper_FDSValOffre
----------------------------------------------------------------------------------------------------------------------------*/
    
    @AuraEnabled
    public static Wrapper_FDSValOffre  LoadWrapperSaisie(Id FicheId){
        // query all the needed fields of the Fiche_de_synthese__c
        Fiche_de_synthese__c ficheDeSynt = [SELECT Id, OffreA1P1VentesServices__c, OffreA1P1MargeBrute__c, OffreA1P1MargeBruteSurCA__c, SaisieRefP1VentesServices__c, SaisieRefP1MargeBrute__c, SaisieRefP1MargeBruteSurCA__c, SaisiRefP1CaEcart__c, SaisieRefP1MbEcart__c, SaisieRefP1MbCaEcart__c,
                                            OffreA1P2VentesServices__c, OffreA1P2MargeBrute__c, OffreA1P2MargeBruteSurCA__c, SaisieRefP2VentesServices__c, SaisieRefP2MargeBrute__c, SaisieRefP2MargeBruteSurCA__c, SaisiRefP2CaEcart__c, SaisieRefP2MbEcart__c, SaisieRefP2MbCaEcart__c,
                                            OffreA1P3VentesServices__c, OffreA1P3MargeBrute__c, OffreA1P3MargeBruteSurCA__c, SaisieRefP3VentesServices__c, SaisieRefP3MargeBrute__c, SaisieRefP3MargeBruteSurCA__c, SaisiRefP3CaEcart__c, SaisieRefP3MbEcart__c, SaisieRefP3MbCaEcart__c,
                                            OffreA1P4VentesServices__c, OffreA1P4MargeBrute__c, OffreA1P4MargeBruteSurCA__c, SaisieRefP4VentesServices__c, SaisieRefP4MargeBrute__c, SaisieRefP4MargeBruteSurCA__c, SaisiRefP4CaEcart__c, SaisieRefP4MbEcart__c, SaisieRefP4MbCaEcart__c,
                                            OffreA1P6VentesServices__c, OffreA1P6MargeBrute__c, OffreA1P6MargeBruteSurCA__c, SaisieRefP6VentesServices__c, SaisieRefP6MargeBrute__c, SaisieRefP6MargeBruteSurCA__c, SaisiRefP6CaEcart__c, SaisieRefP6MbEcart__c, SaisieRefP6MbCaEcart__c,
                                            OffreA1SousTotP1234CaOf__c, OffreA1SousTotP1234MbOf__c, OffreA1SousTotP1234MbCaOf__c, SaisieRefSousTotP1234CaRef__c, SaisieRefSousTotP1234MbRef__c, SaisieRefSousTotP1234MbCaRef__c, SaisieRefSousTotP1234CaEcart__c, SaisieRefSousTotP1234MbEcart__c, SaisieRefSousTotP1234MbCaEcart__c,
                                            OffreA1BklgHorsP6CaOf__c, OffreA1BklgHorsP6MbOf__c, OffreA1BklgHorsP6MbCaOf__c, SaisieRefBklgHorsP6CaOf__c, SaisieRefBklgHorsP6MbRef__c, SaisieRefBklgHorsP6MbCaRef__c, SaisieRefBklgHorsP6CaEcart__c, SaisieRefBklgHorsP6MbEcart__c, SaisieRefBklgHorsP6MbCaEcart__c,
                                            OffreA1BklgAvecP6CaOf__c, OffreA1BklgAvecP6MbOf__c, OffreA1BklgAvecP6MbCaOf__c, SaisieRefBklgAvecP6CaOf__c, SaisieRefBklgAvecP6MbRef__c, SaisieRefBklgAvecP6MbCaRef__c, SasieRefBklgAvecP6CaEcart__c, SaisieRefBklgAvecP6MbEcart__c, SaisieRefBklgAvecP6MbCaEcart__c,
                                            CommentairesValorisationOffre__c, ValorisationMainOeuvre__c, DontInvestissementP4__c, Investissements__c, DontInvestissement1ereAnnee__c,
                                            OffreA1SousTotP12346CaOf__c, OffreA1SousTotP12346MbOf__c, OffreA1SousTotP12346MbCaOf__c, SaisieRefSousTotP12346CaRef__c, SaisieRefSousTotP12346MbRef__c, SaisieRefSousTotP12346MbCaRef__c, SaisieRefSousTotP12346CaEcart__c, SaisieRefSousTotP12346MbEcart__c, SaisieRefSousTotP12346MbCaEcart__c,
                                            Opportunit_commerciale__r.Tech_CdtRefSelectionnee__c, ConditionsDeReference__c, BypassVR__c
                                            FROM Fiche_de_synthese__c
                                            WHERE ID = :FicheId];
        
        Opportunity opp = [select id, Tech_CdtRefSelectionnee__c from Opportunity where id =:ficheDeSynt.Opportunit_commerciale__r.id];
        if(opp.Tech_CdtRefSelectionnee__c != Label.LC12_Saisie) {
            opp.Tech_CdtRefSelectionnee__c = Label.LC12_Saisie;
            update opp;
            ficheDeSynt.ConditionsDeReference__c = Label.LC12_Saisie;
            ficheDeSynt.BypassVR__c = !ficheDeSynt.BypassVR__c;
            update ficheDeSynt;
        }
        
        Wrapper_FDSValOffre wrp1 = new Wrapper_FDSValOffre();// wrapper used to return the values of the table to the component
        
        wrp1.CurrentFiche = ficheDeSynt;
        
        // Load the Values of the first Line in the table using the function LoadFieldsP1
        LoadFieldsP1(wrp1, ficheDeSynt.OffreA1P1VentesServices__c, ficheDeSynt.OffreA1P1MargeBrute__c, ficheDeSynt.OffreA1P1MargeBruteSurCA__c, ficheDeSynt.SaisieRefP1VentesServices__c,  ficheDeSynt.SaisieRefP1MargeBrute__c,  ficheDeSynt.SaisieRefP1MargeBruteSurCA__c,  ficheDeSynt.SaisiRefP1CaEcart__c,  ficheDeSynt.SaisieRefP1MbEcart__c,  ficheDeSynt.SaisieRefP1MbCaEcart__c);
        // Load the Values of the second Line in the table using the function LoadFieldsP2
        LoadFieldsP2(wrp1, ficheDeSynt.OffreA1P2VentesServices__c, ficheDeSynt.OffreA1P2MargeBrute__c, ficheDeSynt.OffreA1P2MargeBruteSurCA__c, ficheDeSynt.SaisieRefP2VentesServices__c,  ficheDeSynt.SaisieRefP2MargeBrute__c,  ficheDeSynt.SaisieRefP2MargeBruteSurCA__c,  ficheDeSynt.SaisiRefP2CaEcart__c,  ficheDeSynt.SaisieRefP2MbEcart__c,  ficheDeSynt.SaisieRefP2MbCaEcart__c);
        // Load the Values of the third Line in the table using the function LoadFieldsP3
        LoadFieldsP3(wrp1, ficheDeSynt.OffreA1P3VentesServices__c, ficheDeSynt.OffreA1P3MargeBrute__c, ficheDeSynt.OffreA1P3MargeBruteSurCA__c, ficheDeSynt.SaisieRefP3VentesServices__c,  ficheDeSynt.SaisieRefP3MargeBrute__c,  ficheDeSynt.SaisieRefP3MargeBruteSurCA__c,  ficheDeSynt.SaisiRefP3CaEcart__c,  ficheDeSynt.SaisieRefP3MbEcart__c,  ficheDeSynt.SaisieRefP3MbCaEcart__c);
        // Load the Values of the forth Line in the table using the function LoadFieldsP4
        LoadFieldsP4(wrp1, ficheDeSynt.OffreA1P4VentesServices__c, ficheDeSynt.OffreA1P4MargeBrute__c, ficheDeSynt.OffreA1P4MargeBruteSurCA__c, ficheDeSynt.SaisieRefP4VentesServices__c,  ficheDeSynt.SaisieRefP4MargeBrute__c,  ficheDeSynt.SaisieRefP4MargeBruteSurCA__c,  ficheDeSynt.SaisiRefP4CaEcart__c,  ficheDeSynt.SaisieRefP4MbEcart__c,  ficheDeSynt.SaisieRefP4MbCaEcart__c);
        // Load the Values of the fifth  Line in the table using the function LoadFieldsP6
        LoadFieldsP6(wrp1, ficheDeSynt.OffreA1P6VentesServices__c, ficheDeSynt.OffreA1P6MargeBrute__c, ficheDeSynt.OffreA1P6MargeBruteSurCA__c, ficheDeSynt.SaisieRefP6VentesServices__c,  ficheDeSynt.SaisieRefP6MargeBrute__c,  ficheDeSynt.SaisieRefP6MargeBruteSurCA__c,  ficheDeSynt.SaisiRefP6CaEcart__c,  ficheDeSynt.SaisieRefP6MbEcart__c,  ficheDeSynt.SaisieRefP6MbCaEcart__c);
        // Load the Values of the sixth Line in the table using the function LoadFieldsSousTotP1234
        LoadFieldsSousTotP1234(wrp1, ficheDeSynt.OffreA1SousTotP1234CaOf__c, ficheDeSynt.OffreA1SousTotP1234MbOf__c, ficheDeSynt.OffreA1SousTotP1234MbCaOf__c, ficheDeSynt.SaisieRefSousTotP1234CaRef__c,  ficheDeSynt.SaisieRefSousTotP1234MbRef__c,  ficheDeSynt.SaisieRefSousTotP1234MbCaRef__c,  ficheDeSynt.SaisieRefSousTotP1234CaEcart__c,  ficheDeSynt.SaisieRefSousTotP1234MbEcart__c,  ficheDeSynt.SaisieRefSousTotP1234MbCaEcart__c);
        // Load the Values of the seventh Line in the table using the function LoadFieldsSousTotP1234
        LoadFieldsSousTotP6(wrp1, ficheDeSynt.OffreA1SousTotP12346CaOf__c, ficheDeSynt.OffreA1SousTotP12346MbOf__c, ficheDeSynt.OffreA1SousTotP12346MbCaOf__c, ficheDeSynt.SaisieRefSousTotP12346CaRef__c,  ficheDeSynt.SaisieRefSousTotP12346MbRef__c,  ficheDeSynt.SaisieRefSousTotP12346MbCaRef__c,  ficheDeSynt.SaisieRefSousTotP12346CaEcart__c,  ficheDeSynt.SaisieRefSousTotP12346MbEcart__c,  ficheDeSynt.SaisieRefSousTotP12346MbCaEcart__c);
        // Load the Values of the eighth  Line in the table using the function LoadFieldsBklgHorsP6
        LoadFieldsBklgHorsP6(wrp1, ficheDeSynt.OffreA1BklgHorsP6CaOf__c,  ficheDeSynt.OffreA1BklgHorsP6MbOf__c,  ficheDeSynt.OffreA1BklgHorsP6MbCaOf__c,  ficheDeSynt.SaisieRefBklgHorsP6CaOf__c, ficheDeSynt.SaisieRefBklgHorsP6MbRef__c, ficheDeSynt.SaisieRefBklgHorsP6MbCaRef__c, ficheDeSynt.SaisieRefBklgHorsP6CaEcart__c, ficheDeSynt.SaisieRefBklgHorsP6MbEcart__c, ficheDeSynt.SaisieRefBklgHorsP6MbCaEcart__c );
        // Load the Values of the nineth Line in the table using the function LoadFieldsBklgAvecP6
        LoadFieldsBklgAvecP6(wrp1, ficheDeSynt.OffreA1BklgAvecP6CaOf__c, ficheDeSynt.OffreA1BklgAvecP6MbOf__c, ficheDeSynt.OffreA1BklgAvecP6MbCaOf__c, ficheDeSynt.SaisieRefBklgAvecP6CaOf__c, ficheDeSynt.SaisieRefBklgAvecP6MbRef__c, ficheDeSynt.SaisieRefBklgAvecP6MbCaRef__c, ficheDeSynt.SasieRefBklgAvecP6CaEcart__c, ficheDeSynt.SaisieRefBklgAvecP6MbEcart__c, ficheDeSynt.SaisieRefBklgAvecP6MbCaEcart__c );
        
        return wrp1;
    }
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: function used to set the Values of the wrapper that are used to fill the first line of the table
Inputs: Wrapper_FDSValOffre, Decimal, Decimal, Decimal, Decimal, Decimal, Decimal, Decimal, Decimal, String
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/
    @AuraEnabled
    public static Void LoadFieldsP1(Wrapper_FDSValOffre wrp1, Decimal P1CaOf, Decimal P1MbOf, Decimal P1MbCaOf, Decimal P1CaRef, Decimal P1MbRef, Decimal P1MbCaRef, Decimal P1CaEcart, Decimal P1MbEcart, Decimal P1MbCaEcart){
        IF(P1CaOf != null)
            wrp1.P1_Offre_CA = P1CaOf.intValue();                 // Set the variable P1_Offre_CA of the wrapper used for the first element of the first line in the table
        
        IF(P1MbOf != null)
            wrp1.P1_Offre_MB = P1MbOf.intValue();                   // Set the variable P1_Offre_MB of the wrapper used for the second  element of the first line in the table
        
        IF(P1MbCaOf != null)
            wrp1.P1_Offre_MBCA = P1MbCaOf.setScale(2);            // Set the variable P1_Offre_MBCA of the wrapper used for the third element of the first line in the table
        
        IF(P1CaRef != null)
            wrp1.P1_Ref_CA = P1CaRef.intValue();                  // Set the variable P1_Ref_CA of the wrapper used for the fourth  element of the first line in the table
        
        IF(P1MbRef != null)
            wrp1.P1_Ref_MB = P1MbRef.intValue();                  // Set the variable P1_Ref_MB of the wrapper used for the fifth  element of the first line in the table
        
        IF(P1MbCaRef != null)
            wrp1.P1_Ref_MBCA = P1MbCaRef.setScale(2);             // Set the variable P1_Ref_MBCA of the wrapper used for the sixth element of the first line in the table
        
        IF(P1CaEcart != null)
            wrp1.P1_Ecart_CA = P1CaEcart.intValue();              // Set the variable P1_Ecart_CA of the wrapper used for the seventh  element of the first line in the table
        
        IF(P1MbEcart != null)
            wrp1.P1_Ecart_MB = P1MbEcart.intValue();              // Set the variable P1_Ecart_MB of the wrapper used for the eighth  element of the first line in the table
        
        IF(P1MbCaEcart != null)
            wrp1.P1_Ecart_MBCA = P1MbCaEcart.setScale(2);         // Set the variable P1_Ecart_MBCA of the wrapper used for the ninth  element of the first line in the table
    }
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: function used to set the Values of the wrapper that are used to fill the second line of the table
Inputs: Wrapper_FDSValOffre, Decimal, Decimal, Decimal, Decimal, Decimal, Decimal, Decimal, Decimal, String
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/
    @AuraEnabled
    public static Void LoadFieldsP2(Wrapper_FDSValOffre wrp1, Decimal P2CaOf, Decimal P2MbOf, Decimal P2MbCaOf, Decimal P2CaRef, Decimal P2MbRef, Decimal P2MbCaRef, Decimal P2CaEcart, Decimal P2MbEcart, Decimal P2MbCaEcart){
        IF(P2CaOf != null)
            wrp1.P2_Offre_CA = P2CaOf.intValue();                     // Set the variable P2_Offre_CA of the wrapper used for the first element of the second line in the table
        
        IF(P2MbOf != null)
            wrp1.P2_Offre_MB = P2MbOf.intValue();                     // Set the variable P2_Offre_MB of the wrapper used for the second element of the second line in the table
        
        IF(P2MbCaOf != null)
            wrp1.P2_Offre_MBCA = P2MbCaOf.setScale(2);                // Set the variable P2_Offre_MBCA of the wrapper used for the third element of the second line in the table
        
        IF(P2CaRef != null)
            wrp1.P2_Ref_CA = P2CaRef.intValue();                      // Set the variable P2_Ref_CA of the wrapper used for the fourth  element of the second line in the table
        
        IF(P2MbRef != null)
            wrp1.P2_Ref_MB = P2MbRef.intValue();                      // Set the variable P2_Ref_MB of the wrapper used for the fifth element of the second line in the table
        
        IF(P2MbCaRef != null)
            wrp1.P2_Ref_MBCA = P2MbCaRef.setScale(2);                 // Set the variable P2_Ref_MBCA of the wrapper used for the sixth element of the second line in the table
        
        IF(P2CaEcart != null)
            wrp1.P2_Ecart_CA = P2CaEcart.intValue();                  // Set the variable P2_Ecart_CA of the wrapper used for the seventh element of the second line in the table
        
        IF(P2MbEcart != null)
            wrp1.P2_Ecart_MB = P2MbEcart.intValue();                  // Set the variable P2_Ecart_MB of the wrapper used for the eighth element of the second line in the table
        
        IF(P2MbCaEcart != null)
            wrp1.P2_Ecart_MBCA = P2MbCaEcart.setScale(2);             // Set the variable P2_Ecart_MBCA of the wrapper used for the ninth  element of the second line in the table
    }
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: function used to set the Values of the wrapper that are used to fill the third line of the table
Inputs: Wrapper_FDSValOffre, Decimal, Decimal, Decimal, Decimal, Decimal, Decimal, Decimal, Decimal, String
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/
    @AuraEnabled
    public static Void LoadFieldsP3(Wrapper_FDSValOffre wrp1, Decimal P3CaOf, Decimal P3MbOf, Decimal P3MbCaOf, Decimal P3CaRef, Decimal P3MbRef, Decimal P3MbCaRef, Decimal P3CaEcart, Decimal P3MbEcart, Decimal P3MbCaEcart){
        IF(P3CaOf != null)
            wrp1.P3_Offre_CA = P3CaOf.intValue();                     // Set the variable P3_Offre_CA of the wrapper used for the first element of the third line in the table
        
        IF(P3MbOf != null)
            wrp1.P3_Offre_MB = P3MbOf.intValue();                     // Set the variable P3_Offre_MB of the wrapper used for the second element of the third line in the table
        
        IF(P3MbCaOf != null)
            wrp1.P3_Offre_MBCA = P3MbCaOf.setScale(2);                // Set the variable P3_Offre_MBCA of the wrapper used for the third element of the third line in the table
        
        IF(P3CaRef != null)
            wrp1.P3_Ref_CA = P3CaRef.intValue();                      // Set the variable P3_Ref_CA of the wrapper used for the fourth  element of the third line in the table
        
        IF(P3MbRef != null)
            wrp1.P3_Ref_MB = P3MbRef.intValue();                      // Set the variable P3_Ref_MB of the wrapper used for the fifth element of the third line in the table
        
        IF(P3MbCaRef != null)
            wrp1.P3_Ref_MBCA = P3MbCaRef.setScale(2);                 // Set the variable P3_Ref_MBCA of the wrapper used for the sixth element of the third line in the table
        
        IF(P3CaEcart != null)
            wrp1.P3_Ecart_CA = P3CaEcart.intValue();                  // Set the variable P3_Ecart_CA of the wrapper used for the seventh element of the third line in the table
        
        IF(P3MbEcart != null)
            wrp1.P3_Ecart_MB = P3MbEcart.intValue();                  // Set the variable P3_Ecart_MB of the wrapper used for the eighth element of the third line in the table
        
        IF(P3MbCaEcart != null)
            wrp1.P3_Ecart_MBCA = P3MbCaEcart.setScale(2);             // Set the variable P3_Ecart_MBCA of the wrapper used for the ninth  element of the third line in the table
    }
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: function used to set the Values of the wrapper that are used to fill the fourth line of the table
Inputs: Wrapper_FDSValOffre, Decimal, Decimal, String, Decimal, Decimal, Decimal, Decimal, Decimal, String
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/
    @AuraEnabled
    public static Void LoadFieldsP4(Wrapper_FDSValOffre wrp1, Decimal P4CaOf, Decimal P4MbOf, Decimal P4MbCaOf, Decimal P4CaRef, Decimal P4MbRef, Decimal P4MbCaRef, Decimal P4CaEcart, Decimal P4MbEcart, Decimal P4MbCaEcart){
        IF(P4CaOf != null)
            wrp1.P4_Offre_CA = P4CaOf.intValue();                     // Set the variable P4_Offre_CA of the wrapper used for the first element of the fourth line in the table
        
        IF(P4MbOf != null)
            wrp1.P4_Offre_MB = P4MbOf.intValue();                     // Set the variable P4_Offre_MB of the wrapper used for the second element of the fourth line in the table
        
        IF(P4MbCaOf != null)
            wrp1.P4_Offre_MBCA = P4MbCaOf.setScale(2);                // Set the variable P4_Offre_MBCA of the wrapper used for the third element of the fourth line in the table
        
        IF(P4CaRef != null)
            wrp1.P4_Ref_CA = P4CaRef.intValue();                      // Set the variable P4_Ref_CA of the wrapper used for the fourth  element of the fourth line in the table
        
        IF(P4MbRef != null)
            wrp1.P4_Ref_MB = P4MbRef.intValue();                      // Set the variable P4_Ref_MB of the wrapper used for the fifth element of the fourth line in the table
        
        IF(P4MbCaRef != null)
            wrp1.P4_Ref_MBCA = P4MbCaRef.setScale(2);                // Set the variable P4_Ref_MBCA of the wrapper used for the sixth element of the fourth line in the table
        
        IF(P4CaEcart != null)
            wrp1.P4_Ecart_CA = P4CaEcart.intValue();                  // Set the variable P4_Ecart_CA of the wrapper used for the seventh element of the fourth line in the table
        
        IF(P4MbEcart != null)
            wrp1.P4_Ecart_MB = P4MbEcart.intValue();                  // Set the variable P4_Ecart_MB of the wrapper used for the eighth element of the fourth line in the table
        
        IF(P4MbCaEcart != null)
            wrp1.P4_Ecart_MBCA = P4MbCaEcart.setScale(2);             // Set the variable P4_Ecart_MBCA of the wrapper used for the ninth  element of the fourth line in the table
    }
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: function used to set the Values of the wrapper that are used to fill the fifth line of the table
Inputs: Wrapper_FDSValOffre, Decimal, Decimal, String, Decimal, Decimal, Decimal, Decimal, Decimal, String
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/
    @AuraEnabled
    public static Void LoadFieldsP6(Wrapper_FDSValOffre wrp1, Decimal P6CaOf, Decimal P6MbOf, Decimal P6MbCaOf, Decimal P6CaRef, Decimal P6MbRef, Decimal P6MbCaRef, Decimal P6CaEcart, Decimal P6MbEcart, Decimal P6MbCaEcart){
        
        IF(P6CaOf != null)
            wrp1.P6_Offre_CA = P6CaOf.intValue();                     // Set the variable P6_Offre_CA of the wrapper used for the first element of the fifth line in the table
        
        IF(P6MbOf != null)
            wrp1.P6_Offre_MB = P6MbOf.intValue();                     // Set the variable P6_Offre_MB of the wrapper used for the second element of the fifth line in the table
        
        IF(P6MbCaOf != null)
            wrp1.P6_Offre_MBCA = P6MbCaOf.setScale(2);                // Set the variable P6_Offre_MBCA of the wrapper used for the third element of the fifth line in the table
        
        IF(P6CaRef != null)
            wrp1.P6_Ref_CA = P6CaRef.intValue();                      // Set the variable P6_Ref_CA of the wrapper used for the fourth  element of the fifth line in the table
        
        IF(P6MbRef != null)
            wrp1.P6_Ref_MB = P6MbRef.intValue();                      // Set the variable P6_Ref_MB of the wrapper used for the fifth element of the fifth line in the table
        
        IF(P6MbCaRef != null)
            wrp1.P6_Ref_MBCA = P6MbCaRef.setScale(2);               // Set the variable P6_Ref_MBCA of the wrapper used for the sixth element of the fifth line in the table
        
        IF(P6CaEcart != null)
            wrp1.P6_Ecart_CA = P6CaEcart.intValue();                  // Set the variable P6_Ecart_CA of the wrapper used for the seventh element of the fifth line in the table
        
        IF(P6MbEcart != null)
            wrp1.P6_Ecart_MB = P6MbEcart.intValue();                  // Set the variable P6_Ecart_MB of the wrapper used for the eighth element of the fifth line in the table
        
        IF(P6MbCaEcart != null)
            wrp1.P6_Ecart_MBCA = P6MbCaEcart.setScale(2);             // Set the variable P6_Ecart_MBCA of the wrapper used for the ninth  element of the fifth line in the table
    }
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: function used to set the Values of the wrapper that are used to fill the sixth line of the table
Inputs: Wrapper_FDSValOffre, Decimal, Decimal, String, Decimal, Decimal, Decimal, Decimal, Decimal, String
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/
    @AuraEnabled
    public static Void LoadFieldsSousTotP1234(Wrapper_FDSValOffre wrp1, Decimal SousTotP1234CaOf, Decimal SousTotP1234MbOf, Decimal SousTotP1234MbCaOf, Decimal SousTotP1234CaRef, Decimal SousTotP1234MbRef, Decimal SousTotP1234MbCaRef, Decimal SousTotP1234CaEcart, Decimal SousTotP1234MbEcart, Decimal SousTotP1234MbCaEcart){
        IF(SousTotP1234CaOf != null)
            wrp1.ST_Offre_CA = SousTotP1234CaOf.intValue();                   // Set the variable ST_Offre_CA of the wrapper used for the first element of the sixth line in the table
        
        IF(SousTotP1234MbOf != null)
            wrp1.ST_Offre_MB = SousTotP1234MbOf.intValue();                   // Set the variable ST_Offre_MB of the wrapper used for the second element of the sixth line in the table
        
        IF(SousTotP1234MbCaOf != null)
            wrp1.ST_Offre_MBCA = SousTotP1234MbCaOf.setScale(2);              // Set the variable ST_Offre_MBCA of the wrapper used for the third element of the sixth line in the table
        
        IF(SousTotP1234CaRef != null)
            wrp1.ST_Ref_CA = SousTotP1234CaRef.intValue();                    // Set the variable ST_Ref_CA of the wrapper used for the fourth  element of the sixth line in the table
        
        IF(SousTotP1234MbRef != null)
            wrp1.ST_Ref_MB = SousTotP1234MbRef.intValue();                    // Set the variable ST_Ref_MB of the wrapper used for the fifth element of the sixth line in the table
        
        IF(SousTotP1234MbCaRef != null)
            wrp1.ST_Ref_MBCA = SousTotP1234MbCaRef.setScale(2);               // Set the variable ST_Ref_MBCA of the wrapper used for the sixth element of the sixth line in the table
        
        IF(SousTotP1234CaEcart != null)
            wrp1.ST_Ecart_CA = SousTotP1234CaEcart.intValue();                // Set the variable ST_Ecart_CA of the wrapper used for the seventh element of the sixth line in the table
        
        IF(SousTotP1234MbEcart != null)
            wrp1.ST_Ecart_MB = SousTotP1234MbEcart.intValue();                // Set the variable ST_Ecart_MB of the wrapper used for the eighth element of the sixth line in the table
        
        IF(SousTotP1234MbCaEcart != null)
            wrp1.ST_Ecart_MBCA = SousTotP1234MbCaEcart.setScale(2);           // Set the variable ST_Ecart_MBCA of the wrapper used for the ninth  element of the sixth line in the table
    }
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Rita Mattar
Company: EI-Technologies
Description: function used to set the Values of the wrapper that are used to fill the seventh line of the table
Inputs: Wrapper_FDSValOffre, Decimal, Decimal, String, Decimal, Decimal, Decimal, Decimal, Decimal, String
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/
    @AuraEnabled
    public static Void LoadFieldsSousTotP6(Wrapper_FDSValOffre wrp1, Decimal SousTotP1234CaOf, Decimal SousTotP1234MbOf, Decimal SousTotP1234MbCaOf, Decimal SousTotP1234CaRef, Decimal SousTotP1234MbRef, Decimal SousTotP1234MbCaRef, Decimal SousTotP1234CaEcart, Decimal SousTotP1234MbEcart, Decimal SousTotP1234MbCaEcart){
        IF(SousTotP1234CaOf != null)
            wrp1.ST_P6Offre_CA = SousTotP1234CaOf.intValue();             // Set the variable ST_P6Offre_CA of the wrapper used for the first element of the sixth line in the table
        
        IF(SousTotP1234MbOf != null)
            wrp1.ST_P6Offre_MB = SousTotP1234MbOf.intValue();             // Set the variable ST_P6Offre_MB of the wrapper used for the second element of the sixth line in the table
        
        IF(SousTotP1234MbCaOf != null)
            wrp1.ST_P6Offre_MBCA = SousTotP1234MbCaOf.setScale(2);        // Set the variable ST_P6Offre_MBCA of the wrapper used for the third element of the sixth line in the table
        
        IF(SousTotP1234CaRef != null)
            wrp1.ST_P6Ref_CA = SousTotP1234CaRef.intValue();              // Set the variable ST_P6Ref_CA of the wrapper used for the fourth  element of the sixth line in the table
        
        IF(SousTotP1234MbRef != null)
            wrp1.ST_P6Ref_MB = SousTotP1234MbRef.intValue();              // Set the variable ST_P6Ref_MB of the wrapper used for the fifth element of the sixth line in the table
        
        IF(SousTotP1234MbCaRef != null)
            wrp1.ST_P6Ref_MBCA = SousTotP1234MbCaRef.setScale(2);         // Set the variable ST_P6Ref_MBCA of the wrapper used for the sixth element of the sixth line in the table
        
        IF(SousTotP1234CaEcart != null)
            wrp1.ST_P6Ecart_CA = SousTotP1234CaEcart.intValue();          // Set the variable ST_P6Ecart_CA of the wrapper used for the seventh element of the sixth line in the table
        
        IF(SousTotP1234MbEcart != null)
            wrp1.ST_P6Ecart_MB = SousTotP1234MbEcart.intValue();          // Set the variable ST_P6Ecart_MB of the wrapper used for the eighth element of the sixth line in the table
        
        IF(SousTotP1234MbCaEcart != null)
            wrp1.ST_P6Ecart_MBCA = SousTotP1234MbCaEcart.setScale(2);     // Set the variable ST_P6Ecart_MBCA of the wrapper used for the ninth  element of the sixth line in the table
    }
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: function used to set the Values of the wrapper that are used to fill the eighth line of the table
Inputs: Wrapper_FDSValOffre, Decimal, Decimal, String, Decimal, Decimal, String, Decimal, Decimal, String
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/
    @AuraEnabled
    public static Void LoadFieldsBklgHorsP6(Wrapper_FDSValOffre wrp1,  Decimal BklgHorsP6CaOf, Decimal BklgHorsP6MbOf, Decimal BklgHorsP6MbCaOf, Decimal BklgHorsP6CaRef, Decimal BklgHorsP6MbRef, Decimal BklgHorsP6MbCaRef, Decimal BklgHorsP6CaEcart, Decimal BklgHorsP6MbEcart, Decimal BklgHorsP6MbCaEcart){
        IF(BklgHorsP6CaOf != null)
            wrp1.BklgHorsP6_Offre_CA = BklgHorsP6CaOf.intValue();             // Set the variable BklgHorsP6_Offre_CA of the wrapper used for the first element of the seventh line in the table
        
        IF(BklgHorsP6MbOf != null)
            wrp1.BklgHorsP6_Offre_MB = BklgHorsP6MbOf.intValue();             // Set the variable BklgHorsP6_Offre_MB of the wrapper used for the second element of the seventh line in the table
        
        IF(BklgHorsP6MbCaOf != null)
            wrp1.BklgHorsP6_Offre_MBCA = BklgHorsP6MbCaOf.setScale(2);        // Set the variable BklgHorsP6_Offre_MBCA of the wrapper used for the third element of the seventh line in the table
        
        IF(BklgHorsP6CaRef != null)
            wrp1.BklgHorsP6_Ref_CA = BklgHorsP6CaRef.intValue();              // Set the variable BklgHorsP6_Ref_CA of the wrapper used for the fourth  element of the seventh line in the table
        
        IF(BklgHorsP6MbRef != null)
            wrp1.BklgHorsP6_Ref_MB = BklgHorsP6MbRef.intValue();              // Set the variable BklgHorsP6_Ref_MB of the wrapper used for the fifth element of the seventh line in the table
        
        IF(BklgHorsP6MbCaRef != null)
            wrp1.BklgHorsP6_Ref_MBCA = BklgHorsP6MbCaRef.setScale(2);         // Set the variable BklgHorsP6_Ref_MBCA of the wrapper used for the sixth element of the seventh line in the table
        
        IF(BklgHorsP6CaEcart != null)
            wrp1.BklgHorsP6_Ecart_CA = BklgHorsP6CaEcart.intValue();          // Set the variable BklgHorsP6_Ecart_CA of the wrapper used for the seventh element of the seventh line in the table
        
        IF(BklgHorsP6MbEcart != null)
            wrp1.BklgHorsP6_Ecart_MB = BklgHorsP6MbEcart.intValue();          // Set the variable BklgHorsP6_Ecart_MB of the wrapper used for the eighth element of the seventh line in the table
        
        IF(BklgHorsP6MbCaEcart != null)
            wrp1.BklgHorsP6_Ecart_MBCA = BklgHorsP6MbCaEcart.setScale(2);     // Set the variable BklgHorsP6_Ecart_MBCA of the wrapper used for the ninth  element of the seventh line in the table
    }
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: function used to set the Values of the wrapper that are used to fill the nineth line of the table
Inputs: Wrapper_FDSValOffre, Decimal, Decimal, String, Decimal, Decimal, String, Decimal, Decimal, String
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/
    @AuraEnabled
    public static Void LoadFieldsBklgAvecP6(Wrapper_FDSValOffre wrp1,  Decimal BklgAvecP6CaOf, Decimal BklgAvecP6MbOf, Decimal BklgAvecP6MbCaOf, Decimal BklgAvecP6CaRef, Decimal BklgAvecP6MbRef, Decimal BklgAvecP6MbCaRef, Decimal BklgAvecP6CaEcart, Decimal BklgAvecP6MbEcart, Decimal BklgAvecP6MbCaEcart){
        IF(BklgAvecP6CaOf != null)
            wrp1.BklgAvecP6_Offre_CA = BklgAvecP6CaOf.intValue();             // Set the variable BklgAvecP6_Offre_CA of the wrapper used for the first element of the eighth line in the table
        
        IF(BklgAvecP6MbOf != null)
            wrp1.BklgAvecP6_Offre_MB = BklgAvecP6MbOf.intValue();             // Set the variable BklgAvecP6_Offre_MB of the wrapper used for the second element of the eighth line in the table
        
        IF(BklgAvecP6MbCaOf != null)
            wrp1.BklgAvecP6_Offre_MBCA = BklgAvecP6MbCaOf.setScale(2);        // Set the variable BklgAvecP6_Offre_MBCA of the wrapper used for the third element of the eighth line in the table
        
        IF(BklgAvecP6CaRef != null)
            wrp1.BklgAvecP6_Ref_CA = BklgAvecP6CaRef.intValue();              // Set the variable BklgAvecP6_Ref_CA of the wrapper used for the fourth  element of the eighth line in the table
        
        IF(BklgAvecP6MbRef != null)
            wrp1.BklgAvecP6_Ref_MB = BklgAvecP6MbRef.intValue();              // Set the variable BklgAvecP6_Ref_MB of the wrapper used for the fifth element of the eighth line in the table
        
        IF(BklgAvecP6MbCaRef != null)
            wrp1.BklgAvecP6_Ref_MBCA = BklgAvecP6MbCaRef.setScale(2);         // Set the variable BklgAvecP6_Ref_MBCA of the wrapper used for the sixth element of the eighth line in the table
        
        IF(BklgAvecP6CaEcart != null)
            wrp1.BklgAvecP6_Ecart_CA = BklgAvecP6CaEcart.intValue();          // Set the variable BklgAvecP6_Ecart_CA of the wrapper used for the seventh element of the eighth line in the table
        
        IF(BklgAvecP6MbEcart != null)
            wrp1.BklgAvecP6_Ecart_MB = BklgAvecP6MbEcart.intValue();          // Set the variable BklgAvecP6_Ecart_MB of the wrapper used for the eighth element of the eighth line in the table
        
        IF(BklgAvecP6MbCaEcart != null)
            wrp1.BklgAvecP6_Ecart_MBCA = BklgAvecP6MbCaEcart.setScale(2);     // Set the variable BklgAvecP6_Ecart_MBCA of the wrapper used for the ninth  element of the eighth line in the table
    }
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Rita Matar
Company: EI-Technologies
Description: Method that gets the value of the last value chosen from the picklist condition de référence
Inputs: Id
Returns: Opportunit_commerciale__r.Tech_CdtRefSelectionnee__c on the Fiche_de_synthese__c
----------------------------------------------------------------------------------------------------------------------------*/
    @AuraEnabled
    public static string GetConditionDeReferenceSelected(Id FicheId){
        Fiche_de_synthese__c ficheDeSynt = [SELECT id, Opportunit_commerciale__r.Tech_CdtRefSelectionnee__c
                                            FROM Fiche_de_synthese__c
                                            WHERE id =:FicheId];
        
        return ficheDeSynt.Opportunit_commerciale__r.Tech_CdtRefSelectionnee__c;
    }
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki
Company: EI-Technologies
Description: Method that gets the value of the last value chosen from the picklist condition de référence
Inputs: Id
Returns: Boolean
----------------------------------------------------------------------------------------------------------------------------*/
    @AuraEnabled
    public static Boolean getConditionOfPicklist(Id FicheId){
        Fiche_de_synthese__c ficheDeSynt = [SELECT id, Opportunit_commerciale__r.StageName, Opportunit_commerciale__r.Statut__c
                                            FROM Fiche_de_synthese__c
                                            WHERE id =:FicheId];
        User usr = [SELECT id, profileId, profile.name FROM USER WHERE id =:userInfo.getUserId()];
        if(((ficheDeSynt.Opportunit_commerciale__r.StageName == Label.PV_Realisation
             || ficheDeSynt.Opportunit_commerciale__r.Statut__c == Label.PV_Statut_SansSuite)
            && (String.valueOf(usr.profileId).substring(0, 15) != Label.VR_AdminID))
           || Label.NotEditFDS.contains(',' + usr.profile.name + ',')) {
               return true;
           } else {
               return false;
           }
    }
}