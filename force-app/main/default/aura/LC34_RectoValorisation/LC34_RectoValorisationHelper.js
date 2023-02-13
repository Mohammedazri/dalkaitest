({
       checkVisibility : function( component ) {
         var action = component.get("c.checkUserProfile");
         action.setCallback(this, function(a) {
             var state = a.getState();
             if (state === 'SUCCESS') 
             {
                 component.set("v.canEdit", a.getReturnValue());
             }
         })
         $A.enqueueAction(action);
     }
})