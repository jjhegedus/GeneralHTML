function XmlSchema()
{
	this.schemaDocument = new XmlDocument();
	this.schemaDocument.createFromFilePath("template.xsd");
	
	this.getSchemaDocument = XmlSchema_getSchemaDocument;
	this.toString = XmlSchema_toString;
	this.setTargetNamespace = XmlSchema_setTargetNamespace;
	this.setNamespace = XmlSchema_setNamespace;
	this.setDefaultNamespace = XmlSchema_setDefaultNamespace;
}
  function XmlSchema_getSchemaDocument()
  {
    return this.schemaDocument;
  }
  function XmlSchema_toString()
  {
    return this.getSchemaDocument().getXml();
  }
  function XmlSchema_setTargetNamespace(targetNamespace)
  {
    this.getSchemaDocument().getDocumentElement().setAttributeValue("targetNamespace", targetNamespace);
  }
  function XmlSchema_setNamespace(namespaceUri, prefix)
  {
    try
    {
      var attributeName = "xmlns";

      if(typeof(prefix) != "undefined")
      {
			  attributeName += ":" + prefix;
			  //alert("attributeName = " + attributeName);
	    }
			
			//alert("namespaceUri = " + namespaceUri);
      var documentElement = this.getSchemaDocument().getDocumentElement();
      documentElement.setAttributeValue(attributeName, namespaceUri, true);
    }
    catch(e)
    {
      throw logError(e);
    }
  }
  function XmlSchema_setDefaultNamespace(defaultNamespace)
  {
    this.setNamespace(defaultNamespace);
  }