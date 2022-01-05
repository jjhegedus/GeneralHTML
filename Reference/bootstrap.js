// Bare minimum utility functions necessary to bootstrap the centrifuge
msgBox = alert;

// Begin Initialization script
window.old_onload = window.onload;
window.onload = load_centrifuge;
window.functionArray = new Array();
functionArray[functionArray.length] = load_centrifuge;
functionArray[functionArray.length] = getCentrifugeScriptObjectNode;
functionArray[functionArray.length] = installCentrifugeScript;
functionArray[functionArray.length] = addAttributeToXMLNode;
// End Initialization script

function load_centrifuge()
{
	try
	{
		window.centrifugeScriptNode = null;
		
		installCentrifugeScript();
		
		window.centrifuge = new Centrifuge();
		
		centrifuge.superClass.onload = window.old_onload;
		try
		{
			centrifuge.afterLoad = Centrifuge_afterLoad;
		}
		catch(e)
		{
			// Don't do anything.  The function is already null if there was an error
		}
		
		centrifuge.onload();
	}
	catch(e)
	{
		alert("Error in " + window.location.href + ":load_centrifuge\r\r" + e.description);
	}
}
function getCentrifugeScriptObjectNode()
{
	try
	{
		var xmlHttp = new ActiveXObject("msxml2.xmlhttp.5.0");
		var xDoc = new ActiveXObject("Microsoft.XMLDOM");

		var requestNode = xDoc.createElement('requestNode');
		addAttributeToXMLNode(requestNode, "xmlns:centrifuge", "http://www.centrifugeit.com/centrifuge.xsd");
		addAttributeToXMLNode(requestNode, "xmlns:xsl", "http://www.w3.org/1999/XSL/Transform");
		addAttributeToXMLNode(requestNode, "requestType", "getObjectNode");
		var matchNode = xDoc.createElement('centrifuge:object');
		addAttributeToXMLNode(matchNode, "objectId", "0");
		requestNode.appendChild(matchNode);
		
		xDoc.loadXML(requestNode.xml);
		xmlHttp.Open("POST", "http://www.centrifugeit.com", false);
		xmlHttp.send(xDoc);
		var resultNode = xmlHttp.responseXML.documentElement;
		
		return resultNode.firstChild;
	}
	catch(e)
	{
		alert("Error in " + window.location.href + ":loadCentrifugeScript\r\r" + e.description);
	}
}
function installCentrifugeScript()
{
	try
	{
		var resultNode = getCentrifugeScriptObjectNode();
		
		if(centrifugeScriptNode != null)
		{
			document.removeChild(centrifugeScriptNode);
		}
		
		centrifugeScriptNode = document.createElement("script");
		addAttributeToXMLNode(centrifugeScriptNode, "language", "javascript");
		addAttributeToXMLNode(centrifugeScriptNode, "name", "CentrifugeScript");
		centrifugeScriptNode.text = resultNode.text;
		
		document.appendChild(centrifugeScriptNode);
	}
	catch(e)
	{
		alert("Error in " + window.location.href + ":loadCentrifugeScript\r\r" + e.description);
	}
}
function addAttributeToXMLNode(xmlNode, name, value)
{
  var attribute = xmlNode.ownerDocument.createAttribute(name);
  attribute.nodeValue = value;
  xmlNode.attributes.setNamedItem(attribute);
}