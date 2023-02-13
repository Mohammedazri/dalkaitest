/*--------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki
Company: EI-Technologies
Description: Class AP32 handles the fields Libelle_Agence__c , Agence_Rattachement__c, Tech_Libelle_Agence__c to fill them with the correct values
Test Class: AP32_ChangeInLabelAgence_test
date: 
--------------------------------------------------------------------------------------------------------------------------*/
public class AP32_ChangeInLabelAgence{
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki
Company: EI-Technologies
Description: Method LabelAgency sets the field Libelle_Agence__c and Libelle_Region__c on insert to the field Nom agence & Nom region on user  
Inputs:set of Ids , list of opportunities
Returns: -
--------------------------------------------------------------------------------------------------------------------------*/
    public static void LabelAgency(set<Id> setOwnerId, List<opportunity> listOpp){
        system.debug('setOwnerId ' + setOwnerId);
        system.debug('listOpp ' + listOpp);
        List<user> listUser = new list<User>( [SELECT id, name, Nom_agence__c, Nom_region__c, Organisation__c
                                               FROM User 
                                               WHERE id in: setOwnerId]);
        system.debug('listUser ' + listUser);
        Set<String> SetCodeAgence = new Set<String>();
        
        for ( User usr : listUser){
            SetCodeAgence.add( usr.Organisation__c);
        }
        system.debug('SetCodeAgence ' + SetCodeAgence);
        
        List<Agence__c> listAgence = new List<Agence__c> ( [ SELECT Id, name, Code_Agence__c,Region__c,DkCode__c
                                                           	 FROM Agence__c 
                                                             WHERE DkCode__c IN :SetCodeAgence]) ;
        system.debug('listAgence ' + listAgence);
        Map<Id,Agence__c> MapUserAgence = new  Map<Id,Agence__c>();
        
        for ( User usr : listUser){
            for ( Agence__c agc : listAgence ){
                system.debug(usr.Organisation__c + ' ' + agc.DkCode__c);
                if ( usr.Organisation__c == agc.DkCode__c){
                    MapUserAgence.put(usr.Id, agc);
                }
            }
        }
        system.debug('MapUserAgence ' + MapUserAgence);
        for(User usr : listUser){
            for(Opportunity opp : listOpp){
                if (opp.OwnerId==usr.id &&  MapUserAgence.get(usr.Id) != null )
                {
                    system.debug('usr.Id ' + usr.Id);
                    opp.Libelle_Agence__c = MapUserAgence.get(usr.Id).Id;
                    system.debug('opp.Libelle_Agence__c ' + opp.Libelle_Agence__c);
                    //opp.Libelle_Region__c = MapUserAgence.get(usr.Id).Region__c;
                    //opp.Libelle_Agence__c = usr.Nom_agence__c;
                    //opp.Libelle_Region__c = usr.Nom_region__c;
                }
            }
        }
    }
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki
Company: EI-Technologies
Description: Method LabelAgencyUpdate sets the field Libelle_Agence__c to the field Agence_Rattachement__r.Name when the 
field Agence_Rattachement__c changes.
Inputs:set of Ids
Returns: -
--------------------------------------------------------------------------------------------------------------------------*/
    /*public static void LabelAgencyUpdate(List<Opportunity> lstOpp ,Set<Id> setAgenceIds)
    {
        
        Map<Id, Agence__c> mapAgence = new Map<Id, Agence__c> ( [SELECT id, Name, Region__r.name 
                                                                 FROM Agence__c
                                                                 WHERE Id IN :setAgenceIds]);
        System.debug('mapAgence--->>>> '+mapAgence);
        Agence__c agence = null;
        for ( Opportunity opp : lstOpp ){
            if( mapAgence.containsKey(opp.Agence_Rattachement__c)){             
                agence = mapAgence.get(opp.Agence_Rattachement__c);
                
                 System.debug('agence------>>>> '+ Agence);
                opp.Libelle_Agence__c = agence.Name;
                opp.Libelle_Region__c = agence.region__r.Name;            
            }   
        } 
    }*/
}