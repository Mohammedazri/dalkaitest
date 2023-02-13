/**
*@author Alain Ghoussoub
*@date 18/02/2020
*@description List of functions thap map salesforce fields to WS fields - Adresse
*/
public class Adresse_Mapper {
    /* public static wwwDalkiaFrReferentielPartenaire.consulterAdresseRequete fillConsulterAdresseRequete(Account acc){
wwwDalkiaFrReferentielPartenaire.consulterAdresseRequete retVal = new wwwDalkiaFrReferentielPartenaire.consulterAdresseRequete();
//retval.DKCodeAdresse = acc.dkc
return retVal;
} */
    
    /* public static Account getConsulterAdresseRequete(wwwDalkiaFrReferentielPartenaire.consulterAdresseReponse retVal){
Account accountToInsert = new Account();
String code = retVal.informationsRetour.codeRetour;
if(retVal.adresse!=null){
accountToInsert.DKCodeSurPartenaire__c = retval.adresse.DKCodePartenaire;
//accountToInsert.dk  = retval.DKCodeSociete;
accountToInsert.Utilisation_filiere_Commerce__c = 'Inactif';
if(retVal.adresse.utilisationFiliereCommerce!=null && retVal.adresse.utilisationFiliereCommerce==true){
accountToInsert.Utilisation_filiere_Commerce__c = 'Actif';
}
accountToInsert.Utilisation_Filiere_Achat__c = retval.adresse.utilisationFiliereAchats;
//retval.adresse.categorieSociete; ne pas maper 
accountToInsert.NaturePartenaire__c = retval.adresse.naturePartenaire;
if(retVal.adresse.listeAdresses!=null){
if(retVal.adresse.listeAdresses.adresse!=null){
for(wwwDalkiaFrReferentielPartenaire.adresse add : retVal.adresse.listeAdresses.adresse){
if(add.adressePrincipale != null && add.adressePrincipale == true ){
//accountToInsert.?? = add.DKCodeAdresse;
//accountToInsert.?? = add.adressePrincipale;
accountToInsert.Statut_adresse_1__c = add.statutAdresse;
accountToInsert.PrecisionDestinataire__c = add.precisionDestinataire;
accountToInsert.PrecisionIdentificationAdresse__c = add.precisionIdentificationAdresse;

accountToInsert.BillingStreet = '';
if(add.numeroVoie != null){
//resp = ValidateWSFields.validateTextField('numeroVoie',100,add.numeroVoie,resp);
accountToInsert.BillingStreet += add.numeroVoie + ' ';
}
if(add.typeDeVoie != null){
//resp = ValidateWSFields.validateTextField('typeDeVoie',100,add.typeDeVoie,resp);
accountToInsert.BillingStreet += add.typeDeVoie + ' ';
}
if(add.libelleVoie != null ){
//resp = ValidateWSFields.validateTextField('libelleVoie',100,add.libelleVoie,resp);
accountToInsert.BillingStreet += add.libelleVoie;
}
accountToInsert.ComplementAdresse__c = add.complementAdresse;  
accountToInsert.BillingPostalCode = add.codePostal;
accountToInsert.BillingCity = add.ville;
accountToInsert.BillingCountry = add.pays;
accountToInsert.Phone = add.telephone;
accountToInsert.fax = add.fax;
accountToInsert.Code_Client_Oracle__c = add.codeClientOracle;
accountToInsert.Numero_fournisseur_DK_client__c = add.codeFournisseurOracle;
accountToInsert.Reference_adresse__c = add.referenceAdresseClient;
accountToInsert.Reference_adresse_2__c = add.referenceAdresseFournisseur;
accountToInsert.Dematerialise__c = add.dematerialise;
//affacturage (champs en rouge, a verifier)
if(add.listeMandataires != null && add.listeMandataires.mandataire.size()>0){
accountToInsert.DKC_Partenaire_Mandataire__c = add.listeMandataires.mandataire.get(0).DKCPartenaireMandataire;
accountToInsert.DKC_Adresse_Partenaire_Mandataire__c = add.listeMandataires.mandataire.get(0).DKCAdressePartenaireMandataire;
accountToInsert.Statut_Lien_Mandataire__c = add.listeMandataires.mandataire.get(0).statutLienMandataire;
}
if(add.metadonneesAdressePartenaire!=null){
//accountToInsert.?? = add.metadonneesAdressePartenaire.creationDate;
//accountToInsert.?? = add.metadonneesAdressePartenaire.creationId;
//accountToInsert.?? = add.metadonneesAdressePartenaire.updateDate;
//accountToInsert.?? = add.metadonneesAdressePartenaire.updateId;

accountToInsert.ValidationDate__c = add.metadonneesAdressePartenaire.validationDate;
//accountToInsert.?? = add.metadonneesAdressePartenaire.validationId;


try {
User usr = [ select id,name,ReferentielId__c from user where ReferentielId__c = :add.metadonneesAdressePartenaire.validationId limit 1];
if ( usr !=null ){
accountToInsert.ValidationId__c   = usr.Id;                   
}
}
Catch( Exception e ){
System.debug('Exception e : ' + e.getMessage());
}



}
}
}
}
}
}
return accountToInsert;
}*/
    
