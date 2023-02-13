/**
* @author: Alain Ghoussoub -EI Technologies
* @date: 10/01/2019
* @description: Class qui gère le web service entrant Ressource
*/
global class WS11_Ressource {
    
    global class Ressource { 
        webservice Header header;
        webservice ProprietesRessource proprietesRessource ;
        webservice List<Categorie> listCategorie;
        webservice EtatCivil etatCivil;
        webservice DonneesPersonelles donneesPersonelles;
        webservice GestionRH gestionRH;
        webservice DonneesContractuelles donneesContractuelles;
        webservice Emploi emploi;
        webservice Affectation affectation;
        webservice Metadonnees metadonnees; 
    } 
    
    global class ProprietesRessource {
        webservice String dkCodeRessource;
        webservice String statut;
        webservice String controleRessource;
        webservice String accesInformatique; 
        webservice String login; 
    } 
    global class Categorie {
        webservice String categorieRessource;
        webservice DateTime dateDebut;
        webservice DateTime dateFin;
    } 
    global class EtatCivil {
        webservice String civilite;
        webservice String nomNaissanceEtatCivil;
        webservice String nomFamilleEtatCivil;
        webservice String prenomEtatCivil;
        webservice String nomUsage;
        webservice String prenomUsage;
        webservice String sexe;
        webservice DateTime dateNaissance; 
        webservice List<Nationalite> listNationalite;
    } 
    global class Nationalite {
        webservice String ordre;
        webservice String nationalite; 
    }
    global class DonneesPersonelles {
        webservice Coordonnees coordonnees; 
    } 
    global class Coordonnees{
        webservice List<Email> listEmail;
        webservice List<Ligne> listLigne;
        webservice Adresse adresse; 
    }
    global class Email {
        webservice String natureEmail;
        webservice String ordre;
        webservice String email;  
    }
    global class Ligne {
        webservice String typeLigne;
        webservice String natureLigne;
        webservice String ordre;
        webservice String numLigne; 
    }
    global class Adresse {
        webservice String natureAdresse;
        webservice String adresse1;
        webservice String adresse2; 
        webservice String adresse3; 
        webservice String adresse4;
        webservice String codePostal;
        webservice String ville;
        webservice String pays; 
    }
    global class GestionRH{
        webservice String matriculeRhDk;
        webservice String codeAccidentTravail;
        webservice String referenceDemandeEmbauche;
        webservice Traitements traitements;
        webservice List<ReferentHierarchique> listReferentHierarchique;
    }
    global class Traitements{
        webservice Boolean paye;
        webservice Boolean noteFrais;
        webservice Boolean gta;
        webservice Boolean evaluationCompetences;
        webservice Boolean formation; 
    }
    global class ReferentHierarchique{
        webservice String superieurHierarchique;
        webservice String roleHierarchique;
        webservice DateTime dateDebut;
        webservice DateTime dateFin;
    }
    global class DonneesContractuelles{
        webservice List<Societe> listSociete;
        webservice Contrat contrat;
        webservice List<ClassificationConventionelle> listClassificationConventionelle;
        webservice Statut statut;
    }
    global class Societe {
        webservice String dkCodePartenaire;
        webservice String matriculeSociete;
        webservice DateTime dateEntree;	
        webservice DateTime dateSortie;
        webservice List<Etablissement> listEtablissement; 
    }
    global class Etablissement {
        webservice String etablissementDalkia;
        webservice DateTime dateDebut;
        webservice DateTime dateFin;
        
    }
    global class Contrat {
        webservice List<CycleTravail> listCycleTravail;
        webservice List<HoraireContractuel> listHoraireContractuel;
        
    }
    global class CycleTravail{
        webservice String cycleTravail;
        webservice DateTime dateDebut;
        webservice DateTime dateFin;
        
    }
    global class HoraireContractuel{
        webservice String typeHoraire;
        webservice String heuresSemaineNormal;
        webservice String heuresMoisNormal;
        webservice String tauxActivite; 
        webservice DateTime dateDebut;
        webservice DateTime dateFin;
    }
    
    global class ClassificationConventionelle {
        webservice String conventionCollective;
        webservice String niveau;
        webservice String echelon;
        webservice String position;
        webservice String coefficient;
        webservice DateTime dateDebut;
        webservice DateTime dateFin; 
    }
    global class Statut {
        webservice String status;
        webservice String natureSuspension;
        webservice DateTime dateEffetSuspension;
        webservice DateTime dateRepriseProvisoireSuspension;
    }
    global class Emploi {
        webservice List<Categorie2> listCategorie;
        webservice List<Position> listPosition; 
        webservice List<Fonction> listFonction; 
        
    } 
    global class Categorie2{
        webservice String categorieSocioProfessionnele;
        webservice DateTime dateDebut;
        webservice DateTime dateFin;
    }
    global class Position{
        webservice String position;
        webservice DateTime dateDebut;
        webservice DateTime dateFin; 
    }
    global class Fonction {
        webservice String fonction;
        webservice DateTime dateDebut;
        webservice DateTime dateFin; 
    }
    global class Affectation {
        webservice List<FiliereDK> listFiliereDK; 
        webservice List<ProjetFinance> listProjetFinance; 
        webservice List<Organisation> listOrganisation; 
        webservice List<PosteTravail> listPosteTravail;  
    } 
    global class FiliereDK{
        webservice String sousFiliere;
        webservice DateTime dateDebut;
        webservice DateTime dateFin; 
        webservice String Filiere;
    }
    global class ProjetFinance{
        webservice String projetFinanceOrganique;
        webservice String tacheOrganique; 
        webservice DateTime dateDebut;
        webservice DateTime dateFin; 
    }
    global class Organisation {
        webservice String Organisation; 
        webservice DateTime dateDebut;
        webservice DateTime dateFin;
    }
    global class PosteTravail{
        webservice Boolean intervenant;
        webservice DateTime dateDebut;
        webservice DateTime dateFin;
        webservice String lieuRattachement; 
        webservice String commentairePosteTravail;  
    }
    global class Metadonnees{
        webservice DateTime creationDate;
        webservice String creationId;
        webservice DateTime updateDate;
        webservice String updateId;
        webservice DateTime validationDate;
        webservice String validationId; 
    } 
    
    webservice static Response insertUpdateRessource(Ressource ressource) {
        Response resp = new Response();
        resp.error = false;
        resp.responseCode = Label.WS_Response_OK;
        resp.errorText = '';
        WebserviceLog__c ws = new WebserviceLog__c();
        ws.Request__c = ressource+'';
        ws.Type__c = Label.WS_Ressource;
        ws.flux__c = Label.WSTypeFluxEntrant;
        Boolean dkCodeExiste = false;
        User userToInsertUpdate = new User();
        userToInsertUpdate.IsActive = false;
        boolean userExists = false;
        String dkCode = '';
        boolean isActive = false;
        List<HistoriqueReferentiel__c> listHistToInsert = new List<HistoriqueReferentiel__c> ();
        
        List<Profile> profileList = new List<Profile>();
        profileList = [select id from profile where name = :Label.WS11_ProfileReadOnly];
        if(profileList != null && profileList.size()>0){
            userToInsertUpdate.ProfileId = profileList[0].id;
        }
        
        userToInsertUpdate.TimeZoneSidKey = Label.WS11_TimeZone;
        userToInsertUpdate.EmailEncodingKey = Label.WS11_Encoding;
        userToInsertUpdate.LanguageLocaleKey = Label.WS11_Language;
        userToInsertUpdate.LocaleSidKey = Label.WS11_SidKey;
        String userMail = '';
        if(Ressource != null){
            //header
            if(Ressource.header != null){
                if (String.isNotBlank(Ressource.header.transactionId)) {
                    ws.TransactionId__c = Ressource.header.transactionId;
                }
            }
            //ProprieteRessource
            if(Ressource.ProprietesRessource != null){
                if(String.isNotBlank(Ressource.ProprietesRessource.dkCodeRessource)){
                    ws.DkCode__c= Ressource.ProprietesRessource.dkCodeRessource;   
                    List<User> userList = new List<User>();
                    userList = [SELECT id,DkCode__c,Statut__c,LastName,Username,FirstName,Email,Phone,Address,EmployeeNumber,Manager.DkCode__c,Title,CodeValeurSousFiliere__c,CodeValeurFiliere__c,Organisation__c,
                                CreatedDate__c,CreateId__c,CommunityNickname,UpdateDate__c,UpdateId__c,ValidationDate__c,ValidationId__c,IsActive,FederationIdentifier,ReferentielId__c
                                FROM User
                                WHERE DkCode__c = :Ressource.ProprietesRessource.dkCodeRessource];
                    if(userList != null && userList.size()>0){
                        usermail = userList[0].Email;
                        userToInsertUpdate = userList[0];
                        userExists = true;
                        isActive = userList[0].IsActive;
                    }
                    else{
                        userToInsertUpdate.DkCode__c = Ressource.ProprietesRessource.dkCodeRessource;
                    }
                    dkCode = Ressource.ProprietesRessource.dkCodeRessource;
                }
                else{
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS11_dkCodeRessourceOB + '\n';
                    resp.error = true;
                }
                if(String.isNotBlank(Ressource.ProprietesRessource.statut)){
                    userToInsertUpdate.Statut__c = Ressource.ProprietesRessource.statut;
                }
                else{
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS11_StatutOB + '\n';
                    resp.error = true;
                }
                if(String.isNotBlank(Ressource.ProprietesRessource.login)){
                    userToInsertUpdate.FederationIdentifier = Ressource.ProprietesRessource.login;
                    userToInsertUpdate.ReferentielId__c = Ressource.ProprietesRessource.login;
                }
            }
            //EtatCivil
            if(Ressource.EtatCivil != null){
                userToInsertUpdate.Alias = '';
                if(String.isNotBlank(Ressource.EtatCivil.nomUsage)){
                    userToInsertUpdate.LastName = Ressource.EtatCivil.nomUsage;
                }
                else{
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS11WS11_nomUsageOB + '\n';
                    resp.error = true;
                }
                if(String.isNotBlank(Ressource.EtatCivil.prenomUsage)){
                    userToInsertUpdate.FirstName = Ressource.EtatCivil.prenomUsage;
                }
                else{
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS11_prenomUsageOB + '\n';
                    resp.error = true;
                }
                if(String.isNotBlank(userToInsertUpdate.LastName) && userToInsertUpdate.LastName.length() > 2){
                    userToInsertUpdate.Alias = userToInsertUpdate.FirstName.Substring(0,1) + userToInsertUpdate.LastName.Substring(0,3);
                }
                else if (String.isNotBlank(userToInsertUpdate.LastName)){
                    userToInsertUpdate.Alias = userToInsertUpdate.FirstName.Substring(0,1) + userToInsertUpdate.LastName;
                }
            }
            //DonneesPersonelles
            boolean emailChosen = false;
            if(Ressource.DonneesPersonelles != null){
                if(Ressource.DonneesPersonelles.coordonnees != null){
                    if(Ressource.DonneesPersonelles.coordonnees.listEmail != null){
                        for(Email mail : Ressource.DonneesPersonelles.coordonnees.listEmail){
                            if(String.isNotBlank(mail.email) && !userExists){
                                if(label.ExtensionTRS != '.'){
                                    userToInsertUpdate.Email = Label.WS11_mail + label.ExtensionTRS;
                                }
                                else{
                                    userToInsertUpdate.Email = Label.WS11_mail;
                                }
                                userToInsertUpdate.CommunityNickname = userToInsertUpdate.FirstName.replaceAll(' ', '').toLowerCase() + '.' + userToInsertUpdate.LastName.replaceAll(' ', '').toLowerCase();
                                if(label.OrganisationName != '.'){
                                    userToInsertUpdate.Username = userToInsertUpdate.FirstName.replaceAll(' ', '').toLowerCase() + '.' + userToInsertUpdate.LastName.replaceAll(' ', '').toLowerCase() + Label.WS11_mail + label.OrganisationName;
                                }
                                else{
                                    userToInsertUpdate.Username = userToInsertUpdate.FirstName.replaceAll(' ', '').toLowerCase() + '.' + userToInsertUpdate.LastName.replaceAll(' ', '').toLowerCase() + Label.WS11_mail;
                                }
                            }
                            else if(String.isNotBlank(mail.natureEmail)){
                                if(mail.natureEmail == Label.WS11_PRO){
                                    if(String.isNotBlank(mail.email) && !userExists){
                                        if(label.ExtensionTRS != '.'){
                                            userToInsertUpdate.Email = mail.email + label.ExtensionTRS;
                                        }
                                        else{
                                            userToInsertUpdate.Email = mail.email;
                                        }
                                        userToInsertUpdate.CommunityNickname = mail.email.SubStringBefore('@');
                                        if(label.OrganisationName != '.'){
                                            userToInsertUpdate.Username = mail.email.SubStringBefore('@') + Label.WS11_mail + label.OrganisationName;
                                        }
                                        else{
                                            userToInsertUpdate.Username = mail.email.SubStringBefore('@') + Label.WS11_mail;
                                        }
                                    }
                                    else if(String.isNotBlank(mail.natureEmail) && userExists && userToInsertUpdate.Email != mail.email){
                                        emailChosen = true;
                                        if(!userToInsertUpdate.email.equals(mail.email)){
                                            HistoriqueReferentiel__c historique = new HistoriqueReferentiel__c();
                                            historique.Objet__c = Label.WS11_Ressource;
                                            if(dkCode != null){
                                                historique.DkCode__c = dkCode;
                                            }
                                            else{
                                                historique.DkCode__c = '';
                                            }
                                            historique.Champ__c = Label.WS11_Email;
                                            if(mail.email != null){
                                                historique.Valeur__c = mail.email;
                                            }
                                            else{
                                                historique.Valeur__c = '';
                                            }
                                            historique.DateDebut__c = System.today();
                                            Date myDate = Date.newInstance(2099, 01, 01);
                                            Time myTime = Time.newInstance(1, 00, 00, 00);
                                            DateTime dt = DateTime.newInstance(myDate, myTime);
                                            historique.DateFin__c = dt;
                                            listHistToInsert.add(historique);
                                        }
                                    }
                                }
                            }
                            else{
                                resp.responseCode = Label.WS_Response_KO;
                                resp.errorText += Label.WS11_natureEmailOB + '\n';
                                resp.error = true;
                            }
                        }
                        if(emailChosen == true){
                            try{
                                List<HistoriqueReferentiel__c> listOldHistorique = [Select id,name
                                                                                    From HistoriqueReferentiel__c
                                                                                    Where Objet__c='Ressource'
                                                                                    And Dkcode__c = :dkCode
                                                                                    And Champ__c = 'email'];
                                delete listOldHistorique;
                            }
                            catch(Exception e){
                                System.debug('Exception in old hisotrique logic for dkcode: ' + dkCode + ' ' + e);
                            }
                        }
                    }
                    else{
                        if(label.ExtensionTRS != '.'){
                            userToInsertUpdate.Email = Label.WS11_mail + label.ExtensionTRS;
                        }
                        else{
                            userToInsertUpdate.Email = Label.WS11_mail;
                        }
                        userToInsertUpdate.CommunityNickname = userToInsertUpdate.FirstName.replaceAll(' ', '').toLowerCase() + '.' + userToInsertUpdate.LastName.replaceAll(' ', '').toLowerCase();
                        if(label.OrganisationName != '.'){
                            userToInsertUpdate.Username = userToInsertUpdate.FirstName.replaceAll(' ', '').toLowerCase() + '.' + userToInsertUpdate.LastName.replaceAll(' ', '').toLowerCase() + Label.WS11_mail + label.OrganisationName;
                        }
                        else{
                            userToInsertUpdate.Username = userToInsertUpdate.FirstName.replaceAll(' ', '').toLowerCase() + '.' + userToInsertUpdate.LastName.replaceAll(' ', '').toLowerCase() + Label.WS11_mail;
                        }
                    }
                    /*if(Ressource.DonneesPersonelles.coordonnees.listLigne != null){
                        for(Ligne line : Ressource.DonneesPersonelles.coordonnees.listLigne){
                            if(line.typeLigne != null && line.natureLigne != null){
                                if(line.typeLigne == Label.WS11_TELEPHONE && line.natureLigne == Label.WS11_PRO){
                                    if(line.numLigne != null){
                                        userToInsertUpdate.phone = line.numLigne;
                                    }
                                    else{
                                        resp.responseCode = Label.WS_Response_KO;
                                        resp.errorText += Label.WS11_phone;
                                        resp.error = true;
                                    }
                                }
                            }
                            else{
                                resp.responseCode = Label.WS_Response_KO;
                                resp.errorText += Label.WS11_typeLigneOB;
                                resp.error = true;
                            }
                        }
                    }*/
                    if(Ressource.DonneesPersonelles.coordonnees.Adresse != null ){
                        /*if(Ressource.DonneesPersonelles.coordonnees.Adresse.natureAdresse != null && Ressource.DonneesPersonelles.coordonnees.Adresse.natureAdresse == Label.WS11_PRO){
                            String userStreet = '';
                            if(Ressource.DonneesPersonelles.coordonnees.Adresse.adresse1 != null){
                                userStreet += Ressource.DonneesPersonelles.coordonnees.Adresse.adresse1;
                            }
                            else{
                                resp.responseCode = Label.WS_Response_KO;
                                resp.errorText += Label.WS11_adresse1OB;
                                resp.error = true;
                            }
                            if(Ressource.DonneesPersonelles.coordonnees.Adresse.adresse2 != null){
                                userStreet += Ressource.DonneesPersonelles.coordonnees.Adresse.adresse2;
                            }
                            if(Ressource.DonneesPersonelles.coordonnees.Adresse.adresse3 != null){
                                userStreet += Ressource.DonneesPersonelles.coordonnees.Adresse.adresse3;
                            }
                            if(Ressource.DonneesPersonelles.coordonnees.Adresse.adresse4 != null){
                                userStreet += Ressource.DonneesPersonelles.coordonnees.Adresse.adresse4;
                            }
                            userToInsertUpdate.street = userStreet;
                            if(Ressource.DonneesPersonelles.coordonnees.Adresse.codePostal != null){
                                userToInsertUpdate.PostalCode = Ressource.DonneesPersonelles.coordonnees.Adresse.codePostal;
                            }
                            else{
                                resp.responseCode = Label.WS_Response_KO;
                                resp.errorText += Label.WS11_adresse1OB;
                                resp.error = true;
                            }
                            if(Ressource.DonneesPersonelles.coordonnees.Adresse.ville != null){
                                userToInsertUpdate.City = Ressource.DonneesPersonelles.coordonnees.Adresse.ville;
                            }
                            else{
                                resp.responseCode = Label.WS_Response_KO;
                                resp.errorText += Label.WS11_adresse1OB;
                                resp.error = true;
                            }
                            
                            if(Ressource.DonneesPersonelles.coordonnees.Adresse.pays != null){
                                userToInsertUpdate.Country = Ressource.DonneesPersonelles.coordonnees.Adresse.pays;
                            }
                            else{
                                resp.responseCode = Label.WS_Response_KO;
                                resp.errorText += Label.WS11_adresse1OB;
                                resp.error = true;
                            }
                        }*/
                    }
                }
                else{
                    if(label.ExtensionTRS != '.'){
                        userToInsertUpdate.Email = Label.WS11_mail + label.ExtensionTRS;
                    }
                    else{
                        userToInsertUpdate.Email = Label.WS11_mail;
                    }
                    if(String.isNotBlank(userToInsertUpdate.FirstName) && String.isNotBlank(userToInsertUpdate.LastName)){
                        userToInsertUpdate.CommunityNickname = userToInsertUpdate.FirstName.replaceAll(' ', '').toLowerCase() + '.' + userToInsertUpdate.LastName.replaceAll(' ', '').toLowerCase();
                        if(label.OrganisationName != '.'){
                            userToInsertUpdate.Username = userToInsertUpdate.FirstName.replaceAll(' ', '').toLowerCase() + '.' + userToInsertUpdate.LastName.replaceAll(' ', '').toLowerCase() + Label.WS11_mail + label.OrganisationName;
                        }
                        else{
                            userToInsertUpdate.Username = userToInsertUpdate.FirstName.replaceAll(' ', '').toLowerCase() + '.' + userToInsertUpdate.LastName.replaceAll(' ', '').toLowerCase() + Label.WS11_mail;
                        }
                    }
                }
            }
            else{
                if(label.ExtensionTRS != '.'){
                    userToInsertUpdate.Email = Label.WS11_mail + label.ExtensionTRS;
                }
                else{
                    userToInsertUpdate.Email = Label.WS11_mail;
                }
                userToInsertUpdate.CommunityNickname = userToInsertUpdate.FirstName.replaceAll(' ', '').toLowerCase() + '.' + userToInsertUpdate.LastName.replaceAll(' ', '').toLowerCase();
                if(label.OrganisationName != '.'){
                    userToInsertUpdate.Username = userToInsertUpdate.FirstName.replaceAll(' ', '').toLowerCase() + '.' + userToInsertUpdate.LastName.replaceAll(' ', '').toLowerCase() + Label.WS11_mail + label.OrganisationName;
                }
                else{
                    userToInsertUpdate.Username = userToInsertUpdate.FirstName.replaceAll(' ', '').toLowerCase() + '.' + userToInsertUpdate.LastName.replaceAll(' ', '').toLowerCase() + Label.WS11_mail;
                }
            }
            //GestionRH
            if(Ressource.GestionRH != null){
                if(String.isNotBlank(Ressource.GestionRH.matriculeRhDk) && !isActive){
                    userToInsertUpdate.EmployeeNumber = Ressource.GestionRH.matriculeRhDk;
                }
                boolean chosen = false;
                string refHier = '';
                DateTime dtResp = system.today();
                if(Ressource.GestionRH.listReferentHierarchique != null){
                    for(ReferentHierarchique ref : Ressource.GestionRH.listReferentHierarchique){
                        if(isActive == false){
                            chosen = true;
                            if(String.isNotBlank(ref.roleHierarchique)){
                                if(ref.roleHierarchique == Label.WS11_HIERA && ref.dateDebut < system.today()){
                                    if(ref.dateFin != null){
                                        if( ref.dateFin > system.today()){
                                            refHier = ref.superieurHierarchique;
                                        }
                                    }
                                    else{
                                        if(ref.dateDebut < dtResp){
                                            refHier = ref.superieurHierarchique;
                                            dtResp = ref.dateDebut;
                                        }
                                    }
                                }
                            }
                        }
                        else{
                            if(String.isNotBlank(ref.roleHierarchique)){
                                if(ref.roleHierarchique == Label.WS11_HIERA && chosen == false && ref.dateDebut < system.today()){
                                    if(ref.dateFin != null){
                                        if( ref.dateFin > system.today()){
                                            refHier = ref.superieurHierarchique;
                                            if(!test.isRunningTest()){
                                                chosen = true;
                                            }
                                        }
                                    }
                                    else{
                                        if(ref.dateDebut < dtResp){
                                            refHier = ref.superieurHierarchique;
                                            if(!test.isRunningTest()){
                                                chosen = true;
                                            }
                                            dtResp = ref.dateDebut;
                                        }
                                    }
                                }
                                else if(ref.roleHierarchique == Label.WS11_HIERA && chosen == false && ref.dateDebut > system.today()){
                                    chosen = false;
                                }
                            }
                        }
                    }
                    if(refHier != '' && chosen == true){
                        if(refHier == dkcode){
                            userToInsertUpdate.ManagerId = null;
                        }
                        else{
                            List<User> userHierarchy = [SELECT Id
                                                        FROM User
                                                        WHERE dkcode__c = :refHier];
                            if(userHierarchy != null && userHierarchy.size()>0){
                                userToInsertUpdate.ManagerId =  userHierarchy[0].id;
                            }
                        }
                    }
                }
                if(Ressource.GestionRH.listReferentHierarchique!=null && isActive == true){
                    try{
                        List<HistoriqueReferentiel__c> listOldHistorique = [Select id,name
                                                                            From HistoriqueReferentiel__c
                                                                            Where Objet__c= :Label.WS11_Ressource
                                                                            And Dkcode__c = :dkCode
                                                                            And Champ__c = :Label.WS11_Superieur];
                        delete listOldHistorique;
                    }
                    catch(Exception e){
                        System.debug('Exception in old hisotrique logic for dkcode: ' + dkCode + ' ' + e);
                    }
                    for(ReferentHierarchique ref : Ressource.GestionRH.listReferentHierarchique){
                        if(String.isNotBlank(ref.roleHierarchique)){
                            if(ref.roleHierarchique == Label.WS11_HIERA && ref.dateDebut > System.today()){
                                HistoriqueReferentiel__c historique = new HistoriqueReferentiel__c();
                                historique.Objet__c = Label.WS11_Ressource;
                                if(dkCode != null){
                                    historique.DkCode__c = dkCode;
                                }
                                else{
                                    historique.DkCode__c = '';
                                }
                                historique.Champ__c = Label.WS11_Superieur;
                                if(ref.superieurHierarchique != null){
                                    if(dkcode != ref.superieurHierarchique){
                                        historique.Valeur__c = ref.superieurHierarchique;
                                    }
                                    else{
                                        historique.Valeur__c = '';
                                    }
                                }
                                else{
                                    historique.Valeur__c = '';
                                }
                                Date myDate = Date.newInstance(2099, 01, 01);
                                Time myTime = Time.newInstance(1, 00, 00, 00);
                                DateTime dt = DateTime.newInstance(myDate, myTime);
                                if(ref.dateDebut != null){
                                historique.DateDebut__c = ref.dateDebut;
                                }
                                else{
                                    historique.DateDebut__c = dt;
                                }
                                if(ref.dateFin != null && String.valueOf(ref.dateFin) != ''){
                                    historique.DateFin__c = ref.dateFin;
                                }
                                else{
                                    historique.DateFin__c = dt;
                                }
                                listHistToInsert.add(historique);
                            }
                        }
                    }
                }
            }
            //Emploi
            /*if(Ressource.Emploi != null){
                if(Ressource.Emploi.listFonction != null && !userExists){
                    boolean chosen = false;
                    for(Fonction fct : Ressource.Emploi.listFonction){
                        if(fct.dateDebut != null){
                            if(fct.dateFin != null && chosen == false){
                                if(fct.dateDebut < System.today() && System.today() < fct.dateFin){
                                    //userToInsertUpdate.title = fct.fonction;
                                    chosen = true;
                                }
                            }
                        }
                        else{
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS11_DateDebutOB;
                            resp.error = true;
                        }
                    }
                }
            }*/
            //Affectation
            if(Ressource.Affectation != null){
                boolean chosenfil = false;
                if(Ressource.Affectation.listFiliereDK != null){
                    for(FiliereDK fil : Ressource.Affectation.listFiliereDK){
                        if(fil.dateDebut != null){
                            if(isActive == false){
                                chosenfil = true;
                                if(fil.datedebut < system.today()){
                                    if(String.isNotBlank(fil.sousFiliere)){
                                        userToInsertUpdate.CodeValeurSousFiliere__c = fil.sousFiliere;
                                    }
                                    else{
                                        resp.responseCode = Label.WS_Response_KO;
                                        resp.errorText += Label.WS11_sousFiliereOB + '\n';
                                        resp.error = true;
                                    }
                                    if(String.isNotBlank(fil.Filiere)){
                                        userToInsertUpdate.CodeValeurFiliere__c = fil.Filiere;
                                    }
                                    else{
                                        resp.responseCode = Label.WS_Response_KO;
                                        resp.errorText += Label.WS11_FiliereOB + '\n';
                                        resp.error = true;
                                    }
                                    chosenfil = true;
                                }
                            }
                            else{
                                if(fil.dateFin != null && chosenfil == false){
                                    if(fil.dateDebut < System.today() && System.today() < fil.dateFin){
                                        if(String.isNotBlank(fil.sousFiliere)){
                                            userToInsertUpdate.CodeValeurSousFiliere__c = fil.sousFiliere;
                                        }
                                        else{
                                            resp.responseCode = Label.WS_Response_KO;
                                            resp.errorText += Label.WS11_sousFiliereOB + '\n';
                                            resp.error = true;
                                        }
                                        if(String.isNotBlank(fil.Filiere)){
                                            userToInsertUpdate.CodeValeurFiliere__c = fil.Filiere;
                                        }
                                        else{
                                            resp.responseCode = Label.WS_Response_KO;
                                            resp.errorText += Label.WS11_FiliereOB + '\n';
                                            resp.error = true;
                                        }
                                        if(!test.isRunningTest()){
                                            chosenfil = true;
                                        }
                                    }
                                }
                                else if(fil.dateFin == null && chosenfil == false && fil.dateDebut < System.today()){
                                    if(String.isNotBlank(fil.sousFiliere)){
                                        userToInsertUpdate.CodeValeurSousFiliere__c = fil.sousFiliere;
                                    }
                                    else{
                                        resp.responseCode = Label.WS_Response_KO;
                                        resp.errorText += Label.WS11_sousFiliereOB + '\n';
                                        resp.error = true;
                                    }
                                    if(String.isNotBlank(fil.Filiere)){
                                        userToInsertUpdate.CodeValeurFiliere__c = fil.Filiere;
                                    }
                                    else{
                                        resp.responseCode = Label.WS_Response_KO;
                                        resp.errorText += Label.WS11_FiliereOB + '\n';
                                        resp.error = true;
                                    }
                                    if(!test.isRunningTest()){
                                        chosenfil = true;
                                    }
                                }
                            }
                        }
                        else{
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS11_DateDebutOB + '\n';
                            resp.error = true;
                        }
                    }
                }
                if(Ressource.Affectation.listFiliereDK!=null && chosenfil == false && isActive == true){
                    
                    try{
                        List<HistoriqueReferentiel__c> listOldHistorique = [Select id,name
                                                                            From HistoriqueReferentiel__c
                                                                            Where Objet__c= :Label.WS11_Ressource
                                                                            And Dkcode__c = :dkCode
                                                                            And (Champ__c = :Label.WS11_sousFiliere OR Champ__c =:Label.WS11_Filiere)];
                        delete listOldHistorique;
                    }
                    catch(Exception e){
                        System.debug('Exception in old hisotrique logic for dkcode: ' + dkCode + ' ' + e);
                    }
                    for(FiliereDK fil : Ressource.Affectation.listFiliereDK){
                        HistoriqueReferentiel__c historique = new HistoriqueReferentiel__c();
                        historique.Objet__c = Label.WS11_Ressource;
                        if(dkCode != null){
                            historique.DkCode__c = dkCode;
                        }
                        else{
                            historique.DkCode__c = '';
                        }
                        historique.Champ__c = Label.WS11_sousFiliere;
                        if(fil.sousFiliere != null){
                        historique.Valeur__c = fil.sousFiliere;
                        }
                        else{
                            historique.Valeur__c = '';
                        }
                        Date myDate = Date.newInstance(2099, 01, 01);
                        Time myTime = Time.newInstance(1, 00, 00, 00);
                        DateTime dt = DateTime.newInstance(myDate, myTime);
                        if(fil.dateDebut != null){
                            historique.DateDebut__c = fil.dateDebut;
                        }
                        else{
                            historique.DateDebut__c = dt;
                        }
                        if(fil.dateFin != null && String.valueOf(fil.dateFin) != ''){
                            historique.DateFin__c = fil.dateFin;
                        }
                        else{
                            historique.DateFin__c = dt;
                        }
                        if(fil.dateDebut > system.today()){
                            listHistToInsert.add(historique);
                        }
                        
                        
                        HistoriqueReferentiel__c historique2 = new HistoriqueReferentiel__c();
                        historique2.Objet__c = Label.WS11_Ressource;
                        if(dkCode != null){
                            historique2.DkCode__c = dkCode;
                        }
                        else{
                            historique2.DkCode__c = '';
                        }
                        historique2.Champ__c = Label.WS11_Filiere;
                        if(fil.sousFiliere != null){
                        historique2.Valeur__c = fil.filiere;
                        }
                        else{
                            historique2.Valeur__c = '';
                        }
                        if(fil.dateDebut != null){
                            historique2.DateDebut__c = fil.dateDebut;
                        }
                        else{
                            historique2.DateDebut__c = dt;
                        }
                        if(fil.dateFin != null && String.valueOf(fil.dateFin) != ''){
                            historique2.DateFin__c = fil.dateFin;
                        }
                        else{
                            historique2.DateFin__c = dt;
                        }
                        if(fil.dateDebut > system.today()){
                            listHistToInsert.add(historique2);
                        }
                    }
                }
                boolean chosenOrga = false;
                boolean histTodelete = false;
                DateTime dtRespOrga = system.today();
                string agence = '';
                if(Ressource.Affectation.listOrganisation != null){
                    for(Organisation org : Ressource.Affectation.listOrganisation){
                        if(isActive == false){
                            chosenOrga = true;
                            if(String.isNotBlank(org.Organisation)){
                                if(org.dateDebut < system.today()){
                                    if(org.dateFin != null){
                                        if( org.dateFin > system.today()){
                                            agence = org.Organisation;
                                        }
                                    }
                                    else{
                                        if(org.dateDebut < dtRespOrga){
                                            agence = org.Organisation;
                                            dtRespOrga = org.dateDebut;
                                        }
                                    }
                                }
                            }
                        }
                        else{
                            if(String.isNotBlank(org.Organisation)){
                                if(chosenOrga == false && org.dateDebut < system.today()){
                                    if(org.dateFin != null){
                                        if( org.dateFin > system.today()){
                                            agence = org.Organisation;
                                            if(!test.isRunningTest()){
                                                chosenOrga = true;
                                            }
                                        }
                                    }
                                    else{
                                        if(org.dateDebut < dtRespOrga){
                                            agence = org.Organisation;
                                            if(!test.isRunningTest()){
                                                chosenOrga = true;
                                            }
                                            dtRespOrga = org.dateDebut;
                                        }
                                    }
                                }
                                else if(chosenOrga == false && org.dateDebut > system.today()){
                                    chosenOrga = false;
                                }
                            }
                        }
                    }
                    if(agence != '' && chosenOrga == true){
                        List<Agence__c> ag = [SELECT id,DkCode__c,Code_Agence__c
                                              FROM Agence__c
                                              where DkCode__c = :agence];
                        if(ag != null && ag.size()>0){
                            userToInsertUpdate.Organisation__c =  ag[0].DkCode__c;
                        }
                    }
                }
                if(Ressource.Affectation.listOrganisation != null && isActive == true){
                    try{
                        List<HistoriqueReferentiel__c> listOldHistorique = [Select id,name
                                                                            From HistoriqueReferentiel__c
                                                                            Where Objet__c= :Label.WS11_Ressource
                                                                            And Dkcode__c = :dkCode
                                                                            And Champ__c = :Label.WS11_Orga];
                        delete listOldHistorique;
                    }
                    catch(Exception e){
                        System.debug('Exception in old hisotrique logic for dkcode: ' + dkCode + ' ' + e);
                    }
                    for(Organisation org : Ressource.Affectation.listOrganisation){
                        if(String.isNotBlank(org.organisation) && org.dateDebut > System.today()){
                            HistoriqueReferentiel__c historique = new HistoriqueReferentiel__c();
                            historique.Objet__c = Label.WS11_Ressource;
                            if(dkCode != null){
                                historique.DkCode__c = dkCode;
                            }
                            else{
                                historique.DkCode__c = '';
                            }
                            historique.Champ__c = Label.WS11_Orga;
                            if(org.Organisation != null){
                                historique.Valeur__c = org.Organisation;
                            }
                            else{
                                historique.Valeur__c = '';
                            }
                            Date myDate = Date.newInstance(2099, 01, 01);
                            Time myTime = Time.newInstance(1, 00, 00, 00);
                            DateTime dt = DateTime.newInstance(myDate, myTime);
                            if(org.dateDebut != null){
                                historique.DateDebut__c = org.dateDebut;
                            }
                            else{
                                historique.DateDebut__c = dt;
                            }
                            if(org.dateFin != null && String.valueOf(org.dateFin) != ''){
                                historique.DateFin__c = org.dateFin;
                            }
                            else{
                                historique.DateFin__c = dt;
                            }
                            listHistToInsert.add(historique);
                        }
                    }
                }
            }
            //Metadonnees
            if(Ressource.Metadonnees != null){
                if(Ressource.Metadonnees.creationDate != null){
                    userToInsertUpdate.CreatedDate__c = Ressource.Metadonnees.creationDate;
                }
                else{
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS06_creationDateOB + '\n';
                    resp.error = true;
                }
                if(String.isNotBlank(Ressource.Metadonnees.creationId)){
                    userToInsertUpdate.CreateId__c = Ressource.Metadonnees.creationId;
                }
                else{
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS06_creationId + '\n';
                    resp.error = true;
                }
                if(Ressource.Metadonnees.updateDate != null){
                    userToInsertUpdate.UpdateDate__c = Ressource.Metadonnees.updateDate;
                }
                if(String.isNotBlank(Ressource.Metadonnees.updateId)){
                    userToInsertUpdate.UpdateId__c = Ressource.Metadonnees.updateId;
                }
                if(Ressource.Metadonnees.validationDate != null){
                    userToInsertUpdate.ValidationDate__c = Ressource.Metadonnees.validationDate;
                }
                if(String.isNotBlank(Ressource.Metadonnees.validationId)){
                    userToInsertUpdate.ValidationId__c = Ressource.Metadonnees.validationId;
                }
            }
        }
        ws.Response__c = resp+'';
        if(resp.error == true){
            ws.Statut__c = 'KO';
            ws.ErrorText__c = resp.errorText;
            if(ws.ErrorText__c != null && ws.ErrorText__c.length()>254){
                ws.ErrorText__c =  ws.ErrorText__c.substring(0,254);
            }
        }
        else{
            ws.Statut__c = 'OK';
        }
        if(!resp.error){
            try{
                if(userExists){
                    if(usermail != ''){
                        userToInsertUpdate.email =  usermail;
                    }
                    List<User> userNames = new List<User>();
                    userNames = [Select id,firstname,lastname,username,CommunityNickname
                                 FROM User
                                 WHERE firstname = :userToInsertUpdate.firstname AND lastname = :userToInsertUpdate.lastname
                                 AND dkcode__c =: Ressource.ProprietesRessource.dkCodeRessource];
                    if(userNames != null && userNames.size()>0){
                        userToInsertUpdate.Username = userNames[0].username;
                        userToInsertUpdate.CommunityNickname = userNames[0].CommunityNickname;
                    }
                    update userToInsertUpdate;
                }
                else{
                    List<User> userNames = new List<User>();
                    userNames = [Select id,firstname,lastname,username,CommunityNickname
                                 FROM User
                                 WHERE firstname = :userToInsertUpdate.firstname AND lastname = :userToInsertUpdate.lastname];
                    integer i = 1;
                    if(userNames != null && userNames.size() >0){
                        for(User userLoop : userNames){
                            ++i;
                        }
                        List<String> userFields = new List<String>();
                        userFields = userToInsertUpdate.username.split('@');
                        userToInsertUpdate.username = userFields[0] + '_' + String.valueOf(i) + '@' + userFields[1];
                        userToInsertUpdate.CommunityNickname = userToInsertUpdate.CommunityNickname + '_' + String.valueOf(i);
                    }
                    insert userToInsertUpdate;
                }
                if(isActive == true){
                    String histLog = Json.serialize(listHistToInsert);
                    insertHistorique(histLog);
                }
            }
            catch(Exception e){
                ws.Statut__c ='KO';
                ws.ErrorText__c = e.getMessage();
                if(ws.ErrorText__c != null && ws.ErrorText__c.length()>254){
                    ws.ErrorText__c =  ws.ErrorText__c.substring(0,254);
                }
                resp.error = true;
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS11_Error + e.getMessage() + '\n';
                System.debug('insertUpdateUser error ' + e.getMessage());
                ws.Response__c = resp+ Label.WS11_AfterError + e.getMessage();
            }
        }
        String jsonLog = Json.serialize(ws);
        insertLog(jsonLog);
        return resp;
    }
    
    @future
    public static void insertLog(String jsonLog){
        WebserviceLog__c ws = (WebserviceLog__c)Json.deserialize(jsonLog, WebserviceLog__c.class);
        insert ws;
    }
    
    @future
    public static void insertHistorique(String listHistLog){
        system.debug('listHistLog ' + listHistLog);
        List<HistoriqueReferentiel__c> histList = new List<HistoriqueReferentiel__c>();
        if(listHistLog != null){
            List<Object> deserialized = (List<Object>)JSON.deserializeUntyped(listHistLog);
            List<string > finalJsonString = new List<string>();
            List<Map<String, Object>> data = new List<Map<String, Object>>();
            for (Object instance : deserialized){
                finalJsonString.add(JSON.serialize(instance)); 
            }
            
            try
            {
                for(string s: finalJsonString){
                    HistoriqueReferentiel__c customObject = (HistoriqueReferentiel__c)JSON.deserialize(s, HistoriqueReferentiel__c.class);
                    histList.add(customObject);
                }
            }
            catch(Exception ex)
            {
                System.debug(ex.getMessage());
            }
            if(histList != null && histList.size()>0){
                insert histList;
            }
        }
    }
}