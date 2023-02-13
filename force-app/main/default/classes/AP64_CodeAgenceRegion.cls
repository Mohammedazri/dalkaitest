/**
*@author Alain Ghoussoub
*@date 17/07/2019
*@description Class to change the lookup region on the object agence according to the Code_Agence__c  
*/
public class AP64_CodeAgenceRegion {
    /**
*@author Alain Ghoussoub
*@date 17/07/2019
*@description change the lookup region on the object agence according to the Code_Agence__c  
*@params List of Agence__c (Trigger.new)
*@return void
*/
    public static void checkCode(List<Agence__c> listNew){
        //Set des codes des agences
        Set<String> setCodeAgence = new Set<String>();
        for(Agence__c ag : listNew){
            if(String.isNotBlank(ag.Code_Agence__c)){
                String code = ag.Code_Agence__c;
                if(code.length()>2){
                    code = code.substring(1, 3);
                }
                else{
                    code = 'DK';
                }
                setCodeAgence.add(code);
            }
        }
        system.debug('setCodeAgence ' + setCodeAgence);
        //Map de la code agence avec dk code region du custom setting CodeAgence_Region__c
        Map<String,String> codeAgenceDKCodeRegion = new Map<String,String>();
        //Set des dkcode des regions
        Set<String> dkCodeRegion = new Set<String>();
        if(setCodeAgence.size()>0){
            for(CodeAgence_Region__c codeAgReg : [Select id,name,Code__c,DkCode__c From CodeAgence_Region__c Where Code__c in :setCodeAgence]){
                if(String.isNotBlank(codeAgReg.Code__c) && String.isNotBlank(codeAgReg.DkCode__c)){
                    codeAgenceDKCodeRegion.put(codeAgReg.Code__c,codeAgReg.DkCode__c);
                    dkCodeRegion.add(codeAgReg.dkcode__c);
                }
            }
        }
        system.debug('codeAgenceDKCodeRegion ' + codeAgenceDKCodeRegion);
        system.debug('dkCodeRegion ' + dkCodeRegion);
        //Map du dkcode de la region avec son Id
        Map<String,Id> dkCodeIdRegion = new Map<String,Id>();
        if(dkCodeRegion.size()>0){
            for(Region__c reg : [Select id,name,DkCode__c From Region__c Where DkCode__c in :dkCodeRegion]){
                if(String.isNotBlank(reg.DkCode__c)){
                    dkCodeIdRegion.put(reg.DkCode__c,reg.id);
                }
            }
        }
        system.debug('dkCodeIdRegion ' + dkCodeIdRegion);
        //Remplir region selon le dkcode en utilisant les 2 maps
        for(Agence__c ag : listNew){
            if(String.isNotBlank(ag.Code_Agence__c)){
                String code = ag.Code_Agence__c;
                if(code.length()>2){
                    code = code.substring(1, 3);
                }
                else{
                    code = 'DK';
                }
                if(String.isNotBlank(code) && codeAgenceDKCodeRegion.containskey(code)){
                    system.debug(code);
                    String dkCodeReg = codeAgenceDKCodeRegion.get(code);
                    system.debug('dkCodeReg' + dkCodeReg);
                    if(dkCodeReg != null && dkCodeIdRegion.containskey(dkCodeReg)){
                        system.debug(dkCodeReg);
                        ag.Region__c = dkCodeIdRegion.get(dkCodeReg);
                        system.debug(dkCodeIdRegion.get(dkCodeReg));
                    }
                }
            }
        }
    }
}