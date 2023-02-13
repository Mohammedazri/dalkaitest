/**
* @author Charbel Khoury Hanna - EIT Mena
* @date 11/15/2022
* @description Recalculer la date de prochaine echeance sur les contrats deja existant avant le chantier date et duree
* @Test Class Batch132_Test 100%
*/

global class Batch132_RecalculDateProchaineEcheance implements Database.Batchable<SObject> {
	
    global Database.QueryLocator start(Database.BatchableContext bc){
        String statutFER = Label.ContratFerme;
        String query = 'select id, TypeReconduction__c,DatePriseEffet__c,DureeInitialeContrat__c,DureeProlongationTotale__c,NombreReconductionsPassees__c,DureeReconduction__c,'
                       +'NombreReconductionsAutorisees__c from Contrat__c where Statut__c != :statutFER and DureeReconduction__c > 0 ';
        return Database.getQueryLocator(query);
    }
    
    global void execute (Database.BatchableContext bc, List<Contrat__c> listContrat){
        
        for(Contrat__c cont: listContrat)
        {
            if(cont.TypeReconduction__c == 'RNUL')
            {
                //DPE = DE + DI + DuP - 1 jour
                cont.DateProchaineEcheance__c = cont.DatePriseEffet__c.addMonths(Integer.valueOf(Integer.valueOf(cont.DureeInitialeContrat__c != null ? cont.DureeInitialeContrat__c : 0) + Integer.valueOf(cont.DureeProlongationTotale__c != null ? cont.DureeProlongationTotale__c : 0))) -1;
            }
            else
            {
                if(cont.DureeReconduction__c != null && cont.DureeReconduction__c > 0)
                {
                    AP115_ContratDateProchEch.NbrRecPasse = 0;
                    
                    Map<Date,Decimal> mapDPE_NbrP = AP115_ContratDateProchEch.calculNombreDeReconduction(cont.DatePriseEffet__c, cont.DureeInitialeContrat__c != null ? cont.DureeInitialeContrat__c : 0, cont.NombreReconductionsPassees__c != null ? cont.NombreReconductionsPassees__c : 0, cont.DureeReconduction__c != null ? cont.DureeReconduction__c : 0, cont.NombreReconductionsAutorisees__c != null ? cont.NombreReconductionsAutorisees__c : 0, cont.DureeProlongationTotale__c != null ? cont.DureeProlongationTotale__c : 0);
                    
                    for(Date dpe : mapDPE_NbrP.keySet())
                    {
                        cont.DateProchaineEcheance__c = dpe;
                        cont.NombreReconductionsPassees__c = mapDPE_NbrP.get(dpe);
                    }
                }
            }
        }
        
        update listContrat;
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
}