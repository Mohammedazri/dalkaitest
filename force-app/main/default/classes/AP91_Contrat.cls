/** 
* @author Jacques Akiki
* @date 02/09/2020 
* @description class that updates the field projet Finance on Opportunity
* @Test Class AP91_Contrat_test 98%
*/
public class AP91_Contrat {
    /** 
* @author Jacques Akiki
* @date 03/09/2020
* @Si LienContratTacheFinance__c est créé, mis à jour ou supprimer
* @param List<LienContratTacheFinance__c> : list des Liens Contrats taches finance en train de se créer, modifier , supprimer
* @return void
*/
    public static void filterLCT(List<LienContratTacheFinance__c> listLCT, map<id,LienContratTacheFinance__c> mapOldLCT)
    {
        /*insert case*/
        if (mapOldLCT==NULL)
        {
            set<id> setcontId = new set<id>();
            for(LienContratTacheFinance__c lct:listLCT)
            {
                setcontId.add(lct.contrat__c);
            }
            List<LienContratTacheFinance__c> listLCTAll = [SELECT id,Contrat__c, ProjetFinance__c ,ProjetFinance__r.DKcode__c ,ProjetFinance__r.Name  
                                                           FROM LienContratTacheFinance__c 
                                                           WHERE contrat__c in: setcontId];
            if(listLCTAll!=NULL && listLCTAll.size()>0)
            {
                setProjetFinanceTF(listLCTAll);
            }
        }
        /*Update case*/
        if(mapOldLCT!=NULL && listLCT!=NULL)
        {
            set<id> setcontId = new set<id>();
            for(LienContratTacheFinance__c lct:listLCT)
            {
                
                if(lct.ProjetFinance__c!=mapOldLCT.get(lct.id).ProjetFinance__c || lct.Contrat__c!=mapOldLCT.get(lct.id).Contrat__c)
                {
                    setcontId.add(lct.contrat__c);
                    setcontId.add(mapOldLCT.get(lct.id).Contrat__c);
                }
            }
            List<LienContratTacheFinance__c> listLCTUpdated = [SELECT id,Contrat__c, ProjetFinance__c,ProjetFinance__r.DKcode__c ,ProjetFinance__r.Name    
                                                               FROM LienContratTacheFinance__c 
                                                               WHERE contrat__c in: setcontId];
            
            if(listLCTUpdated!=NULL && listLCTUpdated.size()>0)
            {
                setProjetFinanceTF(listLCTUpdated);
            }
        }
        /*Delete case*/
        if(mapOldLCT!=NULL && listLCT==NULL)
        {
            map<id,double> mapContratPF = new map<id,double>();
            set<id> setcontIdUpdate = new set<id>();
            for(LienContratTacheFinance__c lct:mapOldLCT.values())
            {
                mapContratPF.put(lct.contrat__c,0);
            }
            List<LienContratTacheFinance__c> listLCTdeleted = [SELECT id,Contrat__c, ProjetFinance__c, ProjetFinance__r.DKcode__c ,ProjetFinance__r.Name   
                                                               FROM LienContratTacheFinance__c 
                                                               WHERE contrat__c in: mapContratPF.keyset()];
            for(LienContratTacheFinance__c lct:listLCTdeleted)
            {
                mapContratPF.put(lct.contrat__c,1);
            }
            for(id contId:mapContratPF.keyset())
            {
                if(mapContratPF.get(contId)==0)
                {
                    setcontIdUpdate.add(contid);
                }
            }
            if(listLCTdeleted!=NULL && listLCTdeleted.size()>0)
            {
                setProjetFinanceTF(listLCTdeleted);
            }
            if(setcontIdUpdate!=NULL && setcontIdUpdate.size()>0)
            {
                setProjetFinanceTFDel(setcontIdUpdate);
            }
        }
    }
    
