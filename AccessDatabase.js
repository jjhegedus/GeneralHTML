/* Class - accessDatabase */
/* Prerequisites:
		Database.asp
*/
	function AccessDatabase()
	{
		try
		{
			this.mvarConnection;
			this.mvarDsn;
			this.mvarUserId = 'admin';
			this.mvarPassword = '';
			this.mvarChanged = false;

			// Properties
			this.setDsn = AccessDatabase_setDsn;
			this.getDsn = AccessDatabase_getDsn;
			this.getConnectionStr = AccessDatabase_getConnectionStr;
			this.setConnectionStr = AccessDatabase_setConnectionStr;
			this.setUserId = AccessDatabase_setUserId;
			this.getUserId = AccessDatabase_getUserId;
			this.setPassword = AccessDatabase_setPassword;
			this.getPassword = AccessDatabase_getPassword;
			this.get_name = AccessDatabase_get_name;
			this.set_name = AccessDatabase_set_name;
			this.viewSystemTables = false;

			// Methods
			this.getConnection = AccessDatabase_getConnection;
			this.getTables = AccessDatabase_getTables;
			this.get_children = AccessDatabase_get_children;
			this.get_tablesCollection = AccessDatabase_get_tablesCollection;
			this.getColumns = AccessDatabase_getColumns;
			this.get_objectType = AccessDatabase_get_objectType;
		}
		catch(e)
		{
			throwError('AccessDatabase', e);
		}
	}
		function AccessDatabase_setDsn(newValue)
		{
			this.mvarDsn = newValue;
			this.mvarChanged = true;
		}
		function AccessDatabase_getDsn()
		{
			return this.mvarDsn;
		}
		function AccessDatabase_getConnectionStr()
		{
			try
			{
				return this.mvarConnectionStr;
			}
			catch(e)
			{
				throwError('AccessDatabase_getConnectionStr', e);
			}
		}
		function AccessDatabase_setConnectionStr(newValue)
		{
			try
			{
				this.mvarConnectionStr = newValue;
			}
			catch(e)
			{
				throwError('AccessDatabase_setConnectionStr', e);
			}
		}
		function AccessDatabase_setUserId()
		{
			this.mvarUserId = newValue;
			this.mvarChanged = true;
		}
		function AccessDatabase_getUserId()
		{
			return this.mvarUserId;
		}
		function AccessDatabase_setPassword()
		{
			this.mvarPassword = newValue;
			this.mvarChanged = true;
		}
		function AccessDatabase_getPassword()
		{
			return this.mvarPassword;
		}
		function AccessDatabase_get_name()
		{
			try
			{
				if(this.mvarName)
				{
					return this.mvarName;
				}
				else
				{
					return this.getConnectionStr();
				}
			}
			catch(e)
			{
				throw logError(e);
			}
		}
		function AccessDatabase_set_name(newName)
		{
			try
			{
				this.mvarName = newName;
			}
			catch(e)
			{
				throw logError(e);
			}
		}
		function AccessDatabase_getConnection()
		{
			try
			{
				if(!this.mvarConnectionStr)
				{
					this.setConnectionStr('DSN=' + this.getDsn() + ';UID=' + this.getUserId() + ';pwd=' + this.getPassword());
				}
					
				if((!this.mvarConnection) || (this.mvarChanged))
				{
					this.mvarConnection = new ActiveXObject("ADODB.Connection");
					this.mvarConnection.Open(this.getConnectionStr());
					this.mvarChanged = false;
				}

				
				return this.mvarConnection;
			}
			catch(e)
			{
				throw e;
			}
		}
		function AccessDatabase_getTables()
		{
			try
			{
				/*
				this.constraintsArray = new Array();
				
				this.constraintsArray[0] = null;
				this.constraintsArray[1] = null;
				this.constraintsArray[2] = null;
				this.constraintsArray[3] = "TABLE";
				
				return this.getConnection().openSchema(20, this.constraintsArray);
				*/
				return this.getConnection().openSchema(20);
			}
			catch(e)
			{
				throw logError(e);
			}
		}
		function AccessDatabase_getColumns(tableName)
		{
			try
			{
				this.constraintsArray = new Array();
				
				this.constraintsArray[0] = null;
				this.constraintsArray[1] = null;
				this.constraintsArray[2] = tableName;

				return this.getConnection().openSchema(4, this.constraintsArray);
			}
			catch(e)
			{
				throw logError(e);
			}
		}
		function AccessDatabase_get_objectType()
		{
			try
			{
				return 'AccessDatabase';
			}
			catch(e)
			{
				throw logError(e);
			}
		}
		function AccessDatabase_get_tablesCollection()
		{
			try
			{
				if(!this.mvarTablesCollection)
				{
					this.mvarTablesCollection = new ObjectCollection();
					this.mvarTablesCollection.set_name('Tables');
					
					var tables = this.getData('SELECT * from column_mapping');
					tables = this.getTables();
					
					var count = 1;
					
					if(!tables.EOF)
					{
						while(!tables.EOF)
						{
							var lpTable;
							
							var tableName = tables.Fields.Item('table_name').Value;
							lpTable = new AccessTable(tableName);
							
							lpTable.db = this;
							
							this.mvarTablesCollection.add(lpTable);
							
							tables.MoveNext();
							count += 1;
						}
					}
				}
				
				return this.mvarTablesCollection;
			}
			catch(e)
			{
				throw logError(e);
			}
		}
		function AccessDatabase_get_children()
		{
			try
			{
				if(!this.mvarChildren)
				{
					this.mvarChildren = new ObjectCollection();
					
					this.mvarChildren.add(this.get_tablesCollection());
				}
				
				return this.mvarChildren;
			}
			catch(e)
			{
				throw logError(e);
			}
		}

/*
		function templateFunction()
		{
			try
			{
			}
			catch(e)
			{
				throw logError(e);
			}
		}
*/