    /*public static wwwDalkiaFrReferentielPartenaire.creerAdresseRequete fillCreerAdresseRequete(Account acc){
wwwDalkiaFrReferentielPartenaire.creerAdresseRequete retVal = new wwwDalkiaFrReferentielPartenaire.creerAdresseRequete();
retVal.adresse.DKCodePartenaire = acc.Statut_adresse_1__c;
retVal.adresse.adresse.DKCodeAdresse = '';
//retVal.adresse.adresse.adressePrincipale = '';
retVal.adresse.adresse.precisionDestinataire = '';
retVal.adresse.adresse.precisionIdentificationAdresse = '';

List<String> lstBilling = getBillingAddressFields(acc.BillingStreet);
retVal.adresse.adresse.numeroVoie = lstBilling[0];
retVal.adresse.adresse.typeDeVoie = lstBilling[1];
retVal.adresse.adresse.libelleVoie = lstBilling[2];

retVal.adresse.adresse.complementAdresse = acc.ComplementAdresse__c;
retVal.adresse.adresse.codePostal = '';
retVal.adresse.adresse.ville = '';
retVal.adresse.adresse.pays = '';
retVal.adresse.adresse.telephone = '';
retVal.adresse.adresse.fax = '';
retVal.adresse.adresse.codeClientOracle = '';
retVal.adresse.adresse.codeFournisseurOracle = '';
retVal.adresse.adresse.referenceAdresseClient = '';
retVal.adresse.adresse.referenceAdresseFournisseur = '';
//retVal.adresse.adresse.dematerialise = '';

retVal.adresse.adresse.listeAffacturages.affacturage = new List<wwwDalkiaFrReferentielPartenaire.affacturageA1>();
wwwDalkiaFrReferentielPartenaire.affacturageA1 aff =  new wwwDalkiaFrReferentielPartenaire.affacturageA1();
//aff.DKCPartenaireAffacturage='';
//aff.DKCAdressePartenaireAffacturage='';
//aff.statutLienAffacturage='';
retVal.adresse.adresse.listeAffacturages.affacturage.add(aff);

retVal.adresse.adresse.listeMandataires.mandataire = new List<wwwDalkiaFrReferentielPartenaire.mandataireA1>();
wwwDalkiaFrReferentielPartenaire.mandataireA1 mand = new wwwDalkiaFrReferentielPartenaire.mandataireA1();
mand.DKCPartenaireMandataire = '';
mand.DKCAdressePartenaireMandataire = '';
//mand.statutLienMandataire = '';
retVal.adresse.adresse.listeMandataires.mandataire.add(mand);

//retVal.adresse.adresse.metadonneesAdressePartenaire.creationDate = '';
retVal.adresse.adresse.metadonneesAdressePartenaire.creationId = '';
//retVal.adresse.adresse.metadonneesAdressePartenaire.updateDate = '';
retVal.adresse.adresse.metadonneesAdressePartenaire.updateId = '';
//retVal.adresse.adresse.metadonneesAdressePartenaire.validationDate = '';
retVal.adresse.adresse.metadonneesAdressePartenaire.validationId = '';
return retVal;
}*/
    
