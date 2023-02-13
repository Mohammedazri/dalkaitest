/**
* @author: Rita Bejjani -EI Technologies
* @date: 12/04/2019
* @description: Class that checks for Document_Contractuel__c of type 'Contrat' and for DC with ReferenceDuree__c equals true and StatutDocument__c =>actif
* @Test Class: AP52_DocumentContractuel_Test
* @Coverage: 92% 
*/
public class AP52_DocumentContractuel {
    
    /**
    * @author: Rita Bejjani -EI Technologies
    * @date: 12/04/2019 modifié le 20/06/2019
    * @description: The method displays an error when inserting a second Document_Contractuel__c of type 'Contrat' or 'Acte d'engagement' on a Contrat__c that already has one.  
    * @inputs: List<Document_Contractuel__c>
    * @returns: - 
    */
    public static void checkPreviousDcContrat(List<Document_Contractuel__c> newDC,String type)
    {
        List<id> listContratId = new List<id>();
        Set<Id> setDCId = new Set<Id>();
        
        for(Document_Contractuel__c dc : newDC)
        {
            if(dc.Contrat__c != null && (dc.NatureDocument__c == Label.AP52_DOC01  || dc.NatureDocument__c == Label.AP52_DOC02) )
            {
                listContratId.add(dc.Contrat__c);
                setDCId.add(dc.id);
            }
        }
        List<Contrat__c> contratList = new List<Contrat__c>();
        if(type=='update'){
            contratList = [select id,(select id,NumeroPiece__c,Contrat__c 
                                      from Documents_Contractuels__r 
                                      where (NatureDocument__c = :Label.AP52_DOC01 or NatureDocument__c = :Label.AP52_DOC02) and id not in :setDCId) 
                           from Contrat__c 
                           where id in :listContratId];
        }
        else{
            contratList = [select id,(select id,NumeroPiece__c,Contrat__c 
                                      from Documents_Contractuels__r 
                                      where NatureDocument__c = :Label.AP52_DOC01 or NatureDocument__c = :Label.AP52_DOC02) 
                           from Contrat__c 
                           where id in :listContratId];
        }
        
        
        map<id,integer> mapContratDC =  new map<id,integer>();
        Map<id,List<Document_Contractuel__c>> mapContratDocument =  new Map<id,List<Document_Contractuel__c>>();
        for (Contrat__c contrat : contratList)
        {
            if(contrat.Documents_Contractuels__r != null)
            {
                mapContratDC.put(contrat.Id, contrat.Documents_Contractuels__r.size());
                mapContratDocument.put(contrat.Id,contrat.Documents_Contractuels__r);
            }
            else{
                mapContratDC.put(contrat.Id, 0);
            }
        }
        Boolean innocentDocument = false;
        for(Document_Contractuel__c dc : newDC){ //  trigger new
            if(dc.NatureDocument__c ==Label.AP52_DOC01 || dc.NatureDocument__c ==Label.AP52_DOC02)
            {
                if(mapContratDC.containsKey(dc.Contrat__c)){ //map all docs
                    if(mapContratDC.get(dc.Contrat__c)>0) // map all docs #
                    {
                        dc.addError(Label.AP52_Error);
                    }
                    else
                    {
                        integer totalContrats = mapContratDC.get(dc.Contrat__c) +1;
                        mapContratDC.put(dc.Contrat__c,totalContrats);
                    }
                }
            }
        }
    }
    
    /**
    * @author: Rita Bejjani -EI Technologies
    * @date: 03/06/2019
    * @description: The method displays an error when inserting a second Document_Contractuel__c with the field ReferenceDuree__c checked on a Contrat__c that already has one.  
    * @inputs: List<Document_Contractuel__c>
    * @returns: - 
    */
    /*public static void checkPreviousDcContratDuree(List<Document_Contractuel__c> newDC, string action)
    {
        List<id> listContratId = new List<id>();
        List<id> listDCId = new List<id>();
        for(Document_Contractuel__c dc : newDC)
        {
            if(dc.Contrat__c != null && dc.ReferenceDuree__c == true)
            {
                listContratId.add(dc.Contrat__c);
                listDCId.add(dc.id);
            }
        }
        List<Contrat__c> contratList = new List<Contrat__c>();
        if(action.equals('insert')){
            contratList = [select id,(select id,NumeroPiece__c,Contrat__c,ReferenceDuree__c from Documents_Contractuels__r ) 
                           from Contrat__c 
                           where id in :listContratId];
        }
        else{
            contratList = [select id,(select id,NumeroPiece__c,Contrat__c,ReferenceDuree__c from Documents_Contractuels__r 
                                     where id not in : listDCId) 
                           from Contrat__c 
                           where id in :listContratId];
        }
        
        map<id,integer> mapContratDC =  new map<id,integer>();
        Map<id,List<Document_Contractuel__c>> mapContratDocument =  new Map<id,List<Document_Contractuel__c>>();
        for (Contrat__c contrat : contratList)
        {
            if(contrat.Documents_Contractuels__r != null)
            {
                mapContratDC.put(contrat.Id, contrat.Documents_Contractuels__r.size());
                mapContratDocument.put(contrat.Id,contrat.Documents_Contractuels__r);
            }
            else{
                mapContratDC.put(contrat.Id, 0);
            }
        }
        
        for(Document_Contractuel__c dc : newDC){
            if(mapContratDC.containsKey(dc.Contrat__c)){
                if(mapContratDC.get(dc.Contrat__c) > 0)
                {
                    for(Document_Contractuel__c dcc : mapContratDocument.get(dc.Contrat__c)){
                        if(dcc.ReferenceDuree__c == true)
                        {
                            dc.addError(Label.AP52_Error2);
                        }
                    }

                }
                else
                {
                    integer totalContrats = mapContratDC.get(dc.Contrat__c) +1;
                    mapContratDC.put(dc.Contrat__c,totalContrats);
                }
            }
        }
    }*/
    
