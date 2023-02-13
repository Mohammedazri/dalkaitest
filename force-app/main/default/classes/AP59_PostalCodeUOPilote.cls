/**
*@author Hussein Farran
*@date 30/05/2019
*@description Use the custom settings object to get the value of the 3 fields (entite commerciale/dalkia and uopilote from the billingpostalcode inserted)
*/
public class AP59_PostalCodeUOPilote {
    /**
*@author Hussein Farran
*@date 30/05/2019
*@description get the 1st 2 digits of the postal code and use it to query the custom settings object to get the values of those fields that needs to be set.
*@params List of account (Trigger.new)
*@return void
*/
    public static void setFieldsFromPostalCode(List<Account> accList, map<id,Account> oldMap)
    {
        Set<String> postalCodes = new Set<String>();
        Set<String> dkCodeCF = new Set<String>();
        if (oldMap==NULL)
        {
            for (Account acc : accList) 
            {
                if(String.isNotBlank(acc.BillingPostalCode)){
                    String firstTwoDigits = acc.BillingPostalCode;
                    firstTwoDigits = firstTwoDigits.substring(0,2);
                    postalCodes.add(firstTwoDigits); //get 1st 2 digits of the postal code
                    System.debug('postalCodes ' + postalCodes);
                }
            }
        }
        else
        {
            for (Account acc : accList) 
            {
                if(acc.BillingPostalCode !=oldMap.get(acc.id).BillingPostalCode)
                {
                    if(String.isNotBlank(acc.BillingPostalCode)){
                        String firstTwoDigits = acc.BillingPostalCode;
                        firstTwoDigits = firstTwoDigits.substring(0,2);
                        postalCodes.add(firstTwoDigits); //get 1st 2 digits of the postal code
                        System.debug('postalCodes ' + postalCodes);
                    } 
                }
            }
        }
        if (postalCodes!=NULL && postalCodes.size()>0)
        {
            List<uo_dalkia__c> uoDalkiaList = [Select id,name,BillingPostalCode__c,EntiteCommercialeDalkia__c, EntiteCommercialeEDF__c, UODalkiaPilote__c 
                                               From uo_dalkia__c 
                                               Where BillingPostalCode__c in :postalCodes]; //get details of custom settings object
            System.debug('uoDalkiaList ' + uoDalkiaList);
            Map<String,uo_dalkia__c> postalCodesMap = new Map<String,uo_dalkia__c>();
            
            for(uo_dalkia__c uo : uoDalkiaList){
                postalCodesMap.put(uo.BillingPostalCode__c,uo); //put them in map to access them and fill all the account's fields that we wanna fill
                dkCodeCF.add(uo.UODalkiaPilote__c); //get all dk codes, select them and create a map of dkcode,id in order to fill correctly inside the final loop
            }
            System.debug('postalCodesMap ' + postalCodesMap);
            List<CentreFinance__c> cfList = [Select id,name,DkCode__c 
                                             From CentreFinance__c
                                             Where DkCode__c in:dkCodeCF];
            
            Map<String,Id> cfMap = new Map<String,Id>();
            
            for(CentreFinance__c cf : cfList){
                cfMap.put(cf.DkCode__c,cf.Id);
            }
            for (Account acc : accList) 
            {
                if(String.isNotBlank(acc.BillingPostalCode)){
                    String firstTwoDigits = acc.BillingPostalCode;
                    firstTwoDigits = firstTwoDigits.substring(0,2);
                    uo_dalkia__c uo = postalCodesMap.get(firstTwoDigits);
                    if(uo!=null){
                        acc.EntiteCommercialeEDF__c = uo.EntiteCommercialeEDF__c;
                        acc.EntiteCommercialeDalkia__c = uo.EntiteCommercialeDalkia__c;
                        if(String.isNotBlank(uo.UODalkiaPilote__c)){
                            acc.UODalkiaPilote__c = cfMap.get(uo.UODalkiaPilote__c);
                        }
                    }
                }
                
            }
        }
    }
}