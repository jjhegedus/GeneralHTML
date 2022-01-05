function XmlSchemaCache()
{
  this.schemaCache = new ActiveXObject("Msxml2.XMLSchemaCache.5.0");
  this.templateFileName = "template.xsd";
  
  this.getSchemaCache = XmlSchemaCache_getSchemaCache;
  this.createXmlSchema = XmlSchemaCache_createXmlSchema;
}
  function XmlSchemaCache_getSchemaCache()
  {
    return this.schemaCache;
  }
  function XmlSchemaCache_createXmlSchema(targetNamespace)
  {
    var schema = null;
    var xmlSchema = null;
    
    if(this.getSchemaCache().getSchema(targetNamespace) == null)
    {
      this.getSchemaCache().add(targetNamespace, this.templateFileName);
      schema = this.getSchemaCache().getSchema(targetNamespace);
      xmlSchema = new XmlSchema(schema);
    }
    
    return xmlSchema;
  }