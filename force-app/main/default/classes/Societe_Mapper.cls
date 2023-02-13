/**
*@author Alain Ghoussoub
*@date 18/02/2020
*@description List of functions thap map salesforce fields to WS fields - Societe
*/
public class Societe_Mapper {
    public static wwwDalkiaFrReferentielSociete.consulterSocieteRequete fillConsulterSocieteRequete(Account acc){
        wwwDalkiaFrReferentielSociete.consulterSocieteRequete retVal = new wwwDalkiaFrReferentielSociete.consulterSocieteRequete();
        retVal.DKCodeSociete = acc.DKCodeSurPartenaire__c;
        return retVal;
    }
    
    public static Account getConsulterSocieteRequete(wwwDalkiaFrReferentielSociete.consulterSocieteReponse retVal){
        Account accountToInsert = new Account();
        
        //proprietesSociete
        if(retVal.societe.proprietesSociete!=null){
            accountToInsert.DKCodeSurPartenaire__c = retVal.societe.proprietesSociete.DKCodeSociete;
            accountToInsert.StatutPartenaire__c = retVal.societe.proprietesSociete.statutSociete;
            accountToInsert.Commentaire__c =  retVal.societe.proprietesSociete.commentaire;
            accountToInsert.Categorie_partenaire__c = retVal.societe.proprietesSociete.categorieSociete;
            accountToInsert.RolePartenaire__c = retVal.societe.proprietesSociete.utilisationSociete;
            accountToInsert.Type_immatriculation__c = retVal.societe.proprietesSociete.typeImmatriculation;
            accountToInsert.Immatriculation_Legale__c = retVal.societe.proprietesSociete.immatriculationLegale;
            accountToInsert.SIRET__c = retVal.societe.proprietesSociete.immatriculationLegale;
            if(retVal.societe.proprietesSociete.denominationSociale.length()>80){
                accountToInsert.Name = retVal.societe.proprietesSociete.denominationSociale.substring(0,80);
            }
            else{
                accountToInsert.Name = retVal.societe.proprietesSociete.denominationSociale;
            }
            accountToInsert.Sigle__c = retVal.societe.proprietesSociete.acronymeSigle;
            // revoire ca
            accountToInsert.Lieu_immatriculation_legale__c = retVal.societe.proprietesSociete.lieuImmatriculationLegale;
            //accountToInsert.Lieu_immatriculation_legale__c = 'dump value';
            //accountToInsert.FormeJuridiqueINSEE__c =  retVal.societe.proprietesSociete.formeJuridiqueINSEE ;
            accountToInsert.FormeJuridique__c = retVal.societe.proprietesSociete.formeJuridique;
            accountToInsert.Type = retVal.societe.proprietesSociete.genreSociete; //picklist issue
            accountToInsert.Devise_Capital_Social__c = retVal.societe.proprietesSociete.deviseCapitalSocial;
            accountToInsert.Montant_capital_Social__c = retVal.societe.proprietesSociete.montantCapitalSocial;
            accountToInsert.Identifiant_Creancier_SEPA__c = retVal.societe.proprietesSociete.identifiantCreancierSEPA;
            accountToInsert.TVA_intra_communautaire__c = retVal.societe.proprietesSociete.numTVAIntracommunautaire;
            accountToInsert.Code_Client_Oracle__c =  retVal.societe.proprietesSociete.codeClientOracle;
            accountToInsert.Code_Fournisseur_Oracle__c = retVal.societe.proprietesSociete.codeFournisseurOracle;
        }
        
        //listeLogos
        
        if(retVal.societe.listeLogos != null && retVal.societe.listeLogos.logo.size()>0) {
            accountToInsert.Logo_Societe_Dalkia__c =  retVal.societe.listeLogos.logo[0].logoSocieteDalkia; 
            accountToInsert.Statut_Logo__c = retVal.societe.listeLogos.logo[0].statutLogo;
        }
        
        //activite
        if ( retVal.societe.activite!= null){
            accountToInsert.Code_NAF__c = retVal.societe.activite.codeActiviteLocal;
            if( String.isNotBlank(retVal.societe.activite.codeActiviteInternational)){
                accountToInsert.Code_NACE__c = retVal.societe.activite.codeActiviteInternational;   
            }
            
            
        }
        
        //categorie
        
        if(retVal.societe.categorie != null  && retVal.societe.categorie.externe!=null){
            //accountToInsert.Niveaurelationcommerciale__c =  retVal.societe.categorie.externe.niveauRelationCommerciale;
            accountToInsert.Qualification__c =  retVal.societe.categorie.externe.niveauRelationCommerciale;
            //accountToInsert.QualitePartenaire__c = retVal.societe.categorie.externe.qualiteRelationCommerciale;
            //accountToInsert.Qualification__c = retVal.societe.categorie.externe.qualiteRelationCommerciale;
            accountToInsert.Visionrelationcommercialeterrain__c = retVal.societe.categorie.externe.qualiteRelationCommerciale;
            accountToInsert.GrandCompteDalkia__c = retVal.societe.categorie.externe.grandCompteDalkia;
            accountToInsert.Grand_compte_EDF__c = retVal.societe.categorie.externe.grandCompteEDF;
            accountToInsert.Score_Risque__c = retVal.societe.categorie.externe.scoreRisque;
            if (retVal.societe.categorie.externe.dateNotationExterne !=null) {
                DateTime dateNotationExterneOriginal = retVal.societe.categorie.externe.dateNotationExterne;
                Date dateNotationExterneConverted = date.newinstance(dateNotationExterneOriginal.year(), dateNotationExterneOriginal.month(), dateNotationExterneOriginal.day());
                accountToInsert.Date_Notation_Externe__c = dateNotationExterneConverted;                
            }
            accountToInsert.Appreciation_Recouvrement__c =  retVal.societe.categorie.externe.appreciationRecouvrement;
            if(retVal.societe.categorie.externe.dateNotationInterne!=null){
                DateTime dateNotationInterneOriginal = retVal.societe.categorie.externe.dateNotationExterne;
                Date dateNotationInterneConverted = date.newinstance(dateNotationInterneOriginal.year(), dateNotationInterneOriginal.month(), dateNotationInterneOriginal.day());
                accountToInsert.Date_Notation_Interne__c = dateNotationInterneConverted;
            }
        }
        
        if (retVal.societe.categorie.listeGroupesDalkia !=null && retVal.societe.categorie.listeGroupesDalkia.groupeDalkia.size()>0){
            
            accountToInsert.Statut_Groupe_Dalkia__c = retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].statutGroupeDalkia;
            accountToInsert.Perimetre_Gestion__c =  retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].perimetreGestion;
            accountToInsert.Zone_Geographique__c =  retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].zoneGeographique;
            try{
                CentreFinance__c centre = [Select id,DkCode__c from CentreFinance__c where DkCode__c = : retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].UODalkiaPiloteSociete];
                accountToInsert.UODalkiaPilote__c = centre.Id;
            }
            catch(exception e){
                System.debug('exception CentreFinance__c query ' + e.getMessage());
            }
            accountToInsert.Statut_Activite__c =  retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].statutActivite;
            accountToInsert.Mode_Gestion_Juridique__c =  retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].modeGestionJuridique;
            
            if (retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].dateFinExercice != null ){
                DateTime dateFinExerciceOriginal = retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].dateFinExercice;
                Date dateFinExerciceConverted = date.newinstance(dateFinExerciceOriginal.year(), dateFinExerciceOriginal.month(), dateFinExerciceOriginal.day());
                accountToInsert.Date_Fin_Exercice__c =  dateFinExerciceConverted;
            }
            
            accountToInsert.Devise_Comptable__c =  retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].deviseComptable;
            accountToInsert.Mode_Gestion_Comptable__c =  retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].modeGestionComptable;
            accountToInsert.Matricule_Societe__c =  retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].matriculeSociete;
            accountToInsert.Mode_Consolidation__c = retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].modeConsolidation;
            accountToInsert.Code_Consolidation__c = retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].codeConsolidation;
            accountToInsert.Gestion_Travaux_Externes__c = retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].gestionTravauxExternes;
            accountToInsert.Groupe_Integration_Fiscale__c = retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].groupeIntegrationFiscale;
            accountToInsert.Societe_Dediee__c = retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].societeDediee;
            // String to boolean 
            accountToInsert.Statut_Gestion_CO2__c =  retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].statutGestionCO2;
            accountToInsert.Reference_CEE__c = retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].referenceCEE;
            
            if( retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].dateDebut !=null){
                DateTime dateDebutOriginal = retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].dateDebut;
                if(dateDebutOriginal!=null){
                    Date dateDebutOriginalConverted = date.newinstance(dateDebutOriginal.year(), dateDebutOriginal.month(), dateDebutOriginal.day());
                    accountToInsert.DateDebut__c = dateDebutOriginalConverted;
                }
            }
            
            if ( retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].dateFin!=null ){
                DateTime dateFinOriginal = retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].dateFin;
                if(dateFinOriginal!=null){
                    Date dateFinOriginalConverted = date.newinstance(dateFinOriginal.year(), dateFinOriginal.month(), dateFinOriginal.day());
                    accountToInsert.DateFin__c = dateFinOriginalConverted;
                }
            }
        }
        
        if(retVal.societe.categorie.listeGroupesEDF!=null && retVal.societe.categorie.listeGroupesEDF.groupeEDF.size()>0){
            accountToInsert.Statut_Groupe_EDF__c = retVal.societe.categorie.listeGroupesEDF.groupeEDF[0].statutGroupeEDF;
            // PJ : on ne récupère pas 
            accountToInsert.Matricule_Societe__c =  retVal.societe.categorie.listeGroupesEDF.groupeEDF[0].matriculeSociete;
            accountToInsert.Mode_Consolidation__c =  retVal.societe.categorie.listeGroupesEDF.groupeEDF[0].modeConsolidation;
            accountToInsert.Code_Consolidation__c =  retVal.societe.categorie.listeGroupesEDF.groupeEDF[0].codeConsolidation;
            accountToInsert.Groupe_Integration_Fiscale__c =  retVal.societe.categorie.listeGroupesEDF.groupeEDF[0].groupeIntegrationFiscale;
            // retVal.societe.categorie.listeGroupesEDF.groupeEDF[0].dateDebut = '';
            //  retVal.societe.categorie.listeGroupesEDF.groupeEDF[0].dateFin = '';
        }
        
        
        //listeParents
        
        if(retVal.societe.listeParents!=null && retVal.societe.listeParents.parent.size()>0){
            
            if (retVal.societe.listeParents.parent[0].societeParente!=null && String.isNotBlank(retVal.societe.listeParents.parent[0].societeParente)){
                List<Account> acc = new List<Account>();
                acc = [SELECT Id FROM Account WHERE DKCodeSurPartenaire__c = :retVal.societe.listeParents.parent[0].societeParente];
                
                if(acc!=null && acc.size()>0){
                    accountToInsert.ParentId = acc[0].Id;   
                    
                }else {
                    accountToInsert.ParentId = null;
                }
                
            }
            else {
                accountToInsert.ParentId = null;
            }
            accountToInsert.NatureRelation__c = retVal.societe.listeParents.parent[0].natureDeRelation;
            accountToInsert.Statut_Lien_Parent__c = retVal.societe.listeParents.parent[0].statutLienParent;
            accountToInsert.Commentaire_Lien_Parent__c =  retVal.societe.listeParents.parent[0].commentaireLienParent;
            
        }
        
        //listeReporting
        if(retVal.societe.listeReporting !=null &&  retVal.societe.listeReporting.reporting.size()>0){
            accountToInsert.Reporting_Societe__c = retVal.societe.listeReporting.reporting[0].reportingSociete;
        }
        
        
        
        //metadonnees
        accountToInsert.CreateDate__c = retVal.societe.metadonnees.creationDate;
        if(retVal.societe.metadonnees.creationID !=null ){
            List<User> usr1 = [ select id,name,ReferentielId__c from user where ReferentielId__c = :retVal.societe.metadonnees.creationID limit 1];
            if ( usr1 !=null && usr1.size()>0){
                accountToInsert.CreateId__c = usr1[0].Id;                   
            }
        }
        accountToInsert.UpdateDate__c = retVal.societe.metadonnees.updateDate;
        
        if(retVal.societe.metadonnees.updateId !=null ){
            List<User> usr2 = [ select id,name,ReferentielId__c from user where ReferentielId__c = :retVal.societe.metadonnees.updateId limit 1];
            if ( usr2 !=null && usr2.size()>0){
                accountToInsert.UpdateId__c = usr2[0].Id;                   
            }                
        }
        accountToInsert.ValidationDate__c = retVal.societe.metadonnees.validationDate;
        if(retVal.societe.metadonnees.validationId !=null ){
            List<User> usr3 = [ select id,name,ReferentielId__c from user where ReferentielId__c = :retVal.societe.metadonnees.validationId limit 1];
            if ( usr3 !=null && usr3.size()>0 && String.isNotBlank(usr3[0].ReferentielId__c))
            {
                accountToInsert.ValidationId__c = usr3[0].id;
            }
        }
        
        return accountToInsert;
    }
    
    public static wwwDalkiaFrReferentielSociete.modifierSocieteRestreintRequete fillModifierSocieteRestreintRequete(Account acc){
        wwwDalkiaFrReferentielSociete.modifierSocieteRestreintRequete retVal = new wwwDalkiaFrReferentielSociete.modifierSocieteRestreintRequete();
        retVal.societe = new wwwDalkiaFrReferentielSociete.societeRS();
        //proprietesSociete
        retVal.societe.proprietesSociete = new wwwDalkiaFrReferentielSociete.proprietesSocieteRS();
        retVal.societe.proprietesSociete.DKCodeSociete = acc.DKCodeSurPartenaire__c;
        retVal.societe.proprietesSociete.commentaire = acc.Commentaire__c;
        // Fields that are not present in the ws
        // statutSociete
        //retVal.societe.proprietesSociete.categorieSociete = acc.Categorie_partenaire__c;
        //retVal.societe.proprietesSociete.utilisationSociete;  
        // // ?? retVal.societe.proprietesSociete.genreSociete = '';
        retVal.societe.proprietesSociete.typeImmatriculation = acc.Type_immatriculation__c;
        retVal.societe.proprietesSociete.immatriculationLegale = acc.Immatriculation_Legale__c;
        retVal.societe.proprietesSociete.denominationSociale = acc.name;
        retVal.societe.proprietesSociete.acronymeSigle = acc.Sigle__c;
        retVal.societe.proprietesSociete.lieuImmatriculationLegale = acc.Lieu_immatriculation_legale__c;
        retVal.societe.proprietesSociete.formeJuridiqueINSEE = acc.FormeJuridiqueINSEE__c;
        retVal.societe.proprietesSociete.formeJuridique = acc.FormeJuridique__c;
        retVal.societe.proprietesSociete.deviseCapitalSocial = acc.Devise_Capital_Social__c;
        
        if(acc.Montant_capital_Social__c !=null  ){ //decimal to int
            retVal.societe.proprietesSociete.montantCapitalSocial = (Integer)acc.Montant_capital_Social__c;
        }
        if(acc.Montant_capital_Social__c == null  || String.ValueOf(acc.Montant_capital_Social__c) == ''){
            retVal.societe.proprietesSociete.field_order_type_info = removeListValue(retVal.societe.proprietesSociete.field_order_type_info,'montantCapitalSocial');
        }
        
        retVal.societe.proprietesSociete.identifiantCreancierSEPA = acc.Identifiant_Creancier_SEPA__c;
        retVal.societe.proprietesSociete.numTVAIntracommunautaire = acc.TVA_intra_communautaire__c;
        
        /*//listeLogos
for(wwwDalkiaFrReferentielSociete.logoRS retv :retVal.societe.listeLogos.logo){
//retv.logoSocieteDalkia = ??
//retv.statutLogo = ??
}*/
        //activite
        retVal.societe.activite = new wwwDalkiaFrReferentielSociete.activiteRS();
        retVal.societe.activite.codeActiviteLocal = acc.Code_NAF__c;
        if(acc.Code_NACE__c!=null){
            retVal.societe.activite.codeActiviteInternational = acc.Code_NACE__c;
        }
        
        //categorie
        retVal.societe.categorie = new wwwDalkiaFrReferentielSociete.categorieRS();
        retVal.societe.categorie.externe =new wwwDalkiaFrReferentielSociete.externeRS();
        retVal.societe.categorie.externe.niveauRelationCommerciale = acc.qualification__c;
        retVal.societe.categorie.externe.grandCompteDalkia = acc.GrandCompteDalkia__c;
        retVal.societe.categorie.externe.grandCompteEDF = acc.Grand_compte_EDF__c;
        retVal.societe.categorie.externe.scoreRisque = acc.Score_Risque__c;
        retVal.societe.categorie.externe.dateNotationExterne = acc.Date_Notation_Externe__c;
        retVal.societe.categorie.externe.appreciationRecouvrement = acc.Appreciation_Recouvrement__c;
        retVal.societe.categorie.externe.dateNotationInterne = acc.Date_Notation_Interne__c;
        
        //listeParents
        List<Account> parentAcc = [SELECT Id, Name,DKCodeSurPartenaire__c FROM ACcount WHERE Id=:acc.ParentId] ;
        if(parentAcc!=null && parentAcc.size()>0){ 
            retVal.societe.listeParents = new wwwDalkiaFrReferentielSociete.listeParentsRS();  
            retVal.societe.listeParents.parent = new List<wwwDalkiaFrReferentielSociete.parentRS>();
            wwwDalkiaFrReferentielSociete.parentRS parentRSObj = new wwwDalkiaFrReferentielSociete.parentRS();
            parentRSObj.societeParente =  parentAcc[0].DKCodeSurPartenaire__c;
            parentRSObj.natureDeRelation = acc.NatureRelation__c;
            parentRSObj.commentaireLienParent = acc.Commentaire_Lien_Parent__c;
            parentRSObj.statutLienParent = true;
            retVal.societe.listeParents.parent.add(parentRSObj);
        }
        else{
            retVal.societe.field_order_type_info = removeListValue(retVal.societe.field_order_type_info,'listeParents');
        }
        //listeReporting to be removed
        retVal.societe.field_order_type_info = removeListValue(retVal.societe.field_order_type_info,'listeReporting');
        //listeReporting to be removed
        /*
retVal.societe.listeReporting = new wwwDalkiaFrReferentielSociete.listeReportingRS();
retVal.societe.listeReporting.reporting = new List<wwwDalkiaFrReferentielSociete.reportingRS>();
wwwDalkiaFrReferentielSociete.reportingRS reportingRSObj = new wwwDalkiaFrReferentielSociete.reportingRS();

reportingRSObj.reportingSociete = acc.Reporting_Societe__c;
retVal.societe.listeReporting.reporting.add(reportingRSObj);
*/
        
        //metadonnees
        retVal.societe.metadonnees = new wwwDalkiaFrReferentielSociete.metadonneesRS();
        retVal.societe.metadonnees.updateDate = acc.LastModifiedDate;
        if(acc.LastModifiedById !=null ){
            retVal.societe.metadonnees.updateId = label.userC360;
        }
        
        retVal.societe.metadonnees.validationDate = acc.ValidationDate__c;
        if(acc.ValidationId__c !=null ){
            List<User> usr2 = [ select id,name,ReferentielId__c from user where id = :acc.ValidationId__c limit 1];
            if (usr2!=null && usr2.size()>0)
            {
                retVal.societe.metadonnees.validationId = usr2[0].ReferentielId__c;
            }
        }
        return retVal;
    }
    
    public static Account getModifierSocieteRestreintRequete(wwwDalkiaFrReferentielSociete.modifierSocieteRestreintReponse retVal,Account accountToInsert){
        if(retVal.societe != null){
            if(retVal.societe.proprietesSociete != null){
                accountToInsert.DKCodeSurPartenaire__c = retVal.societe.proprietesSociete.DKCodeSociete;
                accountToInsert.StatutPartenaire__c = retVal.societe.proprietesSociete.statutSociete;
                accountToInsert.Commentaire__c = retVal.societe.proprietesSociete.commentaire;
                accountToInsert.Categorie_partenaire__c = retVal.societe.proprietesSociete.categorieSociete;
                accountToInsert.RolePartenaire__c = retVal.societe.proprietesSociete.utilisationSociete;
                accountToInsert.Type_immatriculation__c = retVal.societe.proprietesSociete.typeImmatriculation;
                accountToInsert.Immatriculation_Legale__c = retVal.societe.proprietesSociete.immatriculationLegale;
                if(retVal.societe.proprietesSociete.denominationSociale.length()>80){
                    accountToInsert.Name = retVal.societe.proprietesSociete.denominationSociale.substring(0,80);
                }
                else{
                    accountToInsert.Name = retVal.societe.proprietesSociete.denominationSociale;
                }
                accountToInsert.Sigle__c = retVal.societe.proprietesSociete.acronymeSigle;
                accountToInsert.Lieu_immatriculation_legale__c = retVal.societe.proprietesSociete.lieuImmatriculationLegale;
                //retVal.societe.proprietesSociete.formeJuridiqueINSEE = '';
                accountToInsert.FormeJuridique__c = retVal.societe.proprietesSociete.formeJuridique;
                accountToInsert.Type = retVal.societe.proprietesSociete.genreSociete;
                accountToInsert.Devise_Capital_Social__c = retVal.societe.proprietesSociete.deviseCapitalSocial;
                accountToInsert.Montant_capital_Social__c = retVal.societe.proprietesSociete.montantCapitalSocial;
                accountToInsert.Identifiant_Creancier_SEPA__c = retVal.societe.proprietesSociete.identifiantCreancierSEPA;
                accountToInsert.TVA_intra_communautaire__c = retVal.societe.proprietesSociete.numTVAIntracommunautaire;
                accountToInsert.Code_Client_Oracle__c =  retVal.societe.proprietesSociete.codeClientOracle;
                accountToInsert.Code_Fournisseur_Oracle__c = retVal.societe.proprietesSociete.codeFournisseurOracle;
            }
            //listeLogos
            if(retVal.societe.listeLogos != null && retVal.societe.listeLogos.logo.size()>0) {
                accountToInsert.Logo_Societe_Dalkia__c =  retVal.societe.listeLogos.logo[0].logoSocieteDalkia; 
                accountToInsert.Statut_Logo__c = retVal.societe.listeLogos.logo[0].statutLogo;
            }
            //activite
            if ( retVal.societe.activite!= null){
                accountToInsert.Code_NAF__c = retVal.societe.activite.codeActiviteLocal;
                if( String.isNotBlank(retVal.societe.activite.codeActiviteInternational)){
                    accountToInsert.Code_NACE__c = retVal.societe.activite.codeActiviteInternational;   
                }
            }
            //categorie
            if(retVal.societe.categorie != null){
                if(retVal.societe.categorie.externe!=null != null){
                    //accountToInsert.Niveaurelationcommerciale__c =  retVal.societe.categorie.externe.niveauRelationCommerciale;
                    accountToInsert.Qualification__c =  retVal.societe.categorie.externe.niveauRelationCommerciale;
                    //accountToInsert.QualitePartenaire__c = retVal.societe.categorie.externe.qualiteRelationCommerciale;
                    //accountToInsert.Qualification__c = retVal.societe.categorie.externe.qualiteRelationCommerciale;
                    accountToInsert.Visionrelationcommercialeterrain__c = retVal.societe.categorie.externe.qualiteRelationCommerciale;
                    accountToInsert.GrandCompteDalkia__c = retVal.societe.categorie.externe.grandCompteDalkia;
                    accountToInsert.Grand_compte_EDF__c = retVal.societe.categorie.externe.grandCompteEDF;
                    accountToInsert.Score_Risque__c = retVal.societe.categorie.externe.scoreRisque;
                    if (retVal.societe.categorie.externe.dateNotationExterne !=null) {
                        DateTime dateNotationExterneOriginal = retVal.societe.categorie.externe.dateNotationExterne;
                        Date dateNotationExterneConverted = date.newinstance(dateNotationExterneOriginal.year(), dateNotationExterneOriginal.month(), dateNotationExterneOriginal.day());
                        accountToInsert.Date_Notation_Externe__c = dateNotationExterneConverted;                
                    }
                    accountToInsert.Appreciation_Recouvrement__c =  retVal.societe.categorie.externe.appreciationRecouvrement;
                    if(retVal.societe.categorie.externe.dateNotationInterne!=null){
                        DateTime dateNotationInterneOriginal = retVal.societe.categorie.externe.dateNotationExterne;
                        Date dateNotationInterneConverted = date.newinstance(dateNotationInterneOriginal.year(), dateNotationInterneOriginal.month(), dateNotationInterneOriginal.day());
                        accountToInsert.Date_Notation_Interne__c = dateNotationInterneConverted;
                    }
                }
                if (retVal.societe.categorie.listeGroupesDalkia !=null && retVal.societe.categorie.listeGroupesDalkia.groupeDalkia.size()>0){
                    
                    accountToInsert.Statut_Groupe_Dalkia__c = retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].statutGroupeDalkia;
                    accountToInsert.Perimetre_Gestion__c =  retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].perimetreGestion;
                    accountToInsert.Zone_Geographique__c =  retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].zoneGeographique;
                    List<CentreFinance__c> centre = [Select id,DkCode__c from CentreFinance__c where DkCode__c = : retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].UODalkiaPiloteSociete];
                    if(centre != null && centre.size()>0){
                        accountToInsert.UODalkiaPilote__c = centre[0].Id;
                    }
                    accountToInsert.Statut_Activite__c =  retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].statutActivite;
                    accountToInsert.Mode_Gestion_Juridique__c =  retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].modeGestionJuridique;
                    
                    if (retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].dateFinExercice != null ){
                        DateTime dateFinExerciceOriginal = retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].dateFinExercice;
                        Date dateFinExerciceConverted = date.newinstance(dateFinExerciceOriginal.year(), dateFinExerciceOriginal.month(), dateFinExerciceOriginal.day());
                        accountToInsert.Date_Fin_Exercice__c =  dateFinExerciceConverted;
                    }
                    
                    accountToInsert.Devise_Comptable__c =  retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].deviseComptable;
                    accountToInsert.Mode_Gestion_Comptable__c =  retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].modeGestionComptable;
                    accountToInsert.Matricule_Societe__c =  retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].matriculeSociete;
                    accountToInsert.Mode_Consolidation__c = retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].modeConsolidation;
                    accountToInsert.Code_Consolidation__c = retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].codeConsolidation;
                    accountToInsert.Gestion_Travaux_Externes__c = retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].gestionTravauxExternes;
                    accountToInsert.Groupe_Integration_Fiscale__c = retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].groupeIntegrationFiscale;
                    accountToInsert.Societe_Dediee__c = retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].societeDediee;
                    // String to boolean 
                    accountToInsert.Statut_Gestion_CO2__c =  retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].statutGestionCO2;
                    accountToInsert.Reference_CEE__c = retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].referenceCEE;
                    
                    if( retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].dateDebut !=null){
                        DateTime dateDebutOriginal = retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].dateDebut;
                        if(dateDebutOriginal!=null){
                            Date dateDebutOriginalConverted = date.newinstance(dateDebutOriginal.year(), dateDebutOriginal.month(), dateDebutOriginal.day());
                            accountToInsert.DateDebut__c = dateDebutOriginalConverted;
                        }
                    }
                    
                    if ( retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].dateFin!=null ){
                        DateTime dateFinOriginal = retVal.societe.categorie.listeGroupesDalkia.groupeDalkia[0].dateFin;
                        if(dateFinOriginal!=null){
                            Date dateFinOriginalConverted = date.newinstance(dateFinOriginal.year(), dateFinOriginal.month(), dateFinOriginal.day());
                            accountToInsert.DateFin__c = dateFinOriginalConverted;
                        }
                    }
                }
                if(retVal.societe.categorie.listeGroupesEDF!=null && retVal.societe.categorie.listeGroupesEDF.groupeEDF.size()>0){
                    accountToInsert.Statut_Groupe_EDF__c = retVal.societe.categorie.listeGroupesEDF.groupeEDF[0].statutGroupeEDF;
                    // PJ : on ne récupère pas 
                    accountToInsert.Matricule_Societe__c =  retVal.societe.categorie.listeGroupesEDF.groupeEDF[0].matriculeSociete;
                    accountToInsert.Mode_Consolidation__c =  retVal.societe.categorie.listeGroupesEDF.groupeEDF[0].modeConsolidation;
                    accountToInsert.Code_Consolidation__c =  retVal.societe.categorie.listeGroupesEDF.groupeEDF[0].codeConsolidation;
                    accountToInsert.Groupe_Integration_Fiscale__c =  retVal.societe.categorie.listeGroupesEDF.groupeEDF[0].groupeIntegrationFiscale;
                    // retVal.societe.categorie.listeGroupesEDF.groupeEDF[0].dateDebut = '';
                    //  retVal.societe.categorie.listeGroupesEDF.groupeEDF[0].dateFin = '';
                }
            }
            //listeParents
            if(retVal.societe.listeParents!=null && retVal.societe.listeParents.parent.size()>0){
                if (retVal.societe.listeParents.parent[0].societeParente!=null && String.isNotBlank(retVal.societe.listeParents.parent[0].societeParente)){
                    List<Account> acc = new List<Account>();
                    acc = [SELECT Id FROM Account WHERE DKCodeSurPartenaire__c = :retVal.societe.listeParents.parent[0].societeParente];
                    
                    if(acc!=null && acc.size()>0){
                        accountToInsert.ParentId = acc[0].Id;   
                        
                    }else {
                        accountToInsert.ParentId = null;
                    }
                    
                }
                else {
                    accountToInsert.ParentId = null;
                }
                accountToInsert.NatureRelation__c = retVal.societe.listeParents.parent[0].natureDeRelation;
                accountToInsert.Statut_Lien_Parent__c = retVal.societe.listeParents.parent[0].statutLienParent;
                accountToInsert.Commentaire_Lien_Parent__c =  retVal.societe.listeParents.parent[0].commentaireLienParent;
            }
            //listeReporting
            if(retVal.societe.listeReporting !=null &&  retVal.societe.listeReporting.reporting.size()>0){
                accountToInsert.Reporting_Societe__c = retVal.societe.listeReporting.reporting[0].reportingSociete;
            }
            //metadonnees
            accountToInsert.CreateDate__c = retVal.societe.metadonnees.creationDate;
            if(retVal.societe.metadonnees.creationID !=null ){
                List<User> usr1 = [ select id,name,ReferentielId__c from user where ReferentielId__c = :retVal.societe.metadonnees.creationID limit 1];
                if ( usr1 !=null && usr1.size()>0){
                    accountToInsert.CreateId__c = usr1[0].Id;                   
                }
            }
            accountToInsert.UpdateDate__c = retVal.societe.metadonnees.updateDate;
            
            if(retVal.societe.metadonnees.updateId !=null ){
                List<User> usr2 = [ select id,name,ReferentielId__c from user where ReferentielId__c = :retVal.societe.metadonnees.updateId limit 1];
                if ( usr2 !=null && usr2.size()>0){
                    accountToInsert.UpdateId__c = usr2[0].Id;                   
                }
            }
            accountToInsert.ValidationDate__c = retVal.societe.metadonnees.validationDate;
            if(retVal.societe.metadonnees.validationId !=null ){
                List<User> usr3 = [ select id,name,ReferentielId__c from user where ReferentielId__c = :retVal.societe.metadonnees.validationId limit 1];
                if ( usr3 !=null && usr3.size()>0 && String.isNotBlank(usr3[0].ReferentielId__c)){
                    accountToInsert.ValidationId__c = usr3[0].id;
                }
            }
        }
        return accountToInsert;
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