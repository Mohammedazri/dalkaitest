({
    doInit : function(component, event, helper) {
        helper.checkVisibility(component);
        var action = component.get("c.CreateWrappers");
        action.setParams({ 
            FicheId : component.get("v.recordId")
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === 'SUCCESS') 
            {
                component.set("v.hideSpinner",true);
                component.set("v.ListOFwrapper", a.getReturnValue());
                component.set("v.BudgetYear", a.getReturnValue()[0].budgetYear);
                component.set("v.RealiseYear", a.getReturnValue()[0].realiseYear);
                var ListWrapper = component.get("v.ListOFwrapper");
                var AllSaisie = true;
                var AllOffre = true;
                
                for(var i=0;i<ListWrapper.length;i++)
                {
                    if (ListWrapper[i].editable == false && ListWrapper[i].Saisie == 0) 
                    {
                        ListWrapper[i].Saisie= null; 
                        ListWrapper[i].Symbol= null;
                    }
                    if (ListWrapper[i].editable == false && ListWrapper[i].Offre == 0)
                    { ListWrapper[i].Offre= null; 
                     ListWrapper[i].Symbol= null;
                    }
                    if(ListWrapper[i].Saisie == null && ListWrapper[i].Offre == null && ListWrapper[i].Budget == null)
                    {
                       ListWrapper[i].Ecart = null; 
                    }
                    
                }
                component.set("v.ListOFwrapper", ListWrapper);                 
            }
            else if (state === 'ERROR') 
            {
                var errors = a.getError();
            }
        });
        $A.enqueueAction(action); 
    },
    
    ExpandBelow : function(component, event, helper) {
        if(component.get("v.IfExpand"))
        {
            component.set("v.IfExpand", false);
        }
        else 
        {
            component.set("v.IfExpand", true);
        }
        
    },
    
    inputChanged : function(component, event, helper) {
        component.set('v.IsFieldValueEmpty',false);
        var input = event.target.id; 
        var inputValue = document.getElementById(input).value;
        var modifiedfields = component.get("v.ValuesToReturn");
        modifiedfields=modifiedfields.filter(function(el) {
            return el.ApiName !== input;
        });
        modifiedfields.push({'sobjectType':'Wrapper_ApiToValue',
                             'ApiName':input , 'FieldValue':inputValue  });
        console.log(modifiedfields);
        component.set("v.ValuesToReturn", modifiedfields); 
    },
    
    EditFields : function(component, event, helper) {
        component.set("v.IfEditMode", true);
        component.set("v.OffVide",false);

    },
    
    EcartZero : function(component, event, helper) {
        component.set("v.ConfirmEcart", true);
        component.set("v.errorPopUp",'');
    },
    
    OffreVide : function(component, event, helper) {
        var wraperlist = component.get("v.ListOFwrapper");
        var modifiedfields = component.get("v.ValuesToReturn");
        for(var i =0;i<wraperlist.length;i++){
            wraperlist[i].Offre = null;
            if(wraperlist[i].editable){
                modifiedfields=modifiedfields.filter(function(el) {
                    return el.ApiName !== wraperlist[i].ApiNameOffre;
                });
                modifiedfields.push({'sobjectType':'Wrapper_ApiToValue','ApiName':wraperlist[i].ApiNameOffre , 'FieldValue':''});
            }
        }
        component.set("v.ListOFwrapper",wraperlist);
        component.set("v.ValuesToReturn", modifiedfields); 
        component.set("v.OffVide",true);
        component.set("v.IfEditMode", true);
    },
    
    HandleEcartZero: function(component, event, helper) {
        component.set("v.hideSpinner",false);
        var action = component.get('c.updateEcarttoZero');
            action.setParams({ 
                FicheId : component.get("v.recordId"),
            });
        action.setCallback(this, function(a) {
           var state = a.getState();
            if (state === 'SUCCESS'){
             var res1 = a.getReturnValue();
             if(res1=="OK"){
                 component.set("v.hideSpinner",true);
                component.set("v.ConfirmEcart", false);
        		var navigateEvent = $A.get("e.force:navigateToSObject");
       			navigateEvent.setParams({
         		"recordId": component.get('v.recordId'),});
      			 navigateEvent.fire();
             }
                else{
                    component.set("v.hideSpinner",true);
                    component.set("v.errorPopUp",res1);
                }
     }
        });
        $A.enqueueAction(action);
        
    },
    
    
     HandleNotEcartZero: function(component, event, helper) {
        component.set("v.ConfirmEcart", false);
    },
    
    Cancel: function(component, event, helper) {
        var emptylist = [];
        component.set("v.ValuesToReturn", emptylist); 
        component.set("v.IfEditMode", false); 
        component.set("v.error",""); 
        if(component.get("v.OffVide")){
           component.set("v.hideSpinner",false);
           $A.get('e.force:refreshView').fire();
        }
    },
    
    SaveFields: function(component, event, helper) {
        component.set("v.hideSpinner",false);
        var temp=component.get("v.ValuesToReturn");
        if(temp.length > 0)
        {
            var ListOFwrapperJSON = JSON.stringify(component.get("v.ListOFwrapper"));
            var action = component.get("c.UpdateFDS");
            action.setParams({ 
                apiToFieldVal: JSON.stringify(component.get("v.ValuesToReturn")) ,
                FicheId : component.get("v.recordId"),
                ListOFwrapperJSON : ListOFwrapperJSON,
            });
            action.setCallback(this, function(a) 
                               {
                                   component.set("v.hideSpinner",true);
                                   var state = a.getState();
                                   if (state === 'SUCCESS') 
                                   {
                                       var res1 = a.getReturnValue();
                                       if(res1[0]=="OK")
                                       {
                                           component.set("v.OffVide",true);
                                           var toastEvent = $A.get("e.force:showToast");
                                           toastEvent.setParams({
                                               mode: 'dismissible',
                                               duration: '3000',
                                               message: $A.get("$Label.c.LC34_toastMessage1")+ res1[1]+$A.get("$Label.c.LC34_toastMessage2"),
                                               type : 'success'
                                           });
                                           toastEvent.fire();
                                           
                                           component.set("v.IfEditMode", false);
                                           var modifiedfields = [];
                                           component.set("v.ValuesToReturn", modifiedfields);
                                           
                                           var navigateEvent = $A.get("e.force:navigateToSObject");
                                           navigateEvent.setParams({
                                               "recordId": component.get('v.recordId'),
                                           });
                                           navigateEvent.fire();
                                       }
                                       else
                                       {
                                           component.set("v.error", res1[0]);
                                       }
                                   }
                                   else if (state === 'ERROR') 
                                   {
                                       var errors = a.getError();
                                       component.set("v.error",errors);
                                   }
                                   
                               });
            $A.enqueueAction(action);  
        }
        else
        {
            component.set("v.IfEditMode", false);
            component.set("v.hideSpinner",true);

        }
    },
    
})