    /*public static Account getCreerAdresseRequete(wwwDalkiaFrReferentielPartenaire.creerAdresseReponse retVal){
Account accountToInsert = new Account();
String code = retVal.informationsRetour.codeRetour;
if(retVal.adresse!=null){
accountToInsert.DKCodeSurPartenaire__c = retval.adresse.DKCodePartenaire;
//accountToInsert.dk  = retval.DKCodeSociete;
accountToInsert.Utilisation_filiere_Commerce__c = 'Inactif';
if(retVal.adresse.utilisationFiliereCommerce!=null && retVal.adresse.utilisationFiliereCommerce==true){
accountToInsert.Utilisation_filiere_Commerce__c = 'Actif';
}
accountToInsert.Utilisation_Filiere_Achat__c = retval.adresse.utilisationFiliereAchats;
//retval.adresse.categorieSociete;
accountToInsert.NaturePartenaire__c = retval.adresse.naturePartenaire;
if(retVal.adresse.listeAdresses!=null){
if(retVal.adresse.listeAdresses.adresse!=null){
for(wwwDalkiaFrReferentielPartenaire.adresse add : retVal.adresse.listeAdresses.adresse){
if(add.adressePrincipale != null && add.adressePrincipale == true ){
accountToInsert.DkCodeAdressePrincipale__c? = add.DKCodeAdresse;
//accountToInsert.?? = add.adressePrincipale;
accountToInsert.Statut_adresse_1__c = add.statutAdresse;
//accountToInsert.?? = add.precisionDestinataire;
//accountToInsert.?? = add.precisionIdentificationAdresse;
accountToInsert.BillingStreet = '';
if(add.numeroVoie != null){
//resp = ValidateWSFields.validateTextField('numeroVoie',100,add.numeroVoie,resp);
accountToInsert.BillingStreet += add.numeroVoie + ' ';
}
if(add.typeDeVoie != null){
//resp = ValidateWSFields.validateTextField('typeDeVoie',100,add.typeDeVoie,resp);
accountToInsert.BillingStreet += add.typeDeVoie + ' ';
}
if(add.libelleVoie != null ){
//resp = ValidateWSFields.validateTextField('libelleVoie',100,add.libelleVoie,resp);
accountToInsert.BillingStreet += add.libelleVoie;
}
accountToInsert.ComplementAdresse__c = add.complementAdresse;  
accountToInsert.BillingPostalCode = add.codePostal;
accountToInsert.BillingCity = add.ville;
accountToInsert.BillingCountry = add.pays;
accountToInsert.Phone = add.telephone;
accountToInsert.fax = add.fax;
//accountToInsert.?? = add.codeClientOracle;
accountToInsert.Numero_fournisseur_DK_client__c = add.codeFournisseurOracle;
accountToInsert.Reference_adresse__c = add.referenceAdresseClient;
accountToInsert.Reference_adresse_2__c = add.referenceAdresseFournisseur;
//accountToInsert.?? = add.dematerialise;
//affacturage (champs en rouge, a verifier)
if(add.listeMandataires != null && add.listeMandataires.mandataire.size()>0){
accountToInsert.DKC_Partenaire_Mandataire__c = add.listeMandataires.mandataire.get(0).DKCPartenaireMandataire;
accountToInsert.DKC_Adresse_Partenaire_Mandataire__c = add.listeMandataires.mandataire.get(0).DKCAdressePartenaireMandataire;
accountToInsert.Statut_Lien_Mandataire__c = add.listeMandataires.mandataire.get(0).statutLienMandataire;
}
if(add.metadonneesAdressePartenaire!=null){
//accountToInsert.?? = add.metadonneesAdressePartenaire.creationDate;
//accountToInsert.?? = add.metadonneesAdressePartenaire.creationId;
//accountToInsert.?? = add.metadonneesAdressePartenaire.updateDate;
//accountToInsert.?? = add.metadonneesAdressePartenaire.updateId;
//accountToInsert.?? = add.metadonneesAdressePartenaire.validationDate;
//accountToInsert.?? = add.metadonneesAdressePartenaire.validationId;
}
}
}
}
}
}
return accountToInsert;
}*/
    
