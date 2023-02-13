public without sharing class LC10_Hierarchy_Controller {
    
    public static map<Id, list<account>> mapAccountId_Children;
    public static string RootAccountId;
    
    
    @AuraEnabled
    public static string getTopParent(account myCurrentAccount){
        
        if(myCurrentAccount.ParentId != null)
        {            
            account ParentAccount= myCurrentAccount.Parent;            
            return getTopParent(ParentAccount); 
        }
        else
        {
            return myCurrentAccount.Id;
        }
    }
    
    @AuraEnabled
    public static list<WrapperHierarchyRow> getAccounts(string CurrentAccountId){
        string TopParentId;
        Account myAccount = [
            SELECT Id, OwnerId,
            ParentId, 
            Parent.ParentId, //1
            Parent.Parent.ParentId,//2
            Parent.Parent.Parent.ParentId,//3
            Parent.Parent.Parent.Parent.ParentId,//4
            Parent.Parent.Parent.Parent.Parent.ParentId//5
            FROM Account
            WHERE Id =:CurrentAccountId];
        /*This was done in case we have more than 5 levels of parents for an account*/
        if (myAccount.Parent.Parent.Parent.Parent.Parent.ParentId != NULL)
        {
            id parentAccid = myAccount.Parent.Parent.Parent.Parent.Parent.ParentId ;
            integer loopCount = 0;
            while(parentAccid!=NULL && loopCount<integer.valueof(Label.ParentLevel))
            {
                TopParentId = parentAccid;
                myAccount = queryAccount(parentAccid);
                parentAccid = myAccount.parentId;
                loopCount ++ ;
            }
        }
        
        else
        {
            TopParentId = LC10_Hierarchy_Controller.getTopParent(myAccount);
        }
        
        set<id> setLowLevel = new set<id>();// set accounts that have the lowest level in previous query
        set<Account> setHierAccount = new set<Account>();
        setLowLevel.add(TopParentId);
        integer loopCounter2 = 0;
        
        while (setLowLevel.size()!=0 && loopCounter2<(integer.valueof(Label.ParentLevel)/5))
        {
            list<Account> listAccounts = queryAccounts(setLowLevel);
            setLowLevel.clear();
            loopCounter2 ++ ;
            setHierAccount.addall(listAccounts);
            for (Account acc : listAccounts)
            {
                if (acc.Parent.Parent.Parent.Parent.Parent.ParentId != null)
                {
                    setLowLevel.add(acc.id);
                }
            }
        }
        List<Account> listHierAccount = new List<Account>(setHierAccount);
        
        
        mapAccountId_Children = new map<Id, list<Account>>();
        
        for(account theAccount : listHierAccount){            
            if(!mapAccountId_Children.containsKey(theAccount.ParentId)){
                mapAccountId_Children.put(theAccount.ParentId, new list<account>());
            }
            
            mapAccountId_Children.get(theAccount.ParentId).add(theAccount);
        }
        list<WrapperHierarchyRow> returnValue = getCreateWrapperHierarchy(null, CurrentAccountId);
        system.debug('returnValue: '+returnValue );
        
        return returnValue;
    }
    
    @AuraEnabled
    public static list<WrapperHierarchyRow> getCreateWrapperHierarchy(Id AccountId, string CurrentAccountId){
        system.debug('mapAccountId_Children : ' + mapAccountId_Children);
        list<WrapperHierarchyRow> returnValue = new list<WrapperHierarchyRow>();
        if(mapAccountId_Children.containsKey(AccountId)){
            for(account theAccount : mapAccountId_Children.get(AccountId)){
                WrapperHierarchyRow newWrapperHierarchyRow = new WrapperHierarchyRow();
                newWrapperHierarchyRow.ObjectName = theAccount.Name;
                newWrapperHierarchyRow.ObjectType='account';
                newWrapperHierarchyRow.ObjectId=theAccount.Id;
                newWrapperHierarchyRow.isParentOfCurrent=false;
                if (theAccount.BillingCity<>null && theAccount.BillingStreet<>null && theAccount.BillingPostalCode<>null)
                {
                    newWrapperHierarchyRow.ExtraInfo=' -- '+theAccount.Owner.name + ' -- ' + theAccount.BillingStreet+ ' , ' + theAccount.BillingPostalCode+ ' , ' + theAccount.BillingCity ;
                }
                
                else if(theAccount.BillingCity<>null && theAccount.BillingStreet<>null && theAccount.BillingPostalCode==null)
                {
                    newWrapperHierarchyRow.ExtraInfo=' -- '+theAccount.Owner.name + ' -- ' + theAccount.BillingStreet+ ' , ' + theAccount.BillingCity ;
                }
                
                else if(theAccount.BillingCity<>null && theAccount.BillingStreet==null && theAccount.BillingPostalCode<>null)
                {
                    newWrapperHierarchyRow.ExtraInfo=' -- '+theAccount.Owner.name + ' -- ' + theAccount.BillingPostalCode+ ' , ' + theAccount.BillingCity ;
                }
                
                else if (theAccount.BillingCity==null && theAccount.BillingStreet<>null && theAccount.BillingPostalCode<>null)
                {
                    newWrapperHierarchyRow.ExtraInfo=' -- '+theAccount.Owner.name + ' -- ' + theAccount.BillingStreet+ ' , ' + theAccount.BillingPostalCode ;
                }
                
                else if(theAccount.BillingCity==null && theAccount.BillingStreet==null && theAccount.BillingPostalCode<>null)
                {
                    newWrapperHierarchyRow.ExtraInfo=' -- '+theAccount.Owner.name + ' -- ' + theAccount.BillingPostalCode;
                }
                
                else if(theAccount.BillingCity==null && theAccount.BillingStreet<>null && theAccount.BillingPostalCode==null)
                {
                    newWrapperHierarchyRow.ExtraInfo=' -- '+theAccount.Owner.name + ' -- ' + theAccount.BillingStreet;
                }
                
                else if(theAccount.BillingCity<>null && theAccount.BillingStreet==null && theAccount.BillingPostalCode==null)
                {
                    newWrapperHierarchyRow.ExtraInfo=' -- '+theAccount.Owner.name +'--' + theAccount.BillingCity ;
                }
                
                else if(theAccount.BillingCity==null && theAccount.BillingStreet==null && theAccount.BillingPostalCode==null)
                {
                    newWrapperHierarchyRow.ExtraInfo=' -- '+theAccount.Owner.name ;
                }
                
                if(theAccount.Id== CurrentAccountId)
                {
                    newWrapperHierarchyRow.isCurrent=true;
                }  
                
                newWrapperHierarchyRow.listChildren = new list<WrapperHierarchyRow>();
                List<WrapperHierarchyRow> ListChildWrapperHierarchyRow= new List<WrapperHierarchyRow>();
                ListChildWrapperHierarchyRow=getCreateWrapperHierarchy(theAccount.Id, CurrentAccountId);
                for(WrapperHierarchyRow thisChildRow:ListChildWrapperHierarchyRow)
                {
                    if(thisChildRow.isParentOfCurrent==true || thisChildRow.isCurrent==true)
                        newWrapperHierarchyRow.isParentOfCurrent=true;
                }
                newWrapperHierarchyRow.listChildren.addAll(ListChildWrapperHierarchyRow);
                returnValue.add(newWrapperHierarchyRow);
            }
        }
        system.debug('##returnValue' + returnValue);
        
        return returnValue;
    }
    
    public static Account queryAccount(Id parentAccid)
    {
        Account myAccount;
        myAccount = [SELECT Id, OwnerId,ParentId FROM Account WHERE id =:parentAccid];
        return myAccount;
    }
    
    public static List<Account> queryAccounts(set<id> setLowLevel)
    {
        list<Account> listAccounts = [
            SELECT Id, Name,Parent.Id, Owner.name ,BillingCity, OwnerId , BillingStreet , BillingPostalCode,Parent.Parent.Parent.Parent.Parent.ParentId
            FROM Account
            WHERE Id in:setLowLevel 
            OR ParentId in:setLowLevel 
            OR Parent.ParentId in:setLowLevel //1
            OR Parent.Parent.ParentId in:setLowLevel//2
            OR Parent.Parent.Parent.ParentId in:setLowLevel//3
            OR Parent.Parent.Parent.Parent.ParentId in:setLowLevel//4
            OR Parent.Parent.Parent.Parent.Parent.ParentId in:setLowLevel//5
        ];
        return listAccounts;
    }
    
}