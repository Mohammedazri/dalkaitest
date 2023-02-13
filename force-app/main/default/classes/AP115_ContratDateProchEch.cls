/** 
* @author: Charbel Khoury Hanna
* @date: 29/08/2022
* @description: Calcul de la date de prochaine échéance avec le nombre de reconductions passées
* @Test: AP115_ContratDateProchEch(100%)
*/
public class AP115_ContratDateProchEch {
    
    public static Date DPE;
    public static Decimal NbrRecPasse = 0;
    
    public static void calculDateProchaineEcheance(List<Contrat__c> listContrats, map<ID, Contrat__c> oldContratMap){
        
        List<Contrat__c> AP115ListContrats = new List<Contrat__c>();
        
        if(Trigger.isUpdate)
        {
            for(Contrat__c cont : listContrats){
                if(cont.TypeReconduction__c != oldContratMap.get(cont.Id).TypeReconduction__c
                   || cont.DatePriseEffet__c != oldContratMap.get(cont.Id).DatePriseEffet__c
                   || cont.DureeInitialeContrat__c != oldContratMap.get(cont.Id).DureeInitialeContrat__c
                   || cont.DureeProlongationTotale__c != oldContratMap.get(cont.Id).DureeProlongationTotale__c
                   || cont.NombreReconductionsPassees__c != oldContratMap.get(cont.Id).NombreReconductionsPassees__c
                   || cont.DureeReconduction__c != oldContratMap.get(cont.Id).DureeReconduction__c
                   || cont.NombreReconductionsAutorisees__c != oldContratMap.get(cont.Id).NombreReconductionsAutorisees__c)
                {
                    AP115ListContrats.add(cont);
                }
            }
        }
        else
        {
            AP115ListContrats.addAll(listContrats);
        }
        
        List<Contrat__c> lstContratsErrors = new List<Contrat__c>();
        
        for(Contrat__c cont: AP115ListContrats)
        {
            NbrRecPasse = 0;
            
            //Contrat de type "Pas de reconduction"
            if(cont.TypeReconduction__c == 'RNUL')
            {
                //DPE = DE + DI + DuP - 1 jour
                cont.DateProchaineEcheance__c = cont.DatePriseEffet__c.addMonths(Integer.valueOf(Integer.valueOf(cont.DureeInitialeContrat__c != null ? cont.DureeInitialeContrat__c : 0) + Integer.valueOf(cont.DureeProlongationTotale__c != null ? cont.DureeProlongationTotale__c : 0))) -1;
            }
            //Contrat de type différent de "Pas de reconduction"
            else
            {
                if(cont.DureeReconduction__c != null && cont.DureeReconduction__c > 0)
                {
                    Map<Date,Decimal> mapDPE_NbrP = calculNombreDeReconduction(cont.DatePriseEffet__c, cont.DureeInitialeContrat__c != null ? cont.DureeInitialeContrat__c : 0, 0, cont.DureeReconduction__c != null ? cont.DureeReconduction__c : 0, cont.NombreReconductionsAutorisees__c != null ? cont.NombreReconductionsAutorisees__c : 0, cont.DureeProlongationTotale__c != null ? cont.DureeProlongationTotale__c : 0);
                    
                    for(Date dpe : mapDPE_NbrP.keySet())
                    {
                        cont.DateProchaineEcheance__c = dpe;
                        cont.NombreReconductionsPassees__c = mapDPE_NbrP.get(dpe);
                    }
                }
                else
                {
                    lstContratsErrors.add(cont);
                }
            }
        }
        
        if(lstContratsErrors.size() > 0)
        {
            for(Contrat__c cont : lstContratsErrors)
            {
                cont.addError(Label.AP115_ErrorMsg);
            }   
        }
    }
    
    public static Map<Date,Decimal> calculNombreDeReconduction(Date DE, Decimal DI, Decimal NbrP, Decimal DuR, Decimal NbrA, Decimal DuP){
        
        Map<Date,Decimal> mapDPE_NbrP = new Map<Date,Decimal>();
        
        //DPE = DE + DI + NbRP x DuR
        DPE = DE.addMonths(Integer.valueOf(Integer.valueOf(DI) + (Integer.valueOf(NbrP) * Integer.valueOf(DuR))));
        
        if(DPE > System.Today())
        {
            DPE = DPE -1;
        }
        else
        {
			if(NbrA == NbrP)
            {
                //DPE = DE + DI + DuP + NbRA x DuR - 1 jour
                DPE = DE.addMonths(Integer.valueOf(Integer.valueOf(DI) + Integer.valueOf(DuP) + (Integer.valueOf(NbrA) * Integer.valueOf(DuR)))) -1;
            }
            else
            {
                NbrRecPasse++;
                calculNombreDeReconduction(DE, DI, NbrRecPasse, DuR, NbrA, DuP);
            }
        }
        
        mapDPE_NbrP.put(DPE, NbrRecPasse);
        return mapDPE_NbrP;
    }
}