    public static wwwDalkiaFrReferentielPartenaire.modifierAdresseRequete fillModifierAdresseRequete(Account acc){
        wwwDalkiaFrReferentielPartenaire.modifierAdresseRequete retVal = new wwwDalkiaFrReferentielPartenaire.modifierAdresseRequete();
        retVal.adresse =  new wwwDalkiaFrReferentielPartenaire.adressePartenaireA2(); 
        retVal.adresse.DKCodePartenaire = acc.DKCodeSurPartenaire__c;
        retVal.adresse.adresse = new wwwDalkiaFrReferentielPartenaire.adresseA2();
        retVal.adresse.adresse.DKCodeAdresse = acc.DkCodeAdressePrincipale__c;
        retVal.adresse.adresse.adressePrincipale = true;
        retVal.adresse.adresse.statutAdresse = 'ACTIF';
        retVal.adresse.adresse.precisionDestinataire = acc.PrecisionDestinataire__c;
        retVal.adresse.adresse.precisionIdentificationAdresse = acc.PrecisionIdentificationAdresse__c;
        
        List<String> lstBilling = getBillingAddressFields(acc.BillingStreet);
        if(!lstBilling[0].equals(''))
        {
        	retVal.adresse.adresse.numeroVoie = lstBilling[0];    
        }
        if(!lstBilling[1].equals(''))
        {
         	retVal.adresse.adresse.typeDeVoie = lstBilling[1];   
        }
        retVal.adresse.adresse.libelleVoie = lstBilling[2];
        
        retVal.adresse.adresse.complementAdresse = acc.ComplementAdresse__c;
        retVal.adresse.adresse.codePostal = acc.BillingPostalCode;
        retVal.adresse.adresse.ville = acc.BillingCity;
        String billingCountry = acc.BillingCountry;
        if(billingCountry != null && billingCountry.length()>0){
            billingCountry = Accents_Utils.removeDiacritics(billingCountry);
            List<Pays__c> Pays = [SELECT id,Abreviation__c,Nom__c  from Pays__c where nom__c = :billingCountry];
            if(Pays != null && Pays.size()>0){
                retVal.adresse.adresse.pays = Pays[0].Abreviation__c;
            }
        }
        retVal.adresse.adresse.telephone = acc.Phone;
        retVal.adresse.adresse.fax = acc.fax;
        retVal.adresse.adresse.codeClientOracle = acc.Code_Client_Oracle__c;
        //retVal.adresse.adresse.codeFournisseurOracle = '00000001';//on ne récupère pas
        retVal.adresse.adresse.referenceAdresseClient = acc.Reference_adresse__c;
        //retVal.adresse.adresse.referenceAdresseFournisseur = '';//on ne récupère pas
        retVal.adresse.adresse.dematerialise = acc.Dematerialise__c;
        
        //retVal.adresse.adresse.listeAffacturages.affacturage = new List<wwwDalkiaFrReferentielPartenaire.affacturageA1>();
        //wwwDalkiaFrReferentielPartenaire.affacturageA1 aff =  new wwwDalkiaFrReferentielPartenaire.affacturageA1();
        //aff.DKCPartenaireAffacturage='';
        //aff.DKCAdressePartenaireAffacturage='';
        //aff.statutLienAffacturage='';
        //retVal.adresse.adresse.listeAffacturages.affacturage.add(aff);
        
        /*retVal.adresse.adresse.listeMandataires.mandataire = new List<wwwDalkiaFrReferentielPartenaire.mandataireA1>();
wwwDalkiaFrReferentielPartenaire.mandataireA1 mand = new wwwDalkiaFrReferentielPartenaire.mandataireA1();
mand.DKCPartenaireMandataire = acc.DKC_Partenaire_Mandataire__c;
mand.DKCAdressePartenaireMandataire = acc.DKC_Adresse_Partenaire_Mandataire__c;
mand.statutLienMandataire = acc.Statut_Lien_Mandataire__c;
retVal.adresse.adresse.listeMandataires.mandataire.add(mand);*/ //attente confirmation des champs
        
        retVal.adresse.adresse.metadonneesAdressePartenaire = new wwwDalkiaFrReferentielPartenaire.metadonneesA2();
        retVal.adresse.adresse.metadonneesAdressePartenaire.field_order_type_info = removeListValue(retVal.adresse.adresse.metadonneesAdressePartenaire.field_order_type_info,'creationId');
        //retVal.adresse.adresse.metadonneesAdressePartenaire.creationDate = acc.CreatedDate;
        //retVal.adresse.adresse.metadonneesAdressePartenaire.creationId = usr.ReferentielId__c;
        retVal.adresse.adresse.metadonneesAdressePartenaire.updateDate = acc.LastModifiedDate;
        retVal.adresse.adresse.metadonneesAdressePartenaire.updateId = label.userC360;
        retVal.adresse.adresse.metadonneesAdressePartenaire.validationDate = acc.ValidationDate__c;
        
        List<User> usr2 = [select id,name,ReferentielId__c from user where id = :acc.ValidationId__c limit 1];
        if(usr2!=null && usr2.size()>0){
            retVal.adresse.adresse.metadonneesAdressePartenaire.validationId = usr2[0].ReferentielId__c;
        }
        
        return retVal;
    }
    
