({
 helperMethod : function(component,type) {
        if(type=='initialLoad')
        {
        var statusValueSelected=component.get("v.statusValueSelected");
        var action=component.get('c.getAllContrats');
            action.setParams({
                AccId:component.get("v.recordId")
            });
       action.setCallback(this,function(response){   
            var state=response.getState();
            var resultData=response.getReturnValue();
            var recordLength=response.getReturnValue().length;
            component.set("v.totalRecords",recordLength);
            var paginateData=[];
            if(state==="SUCCESS")
            {
              component.set("v.ContList",resultData);
              for(var i=0;i<10;i++)
                  {
                    if(recordLength > i)
                    {
                        paginateData.push(resultData[i]);
                   
                    }                 
                  }
                component.set("v.contListPaginateWise",paginateData);
                component.set("v.lastPageNumber",Math.ceil(recordLength/10));
                component.set("v.Spinner", false);
                
            }
           
       });
            $A.enqueueAction(action);
 }
        if(type=='next')
        {
            var pgNumber=component.get("v.pageNumber");
            var limit=10*pgNumber;
            var start=limit-10;
            var paginateData=[];
            var RequestList=[];
            RequestList=component.get("v.ContList");
            var recordLength=component.get("v.totalRecords");
             for(var i=start;i<limit;i++)
                  {
                    if(recordLength > i)
                    {
                        paginateData.push(RequestList[i]);
                   
                    }                 
                  }
             component.set("v.contListPaginateWise",paginateData);
        }
        if(type=='previous')
        {
            var pgNumber=component.get("v.pageNumber");
            var limit=10*pgNumber;
            var start=limit-10;
           // alert('limit'+limit);
            var paginateData=[];
            var RequestList=[];
            RequestList=component.get("v.ContList");
            var recordLength=component.get("v.totalRecords");
             for(var i=start;i<limit;i++)
                  {
                    if(recordLength > i)
                    {
                        paginateData.push(RequestList[i]);
                   
                    }                 
                  }
             component.set("v.contListPaginateWise",paginateData);
        }
    },
    convertArrayOfObjectsToCSV : function(component,objRecords) {
        var csvStringResult,counter,keys,lineDivider,columnDivider;
        if(objRecords==null || !objRecords.length)
        {
   return null;         
        }
        columnDivider=',';
        lineDivider='\n';
        keys=['Région','Nom du contrat','Partenaire','Pilote', 'Agence' , 'Total CA Budget P1 P2 P3 P4 (en €)'];
        csvStringResult='';
        csvStringResult+=keys.join(columnDivider);
        csvStringResult+=lineDivider;
        for(var i=0;i<objRecords.length;i++)
        {
            if(objRecords[i].LibelleRegion__c!=null)
            {
                csvStringResult+='"'+objRecords[i].LibelleRegion__c+'"';
            }
            else
            {
                csvStringResult+='"'+''+'"';
            }
            csvStringResult+=columnDivider;
            if(objRecords[i].Name!=null)
            {
                csvStringResult+='"'+objRecords[i].Name+'"';
            }
            else
            {
                csvStringResult+='"'+''+'"';
            }
            csvStringResult+=columnDivider;
            if(objRecords[i].NomPartenaire__r.Name!=null)
            {
                csvStringResult+='"'+objRecords[i].NomPartenaire__r.Name+'"';
            }
            else
            {
                csvStringResult+='"'+''+'"';
            }
            csvStringResult+=columnDivider;
            if(objRecords[i].techOwner__c!=null)
            {
                csvStringResult+='"'+objRecords[i].techOwner__c+'"';
            }
            else
            {
                csvStringResult+='"'+''+'"';
            }
            csvStringResult+=columnDivider;
            if(objRecords[i].Nom_d_Agence__c!=null)
            {
                csvStringResult+='"'+objRecords[i].Nom_d_Agence__c+'"';
            }
            else
            {
                csvStringResult+='"'+''+'"';
            }
            csvStringResult+=columnDivider;
            if(objRecords[i].TotalCABudgetP1P2P3P4__c!=null)
            {
                csvStringResult+='"'+objRecords[i].TotalCABudgetP1P2P3P4__c+'"';
            }
            else
            {
                csvStringResult+='"'+''+'"';
            }
            csvStringResult+=columnDivider;
            csvStringResult+=lineDivider;
            
        }
        
        return csvStringResult
    }

})