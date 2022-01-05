function XmlNode(node)
{
  this.node = node;
  
  this.getNode = XmlNode_getNode;
  this.getOwnerDocument = XmlNode_getOwnerDocument;
  this.getAttribute = XmlNode_getAttribute;
  this.addAttribute = XmlNode_addAttribute;
  this.setAttributeValue = XmlNode_setAttributeValue;
}
  function XmlNode_getNode()
  {
    return this.node;
  }
  function XmlNode_getOwnerDocument()
  {
    return this.getNode().ownerDocument;
  }
	function XmlNode_getAttribute(attributeName)
	{
	  return this.getNode().attributes.getNamedItem(attributeName);
	}
	function XmlNode_addAttribute(attributeName, attributeValue)
	{
		var attribute = this.getNode().ownerDocument.createAttribute(attributeName);
		attribute.nodeValue = attributeValue;
		this.getNode().attributes.setNamedItem(attribute);
	}
	function XmlNode_setAttributeValue(attributeName, attributeValue, create)
	{
	  var attribute = this.getAttribute(attributeName);
	  
	  if(attribute)
	  {
	    attribute.nodeValue = attributeValue;
	  }
	  else
	  {
	    if(create)
	    {
	      attribute = this.addAttribute(attributeName, attributeValue);
	    }
	    else
	    {
	      var attributeDoesNotExistError = new Error("Attribute:" + attributeName + " does not exist and create set to false.  Please create it before trying to set it's value");
	      throw(attributeDoesNotExistError);
	    }
	  }
	}