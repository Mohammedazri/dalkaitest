/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: wrapper class used by the Lightning controller LC12_ValorisationDeLOffre_Controller  
to facilitate the display of the table Valorisation de l'Offre 
Test Class: -
History
<Date>      <Authors Name>   <Brief Description of Change>
03/07/2018   Johny Kassis      Created
--------------------------------------------------------------------------------------------------------------------------*/
public class Wrapper_FDSValOffre {
    // this Class contains variables that are used to display elements in the Table 
    // because the display is dynamic we used this class to facilitate the work   
    @AuraEnabled   
    public Fiche_de_synthese__c CurrentFiche;
    
    // the comments next to each variable indicates the placement of the element in the table
    @AuraEnabled   
    public Integer P1_Offre_CA;		//1st element in the 1st line
    @AuraEnabled   
    public Integer P1_Offre_MB;		//2nd element in the 1st line
    @AuraEnabled   
    public Decimal P1_Offre_MBCA;    //3rd element in the 1st line
    @AuraEnabled   
    public Integer P1_Ref_CA;		//4th element in the 1st line
    @AuraEnabled   
    public Integer P1_Ref_MB;		//5th element in the 1st line
    @AuraEnabled  
    public Decimal P1_Ref_MBCA;   	//6th element in the 1st line   
    @AuraEnabled   
    public Integer P1_Ecart_CA;		//7th element in the 1st line
    @AuraEnabled   
    public Integer P1_Ecart_MB;		//8th element in the 1st line
    @AuraEnabled   
    public Decimal P1_Ecart_MBCA; 	//9th element in the 1st line   
    
    @AuraEnabled   
    public Integer P2_Offre_CA;		//1st element in the 2nd line
    @AuraEnabled   
    public Integer P2_Offre_MB;		//2nd element in the 2nd line
    @AuraEnabled   
    public Decimal P2_Offre_MBCA;	//3rd element in the 2nd line
    @AuraEnabled 
    public Integer P2_Ref_CA;		//4th element in the 2nd line
    @AuraEnabled 
    public Integer P2_Ref_MB;		//5th element in the 2nd line
    @AuraEnabled  
    public Decimal P2_Ref_MBCA;		//6th element in the 2nd line
    @AuraEnabled  
    public Integer P2_Ecart_CA;		//7th element in the 2nd line
    @AuraEnabled  
    public Integer P2_Ecart_MB;		//8th element in the 2nd line
    @AuraEnabled 
    public Decimal P2_Ecart_MBCA;	//9th element in the 2nd line
    
    @AuraEnabled 
    public Integer P3_Offre_CA;		//1st element in the 3rd line
    @AuraEnabled 
    public Integer P3_Offre_MB;		//2nd element in the 3rd line
    @AuraEnabled  
    public Decimal P3_Offre_MBCA;	//3rd element in the 3rd line
    @AuraEnabled  
    public Integer P3_Ref_CA;		//4th element in the 3rd line
    @AuraEnabled  
    public Integer P3_Ref_MB;		//5th element in the 3rd line
    @AuraEnabled 
    public Decimal P3_Ref_MBCA;		//6th element in the 3rd line
    @AuraEnabled 
    public Integer P3_Ecart_CA;		//7th element in the 3rd line
    @AuraEnabled 
    public Integer P3_Ecart_MB;		//8th element in the 3rd line
    @AuraEnabled 
    public Decimal P3_Ecart_MBCA; 	//9th element in the 3rd line
    
    @AuraEnabled  
    public Integer P4_Offre_CA; 	//1st element in the 4th line
    @AuraEnabled  
    public Integer P4_Offre_MB; 	//2nd element in the 4th line
    @AuraEnabled  
    public Decimal P4_Offre_MBCA; 	//3rd element in the 4th line
    @AuraEnabled  
    public Integer P4_Ref_CA; 		//4th element in the 4th line
    @AuraEnabled  
    public Integer P4_Ref_MB; 		//5th element in the 4th line
    @AuraEnabled  
    public Decimal P4_Ref_MBCA; 		//6th element in the 4th line
    @AuraEnabled  
    public Integer P4_Ecart_CA; 	//7th element in the 4th line
    @AuraEnabled  
    public Integer P4_Ecart_MB; 	//8th element in the 4th line
    @AuraEnabled 
    public Decimal P4_Ecart_MBCA; 	//9th element in the 4th line
    
