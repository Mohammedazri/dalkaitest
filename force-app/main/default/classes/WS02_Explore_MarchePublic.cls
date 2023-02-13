/*--------------------------------------------------------------------------------------------------------------------------
Author:Dona Kfoury
Company: EI-Technologies
Description: class that calls a webservice and process the response that contains information of leads whose 
             potential type (TypePotentiel__c) is 'Marchés publics'
Test Class: AP03_CallExplore_Test
--------------------------------------------------------------------------------------------------------------------------*/
public class WS02_Explore_MarchePublic {
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-Technologies
Description: Function that does a callout and return the response as a WS_Wrapper which contains the information of leads whose 
             potential type (TypePotentiel__c) is 'Marchés publics'
Inputs:-
Returns: WS_Wrapper
----------------------------------------------------------------------------------------------------------------------------*/
    public static WS_Wrapper DoCalloutMarchePublic()
    {
        WS_Wrapper mywrapper= new WS_Wrapper();
        try{
            WS_endpoint__c myWs = WS_endpoint__c.getInstance('Explore Marchés Publics');
            string DateDeDebut=datetime.newInstance(date.today().adddays(-(myWs.Nombre_de_jours__c).intValue()), time.newInstance(0,0,0,0)).format('yyyy-MM-dd');
            string DateDeFin=datetime.newInstance(date.today(), time.newInstance(0,0,0,0)).format('yyyy-MM-dd');           
            string API_URL=myWs.Endpoint__c;
            API_URL+='?CleClient='+myWs.Cle_Client__c+'&DateDebut='+DateDeDebut+'&DateFin='+DateDeFin;
              WS_Utils.WS_Utils_Wrapper Utilswrapper= WS_Utils.callExplore(WS_Utils.CallType.Explore_MarchePublic, API_URL, null);
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
    public class MPC_FORME_MARCHE {
        public String MPC_FORME_MARCHE;
        public String MPC_FORME_MARCHE_LIB;
    }
    
    public class MPC_MISSION {
        public String MPC_MISSION;
        public String MPC_MISSION_LIB;
    }
    
    public class LOCALISATIONS {
        public String DEPARTEMENT;
        public String DEPARTEMENT_LIB;
        public String CODE_COMMUNE;
        public String ADRESSE1;
        public String ADRESSE2;
        public String CODE_POSTAL;
        public String COMMUNE;
    }
    
    public class DCES {
    }
    
    public class DCES_Z {
        public String NOM_DCE;
        public String DATE_DCE;
        public String URL_TELECHARGEMENT;
    }
    
    public class RootObject {
        public List<Records> records;
    }
    
    public class MPC_TYPE_PRESTATION {
        public String MPC_TYPE_PRESTATION;
        public String MPC_TYPE_PRESTATION_LIB;
    }
    
    public class SOCIETES {
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
    
    public class MPC_PROCEDURE {
        public String MPC_PROCEDURE;
        public String MPC_PROCEDURE_LIB;
    }
    
    public class MPC_TYPE_CONTRAT {
        public String MPC_TYPE_CONTRAT;
        public String MPC_TYPE_CONTRAT_LIB;
    }
    
    public class Records {
        public String IDENTIFIANT;
        public String IDENTIFIANT_EXPLORE;
        public String CLE_MARCHE_PUBLIC_EXPLORE;
        public String OBJET;
        public String DATE_LIMITE_RECEPTION;
        public String DATE_DETECTION;
        public String DATE_PARUTION;
        public Integer SOURCE;
        public String SOURCE_LIB;
        public String TYPE_AVIS;
        public String MPC_NATURE_CONTRAT;
        public String MPC_NATURE_CONTRAT_LIB;
        public Boolean MPC_ALLOTISSEMENT;
        public Double MPC_MONTANT_REEL;
        public Double MPC_MONTANT_MIN;
        public Double MPC_MONTANT_MAX;
        public Boolean MPC_RENOUVELLEMENT;
        public Integer MPC_DUREE;
        public string MPC_DT_ECHEANCE;
        public String MPC_DT_LIM_CANDIDAT;
        public String MPC_DT_LIM_DEM_DOC;
        public String MSG_CR;
        public String MSG_CR_LIB;
        public String URL_DETAIL;
        public String URL_AVIS_ORIGINAL;
        public String TEXTE_ANNONCE;
        public List<String> EMAIL_COLLABORATEUR;
        public List<MPC_MISSION> MPC_MISSION;
        public List<MPC_PROCEDURE> MPC_PROCEDURE;
        public List<MPC_FORME_MARCHE> MPC_FORME_MARCHE;
        public List<MPC_TYPE_PRESTATION> MPC_TYPE_PRESTATION;
        public List<MPC_TYPE_CONTRAT> MPC_TYPE_CONTRAT;
        public List<SOCIETES> SOCIETES;
        public List<LOCALISATIONS> LOCALISATIONS;
        public List<DCES> DCES;
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