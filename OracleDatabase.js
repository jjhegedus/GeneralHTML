
/* Class - OracleDatabase */
/* Prerequisites:
		Utility.js
   Utilized by:
		Database.asp
*/
	function OracleDatabase()
	{
		try
		{
			this.mvarConnection;
			this.mvarDsn;
			this.mvarUserId = '';
			this.mvarPassword = '';
			this.mvarChanged = true;
			
			// Properties
			this.setDsn = OracleDatabase_setDsn;
			this.getDsn = OracleDatabase_getDsn;
			this.setUserId = OracleDatabase_setUserId;
			this.getUserId = OracleDatabase_getUserId;
			this.setPassword = OracleDatabase_setPassword;
			this.getPassword = OracleDatabase_getPassword;
			this.setServer = OracleDatabase_setServer;
			this.getServer = OracleDatabase_getServer;
			this.get_name = OracleDatabase_get_name;
			this.get_objectType = OracleDatabase_get_objectType;
			this.get_children = OracleDatabase_get_children;
			this.get_users = OracleDatabase_get_users;
			
			// Methods
			this.login = OracleDatabase_login;
			this.setConnectionStr = OracleDatabase_setConnectionStr;
			this.getConnectionStr = OracleDatabase_getConnectionStr;
			this.getConnection = OracleDatabase_getConnection;
			this.getTables = OracleDatabase_getTables;
			this.get_tablesCollection = OracleDatabase_get_tablesCollection;
			this.get_viewsCollection = OracleDatabase_get_viewsCollection;
		}
		catch(e)
		{
			throw logError(e);
		}
	}

		function OracleDatabase_setDsn(newValue)
		{
			try
			{
				this.mvarDsn = newValue;
				this.mvarChanged = true;
			}
			catch(e)
			{
				throw logError(e);
			}
		}
		function OracleDatabase_getDsn()
		{
			try
			{
				return this.mvarDsn;
			}
			catch(e)
			{
				throw logError(e);
			}
		}
		function OracleDatabase_setUserId(newValue)
		{
			try
			{
				this.mvarUserId = newValue;
				this.mvarChanged = true;
			}
			catch(e)
			{
				throw logError(e);
			}
		}
		function OracleDatabase_getUserId()
		{
			try
			{
				return this.mvarUserId;
			}
			catch(e)
			{
				throw logError(e);
			}
		}
		function OracleDatabase_setPassword(newValue)
		{
			try
			{
				this.mvarPassword = newValue;
				this.mvarChanged = true;
			}
			catch(e)
			{
				throw logError(e);
			}
		}
		function OracleDatabase_getPassword()
		{
			try
			{
				return this.mvarPassword;
			}
			catch(e)
			{
				throw logError(e);
			}
		}
		function OracleDatabase_setServer(newValue)
		{
			try
			{
				this.mvarServer = newValue;
				this.mvarChanged = true;
			}
			catch(e)
			{
				throw logError(e);
			}
		}
		function OracleDatabase_getServer()
		{
			try
			{
				return this.mvarServer;
			}
			catch(e)
			{
				throw logError(e);
			}
		}
		function OracleDatabase_get_name()
		{
			try
			{
				return 'Oracle:' + this.getServer();
			}
			catch(e)
			{
				throw logError(e);
			}
		}
		function OracleDatabase_get_objectType()
		{
			try
			{
				return 'OracleDatabase';
			}
			catch(e)
			{
				throw logError(e);
			}
		}
		function OracleDatabase_get_children()
		{
			try
			{
				if(!this.mvarChildren)
				{
					this.mvarChildren = new ObjectCollection();
					
					this.mvarChildren.add(this.get_tablesCollection());
					this.mvarChildren.add(this.get_viewsCollection());
					this.mvarChildren.add(this.get_users());
				}
				
				return this.mvarChildren;
			}
			catch(e)
			{
				throw logError(e);
			}
		}
		function OracleDatabase_get_users()
		{
			try
			{
				if(!this.mvarUsers)
				{
					this.mvarUsers = new ObjectCollection();
					this.mvarUsers.set_name('Users');
					
					var rstUsers = this.getData('SELECT * from all_users order by username');
					
					var count = 1;
					
					if(!rstUsers.EOF)
					{
						while(!rstUsers.EOF)
						{
							var lpUser;
							
							var userName = rstUsers.Fields.Item('username').Value;
							lpUser = new OracleUser(userName);
							
							lpUser.db = this;
							
							this.mvarUsers.add(lpUser);
							
							rstUsers.MoveNext();
							count += 1;
						}
					}
				}
				
				return this.mvarUsers;
			}
			catch(e)
			{
				throw logError(e);
			}
		}
		function OracleDatabase_login()
		{
			try
			{
				
				var tmpXMLDoc = new ActiveXObject('Microsoft.XMLDom');
				var dialogData = tmpXMLDoc.createElement('dialogData');
				var xmlNode = tmpXMLDoc.createElement('fields');
				dialogData.appendChild(xmlNode);
				
				var userIdNode = tmpXMLDoc.createElement('userId');
				addAttributeToXMLNode(userIdNode, 'modify', 'true');
				addAttributeToXMLNode(userIdNode, 'tabIndex', '1');
				userIdNode.text = 'ops$is27';
				xmlNode.appendChild(userIdNode);
				
				var passwordNode = tmpXMLDoc.createElement('password');
				addAttributeToXMLNode(passwordNode, 'modify', 'true');
				addAttributeToXMLNode(passwordNode, 'dataType', 'password');
				addAttributeToXMLNode(passwordNode, 'tabIndex', '2');
				addAttributeToXMLNode(passwordNode, 'initialFocus', 'true');
				xmlNode.appendChild(passwordNode);
				
				var serverNode = tmpXMLDoc.createElement('server');
				addAttributeToXMLNode(serverNode, 'modify', 'true');
				addAttributeToXMLNode(serverNode, 'tabIndex', '3');
				serverNode.text = 'repo';
				xmlNode.appendChild(serverNode);
				
				var retData = createXMLDialog(dialogData);
				
				this.setUserId(userIdNode.text);
				this.setPassword(passwordNode.text);
				this.setServer(serverNode.text);
				
				if(this.getConnection())
				{
					this.mvarLoggedIn = true;
				}
				else
				{
					alert('failed to login to Oracle host database');
				}
			}
			catch(e)
			{
				throw logError(e);
			}
		}
		function OracleDatabase_getConnectionStr()
		{
			try
			{
				if(!this.mvarConnectionStr)
				{
					if(this.getDsn())
					{
						this.mvarConnectionStr = 'DSN=' + this.getDsn() + ';UID=' + this.getUserId() + ';pwd=' + this.getPassword();
					}
					else
					{
						this.mvarConnectionStr = 'DRIVER={Microsoft ODBC for Oracle};UID=' + this.getUserId() + ';pwd=' + this.getPassword() + ";SERVER=" + this.getServer() + ";";
					}
				}
				
				return this.mvarConnectionStr;
			}
			catch(e)
			{
				throw logError(e, "Errors connecting through ODBC Drivers for Oracle can be caused by Using an 8.06 default Oracle Home.");
			}
		}
		function OracleDatabase_setConnectionStr(newValue)
		{
			try
			{
				this.mvarConnectionStr = newValue;
				this.mvarConnection = new ActiveXObject("ADODB.Connection");
				try
				{
					this.mvarConnection.Open(this.getConnectionStr());
				}
				catch(connectionError)
				{
					var errMsg = 'Error connecting to\r  ConnectionString = ' + this.getConnectionStr();
					connectionError.description += '\r' + errMsg;
					throw connectionError;
				}
				this.mvarChanged = false;
			}
			catch(e)
			{
				throw logError(e);
			}
		}
		function OracleDatabase_getConnection()
		{
			try
			{
				if(this.getDsn())
				{
					var connectionString = 'DSN=' + this.getDsn() + ';UID=' + this.getUserId() + ';pwd=' + this.getPassword();
				}
				else
				{
					var connectionString = 'DRIVER={Microsoft ODBC for Oracle};UID=' + this.getUserId() + ';pwd=' + this.getPassword() + ";SERVER=" + this.getServer() + ";";
				}

				if((!this.mvarConnection) || (this.mvarChanged))
				{
					this.mvarConnection = new ActiveXObject("ADODB.Connection");
					this.mvarConnection.Open(connectionString);
					this.mvarChanged = false;
				}
				
				return this.mvarConnection;
			}
			catch(e)
			{
				throw logError(e, "Errors connecting through ODBC Drivers for Oracle can be caused by Using an 8.06 default Oracle Home.");
			}
		}

		function OracleDatabase_getTables()
		{
			try
			{
				var sqlStr = 'SELECT * FROM ALL_TABLES';
				var rstTables = new ActiveXObject('ADODB.Recordset');
				rstTables.Open(sqlStr, this.getConnection(), 1);
				
				return rstTables;
			}
			catch(e)
			{
				throw logError(e);
			}
		}
		function OracleDatabase_get_tablesCollection()
		{
			try
			{
				if(!this.mvarTablesCollection)
				{
					this.mvarTablesCollection = new ObjectCollection();
					this.mvarTablesCollection.set_name('Tables');
					
					//var tables = this.getData('SELECT * from all_tables');
					tables = this.getTables();
					
					var count = 1;
					
					if(!tables.EOF)
					{
						while(!tables.EOF)
						{
							var lpTable;
							
							var tableName = tables.Fields.Item('table_name').Value;
							var tableOwner = tables.Fields.Item('owner').Value;
							lpTable = new OracleTable(tableName, tableOwner);
							
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
		function OracleDatabase_get_viewsCollection()
		{
			try
			{
				if(!this.mvarViewsCollection)
				{
					this.mvarViewsCollection = new ObjectCollection();
					this.mvarViewsCollection.set_name('Views');
					
					var views = this.getData('SELECT * from all_views');
					
					var count = 1;
					
					if(!views.EOF)
					{
						while(!views.EOF)
						{
							var lpView;
							
							var viewName = views.Fields.Item('view_name').Value;
							var viewOwner = views.Fields.Item('owner').Value;
							lpView = new OracleView(viewName, viewOwner);
							
							lpView.db = this;
							
							this.mvarViewsCollection.add(lpView);
							
							views.MoveNext();
							count += 1;
						}
					}
				}
				
				return this.mvarViewsCollection;
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
/* end Class OracleDatabase */