    public static List<String> getBillingAddressFields(String strAddress){
        boolean typeVoieExiste = false;
        List<String> returnedFields = new List<String>{'','',''};
            if(strAddress!=null && String.isNotBlank(strAddress)){
                Set<String> typesVoie = new Set<String>{'RUE', 'AVENUE', 'ROUTE','CHEMIN', 'BOULEVARD', 'PLACE','ALLEE', 'LIEU DIT', 'IMPASSE','QUAI', 'COURS', 'LIEU'};
                    strAddress = strAddress.toLowerCase();
                for(String str : typesVoie){
                    if(strAddress.contains(str.toLowerCase())){
                        List<String> addSubString = strAddress.split(str.toLowerCase());
                        if(addSubString.size()>0){
                            returnedFields[0] = addSubString[0].trim();
                        }
                        returnedFields[1] = str.trim();
                        if(addSubString.size()>1){
                            returnedFields[2] = addSubString[1].trim();
                        }
                        typeVoieExiste = true;
                    }
                    else if(!strAddress.contains(str.toLowerCase()) && !typeVoieExiste){
                        returnedFields[0] = '';
                        returnedFields[1] = 'VIDE';
                        returnedFields[2] = strAddress;
                    }
                }
            }
        else{
            returnedFields[0] = '';
            returnedFields[1] = 'VIDE';
            returnedFields[2] = ' ';
        }
        try{
            if(typeVoieExiste == true){
                List<TypeVoie__c> typeVoie = [SELECT TypeVoie__c,Abreviation__c from TypeVoie__c where TypeVoie__c =: returnedFields[1] limit 1];
                if(typeVoie.size() > 0)
                {
                 	returnedFields[1] = typeVoie[0].Abreviation__c;   
                }
            }
        }
        catch(Exception e){
            System.debug('Exception ' + e.getMessage());
            returnedFields[1] = '';
        }
        return returnedFields;
    }
    
    private static List<String> removeListValue(List<String> listToModify, String valueToRemove){
        Set<String> temp = new Set<String>();
        temp.addAll(listToModify);
        temp.remove(valueToRemove);
        List<String> listNew = new List<String>();
        listNew.addAll(temp);
        return listNew;
    }
}