if(typeof(medispan) != 'undefined')
{
	if(medispan)
	{
		medispan.tmpFunctions[medispan.tmpFunctions.length] = ObjectCollection;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = ObjectCollection_setName;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = ObjectCollection_getName;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = ObjectCollection_get_objectType;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = ObjectCollection_initialize;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = ObjectCollection_determineType;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = ObjectCollection_createObject;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = ObjectCollection_createConstructedObject;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = ObjectCollection_createHTMLDomObject;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = ObjectCollection_createXMLDomObject;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = ObjectCollection_add;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = ObjectCollection_verifyType;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = ObjectCollection_remove;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = ObjectCollection_empty;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = ObjectCollection_item;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = ObjectCollection_insertItem;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = ObjectCollection_setItem;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = ObjectCollection_getItemIndexFromProperty;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = ObjectCollection_getItemFromProperty;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = ObjectCollection_getItemIndexFromConformanceTest;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = ObjectCollection_getItemFromConformanceTest;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = ObjectCollection_gatherItems;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = ObjectCollection_getChildIndex;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = ObjectCollection_loadObject;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = ObjectCollection_get_children;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = ObjectCollection_createViewPort;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = ObjectCollection_updateViewPorts;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = ObjectCollection_afterUpdate;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = ObjectCollection_sortBy;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = unmatchedCollectionItems;
		medispan.tmpFunctions[medispan.tmpFunctions.length] = matchedCollectionItems;
	}
}
function ObjectCollection(prototypicalObject)
{
	try
	{
		// private variables
		//this.arguments = xmlArguments;
		this.prototypicalObject = prototypicalObject;
		this.parentObject = null;
		this.m_array = new Array();
		this.m_keys = new Array();
		this.gathering = false;
		this.collectionName = 'ObjectCollection';
		
		// property accessor functions
		this.setName = ObjectCollection_setName;
		this.getName = ObjectCollection_getName;
		this.get_name = this.getName;
		this.set_name = this.setName;
		this.get_objectType = ObjectCollection_get_objectType;

		// public variables
		this.count = 0;				

		
		// methods
		this.initialize = ObjectCollection_initialize;
		this.determineType = ObjectCollection_determineType;
		this.createObject = ObjectCollection_createObject;
		this.createConstructedObject = ObjectCollection_createConstructedObject;
		this.createHTMLDomObject = ObjectCollection_createHTMLDomObject;
		this.createXMLDomObject = ObjectCollection_createXMLDomObject;
		this.add = ObjectCollection_add;
		this.verifyType = ObjectCollection_verifyType;
		this.remove = ObjectCollection_remove;
		this.empty = ObjectCollection_empty;
		this.item = ObjectCollection_item;
		this.insertItem = ObjectCollection_insertItem;
		this.setItem = ObjectCollection_setItem;
		this.getItemFromProperty = ObjectCollection_getItemFromProperty;
		this.getItemIndexFromProperty = ObjectCollection_getItemIndexFromProperty;
		this.getItemIndexFromConformanceTest = ObjectCollection_getItemIndexFromConformanceTest;
		this.getItemFromConformanceTest = ObjectCollection_getItemFromConformanceTest;
		this.getChildIndex = ObjectCollection_getChildIndex;
		this.loadObject = ObjectCollection_loadObject;
		this.sortBy = ObjectCollection_sortBy;
		this.get_children = ObjectCollection_get_children;

		// events
		this.onAdd = null;
		this.onRemove = null;
		this.afterUpdate = ObjectCollection_afterUpdate;


		// viewPort methods, properties and events
		this.createViewPort = ObjectCollection_createViewPort;
		this.updateViewPorts = ObjectCollection_updateViewPorts;

	
		// begin execution
		this.initialize();
	}
	catch(e)
	{
		throwError('ObjectCollection', e);
	}
}
	function ObjectCollection_setName(newValue)
	{
		try
		{
			this.collectionName = newValue;
			this.updateViewPorts();
		}
		catch(e)
		{
			throwError('ObjectCollection_setName', e);
		}
	}
	function ObjectCollection_getName()
	{
		try
		{
			return this.collectionName;
		}
		catch(e)
		{
			throwError('ObjectCollection_getName', e);
		}
	}
	function ObjectCollection_get_objectType()
	{
		try
		{
			return 'ObjectCollection';
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function ObjectCollection_initialize()
	{
		try
		{
			this.objectType = "ObjectCollection";						this.determineType();

			if(!window.objectCollections)
			{
				window.objectCollections = new Collection();
			}

			window.objectCollections.add(this);						this.index = window.objectCollections.count - 1;

			this.viewPorts = new Collection();
		}
		catch(e)
		{
			throwError('ObjectCollection_initialize', e);
		}
	}
	function ObjectCollection_determineType()
	{
		try
		{
			if(this.prototypicalObject)
			{
				if(this.prototypicalObject.constructor)
				{
					this.type = 'constructed';
					this.typeValue = constructorName(this.prototypicalObject.constructor);
				}
				else if(this.prototypicalObject.tagName)
				{
					this.type = 'htmlDom';
					this.typeValue = this.prototypicalObject.tagName;
				}
				else if(this.prototypicalObject.nodeName)
				{
					this.type = 'xmlDom';
					this.typeValue = this.prototypicalObject.nodeName;
				}
				else
				{
					this.type = null;
					this.typeValue = null;
				}
			}
		}
		catch(e)
		{
			throwError('ObjectCollection_determineType', e);
		}
	}
	function ObjectCollection_createObject()
	{
		try
		{
			var newObject;
			if(this.type == 'constructed')
			{
				newObject = this.createConstructedObject();
			}
			else if(this.type = 'htmlDom')
			{
				newObject = this.createHTMLDomObject();
			}
			else if(this.type = 'xmlDom')
			{
				newObject = this.createXMLDomObject();
			}
			else if(this.type = null)
			{
				te = new Error(1018, 'Either no object type was defined or this is a heterogeneous collection.');
				throw te;
			}
			else
			{
				te = new Error(1012, 'Unknown object type');
				throw te;
			}
			
			return newObject;
		}
		catch(e)
		{
			throwError('ObjectCollection_createObject', e);
		}
	}
	function ObjectCollection_createConstructedObject()
	{
		try
		{
			// this.typeValue is prototypicalObject.constructor
			var tmpFuncStr = "window.objectCollections.item(" + this.index + ").add(new " + this.typeValue + "());";
			eval(tmpFuncStr);
			window.objectCollections.item(this.index).updateViewPorts();
			
			return window.objectCollections.item(this.index).item(this.count - 1);
		}
		catch(e)
		{
			throwError('ObjectCollection_createConstructedObject', e);
		}
	}
	function ObjectCollection_createHTMLDomObject()
	{
		try
		{
			var newObject = document.createElement(this.typeValue);
						
			return this.typeValue;
		}
		catch(e)
		{
			throwError('ObjectCollection_createHTMLDomObject', e);
		}
	}
	function ObjectCollection_createXMLDomObject()
	{
		try
		{
			var tmpDoc = new ActiveXObject('Microsoft.XMLDOM');
			tmpDoc.loadXML('<junk/>');
			
			var newObject = tmpDoc.createElement(this.typeValue);
			
			return newObject;
		}
		catch(e)
		{
			throwError('ObjectCollection_createXMLDomObject', e);
		}
	}
	function ObjectCollection_add(newObject, key)
	{
		try
		{
			var cancel = false;
			
			if(this.onAdd != null)
			{
				cancel = this.onAdd(newObject, this);
			}

			if(!this.verifyType(newObject))
			{
				var ne = new Error(1010, 'ObjectCollection initialized with different object prototype');
				cancel = true;
				throwError('ObjectCollection_add(newObject):interiorCode', ne);
			}
			if(cancel)
			{		
				return null;
			}
			else
			{
				++this.count;
				ReDim(this.m_array, this.count);
				ReDim(this.m_keys, this.count);
			
				this.m_array[this.count - 1] = newObject;
				this.m_keys[this.count - 1] = key;
				
				return this.m_array[this.count-1];
			}
		}
		catch(e)
		{
			throwError('ObjectCollection_add', e);
		}
	}
	function ObjectCollection_verifyType(newObject)
	{
		try
		{
			var verify = false;
		
			if(this.type)
			{	
				if(newObject.constructor)
				{
					if(constructorName(newObject.constructor) == this.typeValue)
					{
						verify = true;
					}
				}
				else if(this.tagName)
				{
					if(newObject.tagName == this.prototypicalObject.tagName)
					{
						verify = true;
					}
				}
				else if(this.prototypicalObject.nodeName)
				{
					if(newObject.nodeName == this.prototypicalObject.nodeName)
					{
						verify = true;
					}
				}
			}
			else
			{
				verify = true;
			}
			
			return verify;
		}
		catch(e)
		{
			throwError('ObjectCollection_verifyType', e);
		}
	}
	function ObjectCollection_remove(index)
	{
		try
		{
			var cancel = false;

			if(this.onRemove != null)
			{
				cancel = this.onRemove(index, this);
			}

			if(cancel)
			{
				return null;
			}
			else
			{
				var removedItem = this.item(index);
				var newCount = this.count - 1;
				this.m_array[index] = null;
				this.m_keys[index] = null;
						
				for (var lpVar = index; lpVar < this.count - 1; ++lpVar)
				{
						this.m_array[lpVar] = this.m_array[lpVar+1];
						this.m_keys[lpVar] = this.m_keys[lpVar+1];
						this.m_array[lpVar+1] = null;
						this.m_keys[lpVar+1] = null;
				}
				this.count = newCount;
	
				ReDim(this.m_array, newCount);
				ReDim(this.m_keys, newCount);
				
				return removedItem;
			}
		}
		catch(e)
		{
			throwError('ObjectCollection_remove', e);
		}
	}

	function ObjectCollection_empty()
	{
		try
		{
			for(var i = this.count -1;i >= 0;i--)
			{
				this.remove(i);
			}
		}
		catch(e)
		{
			throwError('ObjectCollection_empty', e);
		}
	}
	function ObjectCollection_item(index)
	{
		try
		{
			
			if(parseInt(index) || (parseInt(index) == 0))
			{
				return this.m_array[parseInt(index)];
			}
			else
			{
				for(var i = 0;i < this.count;i++)
				{
					if(this.m_keys[i] == index)
					{
						// This is a key
						return this.item(i);
						break;
					}
				}
			}
		}
		catch(e)
		{
			throwError('ObjectCollection_item', e);
		}
	}
	function ObjectCollection_insertItem(newObject, key)
	{
		try
		{
			var cancel = false;
			
			if(this.onAdd != null)
			{
				cancel = this.onAdd(newObject, this);
			}
			

			if(!this.verifyType(newObject))
			{
				var ne = new Error(1010, 'ObjectCollection initialized with different object prototype');
				cancel = true;
				throwError('ObjectCollection_insertItem(newObject):interiorCode', ne);
			}

			if(cancel)
			{
				return null;
			}
			else
			{
				++this.count;
				ReDim(this.m_array, this.count);
				ReDim(this.m_keys, this.count);
					var tmp;
				var tmp2 = newObject;
				var tmpKey2 = key;
				
				
				
					for(var j = index;j < this.count;j++)
				{
					tmp = this.m_array[j];
					tmpKey = this.m_keys[j];
					this.m_array[j] = tmp2;
					this.m_keys[j] = tmpKey2;
					tmp2 = tmp;
					tmpKey2 = tmpKey;
				}
					return this.m_array[index];
			}
		}
		catch(e)
		{
			throwError('ObjectCollection_insertItem', e);
		}
	}
	function ObjectCollection_setItem(newItem, index, key)
	{
		try
		{
			var oldItem = this.m_array[index];
			var oldKey = this.m_keys[index];
			this.m_array[index] = newItem;
			this.m_keys[index] = key;
		
			return oldItem;
		}
		catch(e)
		{
			throwError('ObjectCollection_setItem', e);
		}
	}
	function ObjectCollection_getItemIndexFromProperty(propertyName, value, caseInsensitive)
	{
		try
		{
			var itemIndex = null;
			
			for(var i = 0;i < this.count;i++)
			{
				if(this.item(i)[propertyName].constructor)
				{
					var constructorString = new String(this.item(i)[propertyName].constructor);

					if(constructorString.slice(10, 16) == 'String')
					{
						if(caseInsensitive)
						{
							var tmpString = new String(this.item(i)[propertyName]);
							var tmpString2 = new String(value);
							if(tmpString.toUpperCase() == tmpString2.toUpperCase())
							{
								itemIndex = i;
								break;
							}
						}
						else
						{
							if(this.item(i)[propertyName] == value)
							{
								itemIndex = i;
								break;
							}
						}
					}
					else
					{
						if(this.item(i)[propertyName] == value)
						{
							itemIndex = i;
							break;
						}
					}
				}
				else
				{
					if(this.item(i)[propertyName] == value)
					{
						itemIndex = i;
						break;
					}
				}
			}
			
			return itemIndex;
		}
		catch(e)
		{
			alert(e.description);
			throwError('ObjectCollection_getItemIndexFromProperty', e);
		}
	}
	function ObjectCollection_getItemFromProperty(propertyName, value, caseinsensitive)
	{
		try
		{
			var itemIndex = this.getItemIndexFromProperty(propertyName, value, caseinsensitive);
			return this.item(itemIndex);
		}
		catch(e)
		{
			throwError('ObjectCollection_getItemFromProperty', e);
		}
	}
	function ObjectCollection_getItemIndexFromConformanceTest(conformanceTestFunction)
	{
		try
		{
			var itemIndex = null;
			
			for(var i = 0;i < this.count;i++)
			{
				if(conformanceTestFunction(this.item(i)))
				{
					itemIndex = i;
					break;
				}
			}
			
			return itemIndex;

		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function ObjectCollection_getItemFromConformanceTest(conformanceTestFunction)
	{
		try
		{
			var itemIndex = this.getItemIndexFromConformanceTest(conformanceTestFunction);
			if((itemIndex) || (itemIndex == 0))
			{
				return this.item(itemIndex);
			}
			else
			{
				return null;
			}
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function ObjectCollection_gatherItems(newItem, collector)
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
				collector = new ObjectCollection();
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
	function ObjectCollection_getChildIndex(child)
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
	function ObjectCollection_loadObject(xmlObject)
	{
		try
		{

		}
		catch(e)
		{
			throwError('ObjectCollection_loadObject', e);
		}
	}
	function ObjectCollection_get_children()
	{
		try
		{
			return this;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function ObjectCollection_createViewPort(viewPort)
	{
		try
		{
			return this.viewPorts.add(new ObjectCollectionViewPort(this));
		}
		catch(e)
		{
			throwError('ObjectCollection_createViewPort', e);
		}
	}
	function ObjectCollection_updateViewPorts()
	{
		try
		{
			for(var i = 0;i < this.viewPorts.count;i++)
			{
				var viewPort = this.viewPorts.item(i);
				alert(viewPort.constructor);
				viewPort.onObjectUpdated();
			}
		}
		catch(e)
		{
			throwError('ObjectCollection_updateViewPorts', e);
		}
	}
	function ObjectCollection_afterUpdate()
	{
		try
		{
			alert('ObjectCollection_afterUpdate');
		}
		catch(e)
		{
			throwError('ObjectCollection_afterUpdate', e);
		}
	}
	function ObjectCollection_sortBy(sortFunction, ascending)
	{
		try
		{
			var bubbling = true;
			
			while(bubbling == true)
			{
				bubbling = false;
				
				for(j = 0; j < this.count - 1;j++)
				{
					if (sortFunction(this.item(j)) > sortFunction(this.item(j+1)))
					{
						bubbling = true;
						var tempItem = this.item(j);
						this.setItem(this.item(j + 1), j);
						this.setItem(tempItem, j + 1);
					}
				}
			}
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	
function unmatchedCollectionItems(collection1, collection2, matchingFunction)
{
	try
	{
		var unmatchedCollection = new ObjectCollection();
		
		for(var i = 0;i < collection1.count;i++)
		{
			var lpItem1 = collection1.item(i);
			var matchingItem = null;
			
			for(var j = 0;j < collection2.count;j++)
			{
				var lpItem2 = collection2.item(j);
				
				if(matchingFunction(lpItem1, lpItem2))
				{
					matchingItem = lpItem2;
					break;
				}
			}
			
			if(!matchingItem)
			{
				unmatchedCollection.add(lpItem1);
			}
		}
		
		return unmatchedCollection;
	}
	catch(e)
	{
		throw logError(e);
	}
}
function matchedCollectionItems(collection1, collection2, matchingFunction)
{
	try
	{
		var matchedCollection = new ObjectCollection();
		
		for(var i = 0;i < collection1.count;i++)
		{
			var lpItem1 = collection1.item(i);
			var matchingItem = null;
			
			for(var j = 0;j < collection2.count;j++)
			{
				var lpItem2 = collection2.item(j);
				
				if(matchingFunction(lpItem1, lpItem2))
				{
					matchingItem = lpItem2;
					break;
				}
			}
			
			if(matchingItem)
			{
				matchedCollection.add(new ObjectPair(lpItem1, matchingItem));
			}
		}
		
		return matchedCollection;
	}
	catch(e)
	{
		throw logError(e);
	}
}