    /** 
* @author Jacques Akiki
* @date 03/09/2020
* @Si Projet Finance est mis à jour mettre à jour le contrat.
* @param List<LienContratTacheFinance__c> : list des Liens Contrats taches finance en train de se créer, modifier , supprimer
* @return void
*/
    public static void filterPF(List<ProjetFinance__c> listPF, map<id,ProjetFinance__c> mapOldPF)
    {
        List<ProjetFinance__c> listPFUpdated = new List<ProjetFinance__c>();
        for(ProjetFinance__c pf:listPF)
        {
            if(pf.DkCode__c!=mapOldPF.get(pf.id).DkCode__c || pf.Name!=mapOldPF.get(pf.id).Name)
            {
                listPFUpdated.add(pf);
            } 
        }
        if(listPFUpdated!=NULL && listPFUpdated.size()>0)
        {
            setProjetFinancePF(listPFUpdated);
        }
    }
    /** 
* @author Jacques Akiki
* @date 02/09/2020
* @Mapper projet finance aux contrats correspondant a partir de lien tache finance.
* @param List<LienContratTacheFinance__c> : list des Liens Contrats taches finance en train de se créer, modifier , supprimer
* @return void
*/
    public static void setProjetFinanceTF(List<LienContratTacheFinance__c> listLCT)
    {
        map<id,set<ProjetFinance__c>> mapContsetPF = new map<id,set<ProjetFinance__c>>();
        
        for(LienContratTacheFinance__c lct:listLCT)
        {
            if(!mapContsetPF.containsKey(lct.contrat__c))
            {
                mapContsetPF.put(lct.contrat__c,new set<ProjetFinance__c>());
            }
            mapContsetPF.get(lct.contrat__c).add(new ProjetFinance__c(id=lct.ProjetFinance__c,Name=lct.projetFinance__r.Name , DKcode__c = lct.projetFinance__r.DkCode__c));
        }
        if(mapContsetPF!=NULL && mapContsetPF.keyset().size()>0)
        {
            setProjetFinance(mapContsetPF);
        }
    }
    
    /** 
* @author Jacques Akiki
* @date 02/09/2020
* @Mapper projet finance aux contrats correspondant a partir de projet finance
* @param List<ProjetFinance__c> : list des projets finances en train de se modifier ou mis à jour
* @return void
*/
    public static void setProjetFinancePF(List<ProjetFinance__c> listPF)
    {
        set<id>setPFid = new set<id>();
        
        for(ProjetFinance__c pf:listPF)
        {
            setPFid.add(pf.id);
        }
        List<LienContratTacheFinance__c>listLCT = [SELECT id,Contrat__c, ProjetFinance__c 
                                                   FROM LienContratTacheFinance__c 
                                                   WHERE ProjetFinance__c in:setPFid];
        set<id> setContId = new set<id>();
        for(LienContratTacheFinance__c lct:listLCT)
        {
            setContId.add(lct.Contrat__c);
        }
        if(setContId!=NULL && setContId.size()>0)
        {
            listLCT = [SELECT id,Contrat__c, ProjetFinance__c ,ProjetFinance__r.DKcode__c ,ProjetFinance__r.Name 
                       FROM LienContratTacheFinance__c 
                       WHERE contrat__c in:setContId];
            if(listLCT!=NULL && listLCT.size()>0)
            {
                setProjetFinanceTF(listLCT);
            }
        }
    }
    
    /** 
* @author Jacques Akiki
* @date 03/09/2020
* @ vider le champ projet Finance sur contrat si plus de liens tache finance associées.
* @param set<id> des contrats a mettre à jour 
* @return void
*/
    public static void setProjetFinanceTFDel(set<id>setContPF )
    {
        list<Contrat__c> listContUpdate = new list<Contrat__c>();
        for(id contId:setContPF)
        {
            Contrat__c cont = new contrat__c();
            cont.id = contId;
            cont.Projet_Finance__c = '';
            listContUpdate.add(cont);
        }
        if(listContUpdate!=NULL && listContUpdate.size()>0)
        {
            update listContUpdate;
        }
    }
    /** 
* @author Jacques Akiki
* @date 02/09/2020
* @ met à jour le champ Projet Finance sur contrat avec les enregistrements associées tout en de depassant pas les 255 caractères. 
* @param map<id,set<LienContratTacheFinance__c>> de l'id du contrat avec les projets finances associées
* @return void
*/
    public static void setProjetFinance(map<id,set<ProjetFinance__c>> mapContsetPF )
    {
        list<Contrat__c> listContUpdate = new list<Contrat__c>();
        for(id contId:mapContsetPF.keyset())
        {
            String PFName='';
            String PFName1='';
            Contrat__c cont = new Contrat__c();
            cont.id = contId;
            
            for (ProjetFinance__c pf:mapContsetPF.get(contId))
            {
                PFName = PFName + (pf.DkCode__c==NULL?'':pf.DkCode__c)+' - '+pf.Name+',';
                PFName1 =PFName1 + (pf.DkCode__c==NULL?'':pf.DkCode__c)+',';
            }
            if (PFName.length()>255)
            {
                if(PFName1.length()>255)
                {
                    cont.Projet_Finance__c = PFName1.substring(0,252)+'...';
                    listContUpdate.add(cont);
                }
                else
                {
                    cont.Projet_Finance__c = PFName1.substring(0,PFName1.length()-1); 
                    listContUpdate.add(cont);
                }
            }
            else
            {
                cont.Projet_Finance__c = PFName.substring(0,PFName.length()-1); 
                listContUpdate.add(cont); 
            }
        }
        if(listContUpdate!=NULL && listContUpdate.size()>0)
        {
            update listContUpdate;
        }
    }
}