function initialize()
{
	try
	{
		window.moveTo(0, 0);
		window.resizeTo(screen.width, screen.height);
		showSplash(true);
		
		// Load the error handling functions
		loadScript('ErrorManagement.js');

		// Load the utility functions
		loadScript('Utility.js');
		
		loadScript('ObjectCollection.js');

	/* No need for background processing at this point
		loadScript('BackgroundProcessor.js');
		
		window.backgroundProcessor = new BackgroundProcessor();
			
		window.backgroundProcessor.run();
	*/

		showSplash(false);
		afterInitialize();
	}
	catch(e)
	{
		alert('Error in ' + window.location + ':initialize()\r' + e.description);
	}
}
	// Retrieves the properties of an object
	// takes an object as a parameter and returns a string with all
	// of the properties of the object.  Each row has the following format
	// <propName>:<propValue>"\r";
	function viewProperties(obj,recurse, maxRecursion, indent, asHTML)
	{
		var lineBreak = "\r";
		var indentSpace = "    ";
		if(asHTML)
		{
			lineBreak = "<br/>";
			indentSpace = "&nbsp;&nbsp;&nbsp;&nbsp;";
		}
		
		var indentStr = "";
		if(indent)
		{
			for(var i = 0; i < indent; i++)
			{
				indentStr += indentSpace;
			}
		}
		else
		{
			indent = 0;
		}
		
				
		var msg = "";
		var prop
		if(obj)
		{
			for(prop in obj)
			{
				try
				{
					if(recurse)
					{
						if(typeof(obj[prop]) == "object")
						{
							msg += indentStr + prop + ":";
							if(indent < maxRecursion)
							{
								try
								{
									msg += lineBreak + viewProperties(obj[prop],true, maxRecursion, indent + 1, asHTML);
								}
								catch(e)
								{
									msg += e.description + lineBreak;
								}
								//alert("proptype = " + typeof(obj[prop]) + "\r\r" + msg);
							}
							else
							{
								msg += obj[prop] + lineBreak;
							}
						}
						else
						{
							msg += indentStr + prop + ":" + obj[prop] + lineBreak;
						}
					}
					else
					{
						msg += indentStr + prop + ":" + obj[prop] + lineBreak;	  
					}
				}
				catch(e)
				{
					msg += "  error: " + e.description + lineBreak;
				}
			}
		}
		return msg;
	}

function getBaseUrl()
{
	try
	{
		var baseUrl = null;
		
		if((document.all.tags('BASE')[0] != undefined) &&
			(document.all.tags('BASE')[0]))
		{
			baseUrl = document.all.tags('BASE')[0].href;
		}
		else
		{
			baseUrl = new String(window.location.href);
			baseUrl = baseUrl.slice(0, baseUrl.lastIndexOf("/") + 1);
		}
		
		return baseUrl;
	}
	catch(e)
	{
		if(typeof(logError) != 'undefined')
		{
			if(logError)
			{
				throw logError(e);
			}
			else
			{
				alert('Error in ' + window.location + ':loadScript(' + url + ')\r' + e.description);
			}
		}
		else
		{
			alert('Error in ' + window.location + ':loadScript(' + url + ')\r' + e.description); 
		}
	}
}

function loadScript(url)
// function to load a javascript file into the current document
{
	try
	{
		window.dialogArgs = new Object();
		window.dialogArgs[0] = document;
		window.dialogArgs[1] = url;
		window.dialogArgs[2] = getBaseUrl();
		
		
		var dialogFeatures = 'dialogHeight:0;dialogWidth:0';
		

		window.showModalDialog(window.dialogArgs[2] + 'loadScript.htm', window.dialogArgs, dialogFeatures);

		
		return document.dialogReturn;
	}
	catch(e)
	{
		if(typeof(logError) != 'undefined')
		{
			if(logError)
			{
				throw logError(e);
			}
			else
			{
				alert('Error in ' + window.location + ':loadScript(' + url + ')\r' + e.description);
			}
		}
		else
		{
			alert('Error in ' + window.location + ':loadScript(' + url + ')\r' + e.description); 
		}
	}
}

function showSplash(show)
{
	if(show)
	{
		//alert('show splash screen here');
	}
	else
	{
		//alert('hide splash screen here');
	}	
}
