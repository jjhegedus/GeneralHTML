if(typeof(medispan) != 'undefined')
{
	if(medispan)
	{
		medispan.tmpFunctions[medispan.tmpFunctions.length] = copyObject;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = getBaseURL;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = getCookie;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = getCookieVal;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = setCookie;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = formatErrorsNode;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = getErrorsNode;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = getXMLData;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = JustFName;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = FileName;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = FileName_extension;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = childURL;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = constructorName;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = msgBox;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = createXMLDialog;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = throwError;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = getXMLAttributeValue;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = setXMLAttributeValue;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = addAttributeToXMLNode;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = postXMLRequest;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = postDatabaseRequest;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = getError;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = ReDim;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = Collection;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = Collection_getItemIndexFromProperty;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = Collection_getItemFromProperty;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = Collection_gatherItems;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = Collection_getChildIndex;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = Collection_add;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = Collection_remove;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = Collection_item;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = Collection_insert;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = Collection_setItem;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = Map;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = Map_add;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = Map_getMappedItem;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = Map_count;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = viewProperties;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = viewSpecifiedProperties;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = TemplateFunction;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = String_trim;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = ArgumentPackedFunction;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = showToolTip;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = hideToolTip;
	}
}

function copyObject(obj, recurse, maxRecursion, depth)
{
	try
	{
		if(!depth)
		{
			depth = 0;
		}
		
		var newObject;
		var prop;
		
		if(typeof(obj) == 'object')
		{
			newObject = new Object();
			for(prop in obj)
			{
				try
				{
					if(recurse)
					{
						if(typeof(obj[prop]) == "object")
						{
							if(depth < maxRecursion)
							{
								newObject[prop] = copyObject(obj[prop], true, maxRecursion, depth + 1);
							}
							else
							{
								newObject[prop] = obj[prop];
							}
						}
						else
						{
							newObject[prop] = obj[prop];
						}
					}
					else
					{
						newObject[prop] = obj[prop];
					}
				}
				catch(e)
				{
					newObject[prop] = obj[prop];
				}
			}
		}
			
		return obj;
	}
	catch(e)
	{
		throw logError(e);
	}
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

function getCookie(htmlDocument, cookieName)
{
	try
	{
		var arg = cookieName + '=';
		var alen = arg.length;
		var clen = htmlDocument.cookie.length;
		var i = 0;
		while (i < clen)
		{
			var j = i + alen;
			if (htmlDocument.cookie.substring(i, j) == arg)
			{
				return getCookieVal(htmlDocument, j);
			}
			i = htmlDocument.cookie.indexOf(" ", i) + 1;
			if (i == 0) break;
		}

		return null;
	}
	catch(e)
	{
		throwError('getCookie', e);
	}
}
function getCookieVal(htmlDocument, offset)
{
	try
	{
		var endstr = htmlDocument.cookie.indexOf (";", offset);
		if (endstr == -1)
		{
			endstr = htmlDocument.cookie.length;
		}

		return unescape (htmlDocument.cookie.substring(offset, endstr));
	}
	catch(e)
	{
		throwError('getCookieVal', e);
	}
}

function setCookie(htmlDocument, name, value) 
{
	try
	{
		var argv = setCookie.arguments;

		var argc = setCookie.arguments.length;
		var expires = (argc > 3) ? argv[3] : null;
		var path = (argc > 4) ? argv[4] : null;
		var domain = (argc > 5) ? argv[5] : null;
		var secure = (argc > 6) ? argv[6] : false;

		htmlDocument.cookie = name + "=" + escape (value) +
			((expires == null) ? "" : ("; expires=" + expires.toGMTString())) +
			((path == null) ? "" : ("; path=" + path)) +
			((domain == null) ? "" : ("; domain=" + domain)) +
			((secure == true) ? "; secure" : "");

	}
	catch(e)
	{
		throwError('setCookie', e);
	}
}

function formatErrorsNode(errorsNode)
{
	try
	{
		var eString = '';	       
		var errors = errorsNode.childNodes;
		if(errors)
		{
			for(var i = 0;i < errors.length;i++)
			{
				var lpError = errors.item(i);
				var errorDescription = lpError.selectSingleNode('description');

							
				eString += 'Error #' + i + ':' + errorDescription.text + '\r';
			}
		}
		
		return eString;
	}
	catch(e)
	{
		throwError('formatErrorsNode', e);
	}
}
function getErrorsNode(resultNode)
{
	try
	{
		var errorsNode = resultNode.selectSingleNode('//errors');
		
		return errorsNode;
	}
	catch(e)
	{
		throwError('getErrorsNode', e);
	}
}


function getXMLData(queryNode, aspPageUrl)
{
	try
	{
		var xDoc = new ActiveXObject('Microsoft.XMLDOM');
		
		xDoc.loadXML(queryNode.xml);
		var xmlhttp = new ActiveXObject ("Microsoft.XMLHTTP");

		xmlhttp.Open("POST", aspPageUrl, false);

		xmlhttp.Send(xDoc);

		var resultNode = xmlhttp.responseXML;

		return resultNode
	}
	catch(e)
	{
		throwError('getXMLData', e);
	}
}


function JustFName(path)
{
	try
	{
		var sPath = new String(path);
		var gRegBS = new RegExp("[\\\\]", "g");
		sPath = sPath.replace(gRegBS, "/")
		return sPath.substring(sPath.lastIndexOf("/")+1).split('.')[0]
	}
	catch(e)
	{
		throwError('JustFName', e);
	}
}

function FileName(fileName)
{
	try
	{
		this.string = new String(fileName);
		this.extension = FileName_extension;
	}
	catch(e)
	{
		throwError('FileName', e);
	}
}
	function FileName_extension()
	{
		try
		{
			return this.string.slice(this.string.lastIndexOf('.') + 1, this.string.length);
		}
		catch(e)
		{
			throwError('URL_extension', e);
		}
	}


function childURL(baseURL, candidateURL)
{
	try
	{
		var retVal = false;
		
		var candidateURLString = new String(candidateURL.href);
		
		if(candidateURLString.indexOf(baseURL.href) != -1)
		{
			retVal = true;
		}
		
		return retVal;
	}
	catch(e)
	{
		throwError('withinScope', e);
	}
}
function constructorName(constructor)
{
	try
	{
		var constructorString = new String(constructor);
		
		return constructorString.slice(9, constructorString.indexOf('('));
	}
	catch(e)
	{
		alert('Error in constructorName ' + e.description);
	}
}
function msgBox(message, title, options, owner)
{
	try
	{
		message = prepareStringForXML(message);
		var features = 'dialogWidth:' + screen.width + 'px;dialogHeight:' + screen.height + 'px;';
		var xmlData = '<fields><message dataType="long">' + message + '</message></fields>';
		var xmlArg = new ActiveXObject('MSXML2.DOMDocument.4.0');
		
		success = xmlArg.loadXML(xmlData);
		if(!success)
		{
			processXMLParseError(xmlArg);
		}
		
		document.msgBox_XMLArg = xmlArg;
		showModalDialog(getBaseURL() + 'CreateXMLDialog.htm', document.msgBox_XMLArg, features);
	}
	catch(e)
	{
		throwError(msgBox, e);
	}
}

function createXMLDialog(xmlNode)
{
	try
	{
		document.xmlDialogArgs = xmlNode;
		var features = 'dialogWidth:' + screen.width + 'px;dialogHeight:' + screen.height + 'px;';
		showModalDialog(getBaseURL() + 'CreateXMLDialog.htm', document.xmlDialogArgs, features);
		return document.xmlDialogArgs;
	}
	catch(e)
	{
		throwError('createXMLDialog', e);
	}
}

function throwError(functionName, e, errorInformation)
{
	try
	{
		var errStr = '';
		errStr += 'Error in '
		errStr += functionName
				
		if(errorInformation)
		{
			errStr += '\r    Error Information:\r'
			errStr += errorInformation
		}
				
		errStr += '\r'
		errStr += e.description;
				
		var throwError = new Error(1000 + e.number, errStr);
	}
	catch(outerE)
	{
		var errStr = 'Error in throwError:\r  functionName = ' + functionName + '\r  errorInformation = ' + errorInformation + '\r' + outerE.description;
				
		alert(errStr);
		throw errStr;
	}
			
	throw throwError;
}

function getXMLAttributeValue(xmlNode, attributeName)
{
	try
	{
		if(xmlNode.attributes)
		{
			var attribute = xmlNode.attributes.getNamedItem(attributeName);
			if(attribute)
			{
				return attribute.nodeValue;     
			}
			else
			{
				return null;
			}
		}
		else
		{
			return null;
		}
	}
	catch(e)
	{
		throwError('getXMLAttributeValue', e);
	}
}


function setXMLAttributeValue(xmlNode, attributeName, attributeValue)
{
	try
	{
		var attribute;

		attribute = xmlNode.attributes.getNamedItem(attributeName);
		if(attribute)
		{
			attribute.nodeValue = attributeValue;
		}
				
		return attribute;
	}
	catch(e)
	{
		throwError('setXMLAttributeValue', e);
	}
}

function addAttributeToXMLNode(xmlNode, name, value)
{
	try
	{
		var attribute = xmlNode.ownerDocument.createAttribute(name);
		attribute.nodeValue = value;
		xmlNode.attributes.setNamedItem(attribute);
	}
	catch(e)
	{
		throwError('addAttributeToXMLNode', e);
	}
}

function postXMLRequest(xmldoc)
{
	var xmlhttp = new ActiveXObject ("Microsoft.XMLHTTP");
	xmlhttp.Open("POST", "http://www.centrifugeit.com/processRequest.asp", false);
	xmlhttp.Send(xmldoc);
	return xmlhttp.responseXML;
}
	
function postDatabaseRequest(xmlRequest)
{
	try
	{
		var xmlhttp = new ActiveXObject('Microsoft.XMLHTTP');
		xmlhttp.Open('POST', 'http://www.centrifugeit.com/processDatabaseRequest.asp', false);
		xmlhttp.Send(xmlRequest);
		return xmlhttp.responseXML;
	}
	catch(e)
	{
		throwError('postDatabaseRequest', e);
	}
}

function getError(error)
{
	try
	{
		var retString = '';
		var caller = getError.caller;
		var callerString = new String(caller);
		var callerName = callerString.slice(9, callerString.indexOf('('));
		var callerArgs = caller.arguments;
		var callerArgsString = new String('');
		for(var i = 0;i < callerArgs.length;i++)
		{
			if(typeof(callerArgs[i]) == 'string')
			{
				callerArgsString += "'" + callerArgs[i] + "', ";
			}
			else
			{
				callerArgsString += callerArgs[i] + ', ';
			}
		}
		callerArgsString = callerArgsString.slice(0, callerArgsString.length - 2);
						
		var callerSpec = callerName + '(' + callerArgsString + ')';
					
		var eString = 'error in ' + document.location + ':' + callerSpec + '\r\r' +  error.description;
		retString = eString;
	}
	catch(e)
	{
		retString = 'error in getError\r\r' + e.description;
		retString  += '\r\runable to get full error information\roriginal error information:\r\r   ' + error.description;
	}
				
	return retString;
}

function ReDim(curArray, size)
{
	var initLen
		
	initLen = curArray.length;
	curArray.length = size;
	if (size > initLen)
	{
		for (var loopVar = initLen;loopVar < size; ++loopVar)
		{
			curArray[loopVar] = null;
		}
	}
	else if (size < initLen)
	{
		for (var loopVar = size; loopVar <= initLen;++loopVar)
		{
			curArray[loopVar] = null;
		}
	}
}
		
	function Collection()
	{
		this.objectType = "Collection";
		this.m_array = new Array;
		this.count = 0;			 
		this.add = Collection_add;
		this.remove = Collection_remove
		this.item = Collection_item;
		this.insert = Collection_insert;
		this.setItem = Collection_setItem;
		this.onAdd = null;
		this.getItemFromProperty = Collection_getItemFromProperty;
		this.getItemIndexFromProperty = Collection_getItemIndexFromProperty;
		this.getChildIndex = Collection_getChildIndex;
		this.gathering = false;
	}
		function Collection_getItemIndexFromProperty(propertyName, value)
		{
			try
			{
				var itemIndex = null;
				
				for(var i = 0;i < this.count;i++)
				{
					if(this.item(i)[propertyName] == value)
					{
						itemIndex = i;
						break;
					}
				}
				
				return itemIndex;
			}
			catch(e)
			{
				throwError('Collection_getItemIndexFromProperty', e);
			}
		}
		function Collection_getItemFromProperty(propertyName, value)
		{
			var retVar = null;
			for(lpVar = 0;lpVar < this.count;lpVar++)
			{
				if(this.item(lpVar)[propertyName] == value)
				{
					var curItem = this.item(lpVar);
					retVar = Collection_gatherItems(curItem, retVar);
				}
			}
			
			if(retVar)
			{
				if(retVar.gathering)
				{
					retVar.gathering = false;
				}
			}
			
			return retVar;
		}
		function Collection_gatherItems(newItem, collector)
		{
			if(!collector)
			{
				collector = newItem;
			}
			else
			{
				if(!collector.gathering)
				{
					var tmp = collector;
					collector = new Collection();
					collector.add(tmp);
					collector.add(newItem);
					collector.gathering = true;
				}
				else
				{
					collector.add(newItem);
				}
			}
			
			return collector;       
		}
		function Collection_getChildIndex(child)
		{
			for(lpVar = 0;lpVar < this.count;lpVar++)
			{
				var curItem = this.item(lpVar);
				
				if(curItem == child)
				{
					return lpVar;
				}
			}
			return null;
		}
		function Collection_add(newObject)
		{
			var cancel = false;
			
			if(this.onAdd != null)
			{
				cancel = this.onAdd(newObject, this);
			}
			
			if(cancel)
			{
				return null;
			}
			else
			{
				++this.count;
				ReDim(this.m_array, this.count);
			
				this.m_array[this.count - 1] = newObject;
				return this.m_array[this.count-1];
			}
		}
		function Collection_remove(index)
		{
			var removedItem = this.item(index);
			var newCount = this.count - 1;
			this.m_array[index] = null;
					
			for (var lpVar = index; lpVar < this.count - 1; ++lpVar)
			{
					this.m_array[lpVar] = this.m_array[lpVar+1];
					this.m_array[lpVar+1] = null;
			}
			this.count = newCount;

			ReDim(this.m_array, newCount);
			
			return removedItem;
		}
		function Collection_item(index)
		{
			return this.m_array[index];
		}
		function Collection_insert(newObject, index)
		{
			try
			{

				var cancel = false;
				
				if(this.onAdd != null)
				{
					cancel = this.onAdd(newObject, this);
				}
				
				if(cancel)
				{
					return null;
				}
				else
				{
					++this.count;
					ReDim(this.m_array, this.count);

					var tmp;
					var tmp2 = newObject;
					
					

					for(var j = index;j < this.count;j++)
					{
						tmp = this.m_array[j];
						this.m_array[j] = tmp2;
						tmp2 = tmp;
					}

					return this.m_array[index];
				}
			}
			catch(e)
			{
				throwError('Collection_insert', e);
			}
		}
		function Collection_setItem(newItem, index)
		{
			var oldItem = this.m_array[index];

			this.m_array[index] = newItem;
			
			return oldItem;
		}
		/* End Collection Class */      

	
	function Map()
	{
		try
		{
			this.itemCol = new Collection;
			this.keyCol = new Collection;
	
			this.add = Map_add;
			this.getMappedItem = Map_getMappedItem;
			this.count = Map_count;
			this.item = this.itemCol.item;
		}
		catch(e)
		{
			throwError('Map', e);
		}
	}
		function Map_add(object, key)
		{
			try
			{
				this.itemCol.add(object);
				this.keyCol.add(key);
			}
			catch(e)
			{
				throwError('Map_add', e);
			}
		}
		function Map_getMappedItem(key)
		{
			try
			{
				var retVal;

				for(var i = 0;i < this.keyCol.count;i++)
				{
					if(this.keyCol.item(i) === key)
					{
						retVal = this.itemCol.item(i);
						break;
					}
				}

				return retVal;
			}
			catch(e)
			{
				throwError('Map_getMappedItem', e);
			}
		}
		function Map_count()
		{
			try
			{
				return this.itemCol.count;
			}
			catch(e)
			{
				throwError('Map_count', e);
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

	// Retrieves the properties of an object
	// takes an object as a parameter and returns a string with all
	// of the properties of the object.  Each row has the following format
	// <propName>:<propValue>"\r";
	function viewSpecifiedProperties(obj,recurse, maxRecursion, indent, asHTML)
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
							var showProp;
							try
							{
								showProp = obj[prop].specified;
							}
							catch(ee)
							{
								showProp = false;
							}
							if(showProp)
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

function TemplateFunction(functionString, argumentsString)
{
    try
    {
		var templateFunctionString = "";
		
		templateFunctionString += "try\r";
		templateFunctionString += "{\r";
	 
		templateFunctionString += functionString;
		    
		templateFunctionString += "}\r";
		templateFunctionString += "catch(e)\r";
		templateFunctionString += "{\r";
		templateFunctionString += " throw logError(e);\r";
		templateFunctionString += "}\r";
		   
		if(argumentsString)
		{
			return new Function(argumentsString, templateFunctionString);
		}
		else
		{
			return new Function(templateFunctionString);
		}
    }
    catch(e)
    {
	throw logError(e);
    }
}
function prepareStringForXML(in_string)
{
	try
	{

		var lastStart = 0;
		var tmp_string = new String(in_string);
		var retVal = new String();
		var re = new RegExp("[<|>|'|\"|&]", "g");
		
		while ((result = re.exec(tmp_string)) != null)
		{
			retVal += tmp_string.slice(lastStart, result.index);
			retVal += "&#x" + new Number(new String(result[0]).charCodeAt(0)).toString(16) + ";";
			lastStart = result.index + 1;
		}
		
		// Get the last one
		retVal += tmp_string.slice(lastStart);

		return retVal;

	}
	catch(e)
	{
		if(logError)
		{
			throw logError(e);
		}
		else
		{
			alert(e.description);
			throw e;
		}
	}
}

function processXMLParseError(xmlDocument)
{
	try
	{
		var errorMessage = '';
		errorMessage = 'filepos = ' + xmlDocument.parseError.filepos;
		errorMessage += '\rline = ' + xmlDocument.parseError.line;
		errorMessage += '\rlinepos = ' + xmlDocument.parseError.linepos;
		errorMessage += '\rreason = ' + xmlDocument.parseError.reason;
		errorMessage += '\rsrcText = ' + xmlDocument.parseError.srcText;
		
		alert(errorMessage);
	}
	catch(e)
	{
		throw logError(e);
	}
}

// First set up some constants
window.LeftWhitespaceRe = new RegExp("^[ \f\n\r\t\v]*");
window.RightWhitespaceRe = new RegExp("[ \f\n\r\t\v]*$");

// Then add it to the String prototype
String.prototype.trim = String_trim;

function String_trim()
{
	try
	{
		this.replace(window.LeftWhitespaceRe);
		this.replace(window.RightWhitespaceRe);
	}
	catch(e)
	{
		throw logError(e);
	}
}
	function ArgumentPackedFunction(functionText, argumentsString)
	{
		try
		{
			var functionString = "";
			
			functionString += "	try\r";
			functionString += "	{\r";

			functionString += "		try\r";			
			functionString += "		{\r";		
			functionString += "			arguments = arguments[0];\r";
			functionString += "		}\r";
			functionString += "		catch(e)\r";
			functionString += "		{\r";
			functionString += "	}\r";

			functionString += functionText;
			functionString += "\r";
			    
			functionString += "	}\r";
			functionString += "	catch(e)\r";
			functionString += "	{\r";
			functionString += "	 throw logError(e);\r";
			functionString += "	}\r";
			   
			if(argumentsString)
			{
				return new Function(argumentsString, functionString);
			}
			else
			{
				return new Function(functionString);
			}
		}
		catch(e)
		{
		throw logError(e);
		}
	}
function showToolTip(msgStr)
{
	try
	{
		if(!window.toolTipDiv)
		{
			window.toolTipDiv = document.createElement(div);
			window.toolTipDiv.style.backgroundColor = 'yellow';
			window.toolTipDiv.style.position = 'absolute';
		}
		
		if(window.toolTipDiv.style.visibility = 'hidden')
		{
			window.toolTipDiv.innerText = msgStr;
			event.srcElement.appendChild(window.toolTipDiv);
			window.toolTipDiv.style.top = event.y;
			window.toolTipDiv.style.left = event.x;
			window.toolTipDiv.style.visibility = 'visible';
		
			setTimeout(hideToolTip, 1000);
		}
	}
	catch(e)
	{
		throw logError(e);
	}
}

function hideToolTip()
{
	try
	{
		window.toolTipDiv.style.visibility = 'hidden';
		window.toolTipDiv.parentElement.removeChild(window.toolTipDiv);
	}
	catch(e)
	{
		alert(e.description);
		throw logError(e);
	}
}

function modalDialg(xmlArg)
{
	var initialFocusControl;
	
	var dialogForm = document.createElement('div');
	window.dialogForm = dialogForm;
	dialogForm.xmlArg = xmlArg;
	
	var formTable = document.createElement('form');
	formTable.id="formTable";
	formTable.name="formTable";
	formTable.width="100%";
	formTable.height="100%";
	dialogForm.appendChild(formTable);
	dialogForm.formTable = formTable;
	
	var formTableBody = document.createElement('tbody');
	formTableBody.id="formTableBody";
	formTableBody.name="formTableBody";
	formTableBody.width="100%";
	formTableBody.height="100%";
	formTable.appenChild(formTableBody);
	

	var fields = xmlArg.selectNodes('fields/*');
					
	for(var i = 0;i < fields.length;i++)
	{
		var newRow = document.createElement('tr');
		var newCell = document.createElement('td');
		newCell.colspan = '2';
		newCell.width = '100%';
		newCell.align = 'center';
		newCell.innerText = fields.item(i).tagName;
		
		newRow.appendChild(newCell);


		var newControl;
		var dataType = getXMLAttributeValue(fields.item(i), 'dataType');
		var initialFocus = getXMLAttributeValue(fields.item(i), 'initialFocus');
		
		if(dataType == null)
		{
			dataType = 'text';  // default value
		}
		
		switch(dataType)
		{
			case 'text':
				newControl = document.createElement('input');
				newControl.type = 'text';
				break;
			case 'long':
				newControl = document.createElement('textarea');
				
				var data = fields.item(i).text;
				var dataLength = data.length;
				var textAreaHeight = (Math.round(dataLength / 40)) * 50;
				newControl.style.width = 600;
				newControl.style.height = textAreaHeight;
				break;
			case 'password':
				newControl = document.createElement('input');
				newControl.type = 'password';
				break;
		}

		var tabIndex = getXMLAttributeValue(fields.item(i), 'tabIndex');

		if(tabIndex)
		{
			newControl.tabIndex = tabIndex;
		}



		var select = getXMLAttributeValue(fields.item(i), 'select')
		if(select == null)
		{
			select = true;   // default value
		}


		newControl.id = fields.item(i).tagName;
		newControl.name = fields.item(i).tagName;
		newControl.value = fields.item(i).text;
		//newControl.style.width = '100%';
		//newControl.height = '100%';

		if(select)
		{
			var modify = getXMLAttributeValue(fields.item(i), 'modify');
			if(!modify)
			{
				newControl.onkeydown = 'disableChange()';
			}


			
		}
		else
		{
				newControl.onkeydown = 'disableChange()';
				newControl.disabled = 'true';
		}

		if(initialFocus == 'true')
		{
			initialFocusControl = newControl;
		}
		
		newCell.appendChild(newControl);
		formTableBody.align = 'center';
		formTableBody.appendChild(newRow);

	}


	var okCancelRow = document.createElement('tr');

	var okCell = document.createElement('td');
	okCell.width = '50%';
	okCell.align = 'center';
	okCancelRow.appendChild(okCell);
	var btnOK = document.createElement('input');
	btnOK.type = 'submit';
	btnOK.value = 'OK';
	btnOK.onclick = modalDialog_btnOK_onclick;
	okCell.appendChild(btnOK);

	var cancelCell = document.createElement('td');
	cancelCell.width = '50%';
	cancelCell.align = 'center';
	okCancelRow.appendChild(cancelCell);
	var btnCancel = document.createElement('input');
	btnCancel.type = 'button';
	btnCancel.value = 'Cancel';
	btnCancel.onclick = modalDialog_btnCancel_onclick;
	okCell.appendChild(btnCancel);

	formTableBody.appendChild(okCancelRow);
	
	if(initialFocusControl)
	{
		initialFocusControl.focus();
	}
	
	document.appendChild(window.dialogForm);
	window.dialogForm.style.position = 'absolute';
	window.dialogForm.style.top = 0;
	window.dialogForm.style.left = 0;
	window.dialogForm.style.height = screen.availHeight;
	window.dialogForm.style.width = screen.availWidth;
	window.dialogForm.style.visibility = 'visible';
}
	function modalDialog_btnOK_onclick()
	{
		modalDialog_processForm();
	}

	function modalDialog_processForm()
	{
		var inputTags = window.dialogForm.formTable.all.tags('input');
		var xmlString = '';

		var fields = window.dialogForm.xmlArg.selectNodes('fields/*[@modify="true"]');
		
		for(var i = 0;i < fields.length;i++)
		{
			fields.item(i).text = inputTags[i].value;
		}

		window.dialogForm.visibility = 'hidden';
		document.removeChild(window.dialogForm);
	}

	function btnCancel_onclick()
	{
		var fieldsNode = xmlArg.selectSingleNode('fields');

		addAttributeToXMLNode(fieldsNode, 'cancel', 'true');
		
		dialogForm
	}
	function disableChange()
	{
		event.returnValue = false;
	}