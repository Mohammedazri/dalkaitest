/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: This class is used as a controller for the VF page that displays a map with markers on the account 
Test Class: VFC02_Cartographie_Test
Pages: VF02_Cartographie
History
<Date> <Authors Name> <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
public class VFC02_Cartographie {
    public static map<Id, list<account>> mapAccountId_Children;
    public list<wrapperMarker> listMarkers{get;set;}
    public string myBasicUrl{get; set;}
    public account myAccount{get;set;}
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author:Dona Kfoury 
Company: EI-Technologies
Description:  Constructor of the class 
Inputs: -
Returns: -
History
<Date> <Authors Name> <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
    public VFC02_Cartographie(){
        string myBasicUrl1= ApexPages.currentPage().getHeaders().get('referer');
        system.debug('myBasicUrl1 ' + myBasicUrl1);
        if(myBasicUrl1!= null)
        {
            if(!myBasicUrl1.endsWithIgnoreCase('aloha'))
            {
                myBasicUrl1=myBasicUrl1+'one/one.app?source=aloha';
            }
        }
        myBasicUrl=myBasicUrl1;
        system.debug('Page Constructpr ' + myBasicUrl); 
        
        Load_Marker_Wrapper(); 
    }
    
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author:Dona Kfoury 
Company: EI-Technologies
Description: returns the ID of the top parent account 
Inputs: account
Returns: ID
History
<Date> <Authors Name> <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
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
 
  /*--------------------------------------------------------------------------------------------------------------------------
Author:Dona Kfoury 
Company: EI-Technologies
Description: this function loads the List of markers as a list of wrapperMarker using the Billing and shipping address 
Inputs: -
Returns:-
History
<Date> <Authors Name> <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
    public void Load_Marker_Wrapper(){
        listMarkers = new list<wrapperMarker>();
        string myAccountId=ApexPages.currentPage().getParameters().get('Id');
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
            WHERE Id =:myAccountId];
        
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
        
        for(account theAccount : listHierAccount){ 
            if(theAccount.BillingCity!=null || theAccount.BillingCountry!=null || theAccount.BillingStreet!=null || theAccount.BillingState!=null)
            {
                wrapperMarker mywrapperMarker= new wrapperMarker();
                mywrapperMarker.Name=theAccount.Name;
                mywrapperMarker.City=theAccount.BillingCity;
                mywrapperMarker.Country=theAccount.BillingCountry;
                mywrapperMarker.Street=theAccount.BillingStreet;
                mywrapperMarker.State=theAccount.BillingState;
                mywrapperMarker.Id=theAccount.Id;
                mywrapperMarker.isRacine=false;
                mywrapperMarker.isCurrent=false;
                if(theAccount.Id==TopParentId )
                {
                    mywrapperMarker.isRacine=true;
                }
                if(theAccount.Id==myAccount.Id){
                    mywrapperMarker.isCurrent=true;
                }
                listMarkers.add(mywrapperMarker);
            }
            else if(theAccount.ShippingCity!=null || theAccount.ShippingCountry!=null || theAccount.ShippingStreet!=null || theAccount.ShippingState!=null)
            {
                wrapperMarker mywrapperMarker= new wrapperMarker();
                mywrapperMarker.Name=theAccount.Name;
                mywrapperMarker.City=theAccount.ShippingCity;
                mywrapperMarker.Country=theAccount.ShippingCountry;
                mywrapperMarker.Street=theAccount.ShippingStreet;
                mywrapperMarker.State=theAccount.ShippingState;
                mywrapperMarker.Id=theAccount.Id;
                mywrapperMarker.isRacine=false;
                mywrapperMarker.isCurrent=false;
                if(theAccount.Id==TopParentId )
                {
                    mywrapperMarker.isRacine=true;
                }
                if(theAccount.Id==myAccount.Id){
                    mywrapperMarker.isCurrent=true;
                }
                listMarkers.add(mywrapperMarker);
            } 
        }
        system.debug('###listMarkers' + listMarkers);       
        
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
                SELECT Id, Name,Parent.Id, Owner.name ,BillingCity, OwnerId , BillingStreet , BillingPostalCode,BillingCountry,BillingState,
                       ShippingCity,ShippingCountry,ShippingStreet,ShippingState,Parent.Parent.Parent.Parent.Parent.ParentId
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