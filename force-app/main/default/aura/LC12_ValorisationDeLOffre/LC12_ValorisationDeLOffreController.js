({
    doInit : function(component, event, helper) {
        //Query to get the tech field and add its value at the place of numb
        component.set("v.error", null);
        helper.GetTechCdtRefSelected(component);
        helper.getConditionOfPicklist(component);
    },
    
    ExpandBelow : function(component, event, helper) {
        if(component.get("v.IfExpand"))
        {
            component.set("v.IfExpand", false);
            //helper.GetConditionDeReferencePicklistValues(component); 
        }
        else 
        {
            component.set("v.IfExpand", true);
        }
    },
    
    onPicklistChange: function(component, event, helper) {
        var numb ;
        var selectedIndustry = component.find("InputSelectCDR");
        if(  selectedIndustry.get("v.value")== $A.get("$Label.c.LC12_Budget"))
        {
            numb='Budget';
        }
        else if(  selectedIndustry.get("v.value")== $A.get("$Label.c.LC12_Realise"))
        {
            numb='Realise';
        }
            else if(  selectedIndustry.get("v.value")== $A.get("$Label.c.LC12_Normatif"))
            {
                numb='Normatif';
            }
                else if(  selectedIndustry.get("v.value")== $A.get("$Label.c.LC12_Saisie"))
                {
                    numb='Saisie';
                }
        helper.GetTableWrapper(component,numb);   
    },  
})