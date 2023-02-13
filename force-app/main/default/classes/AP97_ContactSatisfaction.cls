/** 
* @author: Jacques Akiki
* @date: 31/05/2021 
* @description: Classe Apex qui prend en charge la gestion des Enquetes Crées à partir de SMILE 
* @Test: AP97_ContactSatisfaction_test
*/
public class AP97_ContactSatisfaction {
    /** 
* @author: Jacques Akiki
* @date: 31/05/2021 
* @description: méthode qui met à jour l'indicateur de satisfaction et la recommandation sur le contact
* @param list<Contact_Satisfaction__c 
* @return: void
*/
    public static void updateContact(list<Contact_Satisfaction__c> listCS){
        list<Contact> listCont = new list<Contact>();
        for(Contact_Satisfaction__c cs:listCS)
        {
            if(cs.Name.contains(Label.EnqSMILE)&&cs.NumeroEnquete__c==NULL)
            {
                Contact cont = new Contact(id=cs.Contact__c , 
                                           Indicateur_de_satisfaction__c = cs.IndicateurSatisfaction__c,
                                           Supporteur__c = cs.Recommandation__c);
                listCont.add(cont);
            }
        }
        if(listCont!=NULL && listCont.size()>0)
        {
            update listCont;
        }
    }
    
    /** 
* @author: Jacques Akiki
* @date: 31/05/2021 
* @description: Méthode qui renomme les Enquetes de satisfaction de SMILE
* @param list<Contact_Satisfaction__c> 
* @return: void
*/
    public static void updateName(list<Contact_Satisfaction__c> listCS){
        list<Contact_Satisfaction__c> listCSName = new list<Contact_Satisfaction__c>();
        integer insertedSmile = 0;
        String enqSmile = '%'+Label.EnqSMILE+' -%';
        for(Contact_Satisfaction__c cs:listCS)
        {
            /*if one of the inserted enquettes is coming from SMILE*/
            if(cs.Name.contains(Label.EnqSMILE)&&cs.NumeroEnquete__c==NULL)
            {
                insertedSmile = insertedSmile + 1;
                listCSName.add(cs);
            }
        }
        Integer lastInteger = 0;
        if(insertedSmile>0)
        {
            list<Contact_Satisfaction__c> listExist   = [SELECT id,Name,CreatedDate 
                                                         FROM Contact_Satisfaction__c 
                                                         WHERE name like :enqSmile order by Name DESC limit 1]; 
            if(listExist!=NULL && listExist.size()>0)
            {
                lastInteger = Integer.valueOf(listExist[0].Name.split(' - ')[1]); 
            }
            
            for(integer nameNumber = 0 ; nameNumber<insertedSmile ; nameNumber++)
            {   
                string num = String.valueOf(lastInteger+nameNumber+1);
                while(num.length()<6)
                {
                    num = '0'+num;
                }
                listCSName[nameNumber].name = Label.EnqSMILE + ' - '+num;  
            }
        }
    }
}