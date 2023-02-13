({
    GetDataFromController : function(component, IFSatisfactionClient, IFEnjeuxContractuels, IFRelationnelClient) {
        //$( "#visualization" ).load(window.location.href + " #visualization" );// test to refresh div
        //alert('in GetDataFromController' + IFSatisfactionClient + IFEnjeuxContractuels + IFRelationnelClient);
        var action = component.get('c.getAccountPlans');
        action.setParams({ 
            AccountId : component.get("v.recordId"),
            IFSatisfactionClient : IFSatisfactionClient,
            IFEnjeuxContractuels : IFEnjeuxContractuels,
            IFRelationnelClient : IFRelationnelClient,
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                var myList= response.getReturnValue();
                //console.log(response.getReturnValue());
                component.set("v.listWrapper", response.getReturnValue());
                //******
                var container = document.getElementById('visualization');
                var datasetArray = [];
                
                for (var myPLan in myList)
                {
                    datasetArray.push({
                        'id': myList[myPLan].TheTaskEvent.Id, 
                        'content': '<div class="res_name"><span id="Parent Span" style="white-space: nowrap;">' 
                        + ((myList[myPLan].ifHighPriority)?'<span id="HighImportance Span" style="color:red;font-weight: bold;font-size: 22px; line-height:5px;">&nbsp;!&nbsp;</span>':'')
                        + ((myList[myPLan].NonAcheve)?'<span id="DueDatePassed Span" style="color:red;font-weight: bold;font-size: 34px; line-height:5px;">&nbsp;.&nbsp;</span>':'')
                        + myList[myPLan].TheTaskEvent.Subject+'</span><div class="res_info"><h3 class="openLink2" onclick="window.open(\'/'+myList[myPLan].TheTaskEvent.Id+'\');">'+myList[myPLan].TheTaskEvent.Subject+'</h3><div class="block"><div class="label">Propriétaire: </div><div class="" onclick="window.open(\'/'+myList[myPLan].TheTaskEvent.OwnerId+'\');" class="value">'+
                        ((myList[myPLan].TheTaskEvent.OwnerId==null)?'':myList[myPLan].TheTaskEvent.Owner.Name)+'</div></div><div class="block"><div class="label">Date:</div><div  class="value">'+myList[myPLan].TheTaskEvent.ActivityDate+'</div></div><div class="block"><div class="label">Statut:</div><div  class="value">'+myList[myPLan].Realise+'</div></div></div></div>', 
                        'start': myList[myPLan].TheTaskEvent.ActivityDate,
                        'className': myList[myPLan].status +' tooltip ' + myList[myPLan].genre_comite
                    });
                }
                //alert('datasetArray'+ datasetArray);
                
                var items = new vis.DataSet(datasetArray);
                //alert('items'+ items);
                var ThisYear=new Date().getFullYear();
                // Configuration for the Timeline
                var options = {
                    end : new Date(ThisYear,12, 32) - 1,
                    start : new Date(ThisYear, 1, 1),
                    min: new Date(ThisYear-2190, 0, 1),                // lower limit of visible range(6 years from now)
                    max: new Date(ThisYear+2190, 0, 1),                // upper limit of visible range
                    zoomMin: 1000 * 60 * 60 * 24 *7             // one week in milliseconds
                };
                
                // Create a Timeline
                if (typeof(timeline) !== 'undefined') {
                    timeline.redraw(); 
                    console.warn('exists');
                }
                console.warn('test 1');
                var timeline = new vis.Timeline(container, items, options);
                timeline.redraw(); 
                
                //$(container).css('height','100px !important');
                //hidden
                $(container).innerhtml="tst";
                $(container).css('overflow','hidden');
                //container.style.height = "400px";
                console.warn(container.offsetHeight);
                console.warn(container);
                
                
                // timeline.redraw();
                //alert($('.res_info'));
                //console.log(document.getElementsByClassName('vis-item-content'));
                $('.res_name').hover(function(e){
                    var targettag=$(e.target);
                    
                    //console.warn('element id =' +targettag.attr('id'));
                    
                    $('.res_info').hide();
                    //added by yorgo
                    //console.warn('target ' + e.target);
                    //console.warn('nodeName  :' + e.target.nodeName +':');
                    //console.warn('Parents  ' + $(targettag).parent("div"));
                    
                    //console.warn('classlist ' + e.target.classList);
                    if(targettag.attr('id')=="Parent Span")
                    {
                        var info = $(e.target).parent("div").find('.res_info');
                        //console.warn('info  parent' + $(info).nodeName);
                        
                    }
                    else if(targettag.attr('id')=="HighImportance Span" || targettag.attr('id')=="DueDatePassed Span")
                    {
                        var info = ($(e.target).parent("SPAN")).parent("div").find('.res_info');
                        //console.warn('info parent  ' + $(info).attr('id'));
                        
                    }
                        else
                        {
                            var info = $(e.target).find('.res_info');
                            //console.warn('info  ' + $(info).nodeName);
                        }
                    
                    //
                    //var info = $(e.target).find('.res_info'); // removed by yorgo
                    //console.log(info);
                    
                    $(info).css('left',e.pageX);      // <<< use pageX and pageY
                    $(info).css('top',e.pageY-window.scrollY+15);    // removing scroll value to fixe the bubble's position even if user scrolls               
                    $(info).css('position', "relatif"); 
                    
                    //done Added by Yorgo
                    
                    $(info).show('slow');
                    
                },
                                     function(e){
                                         //console.log('mouse out');  
                                         $('.res_info').hide();
                                         var info = $(e.target).find('.res_info');
                                         //console.log(info);
                                         $(info).hide();
                                     });
                
                $('.openLink').on('click', function(e){
                    var target = e.target;
                    console.log(target);
                    var id = $(target).attr('data-id');
                    window.top.location.href = '{!$Site.prefix}/'+id;
                });
            }
            else if (component.isValid() && state === "INCOMPLETE") {
            }
                else if (component.isValid() && state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);             
        
    }
})