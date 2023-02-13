public with sharing class LWC11_DemandesEnMasseV2_CTRL {
     
    //Recupération des emplacement
    @AuraEnabled
    public static wResult getEmplacements(String pageSize, String pageNumber, string searchText, string sortDirection,string sortBy, string searchType){
        List<WrapperEmplacement> wrapperEmpList = new List<WrapperEmplacement>();
        String searchKey = searchText+ '%';
 
        String query = 'SELECT Id, Emplacements__c,	Groupe_client__c, contrat__r.name, contrat__r.NumeroContrat__c, Partenaire__c, Contrat__r.NomPartenaire__c, Emplacements__r.Name,    Emplacements__r.Code_Postal__c, Emplacements__r.Libelle_Voie__c, Emplacements__r.Ville__c, Emplacements__r.DKCode_Emplacement__c, Emplacements__r.DKCode_Entite_Exploitation__c, Emplacements__r.Usage__c  FROM  LienContratEmplacement__c';
                    
                        if (String.isNotBlank(searchText)) {
                            if(searchType == 'Contract'){
                                query += ' WHERE (contrat__r.NumeroContrat__c LIKE :searchKey)';
                            } else if(searchType == 'ClientGroup'){
                                query += ' WHERE (Groupe_client__c LIKE :searchKey)';
                            } else if(searchType == 'Partner'){
                                query += ' WHERE (Partenaire__c LIKE :searchKey)';
                            } else if(searchType == 'ZipCode'){
                                query += ' WHERE (Emplacements__r.Code_Postal__c like: searchKey)';
                            } else if(searchType == 'Adress'){
                                query += ' WHERE (Emplacements__r.Libelle_Voie__c like: searchKey)';
                            } else if(searchType == 'DKCode'){
                                query += ' WHERE (Emplacements__r.DKCode_Emplacement__c like: searchKey)';
                            } else if(searchType == 'City'){
                                query += ' WHERE (Emplacements__r.Ville__c like: searchKey)';
                            } else if(searchType == 'Entity'){
                                query += ' WHERE (Emplacements__r.DKCode_Entite_Exploitation__c like: searchKey)';
                            }
                        
                    }   

        
        List<LienContratEmplacement__c> lemp =  Database.query(query);
        for(LienContratEmplacement__c e: lemp){
            wrapperEmpList.add(new WrapperEmplacement(e));
            System.debug(new WrapperEmplacement(e));
        }
        return new wResult(lemp.size(),wrapperEmpList);
    }
 
    public class wResult{
        @AuraEnabled public Integer totalEmplacement;
        @AuraEnabled public List<WrapperEmplacement> lstEmplacements;
        public wResult(Integer totalAccount, List<WrapperEmplacement> lstEmplacements){
            this.totalEmplacement = totalEmplacement;
            this.lstEmplacements = lstEmplacements;
        }
    }
    
    public class WrapperEmplacement{      
        @AuraEnabled public string dkCode;
        @AuraEnabled public string nomEmplacement;
        @AuraEnabled public string ville;
        @AuraEnabled public string codePostal;
        @AuraEnabled public string usage;
        @AuraEnabled public string numeroContrat;

        
        public WrapperEmplacement(LienContratEmplacement__c emp){
            this.dkCode = (emp.emplacements__r.DKCode_Emplacement__c <> null) ? emp.emplacements__r.DKCode_Emplacement__c : '';
            this.nomEmplacement = (emp.Emplacements__r.Name <> null) ? emp.Emplacements__r.Name : '';
            this.ville = (emp.emplacements__r.Ville__c <> null) ? emp.emplacements__r.Ville__c : '';
            this.codePostal = (emp.emplacements__r.Code_Postal__c <> null) ? emp.emplacements__r.Code_Postal__c : '';
            this.usage = (emp.emplacements__r.Usage__c <> null) ? emp.emplacements__r.Usage__c : '';
            this.numeroContrat = (emp.contrat__r.NumeroContrat__c <> null) ? emp.contrat__r.NumeroContrat__c : ''; 
        }
    }

    }