    @AuraEnabled   
    public Integer P6_Offre_CA; 	//1st element in the 5th line
    @AuraEnabled   
    public Integer P6_Offre_MB; 	//2nd element in the 5th line
    @AuraEnabled   
    public Decimal P6_Offre_MBCA; 	//3rd element in the 5th line
    @AuraEnabled  
    public Integer P6_Ref_CA; 		//4th element in the 5th line
    @AuraEnabled  
    public Integer P6_Ref_MB; 		//5th element in the 5th line
    @AuraEnabled 
    public Decimal P6_Ref_MBCA; 		//6th element in the 5th line
    @AuraEnabled  
    public Integer P6_Ecart_CA; 	//7th element in the 5th line
    @AuraEnabled  
    public Integer P6_Ecart_MB; 	//8th element in the 5th line
    @AuraEnabled  
    public Decimal P6_Ecart_MBCA; 	//9th element in the 5th line
    
    @AuraEnabled  
    public Integer ST_Offre_CA; 	//1st element in the 6th line
    @AuraEnabled  
    public Integer ST_Offre_MB; 	//2nd element in the 6th line
    @AuraEnabled  
    public Decimal ST_Offre_MBCA; 	//3rd element in the 6th line
    @AuraEnabled  
    public Integer ST_Ref_CA; 		//4th element in the 6th line
    @AuraEnabled 
    public Integer ST_Ref_MB; 		//5th element in the 6th line
    @AuraEnabled 
    public Decimal ST_Ref_MBCA; 	//6th element in the 6th line
    @AuraEnabled 
    public Integer ST_Ecart_CA; 	//7th element in the 6th line
    @AuraEnabled 
    public Integer ST_Ecart_MB; 	//8th element in the 6th line
    @AuraEnabled 
    public Decimal ST_Ecart_MBCA; 	//9th element in the 6th line 
    
    @AuraEnabled  
    public Integer ST_P6Offre_CA; 	//1st element in the 7th line
    @AuraEnabled  
    public Integer ST_P6Offre_MB; 	//2nd element in the 7th line
    @AuraEnabled  
    public Decimal ST_P6Offre_MBCA; //3rd element in the 7th line
    @AuraEnabled  
    public Integer ST_P6Ref_CA; 	//4th element in the 7th line
    @AuraEnabled 
    public Integer ST_P6Ref_MB; 	//5th element in the 7th line
    @AuraEnabled 
    public Decimal ST_P6Ref_MBCA; 	//6th element in the 7th line
    @AuraEnabled 
    public Integer ST_P6Ecart_CA; 	//7th element in the 7th line
    @AuraEnabled 
    public Integer ST_P6Ecart_MB; 	//8th element in the 7th line
    @AuraEnabled 
    public Decimal ST_P6Ecart_MBCA;  //9th element in the 7th line 
    
    @AuraEnabled 
    public Integer BklgHorsP6_Offre_CA; 	//1st element in the 8th line
    @AuraEnabled 
    public Integer BklgHorsP6_Offre_MB; 	//2nd element in the 8th line
    @AuraEnabled 
    public Decimal BklgHorsP6_Offre_MBCA; 	//3rd element in the 8th line
    @AuraEnabled 
    public Integer BklgHorsP6_Ref_CA; 		//4th element in the 8th line
    @AuraEnabled  
    public Integer BklgHorsP6_Ref_MB; 		//5th element in the 8th line
    @AuraEnabled 
    public Decimal BklgHorsP6_Ref_MBCA; 	//6th element in the 8th line
    @AuraEnabled  
    public Integer BklgHorsP6_Ecart_CA; 	//7th element in the 8th line
    @AuraEnabled 
    public Integer BklgHorsP6_Ecart_MB; 	//8th element in the 8th line
    @AuraEnabled 
    public Decimal BklgHorsP6_Ecart_MBCA; 	//9th element in the 8th line
    
    @AuraEnabled  
    public Integer BklgAvecP6_Offre_CA; 	//1st element in the 9th line
    @AuraEnabled  
    public Integer BklgAvecP6_Offre_MB; 	//2nd element in the 9th line
    @AuraEnabled  
    public Decimal BklgAvecP6_Offre_MBCA; 	//3rd element in the 9th line
    @AuraEnabled  
    public Integer BklgAvecP6_Ref_CA; 		//4th element in the 9th line
    @AuraEnabled  
    public Integer BklgAvecP6_Ref_MB; 		//5th element in the 9th line
    @AuraEnabled  
    public Decimal BklgAvecP6_Ref_MBCA; 	//6th element in the 9th line
    @AuraEnabled  
    public Integer BklgAvecP6_Ecart_CA; 	//7th element in the 9th line
    @AuraEnabled  
    public Integer BklgAvecP6_Ecart_MB; 	//8th element in the 9th line
    @AuraEnabled   
    public Decimal BklgAvecP6_Ecart_MBCA; 	//9th element in the 9th line
}