/*--------------------------------------------------------------------------------------------------------------------------
Author: Hussein FArran
Company: EI-Technologies
Description: Modify the date(date de fermeture) of the contrats fils if the parent date has been changed
Test Class: AP40_Contrat_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
05/04/2022	Jacques AKIKI	  Changer dans les paramètres des contrats fils à MAJ et lancer le Schedular
--------------------------------------------------------------------------------------------------------------------------*/
public without sharing class AP40_Contrat {
    
    public static void UpdateContratFils(List<Contrat__c> listContratParent)
    {
        List<Contrat__c> listContratFils = [SELECT id,name,SocieteVenteLookup__c,ContratCadre__c,DKCodeSurContrat__c,ZZZ_Tech_Bypass_VR08__c,Statut__c //,Date_de_fermeture__c
                                            FROM Contrat__c 
                                            WHERE ContratCadre__c in :listContratParent AND statut__c!=:Label.ContratFerme];
        //list<Contrat__c> listContratFilsSync = new list<contrat__c>();
        if(listContratFils!=NULL && listContratFils.size()>0){
            Map<id,Contrat__c> parentMap = new Map<id,Contrat__c>();
            for(Contrat__c contrat : listContratParent){
                parentMap.put(contrat.id,contrat);
            }
            set<Id> setContId = new set<id>();
            set<Id> contFilsMAJ = new set<Id>();
            for(Contrat__c contrat : listContratFils){
                //contrat.Date_de_fermeture__c = parentMap.get(contrat.ContratCadre__c).Date_de_fermeture__c;
                contrat.SocieteVenteLookup__c = parentMap.get(contrat.ContratCadre__c).SocieteVenteLookup__c;
                contrat.ZZZ_Tech_Bypass_VR08__c = !contrat.ZZZ_Tech_Bypass_VR08__c;
                /*
                if(contrat.DKCodeSurContrat__c!=NULL && contrat.Statut__c!='PREP'){
                    listContratFilsSync.add(contrat);
                }
				*/
                contFilsMAJ.add(contrat.Id);
            }
            
            PAD.PAD_BypassTrigger += ';AP48_ContractCallouts;';
            Database.SaveResult[] results = Database.update(listContratFils,false);
            PAD.PAD_BypassTrigger = PAD.PAD_BypassTrigger.replace(';AP48_ContractCallouts;','');
			/*            
            integer iterator = 0;
            for(Database.SaveResult sr:results){
                if(!sr.isSuccess()&&listContratFilsSync.contains(listContratFils[iterator])){
                   listContratFilsSync.remove(iterator);
                }
                iterator=iterator+1;
            }
            */
            
            Set<Id> successIds = new Set<Id>();
            for(Database.SaveResult sr:results){
                if(sr.isSuccess())
                {
                    successIds.add(sr.getId());
                }
            }
            
            List<Contrat__c> successContratsToSync = new List<Contrat__c>();
            List<Contrat__c> successContratsNonSync = new List<Contrat__c>();
            List<Contrat__c> failContrats = new List<Contrat__c>();
            
            Set<Id> contratToSyncIds = new Set<Id>();
            Set<Id> contratNonSyncIds = new Set<Id>();
            Set<Id> contratNoModifIds = new Set<Id>();
            
            for (Contrat__c  cont : listContratFils) {
                if (successIds.contains(cont.Id) && cont.DKCodeSurContrat__c != NULL && cont.Statut__c != 'PREP') {
                    successContratsToSync.add(cont);
                    contratToSyncIds.add(cont.Id);
                }
                else if(successIds.contains(cont.Id) && (cont.DKCodeSurContrat__c == NULL || cont.Statut__c == 'PREP'))
                {
                    successContratsNonSync.add(cont);
                    contratNonSyncIds.add(cont.Id);
                }
                else
                {
                    failContrats.add(cont);
                    contratNoModifIds.add(cont.Id);
                }
            }
            
            system.debug('*** successContratsToSync size = '+successContratsToSync.size());
            system.debug('*** contratToSyncIds = '+contratToSyncIds);
            system.debug('*** successContratsNonSync size = '+successContratsNonSync.size());
            system.debug('*** contratNonSyncIds = '+contratNonSyncIds);
            system.debug('*** failContrats size = '+failContrats.size());
            system.debug('*** contratNoModifIds = '+contratNoModifIds);
            
            integer filsSize = successContratsToSync.size();
            integer MaxSize = integer.valueof(Label.AP40_Batchsize);
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
                list<contrat__c> listContFils= new list<Contrat__c>();
                if(math.mod(filsSize, MaxSize)==0){
                    for(integer j=MaxSize*i;j<MaxSize*(i+1);j++){
                        listContFils.add(successContratsToSync[j]);
                    }
                }
                else{
                    if(i!=Times-1){
                        for(integer j=MaxSize*i;j<MaxSize*(i+1);j++){
                            listContFils.add(successContratsToSync[j]);
                        }
                    }
                    else{
                        for(integer j=(MaxSize*i);j<((MaxSize*i)+math.mod(filsSize, MaxSize));j++){
                            listContFils.add(successContratsToSync[j]);
                        }
                    }
                    
                }
                SCHD12_updateContratsFils.scheduleMe(GenerateCronExpression(dt,i+1),listContFils,'MAJ-CFils'+i+dt);                
            }
        }
    }
    
    /*Method to generate 1 minute seperated Cron Expressions to schedule by batches of 50 callouts*/ 
    public static String GenerateCronExpression(DateTime dt , integer min) {
        dt = dt.addMinutes(min);
        String CrExp ;
        CrExp = '0 '+(dt.minute())+' '+(dt.hour())+' '+(dt.day())+' '+(dt.month())+' '+' ? '+(dt.year()); 
        
        return CrExp;
    }
}