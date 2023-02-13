/*--------------------------------------------------------------------------------------------------------------------------
Author: Serouj Jamijian
Company: EI-Technologies
Description: This class is used as a controller for the VF page that was a test of the cartographie and contains filters 
Test Class: VFC01_MapFilter_Test
Pages: VF01_MapFilter
History
<Date> <Authors Name> <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
public with sharing class VFC01_MapFilter {
    string Google_API_Key = 'AIzaSyBSLGxbxw56bLnMyXVfJHY0U_rf4y7D_qM';
    public list<wrapperMarker> listMarkers{get;set;}
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Serouj Jamijian 
Company: EI-Technologies
Description:  Constructor of the class 
Inputs: -
Returns: -
History
<Date> <Authors Name> <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
    
    public VFC01_MapFilter(){
        Load_Marker_Wrapper(); 
    }
    
    public VFC01_MapFilter getCurrentController(){
        return this;
    }
    
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Serouj Jamijian 
Company: EI-Technologies
Description:  this method loads the markers of the map  
Inputs: -
Returns: -
History
<Date> <Authors Name> <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
    public void Load_Marker_Wrapper(){
        listMarkers = new list<wrapperMarker>();
        
        //Test
        map<string, list<string>> mapCitryStreets = new map<string, list<string>>{
            'Paris'=>new list<string>{'Allée de Fontainebleau', 'Allée de l\'Espérance',    'Allée de la Comtesse-de-Ségur',    'Allée de la Deuxième-D.-B.',   'Allée de la Garance',  'Allée de la Reine-Marguerite', 'Allée de Longchamp',   'Allée de Madrid-à-Neuilly',    'Allée des Bouleaux',   'Allée des Buttes', 'Allée des Dames',  'Allée des Eiders', 'Allée des Érables',    'Allée des Fortifications', 'Allée des Frères-Voisin',  'Allée des Hortensias', 'Allée des Justes de France',   'Allée des Lapins', 'Allée des Poteaux',    'Allée des Quatre Carrefours',  'Allée des Refuzniks',  'Allée des Vergers',    'Allée Diane-de-Poitiers',  'Allée du Bord-de-l\'Eau',  'Allée du Capitaine-Dronne',    'Allée du Chef-d\'Escadron-de-Guillebon',   'Allée du Commandant Raynal',   'Allée du Général-Denain',  'Allée du Général-Koenig',  'Allée du Parc-de-Choisy',  'Allée du Père-Julien-Dhuit',   'Allée du Philosophe',  'Allée du Professeur Jean Bernard', 'Allée du Révérend Père Michel Riquet', 'Allée Eugène-Beaudouin',   'Allée Federico-Garcia-Lorca',  'Allée Fortunée',   'Allée Gabrielle-d\'Estrées',   'Allée Gaston-Bachelard',   'Allée Georges-Besse',  'Allée Georges-Recipon',    'Allée Georges-Rouault',    'Allée Henry Dunant',   'Allée Jean Sablon',    'Allée Jean-Paulhan',   'Allée Jules-Supervielle',  'Allée Léon-Bourgeois', 'Allée Louis-Aragon',   'Allée Louise-Labé',    'Allée Marc-Chagall',   'Allée Marcel-Jambenoire',  'Allée Marcel-Proust',  'Allée Marguerite-Yourcenar',   'Allée Maria-Callas',   'Allée Marie-Laurent',  'Allée Marius-Barroux', 'Allée Maurice-Baumont',    'Allée Nijinski',   'Allée Paul-Deschanel', 'Allée Pernette-du-Guillet',    'Allée Pierre Mollaret',    'Allée Pierre-Lazareff',    'Allée Pilâtre-de-Rozier',  'Allée Rimski-Korsakov',    'Allée Rodenbach',  'Allée Royale', 'Allée Saint-Denis',    'Allée Saint-John-Perse',   'Allée Samuel Beckett', 'Allée Thomy-Thierry',  'Allée Valentin-Abeille',   'Allée Verhaeren',  'Allée Verte',  'Allée Vivaldi',    'Arcades des Champs-Élysées',   'Avenue Adrien-Hébrard',    'Avenue Albert-Bartholomé', 'Avenue Albert-de-Mun', 'Avenue Albert-Ier-de-Monaco',  'Avenue Alphand',   'Avenue Alphonse-Xiii', 'Avenue Ambroise-Rendu',    'Avenue Anatole-France',    'Avenue André-Rivoire', 'Avenue Armand-Rousseau',   'Avenue Barbey-d\'Aurevilly',   'Avenue Beaucour',  'Avenue Benoît Frachon'},
                'Lyon'=>new list<string>{'Rue Antoine Sallès', 'Rue du Bât-d\'Argent', 'Rue Bichat', 'Rue Dubois', 'Rue du Bon Pasteur'},
                    'Bordeaux'=>new list<string>{'Place Pey Berland', 'Rue Sainte-Catherine', 'Erik Satie', 'Mery', 'Feger'},
                        'Lille'=>new list<string>{'rue de l\'Arc', 'rue de Bruxelles', 'rue Cormont', 'rue Doudin', 'rue de Fontenoy'}
        };
            
            integer totalCities = mapCitryStreets.keyset().size();
        integer totalStreets = 0;
        for(string keyCity : mapCitryStreets.keyset()){
            totalStreets += mapCitryStreets.get(keyCity).size();
        }
        
        system.debug('### totalStreets  : ' + totalStreets );
        for(integer i=0; i< totalStreets ; i++){
            wrapperMarker tempMarker = new wrapperMarker();
            tempMarker.Name = 'Name_'+i;
            
            integer cityIndex = math.mod(i, totalCities);
            
            list<string> listCities = new list<string>();
            listCities.addAll(mapCitryStreets.keyset());
            string CityName = listCities.get(cityIndex);
            tempMarker.City = CityName ;
            
            
            integer CurrentCity_Streets = mapCitryStreets.get(CityName).size();                        
            integer streetIndex = math.mod(i, CurrentCity_Streets);
            tempMarker.Street = mapCitryStreets.get(CityName).get(streetIndex);   
            
            tempMarker.Country = 'France';
            listMarkers.add(tempMarker);
        }
    }
}