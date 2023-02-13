/*--------------------------------------------------------------------------------------------------------------------------
   Author: Jimmy Khalil
   Company: EI-Technologies
   Description: MAj des 4 champs de la section "Préférences contact client"
   Test Class: AP105_Contact_Test (100%)
   History
   <Date>      <Authors Name>   <Brief Description of Change>
   18/02/2022   Jimmy Khalil    Creation
   --------------------------------------------------------------------------------------------------------------------------*/
public class AP105_Contact {
    public static void setContactMailPreferences(List<contact> newListContact, Map<Id, contact> oldMapContact) {

        Map<String, Contact> mapEmailContact = new Map<String, Contact>();

        List<contact> newContactsToUpdate = new List<contact>();

        Set<String> setContactEmails = new Set<String>();
        Set<String> setContactIds = new Set<String>();

        //on verifie le mail pour les nouveaux contacts ou les contacts dont le mail est modifié
        for(Contact con : newListContact) {
            if(con.Email != null && (oldMapContact == null || con.Email != oldMapContact.get(con.Id).Email)) {
                setContactEmails.add(con.Email);
                setContactIds.add(con.Id);
                newContactsToUpdate.add(con);
            }
        }

        if(setContactEmails.size() > 0) {
            //verifier si on a des contacts avec le meme adresse mail
            List<Contact> relatedContacts = [SELECT Id, Email, HasOptedOutOfEmail, Ne_Souhaite_pas_etre_enquete__c,
                                             NeSouhaitePasRecevoirNosPromotions__c, NeSouhaitePasRecevoirNosInvitations__c
                                             FROM CONTACT
                                             WHERE Email in :setContactEmails AND Id not in :setContactIds];
            //reprendra les préférences contact des contacts
            // Prendre les préférences les plus restrictives
            if(relatedContacts != null && relatedContacts.size() > 0) {
                for(Contact relCon : relatedContacts) {
                    if(!mapEmailContact.containsKey(relCon.Email)) {
                        mapEmailContact.put(relCon.Email, new Contact(HasOptedOutOfEmail = false, Ne_Souhaite_pas_etre_enquete__c = false,
                                                                      NeSouhaitePasRecevoirNosPromotions__c = false, NeSouhaitePasRecevoirNosInvitations__c = false));
                    }
                    //il suffit d'avoir un seul contact avec un champ = true pour cocher ce champ,
                    //sinon, tous les contacts ont ce champ décocher et donc le champ reste décocher
                    if(relCon.HasOptedOutOfEmail == true) {
                        mapEmailContact.get(relCon.Email).HasOptedOutOfEmail = true;
                    }
                    if(relCon.Ne_Souhaite_pas_etre_enquete__c == true) {
                        mapEmailContact.get(relCon.Email).Ne_Souhaite_pas_etre_enquete__c = true;
                    }
                    if(relCon.NeSouhaitePasRecevoirNosPromotions__c == true) {
                        mapEmailContact.get(relCon.Email).NeSouhaitePasRecevoirNosPromotions__c = true;
                    }
                    if(relCon.NeSouhaitePasRecevoirNosInvitations__c == true) {
                        mapEmailContact.get(relCon.Email).NeSouhaitePasRecevoirNosInvitations__c = true;
                    }
                }
            }
        }
      
        for(Contact con : newContactsToUpdate) {
            if(mapEmailContact.containsKey(con.Email)) {
                
                con.HasOptedOutOfEmail = mapEmailContact.get(con.Email).HasOptedOutOfEmail;
                con.Ne_Souhaite_pas_etre_enquete__c = mapEmailContact.get(con.Email).Ne_Souhaite_pas_etre_enquete__c;
                con.NeSouhaitePasRecevoirNosPromotions__c = mapEmailContact.get(con.Email).NeSouhaitePasRecevoirNosPromotions__c;
                con.NeSouhaitePasRecevoirNosInvitations__c = mapEmailContact.get(con.Email).NeSouhaitePasRecevoirNosInvitations__c;
            } else {
                //Si la nouvelle adresse email n'existe pas, on mettra automatiquement à False les 4 champs de la section "Préférences contact client"
                con.HasOptedOutOfEmail = false;
                con.Ne_Souhaite_pas_etre_enquete__c = false;
                con.NeSouhaitePasRecevoirNosPromotions__c = false;
                con.NeSouhaitePasRecevoirNosInvitations__c = false;
            }
        }

    }
}