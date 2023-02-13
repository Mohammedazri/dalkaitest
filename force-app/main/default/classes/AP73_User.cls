/** 
* @author Jacques Akiki - EI technologies
* @date 17/1/2020 
* @description Class used to update user signature
* @Test Class AP73_User_test - 87%
*/
public class AP73_User {
    /** 
* @author Jacques Akiki - EI technologies 
* @date 17/1/2020 
* @ Method that updates the user signature with Dalkia format on insert/update based on the fields FName, LName , title , departement and phone
* @param usertList: list of Users being inserted or udated , userMap: Map of old userd
* @return void
*/
    public static void fillUserSignature(List<User> userList , Map<id,User> mapOldUser)
    {
        /*Insert User Case*/
        if (mapOldUser==NULL)
        {
            for (User us:userList)
            {
                if (us.isActive)
                {
                    String sig = composeSignature (us.FirstName,us.LastName,us.Title,us.Department,us.phone); 
                    if(sig<>null && sig.length()<1333)
                    {
                        us.Signature = sig;
                    }
                    else
                    {
                        us.Signature = '';
                        system.debug('Error while updating signature of user '+us.FirstName + ' '+us.LastName);
                    }
                }
            }
        }
        /*Update User Case*/
        if(mapOldUser<>NULL)
        {
            for (User us:userList)
            {
                if(us.isActive)
                {
                    if(!mapOldUser.get(us.id).isActive ||us.FirstName<>mapOldUser.get(us.id).FirstName
                       || us.LastName<>mapOldUser.get(us.id).LastName || us.title<>mapOldUser.get(us.id).title
                       || us.Department<>mapOldUser.get(us.id).Department || us.Phone<>mapOldUser.get(us.id).Phone)
                    {
                        
                        String sig = composeSignature (us.FirstName,us.LastName,us.Title,us.Department,us.phone); 
                        if(sig<>null && sig.length()<1333)
                        {
                            us.Signature = sig;
                        }
                        else
                        {
                            system.debug('Error while updating signature of user '+us.FirstName + ' '+us.LastName);
                        }
                    }
                }
            }
        }
    }
    private static String composeSignature(String fn,String ln,String tit,String dep , String ph)
    {
        if(fn==null)
        {
            fn = '';
        }
        if(ln==null)
        {
            ln='';
        }
        if(tit==null)
        {
            tit='';
        }
        if (dep==null)
        {
            dep='';
        }
        if (ph==null)
        {
            ph='';
        }
        
        String sig = Label.AP73_Sig1+ fn + ' ' + ln +Label.AP73_Sig2 +
            tit+Label.AP73_Sig3+dep+Label.AP73_Sig4+ph+Label.AP73_Sig5; 
        return sig;
        }

}