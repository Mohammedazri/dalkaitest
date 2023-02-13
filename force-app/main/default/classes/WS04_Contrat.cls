/**
 * @author: Alain Ghoussoub -EI Technologies
 * @date: 10/01/2019
 * @description: Class qui gère le web service entrant Contrat
 */
global class WS04_Contrat {
    global class Contrat {
        webservice Header Header;
        webservice Propriete_Contrat proprietesContrat {get; set;}
        webservice Proprietes_Cvs proprietesCvs {get; set;}                    //Added by Jimmy 08/02/2022 - CVS
        webservice Contrat_Cadre contratCadre {get; set;}
        webservice listeDocuments listeDocuments {get; set;}
        webservice Durees durees {get; set;}
        webservice listeResumes listeResumes {get; set;}
        webservice listeServices listeServices {get; set;}
        webservice listePartenaires listePartenaires {get; set;}
        webservice listeAffaires listeAffaires {get; set;}
        webservice listeProjetsFinance listeProjetsFinance {get; set;}
        webservice listeResponsables listeResponsables {get; set;}
        webservice Numerotation_contrat numerotationContrat {get; set;}
        webservice Metadonnees_contrat metadonneesContrat {get; set;}
    }
    global class listeDocuments {
        webservice List<Documents> document;
    }
    global class listeResumes {
        webservice List<Resume> resume;
    }
    global class listeServices {
        webservice List<Services> service;
    }
    global class listePartenaires {
        webservice List<Partenaires> partenaire;
    }
    global class listeAffaires {
        webservice List<Affaires> affaire;
    }
    global class listeProjetsFinance {
        webservice List<Projets_finance> projetFinance;
    }
    global class listeResponsables {
        webservice List<Responsables> responsable;
    }
    global class Propriete_Contrat {
        webservice String DKCodeContrat;//DKCodeSurContrat__c
        webservice String libelle;
        webservice String commentaire;//Commentaire__c
        webservice String controleContrat;//ControleContrat__c
        webservice String statutContrat;//Statut__c
        webservice String statutFacturation;
        webservice String motifRejet;//MotifRejet__c
        webservice String statutServices;//StatutServices__c
        webservice String categorieContrat;//TypeContrat__c
        webservice String interco;//Interco__c
        webservice String formeJuridique;//FormeJuridique__c
        webservice String langue;//Langue__c
        webservice String devise;//Devise__c
        webservice String numeroDossier;//Numdossier__c
        webservice String contratDorigine;//ContratOrigine__c
        webservice Boolean estContratNational;//EstContratNational__c
        webservice String natureContrat;//NatureContrat__c
        webservice String provenanceContrat;//ProvenanceContrat__c
        webservice Datetime dateDeValidation;//Datevalidation__c
        webservice String motifDeFermeture;//Motif_fermeture_contrat__c
        webservice String conditionDeFermeture;//Condition_de_fermeture__c
        webservice Datetime dateDeFin;//DateFin__c
        webservice Boolean estContratCadre;//EstContratcadre__c
        webservice String reportingContrat;//ReportingContrat__c
        webservice String UOPiloteContrat;//UOPiloteContrat__c
        webservice String typeContratFacturation;
        webservice String typeContrat;                              //NatureContratCadre__c  07-03-2022 Added by Jimmy US C360-655
    }
    global class Contrat_Cadre {
        webservice String contratCadre;//ContratCadre__c
    }

    //Added by Jimmy 08/02/2022 - CVS
    global class Proprietes_Cvs {
        webservice String natureOffre;                    //natureOffre__c
        webservice String engagementEnergetique;                    //engagementEnergetique__c
        webservice String paiementDesEnergies;                    //paiementDesEnergies__c
        webservice String niveauDeMaintenance;                    //niveauDeMaintenance__c
    }
    //end CVS

    global class Documents {
        webservice String numeroPiece;
        webservice Boolean referenceDuree;
        webservice String natureDocument;
        webservice String origineDocument;
        webservice String referenceDocument;//DocumentReference__c
        webservice String titreDocument;
        webservice Datetime dateSignature;
        webservice Datetime datePriseEffet;//DatePriseEffet__c
        webservice String statutDocument;//Statutdocument__c
        webservice Datetime dateStockage;
        webservice String niveauConfidentialite;//NiveauDeConfidentialite__c
        webservice String commentaireDocument;//Commentaire__c
        webservice Avenants avenants;
        webservice Metadonnees_document metadonneesDocument;
    }

    global class Avenants {
        webservice Boolean MAJConditionsDuree;//Misejourconditionsduree__c
        webservice Boolean MAJConditionsTechniques;//Misejourconditionstechniques__c
        webservice Boolean MAJConditionsFacturation;//Misejourconditionsfacturation__c
        webservice Boolean ajoutPrestations;//Ajoutprestations__c
        webservice Boolean retraitPrestations;//Retraitprestations__c
        webservice Boolean autresModifications;//Autresmodifications__c
    }
    global class Metadonnees_document {
        webservice Datetime creationDate;
        webservice String creationId;
        webservice Datetime updateDate;
        webservice String updateId;
        webservice Datetime validationDate;
        webservice String validationId;
    }

    global class Durees {
        webservice Datetime datePriseEffetInitiale;
        webservice Double dureeInitialeContrat;//DureeInitialeContrat__c
        webservice String typeReconduction;//TypeReconduction__c
        webservice Double dureeReconduction;//DureeReconduction__c
        webservice Double dureePreavis;//DureePreavis__c
        webservice Double nombreReconductionAutorise;//NombreReconductionsAutorisees__c
        webservice Double dureeMaximaleCumulee;//DureeMaximaleCumulee_del__c
        webservice Boolean reconductionFaitAutorisee;//ReconductionFaitAutorisee__c
        webservice Double nombreReconductionPassee;//NombreReconductionsPassees__c
        webservice Datetime dateProchainPreavis;//DateProchainPreavis__c
        webservice Datetime dateProchaineEcheance;//DateProchaineEcheance__c
    }

    global class Resume {
        webservice String parametrePortailClient;//ParametrePortailClient__c
        webservice String precisionParametre;//PrecisionParametre__c
        webservice String informationComplementaire;//InformationComplementaire__c
        webservice String valeurContractuelle;//ValeurContractuelle__c //type is double in excel, keep it string cause field in SF is of type Text
        webservice String uniteValeurContractuelle;//UniteValeurContractuelle__c
    }

    global class Services {
        webservice String service;//Service__c
        webservice Boolean penalitesAssociees;//Penalitesassocies__c
        webservice String perimetreRealisation;//Perimtrerealisation__c
        webservice Boolean statutLienService;
        webservice listePrestations listePrestations;
    }
    global class listePrestations {
        webservice List<Prestations> prestation;
    }
    global class Prestations {
        webservice String prestation;
        webservice Boolean prestationExternalisee;
        webservice String modeRemuneration;
        webservice String gestionLivreOuvert;
        webservice String complementInformation;
        webservice Boolean statutLienPrestation;
    }

    global class Partenaires {
        webservice String partenaire;//NomPartenaire__c
        webservice String matriculeSociete;//MatriculeSocieteDalkia__c
        webservice String adressePartenaire;
        webservice String rolePartenaire;//RolePartenaire__c
        webservice String modeReglement;//Modereglement__c
        webservice Boolean statutLienPartenaire;
        webservice listeContacts listeContacts;
    }
    global class listeContacts {
        webservice List<Contacts> contact;
    }

    global class Contacts {
        webservice String contact;//Contact_du_partenaire__c
        webservice String roleContact;//FonctionContact__c
        webservice String accesPSV;//AccesPSV__c
        webservice Boolean statutLienContact;
    }
    global class Affaires {
        webservice String affaire;//Affaire__c
        webservice Boolean statutLienAffaire;
    }

    global class Projets_finance {
        webservice String tacheFinance;
        webservice String projetFinance;
        webservice Boolean statutLienTF;
    }
    global class Responsables {
        webservice String responsableContrat;
        webservice String perimetreResponsable;//Perimetreresponsable__c
        webservice Boolean statutLienResponsable;
    }
    global class Numerotation_contrat {
        webservice String applicationSource;//Applicationsourcecontrat__c
        webservice String codeSource;
    }
    global class Metadonnees_contrat {
        webservice DateTime creationDate;//CreatedDate
        webservice String creationId;//CreatedBy
        webservice DateTime updateDate;//LastModifiedDate
        webservice String updateId;//LastModifiedBy
        webservice DateTime validationDate;
        webservice String validationId;
    }

    webservice static Response insertContrat(Contrat contratFields) {
        WebserviceLog__c ws = new WebserviceLog__c();
        ws.Request__c = contratFields + '';
        ws.Type__c = Label.WS_Contrat;
        ws.flux__c = Label.WSTypeFluxEntrant;
        insert ws;

        TimeZone tz = TimeZone.getTimeZone('Europe/Paris');

        List<EcosystemePartenaire__c> listEcoSys = new List<EcosystemePartenaire__c>();
        List<LienContratTacheFinance__c> listLienTacheFinance = new List<LienContratTacheFinance__c>();

        //13-1-2022 Commneted By Jimmy - CVS: the objects Service__c and LienContratService__c are deleted
        /*Map<String,LienContratService__c> mapServiceLien = new Map<String,LienContratService__c>();
           List<LienContratService__c> listLienContratService = new List <LienContratService__c>();
           List<LienContratService__c> listLCSUpdate = new List<LienContratService__c>();
           List<LienContratService__c> listLCSInsert = new List<LienContratService__c>();
           List<LienContratService__c> ListLCSDelete = new List<LienContratService__c>();*/
        //end CVS

        Response resp = new Response();
        Contrat__c cont = new Contrat__c();
        List<Contrat__c> oldCont = new List<Contrat__c>();

        resp.errorText = '';
        resp.error = false;
        resp.responseCode = Label.WS_Response_OK;

        //délaration des champs WebServiceLog
        if(contratFields.header != null) {
            if(contratFields.header.transactionId != null) {
                ws.TransactionId__c = contratFields.header.transactionId;
            }
        }

        boolean dkExists = false;
        boolean numExists = false;
        List<Contrat__c> contDK = new List<Contrat__c>();
        List<Contrat__c>  contNum = new List<Contrat__c>();

        if(contratFields.proprietesContrat != null && String.isNotBlank(contratFields.proprietesContrat.DKCodeContrat)) {
            ws.DkCode__c = contratFields.proprietesContrat.DKCodeContrat;
            contDK = [SELECT id from Contrat__c WHERE DKCodeSurContrat__c = : contratFields.proprietesContrat.DKCodeContrat];
            if(contDK != null && contDK.size() > 0) {
                dkExists = true;
                cont.id = contDK[0].id;
            }
        }

        if(dkExists == false) {
            if(contratFields.numerotationContrat != null && String.isNotBlank(contratFields.numerotationContrat.codeSource)) {
                contNum = [SELECT id
                           FROM Contrat__c
                           WHERE NumeroContrat__c = : contratFields.numerotationContrat.codeSource];
                if(contNum != null && contNum.size() > 0) {
                    numExists = true;
                    cont.id = contNum[0].id;
                }
            }
        }

        if(dkExists == true || numExists == true || Test.isRunningTest()) {
            //proprietesContrat
            if(contratFields.proprietesContrat == null) {
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS04_proprietesContratOB + '\n';
                resp.error = true;
            }
            //proprietesContrat sub fields
            else {
                if(String.isBlank(contratFields.proprietesContrat.DKCodeContrat)) {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS04_DKCodeContratOB + '\n';
                    resp.error = true;
                } else {
                    cont.DKCodeSurContrat__c = contratFields.proprietesContrat.DKCodeContrat;
                    oldCont = [Select id, name, statut__c
                               from contrat__c
                               where dkcodesurcontrat__c = : contratFields.proprietesContrat.DKCodeContrat];
                }
                if(String.isBlank(contratFields.proprietesContrat.libelle)) {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS04_libelleOB + '\n';
                    resp.error = true;
                } else {
                    String tempName = contratFields.proprietesContrat.libelle;
                    if(tempName != null) {
                        if(tempName.length() > 80) {
                            tempName =  tempName.substring(0, 80);
                        }
                        cont.Name = tempName;
                    }
                }
                if(contratFields.proprietesContrat.commentaire != null) {
                    cont.Commentaire__c = contratFields.proprietesContrat.commentaire;
                }
                if(contratFields.proprietesContrat.controleContrat == null) {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS04_controleContratOB + '\n';
                    resp.error = true;
                } else {
                    cont.ControleContrat__c = contratFields.proprietesContrat.controleContrat;
                }
                if(contratFields.proprietesContrat.statutContrat == null) {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS04_statutContratOB + '\n';
                    resp.error = true;
                } else {
                    if(oldCont == null || oldCont.size() == 0 || oldCont[0].Statut__c != Label.ContratFerme) { //if new contract or contract status was not FER --> can modify it (once we set status to FER cannot be changed from mdm)
                        cont.Statut__c = contratFields.proprietesContrat.statutContrat;
                    }
                }
                if(contratFields.proprietesContrat.statutFacturation == null) {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS04_statutFacturationOB + '\n';
                    resp.error = true;
                } else {
                    cont.Statut_Facturation__c = contratFields.proprietesContrat.statutFacturation;
                }
                if(!String.isBlank(contratFields.proprietesContrat.motifRejet)) {
                    cont.MotifRejet__c = contratFields.proprietesContrat.motifRejet;
                }
                if(String.isBlank(contratFields.proprietesContrat.statutServices)) {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS04_statutServicesOB + '\n';
                    resp.error = true;
                } else {
                    cont.StatutServices__c = contratFields.proprietesContrat.statutServices;
                }
                if(String.isBlank(contratFields.proprietesContrat.categorieContrat)) {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS04_categorieContratOB + '\n';
                    resp.error = true;
                } else {
                    cont.CategorieContrat__c = contratFields.proprietesContrat.categorieContrat;
                }
                if(String.isBlank(contratFields.proprietesContrat.interco)) {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS04_intercoOB + '\n';
                    resp.error = true;
                } else {
                    cont.Interco__c = contratFields.proprietesContrat.interco;
                }
                if(!String.isBlank(contratFields.proprietesContrat.formeJuridique)) {
                    cont.FormeJuridique__c = contratFields.proprietesContrat.formeJuridique;
                }
                if(String.isBlank(contratFields.proprietesContrat.langue)) {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS04_langueOB + '\n';
                    resp.error = true;
                } else {
                    cont.Langue__c = contratFields.proprietesContrat.langue;
                }
                if(String.isBlank(contratFields.proprietesContrat.devise)) {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS04_deviseOB + '\n';
                    resp.error = true;
                } else {
                    cont.Devise__c = contratFields.proprietesContrat.devise;
                }
                if(!String.isBlank(contratFields.proprietesContrat.numeroDossier)) {
                    cont.Numdossier__c = contratFields.proprietesContrat.numeroDossier;
                }
                /*
                   if(!String.isBlank(contratFields.proprietesContrat.contratDorigine)){
                    //cont.OpportuniteCommerciale__r.ContratOrigine__r.DKCodeSurContrat__c = contratFields.proprietesContrat.contratDorigine;
                   }
                 */
                if(contratFields.proprietesContrat.estContratNational == null) {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS04_estContratNationalOB + '\n';
                    resp.error = true;
                } else {
                    cont.EstContratNational__c = contratFields.proprietesContrat.estContratNational;
                }
                if(String.isBlank(contratFields.proprietesContrat.natureContrat)) {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS04_natureContratOB + '\n';
                    resp.error = true;
                } else {
                    cont.NatureContrat__c = contratFields.proprietesContrat.natureContrat;
                }
                if(String.isBlank(contratFields.proprietesContrat.provenanceContrat)) {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS04_provenanceContratOB + '\n';
                    resp.error = true;
                } else {
                    cont.OrigineContrat__c = contratFields.proprietesContrat.provenanceContrat;
                }
                if(contratFields.proprietesContrat.dateDeValidation == null) {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS04_dateDeValidationOB + '\n';
                    resp.error = true;
                } else {
                    DateTime DateValidationOriginal = contratFields.proprietesContrat.dateDeValidation;
                    Date DateValidationOriginalConverted = date.newinstance(DateValidationOriginal.year(), DateValidationOriginal.month(), DateValidationOriginal.day());
                    cont.Datevalidation__c = DateValidationOriginalConverted;

                    contratFields.proprietesContrat.dateDeValidation = contratFields.proprietesContrat.dateDeValidation.addSeconds(tz.getOffset(contratFields.proprietesContrat.dateDeValidation) / 1000);
                    ws.Request__c = contratFields + '';
                }
                if(!String.isBlank(contratFields.proprietesContrat.motifDeFermeture)) {
                    cont.Motif_fermeture_contrat__c = contratFields.proprietesContrat.motifDeFermeture;
                }
                if(!String.isBlank(contratFields.proprietesContrat.conditionDeFermeture)) {
                    cont.Condition_de_fermeture__c = contratFields.proprietesContrat.conditionDeFermeture;
                }
                if(contratFields.proprietesContrat.dateDeFin != null) {
                    DateTime DateFinOriginal = contratFields.proprietesContrat.dateDeFin;
                    Date DateFinConverted = date.newinstance(DateFinOriginal.year(), DateFinOriginal.month(), DateFinOriginal.day());
                    cont.DateFin__c = DateFinConverted;

                    contratFields.proprietesContrat.dateDeFin = contratFields.proprietesContrat.dateDeFin.addSeconds(tz.getOffset(contratFields.proprietesContrat.dateDeFin) / 1000);
                    ws.Request__c = contratFields + '';
                }
                if(contratFields.proprietesContrat.estContratCadre != null) {
                    cont.EstContratcadre__c = contratFields.proprietesContrat.estContratCadre;
                }
                if(!String.isBlank(contratFields.proprietesContrat.reportingContrat)) {
                    cont.ReportingContrat__c = contratFields.proprietesContrat.reportingContrat;
                }
                if(String.isBlank(contratFields.proprietesContrat.UOPiloteContrat)) {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS04_UOPiloteContratOB + '\n';
                    resp.error = true;
                } else {
                    List<CentreFinance__c> cf = [SELECT id from CentreFinance__c where DkCode__c = : contratFields.proprietesContrat.UOPiloteContrat];
                    if(cf != null && cf.size() > 0) {
                        cont.UOPiloteContrat__c = cf[0].id;
                    }
                }
                if(!String.isBlank(contratFields.proprietesContrat.typeContratFacturation)) {
                    cont.TypeContrat__c = contratFields.proprietesContrat.typeContratFacturation;
                }
                //07-03-2022 Added by Jimmy US C360-655
                if(!String.isBlank(contratFields.proprietesContrat.typeContrat)) {
                    cont.NatureContratCadre__c = contratFields.proprietesContrat.typeContrat;
                }
                //end US C360-655

            }

            //Added by Jimmy 08/02/2022 - CVS
            if(contratFields.proprietesCvs != null) {
                if(!String.isBlank(contratFields.proprietesCvs.natureOffre)) {
                    cont.natureOffre__c = contratFields.proprietesCvs.natureOffre;
                }
                if(!String.isBlank(contratFields.proprietesCvs.engagementEnergetique)) {
                    cont.engagementEnergetique__c = contratFields.proprietesCvs.engagementEnergetique;
                }
                if(!String.isBlank(contratFields.proprietesCvs.paiementDesEnergies)) {
                    cont.paiementDesEnergies__c = contratFields.proprietesCvs.paiementDesEnergies;
                }
                if(!String.isBlank(contratFields.proprietesCvs.niveauDeMaintenance)) {
                    cont.niveauDeMaintenance__c = contratFields.proprietesCvs.niveauDeMaintenance;
                }
            }
            //end CVS

            //contratCadre
            if(contratFields.contratCadre != null && !String.isBlank(contratFields.contratCadre.contratCadre)) {
                Contrat__c contratParent = new Contrat__c();
                //its the dk code
                //select contrat which has this dkcode, get id then reference it.
                List<Contrat__c> contratParentList = [Select id, name
                                                      From Contrat__c
                                                      Where DKCodeSurContrat__c = : contratFields.contratCadre.contratCadre];
                if(contratParentList != null && contratParentList.size() > 0) {
                    contratParent = contratParentList[0];
                    cont.ContratCadre__c = contratParent.id;
                }
            }

            //documents
            List<Document_Contractuel__c> listDoc = new List<Document_Contractuel__c>();

            //ListDocuments
            if(contratFields.listeDocuments == null || contratFields.listeDocuments.document == null || contratFields.listeDocuments.document.size() == 0) {
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS03_documentOB + '\n';
                resp.error = true;
            } else {
                Set<String> userRefIds = new Set<String>();
                List<User> userMetadonne = new List<User>();
                for(Documents docLoop : contratFields.listeDocuments.document) {
                    if(docLoop.metadonneesDocument != null) {
                        if(String.isNotBlank(docLoop.metadonneesDocument.creationId)) {
                            userRefIds.add(docLoop.metadonneesDocument.creationId);
                        }
                        if(String.isNotBlank(docLoop.metadonneesDocument.updateId)) {
                            userRefIds.add(docLoop.metadonneesDocument.updateId);
                        }
                        if(String.isNotBlank(docLoop.metadonneesDocument.validationId)) {
                            userRefIds.add(docLoop.metadonneesDocument.validationId);
                        }
                    }
                }
                if(userRefIds != null && userRefIds.size() > 0) {
                    userMetadonne = [SELECT id, name, ReferentielId__c
                                     FROM user
                                     WHERE ReferentielId__c in : userRefIds];
                }
                Map<String, Id> mapUserRefId = new Map<String, Id>();
                if(userMetadonne != null && userMetadonne.size() > 0) {
                    for(User userLoop : userMetadonne) {
                        mapUserRefId.put(userLoop.ReferentielId__c, userLoop.id);
                    }
                }
                for(Documents docLoop : contratFields.listeDocuments.document) {
                    Document_Contractuel__c doc = new Document_Contractuel__c();
                    if(String.isBlank(docLoop.numeroPiece)) {
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS03_numeroPieceOB + '\n';
                        resp.error = true;
                    } else {
                        doc.NumeroPiece__c = docLoop.numeroPiece;
                    }
                    if(docLoop.referenceDuree == null) {
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS05_referenceDureeOB + '\n';
                        resp.error = true;
                    } else {
                        doc.ReferenceDuree__c = docLoop.referenceDuree;
                    }
                    if(String.isBlank(docLoop.natureDocument)) {
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS05_natureDocumentOB + '\n';
                        resp.error = true;
                    } else {
                        doc.NatureDocument__c = docLoop.natureDocument;
                    }
                    /*
                       if(!String.isBlank(docLoop.origineDocument)){
                        //doc.? = docLoop.origineDocument; // a demander
                       }
                     */
                    if(!String.isBlank(docLoop.referenceDocument)) {
                        doc.ReferenceDocument__c = docLoop.referenceDocument;
                    }
                    if(String.isBlank(docLoop.titreDocument)) {
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS05_titreDocumentOB + '\n';
                        resp.error = true;
                    } else {
                        //doc.name = docLoop.titreDocument;
                        doc.TitreDocument__c = docLoop.titreDocument;
                    }
                    if(docLoop.dateSignature == null) {
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS05_dateSignatureOB + '\n';
                        resp.error = true;
                    } else {
                        Date DateSignatureConverted = date.newinstance(docLoop.dateSignature.year(), docLoop.dateSignature.month(), docLoop.dateSignature.day());
                        doc.DateSignature__c = DateSignatureConverted;

                        docLoop.dateSignature = docLoop.dateSignature.addSeconds(tz.getOffset(docLoop.dateSignature) / 1000);
                        ws.Request__c = contratFields + '';
                    }
                    if(docLoop.datePriseEffet == null) {
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS05_datePriseEffetOB + '\n';
                        resp.error = true;
                    } else {
                        DateTime DatePriseEffetOriginal = docLoop.datePriseEffet;
                        Date DatePriseEffetConverted = date.newinstance(DatePriseEffetOriginal.year(), DatePriseEffetOriginal.month(), DatePriseEffetOriginal.day());
                        doc.DatePriseEffet__c = DatePriseEffetConverted;

                        docLoop.datePriseEffet = docLoop.datePriseEffet.addSeconds(tz.getOffset(docLoop.datePriseEffet) / 1000);
                        ws.Request__c = contratFields + '';
                    }
                    if(String.isBlank(docLoop.statutDocument)) {
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS05_statutDocumentOB + '\n';
                        resp.error = true;
                    } else {
                        doc.Statutdocument__c = docLoop.statutDocument;
                    }
                    if(docLoop.dateStockage != null) {
                        doc.DateStockage__c = docLoop.dateStockage;
                    }

                    if(String.isBlank(docLoop.niveauConfidentialite)) {
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS05_niveauConfOB + '\n';
                        resp.error = true;
                    } else {
                        doc.NiveauDeConfidentialite__c = docLoop.niveauConfidentialite;
                    }

                    if(!String.isBlank(docLoop.commentaireDocument)) {
                        doc.Commentaire__c = docLoop.commentaireDocument;
                    }

                    if(docLoop.avenants != null) {
                        if(docLoop.avenants.MAJConditionsDuree == null) {
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS05_MAJConditionsDureeOB + '\n';
                            resp.error = true;
                        } else {
                            doc.MajConditionsDuree__c = docLoop.avenants.MAJConditionsDuree;
                        }
                        if(docLoop.avenants.MAJConditionsTechniques == null) {
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS05_MAJConditionsTechniquesOB + '\n';
                            resp.error = true;
                        } else {
                            doc.MajConditionsTechniques__c = docLoop.avenants.MAJConditionsTechniques;
                        }
                        if(docLoop.avenants.MAJConditionsFacturation == null) {
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS05_MAJConditionsFacturationOB + '\n';
                            resp.error = true;
                        } else {
                            doc.MAJConditionsFacturation__c = docLoop.avenants.MAJConditionsFacturation;
                        }
                        if(docLoop.avenants.ajoutPrestations == null) {
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS05_ajoutPrestationsOB + '\n';
                            resp.error = true;
                        } else {
                            doc.Ajoutprestations__c = docLoop.avenants.ajoutPrestations;
                        }
                        if(docLoop.avenants.retraitPrestations == null) {
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS05_retraitPrestationsOB + '\n';
                            resp.error = true;
                        } else {
                            doc.Retraitprestations__c = docLoop.avenants.retraitPrestations;
                        }
                        if(docLoop.avenants.autresModifications == null) {
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS05_autresModificationsOB + '\n';
                            resp.error = true;
                        } else {
                            doc.Autresmodifications__c = docLoop.avenants.autresModifications;
                        }
                    }
                    if(docLoop.metadonneesDocument == null) {
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS05_metadonneesDocumentOB + '\n';
                        resp.error = true;
                    } else {
                        if(docLoop.metadonneesDocument.creationDate == null) {
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS06_creationDateOB + '\n';
                            resp.error = true;
                        } else {
                            doc.WSCreationDate__c = docLoop.metadonneesDocument.creationDate;

                            docLoop.metadonneesDocument.creationDate = docLoop.metadonneesDocument.creationDate.addSeconds(tz.getOffset(docLoop.metadonneesDocument.creationDate) / 1000);
                            ws.Request__c = contratFields + '';
                        }
                        if(String.isBlank(docLoop.metadonneesDocument.creationId)) {
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS06_creationId + '\n';
                            resp.error = true;
                        } else if(!String.isBlank(docLoop.metadonneesDocument.creationId)) {
                            if(mapUserRefId.keySet().contains(docLoop.metadonneesDocument.creationId)) {
                                doc.CreateId__c = mapUserRefId.get(docLoop.metadonneesDocument.creationId);
                            }
                        }
                        if(docLoop.metadonneesDocument.updateDate != null) {
                            doc.WSModificationDate__c = docLoop.metadonneesDocument.updateDate;

                            docLoop.metadonneesDocument.updateDate = docLoop.metadonneesDocument.updateDate.addSeconds(tz.getOffset(docLoop.metadonneesDocument.updateDate) / 1000);
                            ws.Request__c = contratFields + '';
                        }
                        if(!String.isBlank(docLoop.metadonneesDocument.updateId)) {
                            if(mapUserRefId.keySet().contains(docLoop.metadonneesDocument.updateId)) {
                                doc.UpdateId__c = mapUserRefId.get(docLoop.metadonneesDocument.updateId);
                            }
                        }
                        if(docLoop.metadonneesDocument.validationDate != null) {
                            doc.ValidationDate__c = docLoop.metadonneesDocument.validationDate;

                            docLoop.metadonneesDocument.validationDate = docLoop.metadonneesDocument.validationDate.addSeconds(tz.getOffset(docLoop.metadonneesDocument.validationDate) / 1000);
                            ws.Request__c = contratFields + '';
                        }
                        if(!String.isBlank(docLoop.metadonneesDocument.validationId)) {
                            if(mapUserRefId.keySet().contains(docLoop.metadonneesDocument.validationId)) {
                                doc.ValidationId__c = mapUserRefId.get(docLoop.metadonneesDocument.validationId);
                            }
                        }
                    }
                    listDoc.add(doc);
                }
            }
            //durees
            if(contratFields.durees == null) {
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS04_dureesOB + '\n';
                resp.error = true;
            }
            //durees Subfields
            else {
                if(contratFields.durees.datePriseEffetInitiale == null) {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS04_datePriseEffetInitialeOB + '\n';
                    resp.error = true;
                } else {
                    DateTime DatepriseeffetinitialeOriginal = contratFields.durees.datePriseEffetInitiale;
                    Date DatepriseeffetinitialeConverted = date.newinstance(DatepriseeffetinitialeOriginal.year(), DatepriseeffetinitialeOriginal.month(), DatepriseeffetinitialeOriginal.day());
                    cont.DatePriseEffet__c = DatepriseeffetinitialeConverted;

                    contratFields.durees.datePriseEffetInitiale = contratFields.durees.datePriseEffetInitiale.addSeconds(tz.getOffset(contratFields.durees.datePriseEffetInitiale) / 1000);
                    ws.Request__c = contratFields + '';
                }
                /*
                   if(contratFields.durees.dureeInitialeContrat == null) {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS04_dureeInitialeContratOB + '\n';
                    resp.error = true;
                   } else {
                    cont.DureeInitialeContrat__c = contratFields.durees.dureeInitialeContrat;
                   }
                   if(String.isBlank(contratFields.durees.typeReconduction)) {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS04_typeReconductionOB + '\n';
                    resp.error = true;
                   } else {
                    //cont.TypeReconduction__c = contratFields.durees.typeReconduction;
                   }

                   if(contratFields.durees.dureeReconduction != null) {
                    cont.DureeReconduction__c = contratFields.durees.dureeReconduction;
                   } else {
                    cont.DureeReconduction__c = null;
                   }

                   if(contratFields.durees.dureePreavis != null) {
                    cont.DureePreavis__c = contratFields.durees.dureePreavis;
                   }
                   if(contratFields.durees.nombreReconductionAutorise != null) {
                    cont.NombreReconductionsAutorisees__c = contratFields.durees.nombreReconductionAutorise;
                   } else {
                    cont.NombreReconductionsAutorisees__c = null;
                   }
                   if(contratFields.durees.dureeMaximaleCumulee != null) {
                    cont.DureeMaximaleCumulee_del__c = contratFields.durees.dureeMaximaleCumulee;
                   }
                   if(contratFields.durees.reconductionFaitAutorisee == null) {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS04_reconductionFaitAutoriseeOB + '\n';
                    resp.error = true;
                   } else {
                    cont.ReconductionFaitAutorisee__c = contratFields.durees.reconductionFaitAutorisee;
                   }*/

                /*
                   if(contratFields.durees.nombreReconductionPassee != null) {
                    cont.NombreReconductionsPassees__c = contratFields.durees.nombreReconductionPassee;
                   } else   {
                    cont.NombreReconductionsPassees__c = null;
                   }
                 */

                /*
                   if(contratFields.durees.dateProchainPreavis != null) {
                    DateTime DateProchainPreavisOriginal = contratFields.durees.dateProchainPreavis;
                    Date DateProchainPreavisConverted = date.newinstance(DateProchainPreavisOriginal.year(), DateProchainPreavisOriginal.month(), DateProchainPreavisOriginal.day());
                    cont.DateProchainPreavis__c = DateProchainPreavisConverted;

                    contratFields.durees.dateProchainPreavis = contratFields.durees.dateProchainPreavis.addSeconds(tz.getOffset(contratFields.durees.dateProchainPreavis) / 1000);
                    ws.Request__c = contratFields + '';
                   }
                 */

                /*
                   if(contratFields.durees.dateProchaineEcheance == null) {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS04_dateProchaineEcheanceOB + '\n';
                    resp.error = true;
                   } else   {
                    DateTime DateProchaineEcheanceOriginal = contratFields.durees.dateProchaineEcheance;
                    Date DateProchaineEcheanceConverted = date.newinstance(DateProchaineEcheanceOriginal.year(), DateProchaineEcheanceOriginal.month(), DateProchaineEcheanceOriginal.day());
                    cont.DateProchaineEcheance__c = DateProchaineEcheanceConverted;

                    contratFields.durees.dateProchaineEcheance = contratFields.durees.dateProchaineEcheance.addSeconds(tz.getOffset(contratFields.durees.dateProchaineEcheance) / 1000);
                    ws.Request__c = contratFields + '';
                   }
                 */
            }
            //resume sub fields
            /*if(contratFields.listeResumes!=null && contratFields.listeResumes.resume!=null && contratFields.listeResumes.resume.size()>0){
               if(String.isBlank(contratFields.listeResumes.resume.get(0).parametrePortailClient)){
               resp.responseCode = Label.WS_Response_KO;
               resp.errorText += 'Le champ parametrePortailClient est obligatoire \n';
               resp.error = true;
               }
               else{
               //resp = ValidateWSFields.validateTextField('parametrePortailClient',50,contratFields.listeResumes.resume.get(0).parametrePortailClient,resp);
               cont.ParametrePortailClient__c = contratFields.listeResumes.resume.get(0).parametrePortailClient;
               }
               if(!String.isBlank(contratFields.listeResumes.resume.get(0).precisionParametre)){
               //resp = ValidateWSFields.validateTextField('precisionParametre',50,contratFields.listeResumes.resume.get(0).precisionParametre,resp);
               cont.PrecisionParametre__c = contratFields.listeResumes.resume.get(0).precisionParametre;
               }
               if(!String.isBlank(contratFields.listeResumes.resume.get(0).informationComplementaire)){
               //resp = ValidateWSFields.validateTextField('informationComplementaire',100,contratFields.listeResumes.resume.get(0).informationComplementaire,resp);
               cont.InformationComplementaire__c = contratFields.listeResumes.resume.get(0).informationComplementaire;
               }
               if(contratFields.listeResumes.resume.get(0).valeurContractuelle==null){
               resp.responseCode = Label.WS_Response_KO;
               resp.errorText += 'Le champ valeurContractuelle est obligatoire \n';
               resp.error = true;
               }
               else{
               cont.ValeurContractuelle__c = contratFields.listeResumes.resume.get(0).valeurContractuelle;
               }
               if(!String.isBlank(contratFields.listeResumes.resume.get(0).uniteValeurContractuelle)){
               //resp = ValidateWSFields.validateTextField('uniteValeurContractuelle',50,contratFields.listeResumes.resume.get(0).uniteValeurContractuelle,resp);
               cont.UniteValeurContractuelle__c = contratFields.listeResumes.resume.get(0).uniteValeurContractuelle;
               }
               }*/
            //listeServices.service sub fields a faire JAK

            //13-1-2022 Commneted By Jimmy - CVS: the objects Service__c and LienContratService__c are deleted
            /*if(contratFields.listeServices.service!=null && contratFields.listeServices.service.size()>0){
               if(String.isBlank(contratFields.listeServices.service.get(0).service)){
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS04_serviceOB + '\n';
                    resp.error = true;
               }
               else{
               set <String> serviceSet = new Set <String>();
               if(contratFields.listeServices.service !=NULL && contratFields.listeServices.service.size()>0)
               {
               for(Services serv:contratFields.listeServices.service)
               {
               if(serv.Service !=NULL)
               {
                                serviceSet.add(serv.Service); // add the name of services attached to
                            }
                        }
               if (serviceSet<>NULL && serviceSet.size()>0)
               {
               List<Service__c> listService = [SELECT id,CodeService__c FROM Service__c WHERE CodeService__c in:serviceSet];

                            Map<String, id> mapCodeId = new Map<String, id>();

               if (listService!=NULL && listService.size()>0)
               {
               for (Service__c srv : listService)
               {
               mapCodeId.put(srv.CodeService__c,srv.id);
                                }
               for (Services serv:contratFields.listeServices.service)
               {
                                    LienContratService__c lcs = new LienContratService__c();
               if (mapCodeId.get(serv.service) !=NULL)
               {
                                        lcs.Service__c = mapCodeId.get(serv.service);
               }
               else
               {
                                        resp.responseCode = Label.WS_Response_KO;
                                        resp.errorText += Label.WS04_Serv1 + serv.service + Label.WS04_Serv2 + '\n';
                                        resp.error = true;
                                    }
               if(serv.statutLienService !=NULL)
               {
               if (serv.statutLienService)
               {
                                            lcs.Statut__c = Label.WS04_Actif;
               }
               else
               {
                                            lcs.Statut__c = Label.WS04_INACT;
                                        }
               }
               else
               {
                                        resp.responseCode = Label.WS_Response_KO;
                                        resp.errorText += Label.WS04_StatutServOB + '\n';
                                        resp.error = true;
                                    }
               if(serv.penalitesAssociees!=NULL)
               {
                                        lcs.PenalitesAssociees__c = serv.penalitesAssociees;
               }
               else
               {
                                        resp.responseCode = Label.WS_Response_KO;
                                        resp.errorText += Label.WS04_PenaliteOB + '\n';
                                        resp.error = true;
                                    }
                                    lcs.PerimetreRealisation__c = serv.perimetreRealisation;
                                    listLienContratService.add(lcs);
               mapServiceLien.put(lcs.Service__c,lcs);
                                }
               if(oldCont != null && oldCont.size()>0 && oldCont[0].id<>NULL)
               {
               Map<Id, LienContratService__c> mapLienCSold = new Map<Id, LienContratService__c> ( [SELECT id , Service__c,PenalitesAssociees__c,Statut__c
                                                                                                                       FROM LienContratService__c
               WHERE Contrat__c=:oldCont[0].id]);

               Map<String,LienContratService__c> mapServiceLienOld = new Map<String,LienContratService__c>();

               if (mapLienCSold<>NULL && mapLienCSold.values().size()>0)
               {
               for(LienContratService__c lcs:mapLienCSold.values())
               {
               mapServiceLienOld.put(lcs.service__c,lcs);
               if (mapServiceLien.containsKey(lcs.Service__c)) // update existing
               {
                                                LienContratService__c lcsu = new LienContratService__c();
               lcsu= mapServiceLien.get(lcs.Service__c);
               if(mapServiceLienOld.get(lcs.Service__c) != null){
                                                    lcsu.id = mapServiceLienOld.get(lcs.Service__c).id;
                                                }
                                                listLCSUpdate.add(lcsu);
                                            }
               if (!mapServiceLien.containsKey(lcs.Service__c)) // delete existing and not sent
               {
                                                ListLCSDelete.add(lcs); // old services to delete
                                            }
                                        }
               for (LienContratService__c lcsNew:listLienContratService)
               {
               if(!mapServiceLienOld.containskey(lcsNew.service__c))
               {
                                                listLCSInsert.add(lcsNew);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
               }*/
            //End CVS

            /*
               if(contratFields.listeServices.service.get(0).penalitesAssociees==null){
               resp.responseCode = Label.WS_Response_KO;
               resp.errorText += 'Le champ penalitesAssociees est obligatoire \n';
               resp.error = true;
               }
               else{
               //cont.Penalitesassocies__c = contratFields.listeServices.service.get(0).penalitesAssociees;
               }
               if(!String.isBlank(contratFields.listeServices.service.get(0).perimetreRealisation)){
               resp = ValidateWSFields.validateTextField('perimetreRealisation',500,contratFields.listeServices.service.get(0).perimetreRealisation,resp);
               //cont.Perimtrerealisation__c = contratFields.listeServices.service.get(0).perimetreRealisation;
               }
               if(contratFields.listeServices.service.get(0).statutLienService==null){
               resp.responseCode = Label.WS_Response_KO;
               resp.errorText += 'Le champ statutLienService est obligatoire \n';
               resp.error = true;
               }
               else{
               //cont.? = contratFields.listeServices.service.get(0).statutLienService;
               }
               if(contratFields.listeServices.service.get(0).listePrestations!=null && contratFields.listeServices.service.get(0).listePrestations.prestation!=null && contratFields.listeServices.service.get(0).listePrestations.prestation.size()>0){
               if(String.isBlank(contratFields.listeServices.service.get(0).listePrestations.prestation.get(0).prestation)){
               resp.responseCode = Label.WS_Response_KO;
               resp.errorText += 'Le champ prestation est obligatoire \n';
               resp.error = true;
               }
               else{
               //resp = ValidateWSFields.validateTextField('prestation',50,contratFields.listeServices.service.get(0).listePrestations.prestation.get(0).prestation,resp);
               //cont.? = contratFields.listeServices.service.get(0).listePrestations.prestation.get(0).prestation;
               }
               if(contratFields.listeServices.service.get(0).listePrestations.prestation.get(0).prestationExternalisee==null){
               resp.responseCode = Label.WS_Response_KO;
               resp.errorText += 'Le champ prestationExternalisee est obligatoire \n';
               resp.error = true;
               }
               else{
               //cont.? = contratFields.listeServices.service.get(0).listePrestations.get(0).prestationExternalisee;
               }
               if(String.isBlank(contratFields.listeServices.service.get(0).listePrestations.prestation.get(0).modeRemuneration)){
               resp.responseCode = Label.WS_Response_KO;
               resp.errorText += 'Le champ modeRemuneration est obligatoire \n';
               resp.error = true;
               }
               else{
               //resp = ValidateWSFields.validateTextField('modeRemuneration',50,contratFields.listeServices.service.get(0).listePrestations.prestation.get(0).modeRemuneration,resp);
               //cont.? = contratFields.listeServices.service.get(0).listePrestations.prestation.get(0).modeRemuneration;
               }
               if(String.isBlank(contratFields.listeServices.service.get(0).listePrestations.prestation.get(0).gestionLivreOuvert)){
               resp.responseCode = Label.WS_Response_KO;
               resp.errorText += 'Le champ gestionLivreOuvert est obligatoire \n';
               resp.error = true;
               }
               else{
               //resp = ValidateWSFields.validateTextField('gestionLivreOuvert',50,contratFields.listeServices.service.get(0).listePrestations.prestation.get(0).gestionLivreOuvert,resp);
               //cont.? = contratFields.listeServices.service.get(0).listePrestations.prestation.get(0).gestionLivreOuvert;
               }
               if(!String.isBlank(contratFields.listeServices.service.get(0).listePrestations.prestation.get(0).complementInformation)){
               //resp = ValidateWSFields.validateTextField('complementInformation',100,contratFields.listeServices.service.get(0).listePrestations.prestation.get(0).complementInformation,resp);
               //cont.? = contratFields.listeServices.service.get(0).listePrestations.prestation.get(0).complementInformation;
               }
               if(contratFields.listeServices.service.get(0).listePrestations.prestation.get(0).statutLienPrestation==null){
               resp.responseCode = Label.WS_Response_KO;
               resp.errorText += 'Le champ statutLienPrestation est obligatoire \n';
               resp.error = true;
               }
               else{
               //cont.? = contratFields.listeServices.service.get(0).listePrestations.prestation.get(0).statutLienPrestation;
               }
               }
               }*/
            //listePartenaires.partenaire
            boolean prst = false;
            boolean sign = false;
            if(contratFields.listePartenaires == null || contratFields.listePartenaires.partenaire == null || contratFields.listePartenaires.partenaire.size() == 0) {
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS04_listePartenairesPartOB + '\n';
                resp.error = true;
            }
            //listePartenaires.partenaire sub fields
            else {
                String partCont = '';
                Set<String> dkCodeAcccounts = new set<String>();
                for(Partenaires part : contratFields.listePartenaires.partenaire) {
                    if(part.rolePartenaire == Label.WS04_PRST) {
                        prst = true;
                    }
                    if(part.rolePartenaire == Label.WS04_SIGN) {
                        partCont = part.partenaire;
                        sign = true;
                    }
                    dkCodeAcccounts.add(part.partenaire);
                }
                //resp.errorText += 'dkCodeAcccounts ' + dkCodeAcccounts + '\n';
                List<Account> listAcc = [Select id, DKCodeSurPartenaire__c FROM account WHERE DKCodeSurPartenaire__c in : dkCodeAcccounts];
                Map<String, String> dkCodeIdMap = new map<String, String>();
                for(Account acc : listAcc) {
                    dkCodeIdMap.put(acc.DKCodeSurPartenaire__c, acc.id);
                }
                /*Beginnig modificationd JAK 12/02/2020*/
                for(String acc : dkCodeAcccounts) {
                    if(!dkCodeIdMap.keyset().contains(acc)) {
                        resp.errorText += Label.WS04_Acc1 + acc + Label.WS04_Acc2 + '\n';

                    }
                }
                /*End modification JAK*/

                //Commented Out JAK 12/02/2020
                /*Boolean accountDoesNotExists = false;
                   String dkcodeNonExistsant;
                   for(String acc : dkCodeAcccounts){
                   if(!dkCodeIdMap.keyset().contains(acc)){
                   accountDoesNotExists = true;
                   dkcodeNonExistsant = acc;
                   }
                   }
                   if(accountDoesNotExists == true){
                   resp.responseCode = Label.WS_Response_KO;
                   resp.errorText += Label.WS04_Acc1 + dkcodeNonExistsant + Label.WS04_Acc2;
                   resp.error = true;
                   }*/
                //resp.errorText += 'dkCodeIdMap ' + dkCodeIdMap + '\n';
                boolean cond1 = false;
                boolean cond2 = false;
                Integer countSignPart = 0;

                for(Partenaires part : contratFields.listePartenaires.partenaire) {
                    if(part.statutLienPartenaire != null && part.statutLienPartenaire) {
                        if(!String.isBlank(part.rolePartenaire)) {
                            if(part.rolePartenaire.equals(Label.WS04_SIGN) && countSignPart == 0) {
                                if(dkCodeIdMap.get(part.partenaire) != null) {
                                    if(dkCodeIdMap.get(part.partenaire) != null) {
                                        cont.NomPartenaire__c = dkCodeIdMap.get(part.partenaire);
                                        partCont = dkCodeIdMap.get(part.partenaire);
                                    }
                                }
                            }
                        }
                    }
                }

                for(Partenaires part : contratFields.listePartenaires.partenaire) {
                    if(part.statutLienPartenaire != null) {
                        //Pas d'action s'il n'y a pas de role
                        if(!String.isBlank(part.rolePartenaire)) {
                            if(part.rolePartenaire.equals(Label.WS04_SIGN) && countSignPart == 0 && part.statutLienPartenaire) {
                                //Le NomPartenaire__c correspond au premier partenaire avec rolePartenaire = WS04_SIGN et statutLienPartenaire =true
                                if(dkCodeIdMap.get(part.partenaire) != null) {
                                    cont.NomPartenaire__c = dkCodeIdMap.get(part.partenaire);
                                    partCont = dkCodeIdMap.get(part.partenaire);
                                    ++countSignPart;
                                    cond1 = true;
                                }
                            } else if(part.rolePartenaire.equals(Label.WS04_PRST) && part.statutLienPartenaire) {
                                //La SocieteVenteLookup__c correspond au partenaire avec rolePartenaire = WS04_PRST
                                if(dkCodeIdMap.get(part.partenaire) != null) {
                                    cont.SocieteVenteLookup__c = dkCodeIdMap.get(part.partenaire);
                                    cond2 = true;
                                }
                            } else if(part.rolePartenaire.equals(Label.WS04_SIGN) && countSignPart > 0 && part.statutLienPartenaire && dkCodeIdMap.containskey(part.partenaire)) {
                                //Si le partenaire a le role WS04_SIGN et le statut actif et le partenaire existe dans C360, on l'ajoute au liste à creer/maj
                                EcosystemePartenaire__c ecoSys = new EcosystemePartenaire__c();
                                ecoSys.TypeRelation__c = part.rolePartenaire;
                                if(dkCodeIdMap.get(part.partenaire) != null) {
                                    //ecoSys.Partenaire__c = dkCodeIdMap.get(partCont);
                                    ecoSys.PartenaireLie__c = dkCodeIdMap.get(part.partenaire);
                                    if(part.statutLienPartenaire == true) {
                                        ecoSys.Statut__c = Label.WS04_ACTIF;
                                    } else {
                                        ecoSys.Statut__c = Label.WS04_INACT;
                                    }
                                }
                                if(ecoSys.PartenaireLie__c<> null) {
                                    listEcoSys.add(ecoSys);
                                }

                            } else {
                                //Pour les autres roles (autre que WS04_SIGN et WS04_PRST), on l'ajoute au liste à creer/maj
                                EcosystemePartenaire__c ecoSys = new EcosystemePartenaire__c();
                                String role = part.rolePartenaire;
                                if(role == Label.WS04_FACT) {
                                    role = Label.WS04_FACT_1;
                                }
                                if(role == Label.WS04_REPR) {
                                    role = Label.WS04_REPR_1;
                                }
                                ecoSys.TypeRelation__c = role;
                                if(dkCodeIdMap.get(part.partenaire) != null) {
                                    //ecoSys.Partenaire__c = dkCodeIdMap.get(partCont);
                                    ecoSys.PartenaireLie__c = dkCodeIdMap.get(part.partenaire);
                                    if(part.statutLienPartenaire == true) {
                                        ecoSys.Statut__c = Label.WS04_ACTIF;
                                    } else {
                                        ecoSys.Statut__c = Label.WS04_INACT;
                                    }
                                }
                                if(ecoSys.PartenaireLie__c<> null) {
                                    listEcoSys.add(ecoSys);
                                }
                            }
                        }
                    }
                    /*
                       if(String.isBlank(part.partenaire)){
                       resp.responseCode = Label.WS_Response_KO;
                       resp.errorText += 'Le champ partenaire est obligatoire \n';
                       resp.error = true;
                       }
                       else{
                       cont.NomPartenaire__c = dkCodeIdMap.get(part.partenaire);
                       //contratFields.listePartenaires.partenaire.get(0).partenaire; //huss
                       }
                       if(!String.isBlank(contratFields.listePartenaires.partenaire.get(0).matriculeSociete)){
                       cont.MatriculeSocieteDalkia__c = contratFields.listePartenaires.partenaire.get(0).matriculeSociete;
                       }
                       if(String.isBlank(contratFields.listePartenaires.partenaire.get(0).adressePartenaire)){
                       resp.responseCode = Label.WS_Response_KO;
                       resp.errorText += 'Le champ adressePartenaire est obligatoire \n';
                       resp.error = true;
                       }
                       else{
                       //cont.? = contratFields.listePartenaires.partenaire.get(0).adressePartenaire;
                       }
                       if(String.isBlank(contratFields.listePartenaires.partenaire.get(0).rolePartenaire)){
                       resp.responseCode = Label.WS_Response_KO;
                       resp.errorText += 'Le champ rolePartenaire est obligatoire \n';
                       resp.error = true;
                       }
                       else{
                       cont.RolePartenaire__c = contratFields.listePartenaires.partenaire.get(0).rolePartenaire;
                       }
                       if(!String.isBlank(contratFields.listePartenaires.partenaire.get(0).modeReglement)){
                       cont.Modereglement__c = contratFields.listePartenaires.partenaire.get(0).modeReglement;
                       }
                       if(contratFields.listePartenaires.partenaire.get(0).statutLienPartenaire==null){
                       resp.responseCode = Label.WS_Response_KO;
                       resp.errorText += 'Le champ statutLienPartenaire est obligatoire \n';
                       resp.error = true;
                       }
                       if(contratFields.listePartenaires.partenaire.get(0).listeContacts!=null
                       && contratFields.listePartenaires.partenaire.get(0).listeContacts.contact!=null
                       && contratFields.listePartenaires.partenaire.get(0).listeContacts.contact.size()>0){
                       if(String.isBlank(contratFields.listePartenaires.partenaire.get(0).listeContacts.contact.get(0).contact)){
                       resp.responseCode = Label.WS_Response_KO;
                       resp.errorText += 'Le champ contact est obligatoire \n';
                       resp.error = true;
                       }
                       else{
                       //resp = ValidateWSFields.validateTextField('contact',10,contratFields.listePartenaires.partenaire.get(0).listeContacts.contact.get(0).contact,resp);
                       cont.Contact_du_partenaire__c = contratFields.listePartenaires.partenaire.get(0).listeContacts.contact.get(0).contact;
                       }
                       if(String.isBlank(contratFields.listePartenaires.partenaire.get(0).listeContacts.contact.get(0).roleContact)){
                       resp.responseCode = Label.WS_Response_KO;
                       resp.errorText += 'Le champ roleContact est obligatoire \n';
                       resp.error = true;
                       }
                       else{
                       cont.FonctionContact__c = contratFields.listePartenaires.partenaire.get(0).listeContacts.contact.get(0).roleContact;
                       }
                       if(String.isBlank(contratFields.listePartenaires.partenaire.get(0).listeContacts.contact.get(0).accesPSV)){
                       resp.responseCode = Label.WS_Response_KO;
                       resp.errorText += 'Le champ accesPSV est obligatoire \n';
                       resp.error = true;
                       }
                       else{
                       cont.Contact_du_partenaire__c = contratFields.listePartenaires.partenaire.get(0).listeContacts.contact.get(0).accesPSV;
                       }
                       if(contratFields.listePartenaires.partenaire.get(0).listeContacts.contact.get(0).statutLienContact==null){
                       resp.responseCode = Label.WS_Response_KO;
                       resp.errorText += 'Le champ statutLienContact est obligatoire \n';
                       resp.error = true;
                       }
                       else{
                       //cont.? = contratFields.listePartenaires.partenaire.get(0).listeContacts.contact.get(0).statutLienContact;
                       }
                       }*/
                }
                if(prst == false) {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS04_rolePartenaireSIGNOB + '\n';
                    resp.error = true;
                }
                if(sign == false) {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS04_rolePartenairePRSTOB + '\n';
                    resp.error = true;
                }
                if(cond1 == false) {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS04_PRSTX + '\n';
                    resp.error = true;
                }
                if(cond2 == false) {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS04_PRSTX2 + '\n';
                    resp.error = true;
                }
            }
            //listeAffaires.affaire sub fields
            if(contratFields.listeAffaires != null && contratFields.listeAffaires.affaire != null && contratFields.listeAffaires.affaire.size() > 0) {
                String dkCodeAff = '';
                List<Affaire__c> listAffaire = new List<Affaire__c>();
                for(Affaires aff : contratFields.listeAffaires.affaire) {
                    Affaire__c affaire = new Affaire__c();
                    if(aff.statutLienAffaire != null && aff.statutLienAffaire == true) {
                        if(String.isBlank(aff.affaire)) {
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS04_affaireOB + '\n';
                            resp.error = true;
                        } else {
                            dkCodeAff = aff.affaire;
                        }
                    }
                }
                List<Affaire__c> affaireSF = new List<Affaire__c>();
                if(dkCodeAff != '') {
                    affaireSF = [Select id, name from Affaire__c where DkCode__c = : dkCodeAff limit 1];
                    if(affaireSF != null && affaireSF.size() > 0) {
                        cont.AffaireContrat__c = affaireSF[0].id;
                    } else {
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS04_Affaire1 + dkCodeAff + Label.WS04_Affaire2 + contratFields.proprietesContrat.DKCodeContrat + '. ' + '\n';
                        resp.error = true;
                    }
                }
            }
            //projetsFinance sub fields
            if(contratFields.listeProjetsFinance != null
               && contratFields.listeProjetsFinance.projetFinance != null
               && contratFields.listeProjetsFinance.projetFinance.size() > 0) {
                Map<String, String> tacheFinanceDKCodeIdMap = new Map<String, String>();
                Map<String, String> projetFinanceDKCodeIdMap = new Map<String, String>();
                Set<String> dkCodeTacheFinance = new Set<String>();
                Set<String> dkCodeProjetFinance = new Set<String>();
                //Set<String> uniqueIdLCTF = new Set<String>();
                Set<String> uniqueIdLCTFDelete = new Set<String>();
                Map<String, Id>  mapCodeLienTF = new Map<String, Id>();
                for(Projets_finance pf : contratFields.listeProjetsFinance.projetFinance) {
                    dkCodeTacheFinance.add(pf.tacheFinance);
                    dkCodeProjetFinance.add(pf.projetFinance);
                }
                List<TacheFinance__c> tacheFinance = [SELECT id, DkCode__c
                                                      FROM TacheFinance__c
                                                      WHERE DkCode__c in : dkCodeTacheFinance];
                List<ProjetFinance__c> projetFinance = [SELECT id, DkCode__c
                                                        FROM ProjetFinance__c
                                                        WHERE DkCode__c in : dkCodeProjetFinance];
                for(TacheFinance__c tache : tacheFinance) {
                    tacheFinanceDKCodeIdMap.put(tache.dkCode__c, tache.id);
                }
                for(ProjetFinance__c projet : projetFinance) {
                    projetFinanceDKCodeIdMap.put(projet.dkCode__c, projet.id);
                }
                if(oldCont != null && oldCont.size() > 0) {//updating
                    List<LienContratTacheFinance__c> lienTacheExistent = [SELECT id, name, TacheFinance__c, ProjetFinance__c, ZZZ_tech_TF_PF__c
                                                                          FROM LienContratTacheFinance__c
                                                                          WHERE contrat__c = : oldCont[0].id];

                    for(LienContratTacheFinance__c lctf : lienTacheExistent) {
                        mapCodeLienTF.put(lctf.ZZZ_tech_TF_PF__c, lctf.Id);
                        //uniqueIdLCTF.add(lctf.ZZZ_tech_TF_PF__c);//tech field containing the dkcode of TF + dkcode of PF
                    }
                }
                for(Projets_finance pf : contratFields.listeProjetsFinance.projetFinance) {
                    if(pf.statutLienTF != null) {
                        LienContratTacheFinance__c lienTache = new LienContratTacheFinance__c();
                        if(String.isBlank(pf.tacheFinance)) {
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS04_tacheFinanceOB + '\n';
                            resp.error = true;
                        } else if(tacheFinanceDKCodeIdMap.get(pf.tacheFinance) == null) {
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS04_tf1 + pf.tacheFinance + Label.WS04_tf2 + '\n';
                            resp.error = true;
                        } else {
                            lienTache.TacheFinance__c = tacheFinanceDKCodeIdMap.get(pf.tacheFinance);
                        }
                        if(String.isBlank(pf.projetFinance)) {
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS04_projetFinanceOB + '\n';
                            resp.error = true;
                        } else if(projetFinanceDKCodeIdMap.get(pf.projetFinance) == null) {
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS04_pf1 + pf.projetFinance + Label.WS04_pf2 + '\n';
                            resp.error = true;
                        } else {
                            lienTache.ProjetFinance__c = projetFinanceDKCodeIdMap.get(pf.projetFinance);
                        }
                        if(pf.statutLienTF) {
                            lienTache.Statut__c = Label.WS04_ACTIF;
                        } else {
                            lienTache.Statut__c = Label.WS04_INACT;
                        }
                        if(mapCodeLienTF.get(pf.tacheFinance + '' + pf.projetFinance) != null) {
                            lienTache.Id = mapCodeLienTF.get(pf.tacheFinance + '' + pf.projetFinance);
                        }
                        uniqueIdLCTFDelete.add(pf.tacheFinance + '' + pf.projetFinance);
                        //if(!uniqueIdLCTF.contains(pf.tacheFinance+''+pf.projetFinance)){
                        listLienTacheFinance.add(lienTache);
                        //}
                    }
                }
                if(oldCont != null && oldCont.size() > 0) {
                    List<LienContratTacheFinance__c> LienListToDelete = [SELECT id, name, TacheFinance__c, ProjetFinance__c
                                                                         FROM LienContratTacheFinance__c
                                                                         WHERE contrat__c = : oldCont[0].id
                                                                         AND ZZZ_tech_TF_PF__c not in : uniqueIdLCTFDelete];
                    try {
                        delete LienListToDelete;
                    }
                    catch(Exception e) {
                        System.debug('Exception ' + e);
                    }
                }
            } else {
                if(oldCont != null && oldCont.size() > 0) {
                    List<LienContratTacheFinance__c> LienListToDelete = [SELECT id, name, TacheFinance__c, ProjetFinance__c
                                                                         FROM LienContratTacheFinance__c
                                                                         WHERE contrat__c = : oldCont[0].id];
                    try {
                        delete LienListToDelete;
                    }
                    catch(Exception e) {
                        System.debug('Exception ' + e);
                    }
                }

            }
            //listeResponsables.responsable
            if(contratFields.listeResponsables == null || contratFields.listeResponsables.responsable == null || contratFields.listeResponsables.responsable.size() == 0) {
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS04_listeResponsablesRESPOB + '\n';
                resp.error = true;
            }
            //listeResponsables.responsable sub fields
            else {
                String rol01 = '';
                String rol03 = '';
                String rol05 = '';
                for(Responsables responsable : contratFields.listeResponsables.responsable) {
                    if(responsable.perimetreResponsable != null && responsable.statutLienResponsable != null
                       && responsable.perimetreResponsable.equals(Label.WS04_ROL01) && responsable.statutLienResponsable == true) {
                        if(String.isBlank(responsable.responsableContrat)) {
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS04_responsableContratOB + '\n';
                            resp.error = true;
                        } else {
                            rol01 = responsable.responsableContrat;
                        }
                    }
                    if(responsable.perimetreResponsable != null && responsable.statutLienResponsable != null
                       && responsable.perimetreResponsable.equals(Label.WS04_ROL03) && responsable.statutLienResponsable == true) {
                        if(String.isBlank(responsable.responsableContrat)) {
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS04_responsableContratOB + '\n';
                            resp.error = true;
                        } else {
                            rol03 = responsable.responsableContrat;
                        }
                    }
                    if(responsable.perimetreResponsable != null && responsable.statutLienResponsable != null
                       && responsable.perimetreResponsable.equals(Label.WS04_ROL05) && responsable.statutLienResponsable == true) {
                        if(String.isBlank(responsable.responsableContrat)) {
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS04_responsableContratOB + '\n';
                            resp.error = true;
                        } else {
                            rol05 = responsable.responsableContrat;
                        }
                    }
                }
                List<User> dkCodeUserList = [SELECT id, dkcode__c
                                             from user
                                             where dkcode__c = : rol01
                                             or dkcode__c = : rol03
                                             or dkcode__c = : rol05];
                if(dkCodeUserList != null && dkCodeUserList.size() > 0) {
                    for(User userLoop : dkCodeUserList) {
                        if(userLoop.dkcode__c == rol01 && rol01 != '') {
                            cont.ResponsableCommerceReferentiel__c = userLoop.id;
                        }
                        if(userLoop.dkcode__c == rol03 && rol03 != '') {
                            cont.ResponsableFacturation__c = userLoop.id;
                        }
                        if(userLoop.dkcode__c == rol05 && rol05 != '') {
                            cont.ResponsableAffaireReferentiel__c = userLoop.id;
                        }
                    }
                }
            }
            //numerotationContrat sub fields
            if(contratFields.numerotationContrat != null) {
                if(String.isBlank(contratFields.numerotationContrat.applicationSource)) {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS04_applicationSourceOB + '\n';
                    resp.error = true;
                } else {
                    cont.Applicationsourcecontrat__c = contratFields.numerotationContrat.applicationSource;
                }
                if(String.isBlank(contratFields.numerotationContrat.codeSource)) {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS04_codeSourceOB + '\n';
                    resp.error = true;
                } else {
                    cont.NumeroContrat__c = contratFields.numerotationContrat.codeSource;
                }
            }
            //metadonneesContrat
            if(contratFields.metadonneesContrat == null) {
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS04_metadonneesContratOB + '\n';
                resp.error = true;
            }
            //metadonneesContrat sub fields
            else {
                if(contratFields.metadonneesContrat.creationDate == null) {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS06_creationDateOB + '\n';
                    resp.error = true;
                } else {
                    cont.CreateDate__c = contratFields.metadonneesContrat.creationDate;

                    contratFields.metadonneesContrat.creationDate = contratFields.metadonneesContrat.creationDate.addSeconds(tz.getOffset(contratFields.metadonneesContrat.creationDate) / 1000);
                    ws.Request__c = contratFields + '';
                }
                List<User> userMetadonne = new List<User>();
                userMetadonne = [SELECT id, name, ReferentielId__c
                                 FROM user
                                 WHERE ReferentielId__c = : contratFields.metadonneesContrat.creationId
                                 OR ReferentielId__c = : contratFields.metadonneesContrat.updateId
                                 OR ReferentielId__c = : contratFields.metadonneesContrat.validationId];
                if(String.isBlank(contratFields.metadonneesContrat.creationId)) {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS06_creationId + '\n';
                    resp.error = true;
                } else {
                    for(User userLoop : userMetadonne) {
                        if(userLoop.ReferentielId__c == contratFields.metadonneesContrat.creationId) {
                            cont.CreateId__c  = userLoop.id;
                        }
                    }
                }
                if(contratFields.metadonneesContrat.updateDate != null) {
                    cont.UpdateDate__c = contratFields.metadonneesContrat.updateDate;

                    contratFields.metadonneesContrat.updateDate = contratFields.metadonneesContrat.updateDate.addSeconds(tz.getOffset(contratFields.metadonneesContrat.updateDate) / 1000);
                    ws.Request__c = contratFields + '';
                }
                if(!String.isBlank(contratFields.metadonneesContrat.updateId)) {
                    for(User userLoop : userMetadonne) {
                        if(userLoop.ReferentielId__c == contratFields.metadonneesContrat.updateId) {
                            cont.UpdateId__c  = userLoop.id;
                        }
                    }
                }
                if(contratFields.metadonneesContrat.validationDate != null) {
                    DateTime DateValidationOriginal = contratFields.metadonneesContrat.validationDate;
                    Date DateValidationOriginalConverted = date.newinstance(DateValidationOriginal.year(), DateValidationOriginal.month(), DateValidationOriginal.day());
                    cont.Datevalidation__c = DateValidationOriginalConverted;

                    contratFields.metadonneesContrat.validationDate = contratFields.metadonneesContrat.validationDate.addSeconds(tz.getOffset(contratFields.metadonneesContrat.validationDate) / 1000);
                    ws.Request__c = contratFields + '';
                }
                if(!String.isBlank(contratFields.metadonneesContrat.validationId)) {
                    for(User userLoop : userMetadonne) {
                        if(userLoop.ReferentielId__c == contratFields.metadonneesContrat.ValidationId) {
                            cont.Validation_Id__c  = userLoop.id;
                        }
                    }
                }
            }
            ws.Response__c = resp + '';
            if(resp.error == true) {
                ws.Statut__c = 'KO';
                ws.ErrorText__c = resp.errorText;
                if(ws.ErrorText__c != null && ws.ErrorText__c.length() > 254) {
                    ws.ErrorText__c =  ws.ErrorText__c.substring(0, 254);
                }
            } else {
                ws.Statut__c = 'OK';
            }
            //ws.Request__c = contratFields+'';
            update ws;
            if(!resp.error || Test.isRunningTest()) {
                try {
                    List<EcosystemePartenaire__c> listEcosysInsert = new List<EcosystemePartenaire__c>();
                    List<EcosystemePartenaire__c> listEcosysUpdate = new List<EcosystemePartenaire__c>();
                    List<EcosystemePartenaire__c> listEcosysdelete = new List<EcosystemePartenaire__c>();
                    map<id, EcosystemePartenaire__c> mapIdEco = new map<id, EcosystemePartenaire__c>();
                    Set<Id> setEcosysIdUpdate = new Set<Id>();
                    system.debug('*** cont id =' + cont.id);
                    update cont;

                    //CKH US C360-705 Start
                    List<Document_Contractuel__c> docsToInsert = new List<Document_Contractuel__c>();
                    List<Document_Contractuel__c> docsToUpdateNumPiece = new List<Document_Contractuel__c>();
                    List<Document_Contractuel__c> docsToUpdateTitre = new List<Document_Contractuel__c>();

                    Set<String> numPieceIds = new Set<String>();
                    Set<String> docUniqueIds = new Set<String>();

                    for(Document_Contractuel__c doc : listDoc) {
                        numPieceIds.add(doc.NumeroPiece__c);
                        docUniqueIds.add(cont.Id + doc.TitreDocument__c);
                    }

                    List<Document_Contractuel__c> lstExistingDocsNumPiece = [SELECT id, NumeroPiece__c
                                                                             FROM Document_Contractuel__c
                                                                             WHERE NumeroPiece__c in : numPieceIds ];

                    Map<String, Id> mapIdNumPiece = new Map<String, Id>();
                    for(Document_Contractuel__c doc : lstExistingDocsNumPiece) {
                        mapIdNumPiece.put(doc.NumeroPiece__c, doc.id);
                    }

                    List<Document_Contractuel__c> lstExistingDocsTitre = [SELECT id, DocUniqueText__c
                                                                          FROM Document_Contractuel__c
                                                                          WHERE DocUniqueText__c in : docUniqueIds ];

                    Map<String, Id> mapIdTitre = new Map<String, Id>();
                    for(Document_Contractuel__c doc : lstExistingDocsTitre) {
                        mapIdTitre.put(doc.DocUniqueText__c, doc.id);
                    }

                    for(Document_Contractuel__c doc : listDoc) {
                        doc.Contrat__c = cont.id;
                        doc.DocUniqueText__c = doc.Contrat__c + doc.TitreDocument__c;

                        if(mapIdNumPiece.containsKey(doc.NumeroPiece__c)) {
                            doc.Id = mapIdNumPiece.get(doc.NumeroPiece__c);
                            docsToUpdateNumPiece.add(doc);
                        } else if(mapIdTitre.containsKey(doc.DocUniqueText__c)) {
                            doc.Id = mapIdTitre.get(doc.DocUniqueText__c);
                            docsToUpdateTitre.add(doc);
                        } else {
                            docsToInsert.add(doc);
                        }
                    }

                    if(docsToUpdateNumPiece.size() > 0) {
                        update docsToUpdateNumPiece;
                    }

                    if(docsToUpdateTitre.size() > 0) {
                        update docsToUpdateTitre;
                    }

                    if(docsToInsert.size() > 0) {
                        insert docsToInsert;
                    }
                    //CKH US C360-705 End

                    //Initialisation du contrat Id et cles unique
                    for(EcosystemePartenaire__c ecoSys : listEcoSys) {
                        ecoSys.Contrat__c = cont.Id;
                        //resp.errorText += 'ecosys.PartenaireLie__c ' + ecosys.PartenaireLie__c + ' ';
                        //resp.errorText += 'ecosys.TypeRelation__c ' + ecosys.TypeRelation__c + ' ';
                        //resp.errorText += 'cont.id ' + cont.id + ' ';

                        //cles unique = partenaire Id + type + contrat Id
                        ecoSys.ZZZTechEcosystemeRegleUnicite__c = String.ValueOf(ecosys.PartenaireLie__c).substring(0, 15) + ',' + String.valueOf(ecoSys.TypeRelation__c) + ',,' + String.ValueOf(cont.id).substring(0, 15);
                    }

                    //Recuperer les EcosystemePartenaire__c existants
                    list<EcosystemePartenaire__c> listESP = new list<EcosystemePartenaire__c>();
                    Set<String> setESP = new set<String>();
                    Map<String, id> mapESP = new map<String, id>(); // rita
                    try {
                        listESP = [SELECT id, ZZZTechEcosystemeRegleUnicite__c, contrat__c, TypeRelation__c
                                   FROM EcosystemePartenaire__c
                                   WHERE contrat__c = : cont.Id ];
                        for(EcosystemePartenaire__c ecoLoop : listESP) {
                            //set de tous les EcosystemePartenaire__c existants depuis leurs cles
                            setESP.add(ecoLoop.ZZZTechEcosystemeRegleUnicite__c);
                            //map cles unique avec id des EcosystemePartenaire__c existants
                            mapESP.put(ecoLoop.ZZZTechEcosystemeRegleUnicite__c, ecoLoop.Id); // rita
                        }
                    }
                    catch(Exception e) {
                        system.debug('Exception dml ecosys: .....' + e.getMessage());
                    }
                    Map<String, List<EcosystemePartenaire__c>> mapKeyEcosSys = new Map<String, List<EcosystemePartenaire__c>>();
                    for(EcosystemePartenaire__c ecoSP : listEcoSys) {
                        //map cles unique avec listes des EcosystemePartenaire__c diffusés
                        //ici c'est une liste car on peut avoir plus qu'un seul ecosysteme diffuser pour le mem partenaire et le cle se base sur le partenaire
                        if(!mapKeyEcosSys.keySet().contains(ecoSP.ZZZTechEcosystemeRegleUnicite__c)) {
                            mapKeyEcosSys.put(ecoSP.ZZZTechEcosystemeRegleUnicite__c, new List<EcosystemePartenaire__c>());
                        }
                        mapKeyEcosSys.get(ecoSP.ZZZTechEcosystemeRegleUnicite__c).add(ecoSP);
                    }

                    for(String keyEco : mapKeyEcosSys.keySet()) {
                        if(setESP.contains(keyEco)) {
                            //L'ecosysteme diffusé existe dans C360 donc MAJ
                            List<EcosystemePartenaire__c> listEco = mapKeyEcosSys.get(keyEco);
                            EcosystemePartenaire__c eco = new EcosystemePartenaire__c();
                            integer i = 0;
                            if(listEco != null && listEco.size() > 0) {
                                for(EcosystemePartenaire__c ecoLoop : listEco) {
                                    //On peut avoir plusieurs ecosysteme pour le meme partenaire (differents adressePartenaire qui n'est pas utilisé dans C360)
                                    //On prend le premier, puis, on verifie s'il y a un actif
                                    if(i == 0) {
                                        eco = ecoLoop;
                                        eco.id = mapESP.get(keyEco); // rita
                                        ++i;
                                    } else if(ecoLoop.statut__c == Label.WS04_ACTIF) {
                                        eco = ecoLoop;
                                        eco.id = mapESP.get(keyEco); // rita
                                    }
                                }
                                setEcosysIdUpdate.add(eco.Id);
                                listEcosysUpdate.add(eco);
                            }
                        } else {
                            List<EcosystemePartenaire__c> listEco = mapKeyEcosSys.get(keyEco);
                            EcosystemePartenaire__c eco = new EcosystemePartenaire__c();
                            integer i = 0;
                            if(listEco != null && listEco.size() > 0) {
                                for(EcosystemePartenaire__c ecoLoop : listEco) {
                                    //On peut avoir plusieurs ecosysteme pour le meme partenaire (differents adressePartenaire qui n'est pas utilisé dans C360)
                                    //On prend le premier, puis, on verifie s'il y a un actif
                                    if(i == 0) {
                                        eco = ecoLoop;
                                        ++i;
                                    } else if(ecoLoop.statut__c == Label.WS04_ACTIF) {
                                        eco = ecoLoop;
                                    }
                                }
                                listEcosysInsert.add(eco);
                            }
                        }
                    }

                    //On supprime les ecosysteme de type Facturé et Destinataire qui existe dans C360 et qui ne sont pas diffusés, donc, ne sont pas dans la liste à mettre à jour
                    if(listESP != null && listESP.size() > 0) {
                        for(EcosystemePartenaire__c ecoTodelete : listESP) {
                            if((ecoTodelete.TypeRelation__c == Label.WS04_FACT_1 || ecoTodelete.TypeRelation__c == Label.WS04_DEST) && !setEcosysIdUpdate.contains(ecoTodelete.Id)) {
                                listEcosysdelete.add(ecoTodelete);
                            }
                        }
                    }

                    for(LienContratTacheFinance__c lien :  listLienTacheFinance) {
                        if(lien.id == null) {
                            lien.Contrat__c = cont.id;
                        }
                    }

                    //13-1-2022 Commneted By Jimmy - CVS: the objects Service__c and LienContratService__c are deleted
                    /*for (LienContratService__c lcs:listLCSInsert)
                       {
                        lcs.Contrat__c = cont.id;
                       }*/
                    //end CVS

                    if(listEcosysInsert != null && listEcosysInsert.size() > 0) {
                        insert listEcosysInsert;
                    }
                    if(listEcosysUpdate != null && listEcosysUpdate.size() > 0) {
                        update listEcosysUpdate;
                    }
                    if(listEcosysdelete != null && listEcosysdelete.size() > 0) {
                        delete listEcosysdelete;
                    }

                    //upsert listEcoSys ZZZTechEcosystemeRegleUnicite__c ;
                    //upsert listEcoSys ZZZ_TechPartenaireContrat__c;
                    PAD.PAD_BypassTrigger += ';AP52_DocumentContractuel;AP01_DocumentContractuel;';

                    Set<LienContratTacheFinance__c> setLienTacheFinance = new Set<LienContratTacheFinance__c>();
                    for(LienContratTacheFinance__c lienLoop : listLienTacheFinance) {
                        setLienTacheFinance.add(lienLoop);
                    }
                    List<LienContratTacheFinance__c> listTacheToInsert = new List<LienContratTacheFinance__c>();
                    listTacheToInsert.addAll(setLienTacheFinance);
                    upsert listTacheToInsert;

                    //13-1-2022 Commneted By Jimmy - CVS: the objects Service__c and LienContratService__c are deleted
                    //insert listLCSInsert;
                    //update listLCSUpdate;
                    //delete listLCSDelete;
                    //end CVS

                }
                catch(Exception e) {
                    ws.Statut__c = 'KO';
                    ws.ErrorText__c = e.getMessage();
                    if(ws.ErrorText__c != null && ws.ErrorText__c.length() > 254) {
                        ws.ErrorText__c =  ws.ErrorText__c.substring(0, 254);
                    }
                    resp.error = true;
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS04_Error + e.getMessage() + '\n';
                    System.debug('insertUpdateContrat upsert error ' + e.getMessage());
                    ws.Response__c = resp + Label.WS04_AfterError + e.getMessage();
                    update ws;
                }
            }
        } else {
            /*
               if(contratFields.numerotationContrat!=null && String.isNotBlank(contratFields.numerotationContrat.codeSource)){
               resp.errorText = Label.WS04_Ins1 + ' ' + contratFields.proprietesContrat.DKCodeContrat + Label.WS04_Ins2 + ' ' + contratFields.numerotationContrat.codeSource + ' ' + Label.WS04_Ins3 + '\n';
               }
               else
             */
            if(!String.isBlank(contratFields.proprietesContrat.DKCodeContrat)) {
                resp.errorText = Label.WS05_ContInexistant1 + ' ' + contratFields.proprietesContrat.DKCodeContrat + ' ' + Label.WS05_ContInexistant2 + '\n';
                ws.Statut__c = 'OK';
                resp.responseCode = Label.WS_Response_OK;
            } else {
                resp.errorText = Label.WS04_DKCodeContratOB + '\n';
                ws.Statut__c = 'KO';
                resp.responseCode = Label.WS_Response_KO;
            }
            ws.Response__c = resp + '';
            update ws;
        }

        return resp;
    }
}