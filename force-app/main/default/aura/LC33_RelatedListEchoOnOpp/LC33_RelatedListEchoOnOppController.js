({
  doInit: function (component, event, helper) {
    var action0 = component.get("c.getStatut");
    action0.setParams({ OppId: component.get("v.recordId") });
    action0.setCallback(this, function (resp0) {
      if (resp0.getReturnValue() != null) {
        component.set("v.statutNotFer", resp0.getReturnValue());
      }
      var temp = component.get("v.recordId").substring(0, 3);
      if (temp == "006") {
        component.set("v.Titre", $A.get("$Label.c.LC33_titre"));
      } else {
        component.set("v.Titre", $A.get("$Label.c.LC33_titreContrat"));
      }
      component.set("v.columns", [
        { label: "TYPE DE RELATION", fieldName: "TypeRel", type: "text" },
        {
          label: "PARTENAIRE LIÉ",
          fieldName: "PartenaireLie",
          type: "url",
          typeAttributes: {
            label: { fieldName: "PartenaireLieName" },
            tooltip: { fieldName: 'PartenaireLieName' },
            target: "_blank"
          }
        },
        {
          label: "CONTACT DU PARTENAIRE LIÉ",
          fieldName: "ContPartenaireLie",
          type: "url",
          typeAttributes: {
            label: { fieldName: "ContPartenaireLieName" },
            tooltip: { fieldName: 'ContPartenaireLieName' },
            target: "_blank"
          }
        },
        {label: 'STATUT', fieldName: 'Statut', type: 'text'},
        {
          type: "button",
          typeAttributes: {
            iconName: { fieldName: "iconNameSet"},
            //label:'Supprimer',
            name: "deleteRecord",
            title: "Supprimer",
            disabled: !component.get("v.statutNotFer"),
            value: "Supprimer",
            iconPosition: "center"
          },
          initialWidth: 80
        }
      ]);

      var action1 = component.get("c.getEcoSystems");
      action1.setParams({ OppId: component.get("v.recordId") });
      action1.setCallback(this, function (resp1) {
        var state = resp1.getState();
        if (state === "SUCCESS") {
          var res1 = resp1.getReturnValue();
          if (res1 != null && res1.length != 0) {
            for (var i = 0; i < res1.length; i++) {
              var row = res1[i];
              if (row.PartenaireLie__c != null) {
                row.PartenaireLieName = row.PartenaireLie__r.Name;
              }
              if (row.ContactDuPartenaireLie__c != null) {
                row.ContPartenaireLieName = row.ContactDuPartenaireLie__r.Name;
              }

              if (
                row.TypeRelation__c == "Destinataire" ||
                row.TypeRelation__c == "Facturé"
              ) {
                row.iconNameSet = "utility:lock";
              }
              else{
                row.iconNameSet = "utility:delete";
              }

              row.id = row.Id;
              row.TypeRel = row.TypeRelation__c;
              row.Statut = row.Statut__c;
            }
            res1.forEach(function (record) {
              if (record.PartenaireLie__c != null) {
                record.PartenaireLie = "/" + record.PartenaireLie__c;
              }
              if (record.ContactDuPartenaireLie__c != null) {
                record.ContPartenaireLie =
                  "/" + record.ContactDuPartenaireLie__c;
              }
              return record;
            });
            component.set("v.showTable", true);
            component.set("v.listofEco", res1);
          }
          component.set("v.numb", res1.length);
          var i;
          var partEco = component.get("v.partofEco");
          partEco = [];
          var initval = $A.get("$Label.c.LC33_NumDEcoAffic");
          for (i = 0; i < initval; i++) {
            if (res1[i] == null) {
              break;
            }
            partEco.push(res1[i]);
          }
          component.set("v.partofEco", partEco);
          component.set("v.listforItteration", partEco);
        }
      });
      $A.enqueueAction(action1);

      var action2 = component.get("c.getAccountID");
      action2.setParams({ OppId: component.get("v.recordId") });
      action2.setCallback(this, function (resp2) {
        var state2 = resp2.getState();
        if (state2 === "SUCCESS") {
          var res2 = resp2.getReturnValue();
          if (res2 != null) {
            component.set("v.accountId", res2);
          }
        }
      });
      $A.enqueueAction(action2);
    });
    $A.enqueueAction(action0);
  },

  handleViewAllClick: function (component, event, helper) {
    component.set("v.listforItteration", component.get("v.listofEco"));
    component.set("v.viewAll", true);
  },

  handleViewLessClick: function (component, event, helper) {
    component.set("v.listforItteration", component.get("v.partofEco"));
    component.set("v.viewAll", false);
  },

  handleDelete: function (component, event, helper) {
    var row = event.getParam("row");

    if (
      row.TypeRelation__c == "Destinataire" ||
      row.TypeRelation__c == "Facturé"
    ) {
      var toastEvent = $A.get("e.force:showToast");
      toastEvent.setParams({
        title: "Erreur!",
        type: "error",
        message: $A.get("$Label.c.LC33_TypeDestOuFactMessage")
      });
      toastEvent.fire();
    } else {
      component.set("v.viewModal", true);
      component.set("v.recordToDelete", row.Id);
    }
  },

  handleCancel: function (component, event, helper) {
    component.set("v.viewModal", false);
    component.set("v.recordToDelete", "");
    component.set("v.error", "");
  },

  handleRecordDelete: function (component, event, helper) {
    var action1 = component.get("c.deleteEco");
    action1.setParams({ ecoID: component.get("v.recordToDelete") });
    action1.setCallback(this, function (resp1) {
      var state = resp1.getState();
      if (state === "SUCCESS") {
        var res1 = resp1.getReturnValue();

        if (res1[1] == "OK") {
          component.set("v.viewModal", false);
          var toastEvent = $A.get("e.force:showToast");
          toastEvent.setParams({
            mode: "dismissible",
            duration: "3000",
            message: 'Écosystème du partenaire "' + res1[0] + '" was deleted.',
            type: "success"
          });
          toastEvent.fire();
          $A.get("e.force:refreshView").fire();
        } else {
          component.set("v.error", res1[1]);
        }
      }
    });
    $A.enqueueAction(action1);
  },

  handleEdits: function (component, event, helper) {
    var ediRecordEvent = $A.get("e.force:editRecord");
    ediRecordEvent.setParams({
      recordId: event.currentTarget.dataset.value
    });
    ediRecordEvent.fire();
  },

  handleNewClick: function (component, event, helper) {
    var visibility = component.find("visibility");
    $A.util.addClass(visibility, "slds-backdrop--open");

    var recordId = component.get("v.recordId");
    var showDiv = document.getElementById("showCreateCmp_" + recordId);
    showDiv.style.display = "block";
  },

  ifShowCreateCmpChange: function (component, event, helper) {
    var recordId = component.get("v.recordId");
    var showDiv = document.getElementById("showCreateCmp_" + recordId);
    showDiv.style.display = "none";
    $A.get("e.force:refreshView").fire();
  }
});