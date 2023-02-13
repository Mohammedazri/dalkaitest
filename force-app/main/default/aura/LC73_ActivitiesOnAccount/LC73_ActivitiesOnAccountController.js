({
    doInit : function (component, event, helper) {
        var np=component.get("v.navigateParameter");
        component.set("v.pageNumber",1);
        helper.helperMethod(component,np);
    },
    
    goToNext: function(component, event, helper) {
        var pgNumber=component.get("v.pageNumber");
        pgNumber=pgNumber+1;
        component.set("v.pageNumber",pgNumber);
        component.set("v.navigateParameter",'next');
        var ntType=component.get("v.navigateParameter");
        helper.helperMethod(component,ntType);
    },
    goToPrevious: function(component, event, helper) {
        var pgNumber=component.get("v.pageNumber");
        pgNumber=pgNumber-1;
        component.set("v.pageNumber",pgNumber);
        component.set("v.navigateParameter",'previous');
        var ntType=component.get("v.navigateParameter");
        helper.helperMethod(component,ntType);
    },
    
    handleButton: function(component, event, helper){
        var trueFalseCheck=event.getSource().get("v.value");
        if(trueFalseCheck==true)
        {
            component.set("v.selectedNumber",component.get("v.selectedNumber")+1);
        }
        else
        {
            component.set("v.selectedNumber",component.get("v.selectedNumber")-1);
            
        }
        if (component.get("v.selectedNumber")==0)
        {
            component.set("v.isDisabled",true);
            
        }
        else
        {
            component.set("v.isDisabled",false);
        }
        
    },
    
    selectAllORDeselectAll: function(component, event, helper){
    var trueFalseCheck=event.getSource().get("v.value");
    var cntList=component.get("v.ContList");
    var pagnitaList=component.get("v.contListPaginateWise");
    var contListUpd=[];
    var pagnitaListUpd=[];
    for(var i=0;i<cntList.length;i++)
    {
    if(trueFalseCheck==true)
    {
    cntList[i].check=true;
    component.set("v.isDisabled",false);
    component.set("v.selectedNumber",cntList.length);
}
 else
 {
 cntList[i].check=false;
 component.set("v.isDisabled",true);
component.set("v.selectedNumber",0);

}
contListUpd.push(cntList[i]);
}
component.set("v.ContList",contListUpd);
for(var i=0;i<pagnitaList.length;i++)
{
    if(trueFalseCheck==true)
    {
        pagnitaList[i].check=true;
    }
    else
    {
        pagnitaList[i].check=false;
    }
    pagnitaListUpd.push(pagnitaList[i]);
}
component.set("v.contListPaginateWise",pagnitaListUpd);

},downloadSelectedCont :function(component, event, helper){
    var allSelectedCont=component.get("v.ContList");
    var contListAdd=[];
    for(var i=0;i < allSelectedCont.length;i++)
    {
        if(allSelectedCont[i].check==true)
        {
            
            contListAdd.push(allSelectedCont[i].obj);
            
        }
        
    }
    component.set("v.finalListToAdd",contListAdd);
    var finalListToDownload=component.get("v.finalListToAdd");
    var csv=helper.convertArrayOfObjectsToCSV(component,finalListToDownload); 
    if(csv==null)
    {
        return ;
    }                         
    var elementLink=document.createElement('a');
    elementLink.href='data:text/csv;charset=utf-8,%EF%BB%BF'+encodeURI(csv);
    elementLink.target='_self';
    var today = new Date();
    var dd = String(today.getDate()).padStart(2, '0');
    var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
    var yyyy = today.getFullYear();
    elementLink.download='Contrats Exportés '+dd+'-'+mm+'-'+yyyy+'.csv';
    document.body.appendChild(elementLink);
    elementLink.click();
    $A.get('e.force:refreshView').fire();
    
}
})