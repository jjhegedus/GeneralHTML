function XmlDocument()
{
  this.initialized = false;
  this.document = null;
  this.documentElement = null;
  
  this.createNew = XmlDocument_createNew;
  this.createFromDocument = XmlDocument_createFromDocument;
  this.createFromUrlString = XmlDocument_createFromUrlString;
  this.createFromFilePath = XmlDocument_createFromFilePath;
  this.getDocument = XmlDocument_getDocument;
  this.getXml = XmlDocument_getXml;
  this.getDocumentElement = XmlDocument_getDocumentElement;
}
	function XmlDocument_createNew()
	{
	  if(this.initialized)
	  {
	    var reinitilizationError = new Error("Cannot initialize an XmlDocument twice");
	    throw(reinitializationError);
	  }
	  
	  this.document = new ActiveXObject("msxml2.domdocument.5.0");
	}
	function XmlDocument_createFromDocument(document)
	{
	  if(this.initialized)
	  {
	    var reinitilizationError = new Error("Cannot initialize an XmlDocument twice");
	    throw(reinitializationError);
	  }
	  
	  this.document = document;
	}
	function XmlDocument_createFromUrlString(urlString)
	{
	  if(this.initialized)
	  {
	    var reinitilizationError = new Error("Cannot initialize an XmlDocument twice");
	    throw(reinitializationError);
	  }
	  
	  this.document = new ActiveXObject("msxml2.domdocument.5.0");
	  this.document.load(urlString);
	}
	function XmlDocument_createFromFilePath(filePath)
	{
	  if(this.initialized)
	  {
	    var reinitilizationError = new Error("Cannot initialize an XmlDocument twice");
	    throw(reinitializationError);
	  }
	  
	  this.document = new ActiveXObject("msxml2.domdocument.5.0");
	  this.document.load(filePath);
	}
	function XmlDocument_getDocument()
	{
	  return this.document;
	}
	function XmlDocument_getXml()
	{
	  return this.getDocument().xml;
	}
	function XmlDocument_getDocumentElement()
	{
	  if(this.documentElement == null)
	  {
	    this.documentElement = new XmlNode(this.getDocument().documentElement);
	  }
	  
	  return this.documentElement;
	}