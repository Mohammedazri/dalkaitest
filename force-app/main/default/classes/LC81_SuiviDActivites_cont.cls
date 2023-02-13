/** 
* @author Jacques Akiki
* @date 28/10/2020 
* @Controller of lightning Component LC81
* @Test Class LC81_SuiviDActivites_test 85%
*/
public without sharing class LC81_SuiviDActivites_cont {
     /** 
* @author Jacques Akiki
* @date 28/10/2020
* @Function that checks the profile of active user
* @param void
* @return Boolean 
*/
    @AuraEnabled
    public static Boolean getProfile() 
    {
       List<profile> listprof = [SELECT id,Name FROM Profile WHERE id=:Userinfo.getProfileId()];
        if (listprof!=NULL && listprof.size()>0)
        {
            if (Label.ProfilsAccessDetail.contains(','+listprof[0].Name+','))
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        else 
        {
            return null;
        }
        
    }

}