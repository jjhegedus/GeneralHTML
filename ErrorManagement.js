msgBox = alert;
function window.onerror()
{
  try
  {
    var errorDescription = arguments[0];
    var errorFile = arguments[1];
    var errorLine = arguments[2];
    
    var errorMessage = 'ERROR:\r';
    errorMessage += '       File:           ' + errorFile + '\r';
    errorMessage += '       Line:           ' + errorLine + '\r';
    errorMessage += '\r errorDescription:  ' + errorDescription + '\r\r';
    
    window.errorFunction = new JavaScriptFunction(window.onerror.caller);
    
    //errorMessage += window.errorFunction.toString(0);
    //errorMessage += callStackToString(window.onerror.caller);
    
    var rootFunction = window.errorFunction.getRootFunction();
    var callee = rootFunction;
    var depth = 0;
    while(callee)
    {
      errorMessage += getTextIndent(depth) + "-----------------------------------\r";
      errorMessage += getTextIndent(depth) + callee.getSpec() + "\r";
      callee = callee.getCallee();
      depth++;
    }
    
    msgBox(errorMessage);
    
    // setting the event.returnValue equal to true
    // will suppress the Internet Explorer default error message
    event.returnValue = true;
  }
  catch(e)
  {
    var errorMessage = 'Error in ' + window.location + ' window.onerror';
    
    if(e.description)
    {
      errorMessage += '\r' + e.description;
    }
    alert(errorMessage);
  }
}

var indentSize = 4;
var textSpace = " ";
var htmlSpace = "&nbsp;";

function getTextIndent(depth)
{
  return makeString(depth, indentSize, textSpace);
}
function makeString(count, multiplier, str)
{
  if((typeof(count) == "undefined") ||
     (count == null))
  {
    count = 0;
  }
  
  var returnString = new String();
  for(var i = 0; i < multiplier * count; i++)
  {
    returnString += str;
  }
  return returnString;
}

function getCallStackString(inputFunction)
{
  var callStackString
    var rootFunction = window.errorFunction.getRootFunction();
    var callee = rootFunction;
    var depth = 0;
    while(callee)
    {
      errorMessage += getTextIndent(depth) + "-----------------------------------\r";
      errorMessage += getTextIndent(depth) + callee.getSpec() + "\r";
      callee = callee.getCallee();
      depth++;
    }
}

function getFunctionArgumentsString(inputFunction)
{
      var argumentsString = new String();
      
      for(var argCount = 0;argCount < inputFunction
                                        .arguments.length;argCount++)
      {
        argumentsString += inputFunction
                            .arguments[argCount];
        argumentsString += ', ';
      }
      argumentsString = argumentsString
                          .slice(0, - 2);
                          
      return argumentsString;
}

function constructorName(constructor)
{
  var constructorString = null;
  var constructorName = null;
  
  if(constructor)
  {
    constructorString = new String(constructor);
    constructorName = constructorString.slice(9, constructorString.indexOf('('));
  }
  else
  {
    constructorName = null;
  }
  return constructorName;
}
function getXmlParseErrorMessage(xmlDocument)
{
  try
  {
    var errorMessage = '';
    
    errorMessage = 'filepos = ' + xmlDocument.parseError.filepos;
    errorMessage += '\rline = ' + xmlDocument.parseError.line;
    errorMessage += '\rlinepos = ' + xmlDocument.parseError.linepos;
    errorMessage += '\rreason = ' + xmlDocument.parseError.reason;
    errorMessage += '\rsrcText = ' + xmlDocument.parseError.srcText;
    
    return errorMessage;
  }
  catch(e)
  {
    throw logError(e);
  }
}
