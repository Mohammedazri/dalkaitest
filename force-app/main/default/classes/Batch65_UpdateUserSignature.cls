/** 
* @author Jacques Akiki - Ei technologies
* @date 14/02/2020 
* @description Batch qui renseigne la signature de tous les utilisateurs actifs de l'environnement
* @Test Class Batch65_UpdateUserSignature_test
*/
global class Batch65_UpdateUserSignature implements Database.Batchable<SObject>
{
    global string limt;
    /* Constructor to pass query limits while execution*/
    global Batch65_UpdateUserSignature(string lim) 
    {
        if(lim<>'' && lim<>null)
        {
            limt = lim;
        }
    }
     /** 
    * @author Jacques AKiki 
    * @date 14/02/2020 
    * @Select all active non techinical users with empty signatures 
    */
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query='SELECT id,Signature,FirstName,LastName,title,Department,Phone FROM User where isActive=True AND (not name  like \'%User%\') AND (not name like \'%Process%\') AND (not name like \'%Système%\')';
         if(limt<>'' && limt<>null)
        {
            query = query+ limt; 
        }
        return Database.getQueryLocator(query); 
    }
     /** 
    * @author Jacques AKiki 
    * @date 14/02/2020 
    * @check complete the signature accordingly to each user
    * @param Database.BatchableContext and list of users
    * @return void
    */
    global void execute (Database.BatchableContext bc , List<User> listUsr)
    {
        List<User> listUserupdate = new List<User>();
        for(User usr:listUsr)
        {
            String fn = usr.firstName;
            String ln = usr.LastName;
            String tit= usr.Title;
            String dep = usr.department;
            String ph = usr.phone;
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
            
            String sign = Label.AP73_Sig1+ fn + ' ' + ln +Label.AP73_Sig2 + tit+Label.AP73_Sig3+dep+Label.AP73_Sig4+ph+Label.AP73_Sig5;   
            
            if (sign<>null && sign.length()<1333)
            {
                usr.Signature = sign;
                listUserupdate.add(usr);
            }
        }
        if(listUserupdate<>NULL &&listUserupdate.size()>0)
        {
            update listUserupdate; 
        }
    }
    /*no action needed in finish*/
    global void finish(Database.BatchableContext bc)
    {
        
    }
}