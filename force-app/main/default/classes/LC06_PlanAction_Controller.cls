/*--------------------------------------------------------------------------------------------------------------------------
   Author: Dona Kfoury
   Company: EI-Technologies
   Description: Apex controller for the lightning component LC06_PlanAction used on the account layout
              which is responsible of the section => Plan de Compte
   Test Class: LC06_PlanAction_Controller_Test
   History
   <Date>      <Authors Name>   <Brief Description of Change>
   10/2/2017      Yorgo Nabhan   added the marked section
   04/07/2018      Johny Kassis	added the condition Ajouter_au_plan_de_compte__c= true to the query on line 132
   --------------------------------------------------------------------------------------------------------------------------*/
public without sharing class LC06_PlanAction_Controller {

    /*--------------------------------------------------------------------------------------------------------------------------
       Author: Dona Kfoury
       Company: EI-Technologies
       Description: this function returns a list of tasks and events and their information using the wrapper class WrapperPlan_d_actions.
       Inputs: string AccountId, boolean IFSatisfactionClient, boolean IFEnjeuxContractuels, boolean IFRelationnelClient
       Returns:list of WrapperPlan_d_actions
       ----------------------------------------------------------------------------------------------------------------------------*/
    @AuraEnabled
    public static list<WrapperPlan_d_actions> getAccountPlans(string AccountId, boolean IFSatisfactionClient, boolean IFEnjeuxContractuels, boolean IFRelationnelClient){

        List<WrapperPlan_d_actions> MyWrapperList = new List<WrapperPlan_d_actions>();

        //Added By Jimmy for ApexSOQLInjection
        String Satisfaction_client = 'Satisfaction client';
        String Enjeux_contractuels = 'Enjeux contractuels';
        String Relationnel_client = 'Relationnel client';

        //string WhereCondidtion='WhatId=:AccountId'; // replaced by yorgo
        //
        //added by yorgo 10/2/2017

        List<id> QuerryIDs = new List<id>();
        //Set to put Objectif and ProjectCommercial without duplicates
        Set<id> IdsSet = new Set<id>();
        //Get Opportunities linked to account
        List<opportunity> Opportunities = [select id, TECH_objectif__c, ProjetCommercial__c,
                                           (select id FROM Fiches_GO_NO_GO__r)
                                           From opportunity
                                           where accountid =:AccountId];
        List<id> OpportunityIDs = new List<id>();
        for(opportunity opp : Opportunities) {
            OpportunityIDs.add(opp.id);
            QuerryIDs.add(opp.id);
            IdsSet.add(opp.TECH_objectif__c); // get objectif related to opportunity without duplicates
            IdsSet.add(opp.ProjetCommercial__c);  // get ProjetCommercial related to opportunity without duplicates
            for(fichegonogo__c fichegonogo : opp.Fiches_GO_NO_GO__r) {      //Get FicheGNG linked to all opportunities linked to account
                QuerryIDs.add(fichegonogo.id);
            }

        }
        QuerryIDs.addAll(IdsSet);

        List<Contrat__c> listContrat = [SELECT id
                                        FROM Contrat__c
                                        WHERE NomPartenaire__c =:AccountId];
        for(Contrat__c cont : listContrat) {
            QuerryIDs.add(cont.id);
        }

        //Get StrategieCompte__c linked to account  (select id FROM Contrats1__r)
        list<StrategieCompte__c> StrategieCompteslist = [select id FROM StrategieCompte__c where Compte__c =:AccountId];
        for(StrategieCompte__c StrategieCompte : StrategieCompteslist) {
            QuerryIDs.add(StrategieCompte.id);
        }

        QuerryIDs.add(AccountId);
        string WhereCondidtion = 'WhatId IN: QuerryIDs And WhatId!=null';
        system.debug('ids:' + QuerryIDs);

        //end Yorgo

        integer firstElement = 1;

        //Modified By Jimmy for ApexSOQLInjection
        If(IFSatisfactionClient){
            if(IFRelationnelClient || IFEnjeuxContractuels) {
                WhereCondidtion += ' And (genre_comite__c=:Satisfaction_client';
                firstElement++;
            } else {
                WhereCondidtion += ' And (genre_comite__c=:Satisfaction_client)';
                firstElement++;
            }
        }
        If(IFEnjeuxContractuels){
            if(firstElement == 1) {
                if(IFRelationnelClient) {
                    WhereCondidtion += ' And (genre_comite__c=:Enjeux_contractuels';
                    firstElement++;
                } else {
                    WhereCondidtion += ' And (genre_comite__c=:Enjeux_contractuels)';
                    firstElement++;
                }
            } else {
                if(IFRelationnelClient) {
                    WhereCondidtion += ' Or genre_comite__c=:Enjeux_contractuels';
                } else {
                    WhereCondidtion += ' Or genre_comite__c=:Enjeux_contractuels)';
                }
            }
        }
        If(IFRelationnelClient){
            if(firstElement == 1) {
                WhereCondidtion += ' And (genre_comite__c=:Relationnel_client)';
                firstElement++;
            } else {
                WhereCondidtion += ' Or genre_comite__c=:Relationnel_client)';
            }
        }
        if(!IFSatisfactionClient && !IFEnjeuxContractuels && !IFRelationnelClient) {
            WhereCondidtion += ' And genre_comite__c!= :Relationnel_client And genre_comite__c!= :Enjeux_contractuels And genre_comite__c!= :Satisfaction_client And genre_comite__c!=null';
        }
        WhereCondidtion += ' And (Action_strategie_compte__c=true OR Ajouter_au_plan_de_compte__c =true)';// show event in "plan de compte" only when type!=null and actionStrategieCompte is true
        string query = 'SELECT Id, WhatId, Subject, OwnerId, ActivityDate, genre_comite__c, Priority, Owner.Name, Status FROM Task WHERE ';
        query += WhereCondidtion;
        system.debug('###query  ' + query);

        //Modified By Jimmy for ApexSOQLInjection
        String queryEscaped = String.escapeSingleQuotes(query);
        List<Task> ListTasks = Database.query(queryEscaped);
        system.debug('###ListTasks  ' + ListTasks);

        for(Task theTask : ListTasks) {
            WrapperPlan_d_actions MyWrapperTask = new WrapperPlan_d_actions();
            MyWrapperTask.TheTaskEvent = theTask;
            if(theTask.genre_comite__c != null) {
                MyWrapperTask.genre_comite = theTask.genre_comite__c.substring(0, 3);
            } else {
                MyWrapperTask.genre_comite = 'Aucune';
            }
            if(theTask.Priority == 'Elevée') {
                MyWrapperTask.ifHighPriority = true;
            }

            MyWrapperTask.status = 'rond';
            MyWrapperTask.Realise = theTask.Status;
            MyWrapperTask.Type = 'Task';
            MyWrapperTask.NonAcheve = false;

            if(theTask.Status != 'Terminé' && theTask.ActivityDate < date.today()) {
                MyWrapperTask.NonAcheve = true;
            }
            MyWrapperList.add(MyWrapperTask);
        }

        string WhereCondidtion2 = 'WhatId IN: QuerryIDs And WhatId!=null';
        integer firstElement2 = 1;
        //Modified By Jimmy for ApexSOQLInjection
        If(IFSatisfactionClient){
            if(IFRelationnelClient || IFEnjeuxContractuels) {
                WhereCondidtion2 += ' And (genre_comite__c=:Satisfaction_client';
                firstElement2++;
            } else {
                WhereCondidtion2 += ' And (genre_comite__c=:Satisfaction_client)';
                firstElement2++;
            }
        }
        If(IFEnjeuxContractuels){
            if(firstElement2 == 1) {
                if(IFRelationnelClient) {
                    WhereCondidtion2 += ' And (genre_comite__c=:Enjeux_contractuels';
                    firstElement2++;
                } else {
                    WhereCondidtion2 += ' And (genre_comite__c=:Enjeux_contractuels)';
                    firstElement2++;
                }
            } else {
                if(IFRelationnelClient) {
                    WhereCondidtion2 += ' Or genre_comite__c=:Enjeux_contractuels';
                } else {
                    WhereCondidtion2 += ' Or genre_comite__c=:Enjeux_contractuels)';
                }
            }
        }
        If(IFRelationnelClient){
            if(firstElement2 == 1) {
                WhereCondidtion2 += ' And (genre_comite__c=:Relationnel_client)';
                firstElement2++;
            } else {
                WhereCondidtion2 += ' Or genre_comite__c=:Relationnel_client)';
            }
        }
        if(!IFSatisfactionClient && !IFEnjeuxContractuels && !IFRelationnelClient) {
            WhereCondidtion2 += ' And genre_comite__c!= :Relationnel_client And genre_comite__c!= :Enjeux_contractuels And genre_comite__c!= :Satisfaction_client And genre_comite__c!=null';
        }
        WhereCondidtion2 += ' And (Action_strategie_compte__c=true  OR Ajouter_au_plan_de_compte__c =true)';// show event in "plan de compte" only when type!=null and actionStrategieCompte is true
        string query2 = 'SELECT Id, WhatId, OwnerId, Subject, ActivityDate, genre_comite__c, Statut_Evenement__c,Owner.Name FROM Event WHERE ';
        query2 += WhereCondidtion2;

        //Modified By Jimmy for ApexSOQLInjection
        String query2Escaped = String.escapeSingleQuotes(query2);
        List<Event> ListEvents = Database.query(query2Escaped);

        for(Event theEvent : ListEvents) {
            WrapperPlan_d_actions MyWrapperEvent = new WrapperPlan_d_actions();
            MyWrapperEvent.TheTaskEvent = theEvent;

            MyWrapperEvent.status = 'rect';
            MyWrapperEvent.Type = 'Event';
            MyWrapperEvent.Realise = theEvent.Statut_Evenement__c;
            MyWrapperEvent.NonAcheve = false;

            if(theEvent.Statut_Evenement__c != 'Terminé' && theEvent.ActivityDate < date.today()) {
                MyWrapperEvent.NonAcheve = true;
            }
            if(theEvent.genre_comite__c != null) {
                MyWrapperEvent.genre_comite = theEvent.genre_comite__c.substring(0, 3);
            } else {
                MyWrapperEvent.genre_comite = 'Aucune';
            }
            MyWrapperList.add(MyWrapperEvent);
        }

        return MyWrapperList;
    }
}