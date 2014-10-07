var url = 'http://localhost:1331/graphData.json'
///url = 'http://localhost:1331/rawGraphData.json'
//url = 'http://localhost:1331/graphData/predicate/is an'
//url = 'http://localhost:1331/graphData/subject/3e15eef3a23c'
var showData = function(graphData)
    {
        // create a network
        var container = document.getElementById('graph');
        $("#graph").css({'left':'0','right':'0' , 'bottom':'0', 'top':'0'});
        var options = {
            dataManipulation: true
            //stabilize : true,
            //stabilizationIterations  : 2000,
            //hierarchicalLayout: true
            //clustering: true,
            //initialMaxNodes  : 10
            /*physics: {
                barnesHut: {
                    enabled: true,
                    gravitationalConstant: -2000,
                    centralGravity: 0.1,
                    springLength: 195,              //modified
                    springConstant: 0.04,
                    damping: 0.09
                }}*/
        };
        network = new vis.Network(container, graphData, options);
    };

var previousNodes = null;

var loadData = function()
    {   
        console.log("[loadData]");
        $.ajax({
                type: "GET",
                url: url
            }).done(function(graphData)
                    {                     
                        if (graphData.refresh ==false && JSON.stringify(graphData.nodes) == JSON.stringify(previousNodes))
                        {
                            console.log('...same data as before, skipping load');
                            return;
                        }
                        console.log('...new data, parsing and showing data');
                        previousNodes = graphData.nodes;
                        
                        showData(graphData);
                    });
    };
//loadData()    
window.setInterval(loadData, 2000);