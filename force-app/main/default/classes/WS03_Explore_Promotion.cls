/*--------------------------------------------------------------------------------------------------------------------------
Author:Dona Kfoury
Company: EI-Technologies
Description: class that calls a webservice and process the response that contains information of leads whose 
potential type (TypePotentiel__c) is 'Projet des promoteurs'
Test Class: AP03_CallExplore_Test
--------------------------------------------------------------------------------------------------------------------------*/
public class WS03_Explore_Promotion {
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-Technologies
Description: Function that does a callout and return the response as a WS_Wrapper which contains the information of leads whose 
potential type (TypePotentiel__c) is 'Projet des promoteurs'
Inputs:-
Returns: WS_Wrapper
----------------------------------------------------------------------------------------------------------------------------*/
    
    public static WS_Wrapper DoCalloutPromotion()
    {
        WS_Wrapper mywrapper= new WS_Wrapper();
        try{
            WS_endpoint__c myWs = WS_endpoint__c.getInstance('Explore Projet des promoteurs');
            string DateDeDebut=datetime.newInstance(date.today().adddays(-(myWs.Nombre_de_jours__c).intValue()), time.newInstance(0,0,0,0)).format('yyyy-MM-dd');
            string DateDeFin=datetime.newInstance(date.today(), time.newInstance(0,0,0,0)).format('yyyy-MM-dd');
            string API_URL=myWs.Endpoint__c;
            API_URL+='?CleClient='+myWs.Cle_Client__c+'&DateDebut='+DateDeDebut+'&DateFin='+DateDeFin;
            
            WS_Utils.WS_Utils_Wrapper Utilswrapper= WS_Utils.callExplore(WS_Utils.CallType.Explore_Promotion, API_URL, null);
            HttpResponse res=Utilswrapper.HttpRes;
            mywrapper.Log=Utilswrapper.Log;
            
            if(res!= null && res.getBody() != null)
            {
                string  resultat = res.getBody();
                if(resultat!= 'Aucune information trouvée')
                {
                    resultat = '{ "records":' + resultat + '}';        
                    RootObject myRootsWrapper=(RootObject) System.JSON.deserialize(resultat, RootObject.class);
                    mywrapper.RootObj=myRootsWrapper;
                    return mywrapper; 
                }
                else
                {
                    return mywrapper;
                }
            }
            else
            {
                return mywrapper;
            }
        }
        catch (Exception e)
        {
            return mywrapper;
        }
    }
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-Technologies
Description: the following classes are used to deserialize the response from JSON to apex
--------------------------------------------------------------------------------------------------------------------------*/
    public class CONTACTS {
        public String SIRET;
        public String CIVILITE_CONTACT;
        public String NOM_CONTACT;
        public String FONCTION;
        public string LIGNE_DIRECTE;
        public string MAIL;
    }
    
    public class LOCALISATIONS_GEOGRAPHIQUES {
        public String DEPARTEMENT;
        public String DEPARTEMENT_LIB;
        public String CODE_COMMUNE;
        public String ADRESSE1;
        public string ADRESSE2;
        public String CODE_POSTAL;
        public String COMMUNE;
    }
    
    public class RootObject {
        public List<Records> records;
    }
    
    public class SOCIETES_Z {
        public String ROLE;
        public String RAISON_SOCIALE;
        public String SIRET;
        public String SIREN;
        public String IDENTIFIANT_SOCIETE_EXPLORE;
        public String ADRESSE_1;
        public String ADRESSE_2;
        public String CODE_POSTAL;
        public String VILLE;
        public String CODE_NAF;
        public String NATURE_ETS;
        public String TELEPHONE;
        public String TEFEN;
        public String TEFEN_LIB;
    }
    
    public class SOCIETES {
        public String ROLE;
        public String RAISON_SOCIALE;
        public String SIRET;
        public String SIREN;
        public string IDENTIFIANT_SOCIETE_EXPLORE;
        public String ADRESSE_1;
        public string ADRESSE_2;
        public String CODE_POSTAL;
        public String VILLE;
        public String CODE_NAF;
        public String NATURE_ETS;
        public String TELEPHONE;
        public String TEFEN;
        public String TEFEN_LIB;
    }
    
    public class LOCALISATIONS_GEOGRAPHIQUES_Z {
        public String DEPARTEMENT;
        public String DEPARTEMENT_LIB;
        public String CODE_COMMUNE;
        public String ADRESSE1;
        public String ADRESSE2;
        public String CODE_POSTAL;
        public String COMMUNE;
    }
    
    public class CONTACTS_W {
        public String SIRET;
        public String CIVILITE_CONTACT;
        public String NOM_CONTACT;
        public String FONCTION;
        public string LIGNE_DIRECTE;
        public String MAIL;
    }
    
    public class SOCIETES_Y {
        public String ROLE;
        public String RAISON_SOCIALE;
        public String SIRET;
        public String SIREN;
        public Integer IDENTIFIANT_SOCIETE_EXPLORE;
        public String ADRESSE_1;
        public String ADRESSE_2;
        public String CODE_POSTAL;
        public String VILLE;
        public String CODE_NAF;
        public String NATURE_ETS;
        public string TELEPHONE;
        public String TEFEN;
        public String TEFEN_LIB;
    }
    
    public class CONTACTS_X {
        public string SIRET;
        public String CIVILITE_CONTACT;
        public String NOM_CONTACT;
        public string FONCTION;
        public string LIGNE_DIRECTE;
        public string MAIL;
    }
    
    public class Records {
        public String IDENTIFIANT;
        public String IDENTIFIANT_EXPLORE;
        public String TITRE;
        public String SURFACE;
        public Double NB_LOTS;
        public String COMMENTAIRE;
        public String ETAT_FUTURS_LOCAUX;
        public String DATE_DETECTION;
        public String DATE_OUVERTURE_CHANTIER;
        public String DATE_ECHEANCE;
        public List<String> EMAIL_COLLABORATEUR;
        public List<LOCALISATIONS_GEOGRAPHIQUES> LOCALISATIONS_GEOGRAPHIQUES;
        public List<SOCIETES> SOCIETES;
        public List<CONTACTS> CONTACTS;
    }
    
    public class CONTACTS_Y {
        public String SIRET;
        public string CIVILITE_CONTACT;
        public string NOM_CONTACT;
        public string FONCTION;
        public string LIGNE_DIRECTE;
        public String MAIL;
    }
    
    public class CONTACTS_Z {
        public String SIRET;
        public string CIVILITE_CONTACT;
        public string NOM_CONTACT;
        public string FONCTION;
        public string LIGNE_DIRECTE;
        public string MAIL;
    }
    
    public class WS_Wrapper{
        
        public WebserviceLog__c Log;
        public RootObject RootObj;
        
        public WS_Wrapper(WebserviceLog__c Log, RootObject RootObj){
            this.Log = Log;
            this.RootObj = RootObj;
        }
        
        public WS_Wrapper(){
            this.Log = null;
            this.RootObj = null;
        }
    }
}