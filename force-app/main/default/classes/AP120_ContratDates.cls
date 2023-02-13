/** 
* @author: Charbel Khoury Hanna
* @date: 12/16/2022
* @description: Recalculer la date de prochaine échéance lorsque la date de jour dépasse la date de prochaine échéance (à J+1)
* @Test: AP120_ContratDates_Test(100%)
*/
public class AP120_ContratDates {

    public static Date DPE;
    public static Decimal NbrRecPasse = 0;
    public static Integer nbrSeconds = 60;
    
    public static void recalculerDPE(List<Contrat__c> listContrats){
        
        String errorIds = '';
        Map<Id,String> mapContratError = new Map<Id,String>();
        
        for(Contrat__c cont: listContrats)
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
                    errorIds += cont.id + '-' + 'DureeReconduction null,';
                    mapContratError.put(cont.Id, 'DureeReconduction null,');
                }
            }
        }
        
        PAD.PAD_BypassTrigger += ';AP48_ContractCallouts;AP115_ContratDateProchEch;';
        Database.SaveResult[] results = Database.update(listContrats,false);
        PAD.PAD_BypassTrigger = PAD.PAD_BypassTrigger.replace(';AP48_ContractCallouts;','');
        PAD.PAD_BypassTrigger = PAD.PAD_BypassTrigger.replace(';AP115_ContratDateProchEch;','');
        
        Set<Id> successIds = new Set<Id>();
        
        for(Database.SaveResult sr:results){
            if(sr.isSuccess())
            {
                successIds.add(sr.getId());
            }
            else
            {
                errorIds += sr.getId() + '-' + sr.getErrors()[0].getMessage() + ',';
                mapContratError.put(sr.getId(), sr.getErrors()[0].getMessage() + ',');
            }
        }
        
        String body = 'Contrat error info:\n';
        for (Contrat__c cont: listContrats) {
            if(mapContratError.containsKey(cont.id))
            {
                body += cont.id +'-'+ mapContratError.get(cont.Id) + '-' + cont.LibelleRegion__c + '-' + cont.Nom_d_Agence__c + '-' + cont.techOwner__c + '\n';
            }
        }

        if(errorIds.length() > 1 || Test.isRunningTest())
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            // Set the recipient
            mail.setToAddresses(new String[] {'charbel.hanna@eit-mena.com'});
            
            // Set the subject
            mail.setSubject('AP120_ContratDates error result');
            
            // Set the body
            errorIds = errorIds.removeEnd(',');
            mail.setPlainTextBody(body);
            
            // Send the email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });   
        }
        
        List<Contrat__c> successContratsToSync = new List<Contrat__c>();
        
        for (Contrat__c  cont : listContrats){
            if(successIds.contains(cont.Id)){
                successContratsToSync.add(cont);
            }
        }
        
        integer filsSize = successContratsToSync.size();
        integer MaxSize = integer.valueof(Label.AP120_BatchSize);
        integer Times = 0;
        if(math.mod(filsSize, MaxSize)!=0)
        {
            Times = (filsSize/MaxSize) + 1;
        }
        else 
        {
            Times = (filsSize/MaxSize);
        }
        
        for(integer i=0;i<Times; i++){
            dateTime dt = DateTime.now();
            nbrSeconds = nbrSeconds + Integer.valueOf(Label.AP120_BatchTime);
            list<contrat__c> listContRecalcul= new list<Contrat__c>();
            if(math.mod(filsSize, MaxSize)==0){
                for(integer j=MaxSize*i;j<MaxSize*(i+1);j++){
                    listContRecalcul.add(successContratsToSync[j]);
                }
            }
            else{
                if(i!=Times-1){
                    for(integer j=MaxSize*i;j<MaxSize*(i+1);j++){
                        listContRecalcul.add(successContratsToSync[j]);
                    }
                }
                else{
                    for(integer j=(MaxSize*i);j<((MaxSize*i)+math.mod(filsSize, MaxSize));j++){
                        listContRecalcul.add(successContratsToSync[j]);
                    }
                }
            }
            SCHD14_recalculDPE.scheduleMe(GenerateCronExpression(dt,nbrSeconds),listContRecalcul,'MAJ-Contrat-RecalculDPE'+i+dt);
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
    
    /*Method to generate 1 minute seperated Cron Expressions to schedule by batches of 50 callouts*/ 
    public static String GenerateCronExpression(DateTime dt , integer seconds) {
        //dt = dt.addMinutes(min);
        dt = dt.addSeconds(seconds);
        String CrExp ;
        //CrExp = '0 '+(dt.minute())+' '+(dt.hour())+' '+(dt.day())+' '+(dt.month())+' '+' ? '+(dt.year()); 
        CrExp = '' + dt.second() + ' ' + dt.minute() + ' ' + dt.hour() + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        
        return CrExp;
    }
}