    /**
    * @author: Rita Bejjani -EI Technologies
    * @date: 18/06/2019
    * @description: The method checks the fields ReferenceDuree__c (=> true) and StatutDocument__c (=> Actif) on the first DC inserted
    * @inputs: List<Document_Contractuel__c>
    * @returns: - 
    */
    public static void checkDcContratDuree(List<Document_Contractuel__c> newDC)
    {
        List<id> listContratId = new List<id>();
        
        for(Document_Contractuel__c dc : newDC)
        {
            if(dc.Contrat__c != null)
            {
                listContratId.add(dc.Contrat__c);
            }
        }
        List<Contrat__c> contratList = new List<Contrat__c>();
        
        contratList = [select id,(select id,NumeroPiece__c,Contrat__c,ReferenceDuree__c from Documents_Contractuels__r ) 
                       from Contrat__c 
                       where id in :listContratId];
               
        map<id,integer> mapContratDC =  new map<id,integer>();
        Map<id,List<Document_Contractuel__c>> mapContratDocument =  new Map<id,List<Document_Contractuel__c>>();
        for (Contrat__c contrat : contratList)
        {
            if(contrat.Documents_Contractuels__r != null)
            {
                mapContratDC.put(contrat.Id, contrat.Documents_Contractuels__r.size());
                mapContratDocument.put(contrat.Id,contrat.Documents_Contractuels__r);
            }
            else{
                mapContratDC.put(contrat.Id, 0);
            }
        }
        
        for(Document_Contractuel__c dc : newDC){
            if(mapContratDC.containsKey(dc.Contrat__c)){
                if(mapContratDC.get(dc.Contrat__c) == 0)
                {
                    dc.ReferenceDuree__c = true;
                    integer totalContrats = mapContratDC.get(dc.Contrat__c) +1;
                    mapContratDC.put(dc.Contrat__c,totalContrats);

                }
            }
        }
    }
    
     /**
    * @author: Rita Bejjani -EI Technologies
    * @date: 28/08/2019
    * @description: The method checks the field Avenant? on contrat__c when DC type is 'Avenant' or 'Lettre avenantaire'
    * @inputs: List<Document_Contractuel__c>
    * @returns: - 
    */
     public static void checkContratAvenant(List<Document_Contractuel__c> newDC,map<Id, Document_Contractuel__c> oldDC, string type)
    {
        Set<Id> setContratId = new Set<Id>();
        set<Id> setDCId = new Set<id>();
        
        for(Document_Contractuel__c dc : newDC)
        {
            if(dc.Contrat__c != null && dc.NatureDocument__c == Label.AP52_DOC05)
            {
                if(type == 'insert' || (type == 'update' && oldDC.get(dc.id).NatureDocument__c != dc.NatureDocument__c && oldDC.get(dc.id).NatureDocument__c !=Label.AP52_DOC05 ))
                {
                    if(!setContratId.contains(dc.Contrat__c))
                    {
                        setContratId.add(dc.Contrat__c);
                        setDCId.add(dc.id);
                    }
                }
            }
        }
        
        List<Contrat__c> contratList = [select id, Avenant__c, (select id,NumeroPiece__c,Contrat__c 
                                        from Documents_Contractuels__r 
                                        where NatureDocument__c = :Label.AP52_DOC05)
                       					from Contrat__c 
                       					where id in :setContratId];
        
        List<Contrat__c> contratLstToUpdate = new List<Contrat__c>();
        
        /*map<id,integer> mapContratDC =  new map<id,integer>();
        map<id, contrat__c> mapContrat = new map<id,contrat__c>();
        
        if(contratList != null)
        {
            for (Contrat__c contrat : contratList)
            {
                if(contrat.Documents_Contractuels__r != null)
                {
                    mapContratDC.put(contrat.Id, contrat.Documents_Contractuels__r.size());
                    system.debug('size '+ contrat.Documents_Contractuels__r.size());
                    
                }
                else{
                    mapContratDC.put(contrat.Id, 0);
                }
                mapContrat.put(contrat.id, contrat);
            }
        }
        
        for(Document_Contractuel__c dc : newDC)
        {
            if(mapContratDC.containsKey(dc.Contrat__c))
            {
                Contrat__c cont = mapContrat.get(dc.Contrat__c);
                
                if(cont.Avenant__c == Label.LC29_Non)
                {
                    cont.Avenant__c = Label.LC29_Oui; 
                }
                if(mapContratDC.get(dc.Contrat__c) == 0)
                {
                   cont.NumeroAvenant__c = 1;
                }
                else if(cont.NumeroAvenant__c != 99) 
                {
                    cont.NumeroAvenant__c = mapContratDC.get(dc.Contrat__c);
                }
                contratLstToUpdate.add(cont);
            }
        }*/
        
        for(Contrat__c cont : contratList)
        {
            if(cont.Avenant__c == Label.LC29_Non)
            {
                cont.Avenant__c = Label.LC29_Oui;
                
            }
            
            /*if(cont.NumeroAvenant__c == null)
            {
                cont.NumeroAvenant__c = 1;
                
            }else if(cont.NumeroAvenant__c != 99 )
            {
                cont.NumeroAvenant__c = cont.NumeroAvenant__c +1;
            }*/
            contratLstToUpdate.add(cont);
        }
        
        if(contratLstToUpdate.size()>0)
        {
            try{
                update contratLstToUpdate ;}
            catch(exception e){
                System.debug('#### update exception  ' + e );  
            }
        }
        
    }
}