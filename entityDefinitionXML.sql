DECLARE
	-- define weak REF CURSOR type
	TYPE ref_cur_type IS REF CURSOR;
	
	l_package_name CONSTANT 	VARCHAR2(32) := 'DPD_REPORT_PKG';
	l_xml_clob 					clob;
	l_entity_irids				varchar2(4000);
	l_table_irids				varchar2(4000);
	
	-- Main tables cursor
	cursor table_irids_cur(cur_folder_name varchar2,
						   cur_table_names varchar2)
	is
	select 	tab.irid
	  from 	ci_table_definitions 	tab,
	  	   	sdd_folder_members 		mem,
		   	sdd_folders 			fld
     where 	mem.member_object		= tab.irid
       and  mem.folder_reference	= fld.irid
       and  mem.ownership_flag 		= 'Y'
       and  fld.name				= cur_folder_name
     order
        by  tab.name;
        
	-- Main entities cursor
	cursor entity_irids_cur(cur_folder_name varchar2)
	is
	select 	ent.irid
	  from 	ci_entities 	ent,
	  	   	sdd_folder_members 		mem,
		   	sdd_folders 			fld
     where 	mem.member_object		= ent.irid
       and  mem.folder_reference	= fld.irid
       and  mem.ownership_flag 		= 'Y'
       and  fld.name				= cur_folder_name
     order
        by  ent.name;
	
	-- Return all workareas in the repository
	cursor workarea_cur
	is
	select 	irid,
			name
	  from 	sdd_workareas;
	
	-- Return the workareas and their corresponding applications
	-- from the repository
 	cursor workareas_and_apps_cur
 	is
 	SELECT wa.name  					workarea_name,
           wa.irid  					workarea_irid,
   	       cas.irid  					application_irid,
   	       cas.ivid						application_ivid,
   	       cas.name  					application_name
     FROM repository.i$sdd_wa_context 	wac,
          sdd_workareas 				wa,
          ci_application_systems 		cas
    WHERE wac.object_ivid 				= cas.ivid
      and wa.irid 						= wac.workarea_irid;
      
	-- Return the folders for a given workarea
	cursor workarea_folders_cur(cur_workarea_irid number)
	is
	select wa.name  					workarea_name,
           wa.irid  					workarea_irid,
   	       cas.irid  					folder_irid,
   	       cas.ivid						folder_ivid,
   	       cas.name  					folder_name
     FROM repository.i$sdd_wa_context 	wac,
          sdd_workareas 				wa,
          sdd_folders			 		cas
    WHERE wac.object_ivid 				= cas.ivid
      and wa.irid 						= wac.workarea_irid
      and wa.irid						= cur_workarea_irid;
	
	-- Return the tables for a given folder
	cursor folder_tables_cur(cur_folder_irid number)
	is
	select 	tab.irid				table_irid,
			tab.ivid				table_ivid,
			tab.name				table_name,
			tab.date_created		table_created,
			tab.date_changed		table_changed
	  from 	ci_table_definitions 	tab,
	  	   	sdd_folder_members 		mem,
		   	sdd_folders 			fld
     where 	mem.member_object		= tab.irid
       and  mem.folder_reference	= fld.irid
       and  mem.ownership_flag 		= 'Y'
       and  fld.irid				= cur_folder_irid
     order
        by  tab.name;
        
	-- Return the entities for a given folder
	cursor folder_entities_cur(cur_folder_irid number)
	is
	select 	ent.irid,
			ent.ivid,
			ent.name,
			ent.date_created,
			ent.date_changed
	  from 	ci_entities 	ent,
	  	   	sdd_folder_members 		mem,
		   	sdd_folders 			fld
     where 	mem.member_object		= ent.irid
       and  mem.folder_reference	= fld.irid
       and  mem.ownership_flag 		= 'Y'
       and  fld.irid				= cur_folder_irid
     order
        by  ent.name;

	-- Return the columns for a given table
	cursor table_columns_cur(cur_table_irid number)
	is
	select  col.irid,
            col.name,
            col.datatype,
            to_char(col.maximum_length) as dataLength,
            to_char(col.decimal_places) as dataPrecision,
            col.null_indicator,
            col.remark,
			col.sequence_number
      from  ci_table_definitions tab,
            ci_columns col
     where  col.table_reference = tab.irid
       and  tab.id = cur_table_irid
     order
        by  sequence_number;

	
	-- Return the constraints for a given table
    cursor table_constraints_cur (cur_table_irid VARCHAR2) is
    select  cons.irid,
            cons.constraint_type,
            cons.name,
            cons.check_constraint_type
      from  ci_table_definitions tab,
            ci_constraints cons
     where  cons.table_reference = tab.irid
       and  tab.irid = cur_table_irid
     order
        by  cons.name,
            cons.check_constraint_type;

	-- Return the coluns for a given constraint
    cursor constraint_columns_cur (cur_constraint_irid VARCHAR2) is
    select  col.irid,
            col.name,
            kc.sequence_number
      from  ci_columns col,
            ci_key_components kc,
            ci_constraints cons
     where  col.irid = kc.column_reference
       and  kc.constraint_reference = cons.irid
       and  cons.irid = cur_constraint_irid
     order
        by  kc.sequence_number;

	-- Return the attributes for a given entity
	cursor entity_attributes_cur(cur_entity_irid number)
	is
	select  attr.irid,
            attr.name,
            attr.format,
            to_char(attr.maximum_length) maximum_length,
            to_char(attr.precision) precision,
            attr.optional_flag,
            attr.notes,
			attr.sequence_number
      from  ci_entities ent,
            ci_attributes attr
     where  attr.entity_reference = ent.irid
       and  ent.irid = cur_entity_irid
     order
        by  attr.sequence_number;

	-- Return the relationship ends for a given entity
	cursor entity_relationship_ends_cur(cur_entity_irid number)
	is
	select  re.irid,
            re.name,
            re.minimum_cardinality,
            re.maximum_cardinality,
            oent.name 				to_entity_name,
            oent.plural 			to_entity_plural,
            re.remark
      from  ci_relationship_ends re,
	        ci_entities oent
     where  re.from_entity_reference = cur_entity_irid
       and  oent.irid = re.to_entity_reference;

	-- Return the indexes for a given table	
    cursor table_indexes_cur (cur_table_irid VARCHAR2) is
    select irid,
           name
      from ci_relation_indexes
     where table_definition_reference = cur_table_irid;

    cursor index_columns_cur (cur_index_irid VARCHAR2) is
    select col.irid,
           col.name,
           ie.sequence_number
      from ci_index_entries ie,
           ci_columns col
     where col.irid = ie.column_reference
       and ie.relation_index_reference = cur_index_irid
     order
        by ie.sequence_number;

	-- Return the number of times a column is used in a given
	-- constraint type
	cursor key_cur(cur_column_id VARCHAR2, cur_constraint_type VARCHAR2) is
    select count('x') as ref_count
      from ci_key_components kc,
           ci_constraints co,
           ci_columns c
     where co.irid = kc.constraint_reference
       and c.irid = kc.column_reference
       and co.constraint_type = cur_constraint_type
       and c.irid = cur_column_id;

	-- Return the table api data for a given table
	cursor table_apis_cur(cur_table_irid varchar2)
	is
	SELECT	al.al_source,
			al.al_target_location,
			al.al_evt_name,
			al.al_evt_short_description,
			rtl.txt_text,
			al.al_evt_seq_in_event
	  FROM	ck_application_logic al,
	  		ci_table_definitions td,
	        rm_text_lines rtl
	 WHERE	rtl.txt_ref 	= al.irid
	   AND  td.ivid			= rtl.parent_ivid
	   AND  rtl.txt_type	= 'ALCODE'
	   AND  td.irid			= cur_table_irid
     ORDER
	    BY	al.al_evt_name,
    		al.al_evt_seq_in_event;
	
	-- Display the workareas in the browser
	-- Utilizes 'get_workareas_xml'
	procedure display_workareas;
	
	-- Return a clob with the xml representation of all workareas
	-- in the current repository
	function get_workareas_xml
	return clob;
	
	-- Display the workareas and applications in the browser
	-- Utilizes 'get_workareas_and_apps_xml'
	procedure display_workareas_and_apps;
	
	-- Return a clob with the xml data of all workareas and applications
	-- in the current repository
	function get_workareas_and_apps_xml
	return clob;
	
	-- Return a clob containing the xml representation of a given workarea
	function get_workarea_xml(in_workarea_irid number)
	return clob;
	
	-- Display the xml data of the given folder in the browser
	-- Utilizes 'get_folder_xml'
	procedure display_folder_xml(in_folder_irid number);
	
	-- Return a clob containing the xml representation of a given folder
	-- Utilizes 'get_tables_xml'
	function get_folder_xml(in_folder_irid number)
	return clob;
	
	-- Display the xml_data for a given set of tables in the browser
	-- Utilizes 'get_tables_xml'
	procedure display_tables_xml(in_table_irids varchar2);
	
	-- Return a clob containing the xml representation of the set of
	-- tables identified by the irids in the 'in_table_irids' argument
	-- Utilizes 'get_table_columns_xml', 'get_table_constraints_xml',
	-- 'get_table_indexes_xml' and 'get_text'
	function get_tables_xml(in_table_irids varchar2)
	return clob;
	
	-- Returns a clob containing the xml representation of the columns
	-- in the given table
	-- Utilizes 'get_text'
	function get_table_columns_xml(in_table_irid number)
	return clob;
	
	-- Returns a clob containing the xml representation of the constraints
	-- in the given table
	-- Utilizes 'get_text'
	function get_table_constraints_xml(in_table_irid number)
	return clob;
	
	-- Returns a clob containing the xml representation of the indexes
	-- in the given table
	-- Utilizes 'get_text'
	function get_table_indexes_xml(in_table_irid number)
	return clob;
	
	-- Display the xml data for a given entity in the browser
	-- Utilizes 'get_entities_xml'
	procedure display_entities_xml(in_entity_irids varchar2);
	
	-- Returns a clob containing the xml representation of the given entity
	-- Utilizes 'get_entity_attributes_xml', 'get_entity_relationships_xml'
	-- and 'get_text'
	function get_entities_xml(in_entity_irids varchar2)
	return clob;
	
	-- Returns a clob containing the xml representation of the
	-- attributes of the given entity.
	-- Utilizes 'get_text'
	function get_entity_attributes_xml(in_entity_irid number)
	return clob;
	
	-- Returns a clob containing the xml representation of the
	-- relationship ends for a given entity
	function get_entity_relationships_xml(in_entity_irid number)
	return clob;
	
	-- Display the xml data for a given set of table apis in the
	-- browser.  Utilizes 'get_table_apis_xml'
	procedure display_tables_apis_xml(in_table_irids varchar2);
	
	-- Returns a clob containing the xml representation of the table
	-- apis for the given set of tables.
	-- Utilizes 'get_text'
	function get_tables_apis_xml(in_table_irids varchar2)
	return clob;
	
	-- Returns a clob containing the xml representation of the table
	-- apis for the given table
	function get_table_apis_xml(in_table_irid number)
	return clob;
	
		
	-- Returns a varchar2 containing the text stored in the designer
	-- repository for a given object(in_owner_irid) and text type(in_text_type)
	-- This is really just a thin wrapper over designer's rmotext.read_all function
	function get_text(in_owner_irid number,
					  in_text_type	varchar2)
	return varchar2;
	


    PROCEDURE prnt(in_message VARCHAR2)
    IS
                -- Program Data
                L_END_POS NUMBER(10, 0);
                L_MAX_LENGTH NUMBER(10, 0);
                L_MESSAGE_PART VARCHAR2(4000);
                L_POS NUMBER(10, 0);
    BEGIN
    
            l_pos := 0;
            l_max_length := 252;
            l_end_pos := l_pos + l_max_length;
        
            WHILE l_pos < length(IN_MESSAGE)
            LOOP
                    IF l_end_pos > length(IN_MESSAGE) THEN
                            l_max_length := length(IN_MESSAGE) - l_pos;
                    END IF;
        
                    l_message_part := chr(167) || substr(IN_MESSAGE, l_pos + 1, l_max_length) || chr(167);
        
                    dbms_output.put_line(l_message_part);
        
        
                    l_pos := l_end_pos;
                    l_end_pos := l_pos + l_max_length;
            END LOOP;
    END;
	
	procedure prnt(l_data clob)
	is
	    l_string_data           VARCHAR2(4000) CHARACTER SET l_data%CHARSET;
	    l_string_length         BINARY_INTEGER := 4000;
	    l_clob_length           INTEGER;
	    l_offset                INTEGER := 1;  
	begin
	    l_clob_length := dbms_lob.getlength(l_data);
	    
	    WHILE l_offset < l_clob_length LOOP
	        DBMS_LOB.READ(l_data, l_string_length, l_offset, l_string_data);
	        
	        prnt(l_string_data);
	        l_offset := l_offset + l_string_length;      
	    END LOOP;
	end;	
	/* To add a varchar2 to the end of a clob */
	PROCEDURE ADD_TO_CLOB
	 (IN_CLOB IN OUT CLOB
	 ,IN_STR IN VARCHAR2
	 )
	 is
	 begin
		 dbms_lob.writeappend(in_clob,
		                      length(in_str),
	                          in_str);
	 end;

	-- Display the workareas in the browser
	-- Utilizes 'get_workareas_xml'
	procedure display_workareas
	is
	begin
		owa_util.mime_header('text/xml');
		owa_util.http_header_close;
		
		--appl_html_pkg.display_in_browser(get_workareas_xml);
	exception
		when others then
			add_to_clob(l_xml_clob, '<error><source>DPD_REPORT_PKG.display_report_launcher_html</source><sqlerrm>' || sqlerrm || '</sqlerrm></error>' || chr(10));
			
			--appl_html_pkg.display_in_browser(l_xml_clob);
	end;
	
	
	-- Return a clob with the xml representation of all workareas
	-- in the current repository
	function get_workareas_xml
	return clob
	is
	begin
		dbms_lob.createTemporary(l_xml_clob,
                             true,
                             dbms_lob.session);

		add_to_clob(l_xml_clob, '<?xml version="1.0"?>' || chr(10));
		add_to_clob(l_xml_clob, '<?xml-stylesheet type="text/xsl" href="I:\DBFORUM\Designer\HTMLReports\reports.xsl"?>' || chr(10));

		add_to_clob(l_xml_clob, '<workareas>' || chr(10));
		
		for workarea_rec in workarea_cur loop
			dbms_lob.append(l_xml_clob,
							get_workarea_xml(workarea_rec.irid));
		end loop;
		
		add_to_clob(l_xml_clob, '</workareas>' || chr(10));
	end;
	
	
	-- Display the workareas and applications in the browser
	-- Utilizes 'get_workareas_and_apps_xml'
	procedure display_workareas_and_apps
	is
	begin
		owa_util.mime_header('text/xml');
		owa_util.http_header_close;
		
		--appl_html_pkg.display_in_browser(get_workareas_and_apps_xml);
	exception
		when others then
			add_to_clob(l_xml_clob, '<error><source>DPD_REPORT_PKG.display_report_launcher_html</source><sqlerrm>' || sqlerrm || '</sqlerrm></error>' || chr(10));
			
			--appl_html_pkg.display_in_browser(l_xml_clob);
	end;
	
	
	-- Return a clob with the xml data of all workareas and applications
	-- in the current repository
	function get_workareas_and_apps_xml
	return clob
	is
		l_xml_clob clob;
		l_prev_workarea_irid number := 0;
	begin
		dbms_lob.createTemporary(l_xml_clob,
                             true,
                             dbms_lob.session);

		add_to_clob(l_xml_clob, '<?xml version="1.0"?>' || chr(10));
		add_to_clob(l_xml_clob, '<?xml-stylesheet type="text/xsl" href="http://indsun2.medispan.com/dpdReports/Reports.xsl"?>' || chr(10));

		add_to_clob(l_xml_clob, '<workareas>' || chr(10));
		
		for workareas_and_apps_rec in workareas_and_apps_cur loop
			if workareas_and_apps_rec.workarea_irid != l_prev_workarea_irid then
				if l_prev_workarea_irid = 0 then
					add_to_clob(l_xml_clob,
											  '	<workarea irid = "' || workareas_and_apps_rec.workarea_irid ||
											  '" name="' || workareas_and_apps_rec.workarea_name ||
											  '">' || chr(10));
				else
					add_to_clob(l_xml_clob,
											  '	</workarea>' || chr(10));
					add_to_clob(l_xml_clob,
											  '	<workarea irid = "' || workareas_and_apps_rec.workarea_irid ||
											  '" name="' || workareas_and_apps_rec.workarea_name ||
											  '">' || chr(10));
				end if;
			end if;
			
			add_to_clob(l_xml_clob, '		<application irid = "' || workareas_and_apps_rec.application_irid || '" name="' || workareas_and_apps_rec.application_name || '"/>' || chr(10));				
			
			l_prev_workarea_irid := workareas_and_apps_rec.workarea_irid;
		end loop;
		
		add_to_clob(l_xml_clob, '	</workarea>' || chr(10) || '</workareas>' || chr(10));
		
		return l_xml_clob;
	end;
	
	-- Return a clob containing the xml representation of a given workarea
	function get_workarea_xml(in_workarea_irid number)
	return clob
	is
		l_xml_clob clob;
		l_workarea_name sdd_workareas.name%type;
	begin
		dbms_lob.createTemporary(l_xml_clob,
                             true,
                             dbms_lob.session);
                             
 		select name
 		  into l_workarea_name
 		  from sdd_workareas
	     where irid = in_workarea_irid;

		add_to_clob(l_xml_clob,
								  '	<workarea irid = "' || in_workarea_irid ||
								  '" name="' || l_workarea_name ||
								  '">' || chr(10));


		add_to_clob(l_xml_clob,
								  '<folders>' || chr(10));
								  
		for workarea_folders_rec in workarea_folders_cur(in_workarea_irid) loop
			dbms_lob.append(l_xml_clob,
							get_folder_xml(workarea_folders_rec.folder_irid));
		end loop;

		add_to_clob(l_xml_clob,
								  '</folders>' || chr(10));
								  

		add_to_clob(l_xml_clob,
								  '</workarea>' || chr(10));
		return l_xml_clob;
	exception
		when others then
			return l_xml_clob;
	end;
	
	-- Display the xml data of the given folder in the browser
	-- Utilizes 'get_folder_xml'
	procedure display_folder_xml(in_folder_irid number)
	is
	begin
		owa_util.mime_header('text/xml');
		owa_util.http_header_close;

		--appl_html_pkg.display_in_browser(get_folder_xml(in_folder_irid));
	end;
	

	-- Return a clob containing the xml representation of a given folder
	-- Utilizes 'get_tables_xml'
	function get_folder_xml(in_folder_irid number)
	return clob
	is
		l_xml_clob clob;
		l_folder_name sdd_folders.name%type;
	begin
		dbms_lob.createTemporary(l_xml_clob,
                             true,
                             dbms_lob.session);

 		select name
 		  into l_folder_name
 		  from sdd_folders
	     where irid = in_folder_irid;
	     
		add_to_clob(l_xml_clob, '	<folder irid = "' || in_folder_irid || '" name="' || l_folder_name || '">' || chr(10));


		add_to_clob(l_xml_clob, '		<tables>' || chr(10));
     	for folder_table_rec in folder_tables_cur(in_folder_irid) loop
 			add_to_clob(l_xml_clob, '			<table irid="' || folder_table_rec.table_irid || '" ivid="' || folder_table_rec.table_ivid || '" name="' || folder_table_rec.table_name || '"/>' || chr(10));    		
     	end loop;
		add_to_clob(l_xml_clob, '		</tables>' || chr(10));

		add_to_clob(l_xml_clob, '		<entities>' || chr(10));
     	for entity_rec in folder_entities_cur(in_folder_irid) loop
 			add_to_clob(l_xml_clob, '			<entity irid="' || entity_rec.irid || '" ivid="' || entity_rec.ivid || '" name="' || entity_rec.name || '"/>' || chr(10));    		
     	end loop;
		add_to_clob(l_xml_clob, '		</entities>' || chr(10));

		add_to_clob(l_xml_clob, '	</folder>' || chr(10));

		return l_xml_clob;
	exception
		when others then
			return l_xml_clob;
	end;
	

	-- Display the xml_data for a given set of tables in the browser
	-- Utilizes 'get_tables_xml'
	procedure display_tables_xml(in_table_irids varchar2)
	is
	begin
		owa_util.mime_header('text/xml');
		owa_util.http_header_close;

		--appl_html_pkg.display_in_browser(get_tables_xml(in_table_irids));
	end;
	

	-- Return a clob containing the xml representation of the set of
	-- tables identified by the irids in the 'in_table_irids' argument
	-- Utilizes 'get_table_columns_xml', 'get_table_constraints_xml',
	-- 'get_table_indexes_xml' and 'get_text'
	function get_tables_xml(in_table_irids varchar2)
	return clob
	is	
	   tables_cur   ref_cur_type;  -- declare cursor variable
	
	   selectString 				varchar2(4000);
	
	   l_tab_irid 					number;
	   l_tab_name 					varchar2(32);
	
	   l_tmp_str					varchar2(32767);
	   l_xml_clob clob;
	begin
		dbms_lob.createTemporary(l_xml_clob,
                                 true,
                                 dbms_lob.session);

		selectString := 'select 	tab.irid				table_irid, ' || chr(10) ||
						'           tab.name				table_name' || chr(10) ||
						'  from 	ci_table_definitions 	tab,' || chr(10) ||
						'			sdd_folder_members 		mem,' || chr(10) ||
						'			sdd_folders 			fld' || chr(10) ||
						' where 	mem.member_object		= tab.irid' || chr(10) ||
						'   and  mem.folder_reference	= fld.irid' || chr(10) ||
						'   and  mem.ownership_flag 		= ''Y''' || chr(10) ||
						'   and  tab.irid				in(' || in_table_irids ||')' || chr(10) ||
						' order' || chr(10) ||
						'    by  tab.name';
	
		add_to_clob(l_xml_clob, '<tables>' || chr(10));

		begin
			open tables_cur for selectString;
			loop
			   fetch tables_cur into l_tab_irid, l_tab_name;
			   exit when tables_cur%notfound;
				add_to_clob(l_xml_clob, '<table irid="' || l_tab_irid || '" name="' || l_tab_name || '">');
				
	    		l_tmp_str := chr(9) || chr(9) || '<description>';
	            l_tmp_str := l_tmp_str || chr(9) || chr(9) || chr(9) || '<line>';
	            l_tmp_str := l_tmp_str || '<![CDATA[';
	            add_to_clob(l_xml_clob, l_tmp_str);
	
	            add_to_clob(l_xml_clob, nvl(get_text(l_tab_irid, 'CDISC'), 'N/A'));
	
	            l_tmp_str := ']]>';
	            l_tmp_str := l_tmp_str || chr(9) || chr(9) || chr(9) || '</line>';
	            l_tmp_str := l_tmp_str || chr(9) || chr(9) || '</description>';
				add_to_clob(l_xml_clob, l_tmp_str);
	
	            l_tmp_str := '';
	            l_tmp_str := l_tmp_str || chr(9) || chr(9) || '<deployment>' || chr(10)
	            			           || chr(9) || chr(9) || chr(9) || '<line>' || chr(39) || 'WIP' || chr(39) || ' schema:FAC tablespace: WIP_DATA</line>' || chr(10)
	                                   || chr(9) || chr(9) || chr(9) || '<line>_CH schema:FAC tablespace:CH_DATA</line>' || chr(10)
				                       || chr(9) || chr(9) || chr(9) || '<line>_OF schema:OFL tablespace: OFL_DATA</line>' || chr(10)
			                           || chr(9) || chr(9) || '</deployment>' || chr(10);
	            add_to_clob(l_xml_clob, l_tmp_str);
	
	
	
				add_to_clob(l_xml_clob, get_table_columns_xml(l_tab_irid));						
				add_to_clob(l_xml_clob, get_table_constraints_xml(l_tab_irid));					
				add_to_clob(l_xml_clob, get_table_indexes_xml(l_tab_irid));
	
	            add_to_clob(l_xml_clob, chr(9) || chr(9) || '<notes>' || chr(10));
	            add_to_clob(l_xml_clob, nvl(get_text(l_tab_irid, 'CDINOT'), 'N/A'));
	            add_to_clob(l_xml_clob, chr(9) || chr(9) || '</notes>' || chr(10));
				
				add_to_clob(l_xml_clob, '</table>');		
			
			end loop;
			close tables_cur;
		exception
			when others then
				add_to_clob(l_xml_clob, sqlerrm);
		end;

		add_to_clob(l_xml_clob, '		</tables>' || chr(10));

		return l_xml_clob;
	end;

	-- Returns a clob containing the xml representation of the columns
	-- in the given table
	-- Utilizes 'get_text'
	function get_table_columns_xml(in_table_irid number)
	return clob
	is
		l_xml_clob 	clob;
	    pk 			varchar2(1);
	    uk 			varchar2(1);
	    nl 			varchar2(1);
	
		num_unique 	integer;
		num_primary integer;
	begin
		dbms_lob.createTemporary(l_xml_clob,
                                 true,
                                 dbms_lob.session);

		add_to_clob(l_xml_clob, '<columns>' || chr(10));

		for column_rec in table_columns_cur(in_table_irid) loop
			add_to_clob(l_xml_clob, '<column irid="' || column_rec.irid || '" name="' || column_rec.name || '">');
			add_to_clob(l_xml_clob, '<name>' || column_rec.name || '</name>' || chr(10));

            add_to_clob(l_xml_clob, chr(9) || chr(9) || chr(9) || chr(9) || '<description>');
            add_to_clob(l_xml_clob, '<![CDATA[');
   			add_to_clob(l_xml_clob, nvl(get_text(column_rec.irid, 'CDIDSC'), 'N/A'));
            add_to_clob(l_xml_clob, ']]>');
            add_to_clob(l_xml_clob, '</description>' || chr(10));



            OPEN key_cur(column_rec.irid, 'PRIMARY');
            FETCH key_cur INTO num_primary;
            IF num_primary = 0 THEN
                pk := 'N';
            ELSE
                pk := 'Y';
            END IF;

            num_primary := 0;
            close key_cur;

            OPEN key_cur(column_rec.irid, 'UNIQUE');
            FETCH key_cur INTO num_primary;
            IF num_unique = 0 THEN
                uk := 'N';
            ELSE
                uk := 'Y';
            END IF;

            num_unique := 0;
            close key_cur;

            IF column_rec.null_indicator = 'NOT NULL' THEN
                nl := 'N';
            ELSE
                nl := 'Y';
            END IF;

            add_to_clob(l_xml_clob, chr(9) || chr(9) || chr(9) || chr(9) || '<dataType>' || nvl(column_rec.dataType, 'N/A') || '</dataType>' || chr(10));
            add_to_clob(l_xml_clob, chr(9) || chr(9) || chr(9) || chr(9) || '<dataLength>' || nvl(column_rec.dataLength, 'N/A') || '</dataLength>' || chr(10));

            add_to_clob(l_xml_clob, chr(9) || chr(9) || chr(9) || chr(9) || '<dataPrecision>' || nvl(column_rec.dataPrecision, 'N/A') || '</dataPrecision>' || chr(10));
            add_to_clob(l_xml_clob, chr(9) || chr(9) || chr(9) || chr(9) || '<key>' || pk || '</key>' || chr(10));

            add_to_clob(l_xml_clob, chr(9) || chr(9) || chr(9) || chr(9) || '<unique>' || uk || '</unique>' || chr(10));
            add_to_clob(l_xml_clob, chr(9) || chr(9) || chr(9) || chr(9) || '<null>' || nvl(nl, 'N/A') || '</null>' || chr(10));
            add_to_clob(l_xml_clob, chr(9) || chr(9) || chr(9) || chr(9) || '<notes>' || nvl(get_text(column_rec.irid, 'CDINOT'), 'N/A') || chr(10) || column_rec.remark || '</notes>' || chr(10));

			add_to_clob(l_xml_clob, '</column>');		
		end loop;


		add_to_clob(l_xml_clob, chr(9) || chr(9) || chr(9) || '<line>_CH schema:FAC tablespace:CH_DATA</line>' || chr(10));
		add_to_clob(l_xml_clob, chr(9) || chr(9) || chr(9) || '<line>_OF schema:OFL tablespace: OFL_DATA</line>' || chr(10));
		
		add_to_clob(l_xml_clob, '</columns>' || chr(10));

		return l_xml_clob;

	end;
	
	-- Returns a clob containing the xml representation of the constraints
	-- in the given table
	-- Utilizes 'get_text'
	function get_table_constraints_xml(in_table_irid number)
	return clob
	is
		l_xml_clob		clob;
	begin
		dbms_lob.createTemporary(l_xml_clob,
                                 true,
                                 dbms_lob.session);

		add_to_clob(l_xml_clob, '<constraints>' || chr(10));
								
	    FOR cons_rec in table_constraints_cur(in_table_irid) LOOP
	        add_to_clob(l_xml_clob, chr(9) || chr(9) || chr(9) || '<constraint>' || chr(10));
	
			add_to_clob(l_xml_clob, chr(9) || chr(9) || chr(9) || chr(9) || '<name>' || cons_rec.name || '</name>' || chr(10));

	        add_to_clob(l_xml_clob,chr(9) || chr(9) || chr(9) || chr(9) || '<constraint_type>' || nvl(cons_rec.constraint_type, 'N/A') || '</constraint_type>' || chr(10));
	        add_to_clob(l_xml_clob,chr(9) || chr(9) || chr(9) || chr(9) || '<check_constraint_type>' || nvl(cons_rec.check_constraint_type, 'N/A') || '</check_constraint_type>' || chr(10));
	
	        -- Constraint Columns
	        add_to_clob(l_xml_clob,chr(9) || chr(9) || chr(9) || chr(9) || '<cons_columns>' || chr(10));
	
	        FOR cons_col_rec in constraint_columns_cur(cons_rec.irid) LOOP
	            add_to_clob(l_xml_clob,chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<cons_column>' || chr(10));
	            add_to_clob(l_xml_clob,chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<column_name>' || cons_col_rec.name || '</column_name>' || chr(10));
	            add_to_clob(l_xml_clob,chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '</cons_column>' || chr(10));
	        END LOOP;
	
			add_to_clob(l_xml_clob,chr(9) || chr(9) || chr(9) || chr(9) || '</cons_columns>' || chr(10));
	        -- End Constraint Columns
	
	        add_to_clob(l_xml_clob,chr(9) || chr(9) || chr(9) || '</constraint>' || chr(10));
	    END LOOP;
	
		add_to_clob(l_xml_clob,chr(9) || chr(9) || '</constraints>' || chr(10));
	    -- End Constraints

		return l_xml_clob;
	end;	

	-- Returns a clob containing the xml representation of the indexes
	-- in the given table
	-- Utilizes 'get_text'
	function get_table_indexes_xml(in_table_irid number)
	return clob
	is
		l_xml_clob		clob;
	begin
		dbms_lob.createTemporary(l_xml_clob,
                                 true,
                                 dbms_lob.session);

		add_to_clob(l_xml_clob, '<indexes>' || chr(10));
								
	    FOR index_rec in table_indexes_cur(in_table_irid) LOOP
	        add_to_clob(l_xml_clob, chr(9) || chr(9) || chr(9) || '<index>' || chr(10));
	
			add_to_clob(l_xml_clob, chr(9) || chr(9) || chr(9) || chr(9) || '<name>' || index_rec.name || '</name>' || chr(10));
	
	        -- Constraint Columns
	        add_to_clob(l_xml_clob,chr(9) || chr(9) || chr(9) || chr(9) || '<cons_columns>' || chr(10));
	
	        FOR index_col_rec in index_columns_cur(index_rec.irid) LOOP
	            add_to_clob(l_xml_clob,chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<index_column>' || chr(10));
	            add_to_clob(l_xml_clob,chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<column_name>' || index_col_rec.name || '</column_name>' || chr(10));
	            add_to_clob(l_xml_clob,chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '</index_column>' || chr(10));
	        END LOOP;
	
			add_to_clob(l_xml_clob,chr(9) || chr(9) || chr(9) || chr(9) || '</cons_columns>' || chr(10));
	        -- End Constraint Columns
	
	        add_to_clob(l_xml_clob,chr(9) || chr(9) || chr(9) || '</index>' || chr(10));
	    END LOOP;
	
		add_to_clob(l_xml_clob,chr(9) || chr(9) || '</indexes>' || chr(10));
	    -- End Constraints

		return l_xml_clob;
	end;	


	-- Display the xml_data for a given entity in the browser
	-- Utilizes 'get_entities_xml'
	procedure display_entities_xml(in_entity_irids varchar2)
	is
	begin
		owa_util.mime_header('text/xml');
		owa_util.http_header_close;

		--appl_html_pkg.display_in_browser(get_entities_xml(in_entity_irids));
	end;
	

	-- Returns a clob containing the xml representation of the given entity
	-- Utilizes 'get_entity_attributes_xml', 'get_entity_relationships_xml'
	-- and 'get_text'
	function get_entities_xml(in_entity_irids varchar2)
	return clob
	is	
	   entities_cur   ref_cur_type;  -- declare cursor variable
	   
	   selectString 				varchar2(4000);
	   
	   l_entity_irid 					number;
	   l_entity_name 					varchar2(32);
	   
	   l_tmp_str					varchar2(32767);
	   l_xml_clob clob;
	begin
		dbms_lob.createTemporary(l_xml_clob,
                                 true,
                                 dbms_lob.session);

		selectString := 'select 	ent.irid, ' || chr(10) ||
						'           ent.name' || chr(10) ||
						'  from 	ci_entities 			ent,' || chr(10) ||
						'			sdd_folder_members 		mem,' || chr(10) ||
						'			sdd_folders 			fld' || chr(10) ||
						' where 	mem.member_object		= ent.irid' || chr(10) ||
						'   and  	mem.folder_reference	= fld.irid' || chr(10) ||
						'   and  	mem.ownership_flag 		= ''Y''' || chr(10) ||
						'   and  	ent.irid				in(' || in_entity_irids ||')' || chr(10) ||
						' order' || chr(10) ||
						'    by  	ent.name';
	
		add_to_clob(l_xml_clob, '<entities>' || chr(10));

				prnt(selectString);
		begin
			open entities_cur for selectString;
			loop
			   fetch entities_cur into l_entity_irid, l_entity_name;
			   exit when entities_cur%notfound;
				add_to_clob(l_xml_clob, '<entity irid="' || l_entity_irid || '" name="' || l_entity_name || '">');
				
	    		l_tmp_str := chr(9) || chr(9) || '<description>';
	            l_tmp_str := l_tmp_str || chr(9) || chr(9) || chr(9) || '<line>';
	            l_tmp_str := l_tmp_str || '<![CDATA[';
	            add_to_clob(l_xml_clob, l_tmp_str);
	
	            add_to_clob(l_xml_clob, nvl(get_text(l_entity_irid, 'CDISC'), 'N/A'));
	
	            l_tmp_str := ']]>';
	            l_tmp_str := l_tmp_str || chr(9) || chr(9) || chr(9) || '</line>';
	            l_tmp_str := l_tmp_str || chr(9) || chr(9) || '</description>';
				add_to_clob(l_xml_clob, l_tmp_str);
	
				add_to_clob(l_xml_clob, get_entity_attributes_xml(l_entity_irid));						
				add_to_clob(l_xml_clob, get_entity_relationships_xml(l_entity_irid));						

	            add_to_clob(l_xml_clob, chr(9) || chr(9) || '<notes>' || chr(10));
	            add_to_clob(l_xml_clob, nvl(get_text(l_entity_irid, 'CDINOT'), 'N/A'));
	            add_to_clob(l_xml_clob, chr(9) || chr(9) || '</notes>' || chr(10));
				
				add_to_clob(l_xml_clob, '</entity>');		
			
			end loop;
			close entities_cur;
		exception
			when others then
				add_to_clob(l_xml_clob, sqlerrm);
		end;

		add_to_clob(l_xml_clob, '		</entities>' || chr(10));

		return l_xml_clob;
	end;
	
	-- Returns a clob containing the xml representation of the
	-- attributes of the given entity.
	-- Utilizes 'get_text'
	function get_entity_attributes_xml(in_entity_irid number)
	return clob
	is
		l_xml_clob 	clob;
	    pk 			varchar2(1)		:= 'N';
	    uk 			varchar2(1)		:= 'N';
	    nl 			varchar2(1)		:= 'N';
	
		num_unique 	integer;
		num_primary integer;
	begin
		dbms_lob.createTemporary(l_xml_clob,
                                 true,
                                 dbms_lob.session);

		add_to_clob(l_xml_clob, '<attributes>' || chr(10));

		for attribute_rec in entity_attributes_cur(in_entity_irid) loop
			add_to_clob(l_xml_clob, '<attribute irid="' || attribute_rec.irid || '" name="' || attribute_rec.name || '">');
			add_to_clob(l_xml_clob, '<name>' || attribute_rec.name || '</name>' || chr(10));

            add_to_clob(l_xml_clob, chr(9) || chr(9) || chr(9) || chr(9) || '<description>');
            add_to_clob(l_xml_clob, '<![CDATA[');
   			add_to_clob(l_xml_clob, nvl(get_text(attribute_rec.irid, 'CDIDSC'), 'N/A'));
            add_to_clob(l_xml_clob, ']]>');
            add_to_clob(l_xml_clob, '</description>' || chr(10));

			select 	count(*)
			  into 	num_primary
			  from 	ci_unique_identifiers ui,
			  		ci_unique_identifier_entries uie
	  		 where	ui.irid = uie.unique_identifier_reference
	  		   and	uie.attribute_reference = attribute_rec.irid;
	  		   
 		   	if num_primary > 0 then
	   			pk := 'Y';
   			end if;
   			num_primary := 0;
   			pk := 'N';

			select count(*)
			  into num_unique
			  from ci_unique_identifier_entries
	         where attribute_reference = attribute_rec.irid;
     		
     		if num_unique > 0 then
     			uk := 'Y';
  			end if;
  			num_unique := 0;
  			uk := 'N';

            add_to_clob(l_xml_clob, chr(9) || chr(9) || chr(9) || chr(9) || '<format>' || to_char(nvl(attribute_rec.format, 'N/A')) || '</format>' || chr(10));
            add_to_clob(l_xml_clob, chr(9) || chr(9) || chr(9) || chr(9) || '<maximum_length>' || to_char(nvl(attribute_rec.maximum_length, 'N/A')) || '</maximum_length>' || chr(10));

            add_to_clob(l_xml_clob, chr(9) || chr(9) || chr(9) || chr(9) || '<precision>' || nvl(attribute_rec.precision, 'N/A') || '</precision>' || chr(10));

            add_to_clob(l_xml_clob, chr(9) || chr(9) || chr(9) || chr(9) || '<key>' || pk || '</key>' || chr(10));

            add_to_clob(l_xml_clob, chr(9) || chr(9) || chr(9) || chr(9) || '<unique>' || uk || '</unique>' || chr(10));
            add_to_clob(l_xml_clob, chr(9) || chr(9) || chr(9) || chr(9) || '<optional>' || nvl(attribute_rec.optional_flag, 'N/A') || '</optional>' || chr(10));

            add_to_clob(l_xml_clob, chr(9) || chr(9) || chr(9) || chr(9) || '<notes>' || nvl(get_text(attribute_rec.irid, 'CDINOT'), 'N/A') || chr(10) || nvl(attribute_rec.notes, '') || '</notes>' || chr(10));

			add_to_clob(l_xml_clob, '</attribute>');		
		end loop;

		add_to_clob(l_xml_clob, '</attributes>' || chr(10));

		return l_xml_clob;

	end;
	
	-- Returns a clob containing the xml representation of the
	-- relationship ends for a given entity
	function get_entity_relationships_xml(in_entity_irid number)
	return clob
	is
		l_xml_clob 	clob;
	begin
		dbms_lob.createTemporary(l_xml_clob,
                                 true,
                                 dbms_lob.session);

		add_to_clob(l_xml_clob, '<relationships>' || chr(10));

		for relationship_rec in entity_relationship_ends_cur(in_entity_irid) loop
			add_to_clob(l_xml_clob, '<relationship irid="' || relationship_rec.irid || '" name="' || relationship_rec.name || '">');
			add_to_clob(l_xml_clob, '<name>' || relationship_rec.name || '</name>' || chr(10));
			add_to_clob(l_xml_clob, '<minimum_cardinality>' || relationship_rec.minimum_cardinality || '</minimum_cardinality>' || chr(10));
			add_to_clob(l_xml_clob, '<maximum_cardinality>' || relationship_rec.maximum_cardinality || '</maximum_cardinality>' || chr(10));
			add_to_clob(l_xml_clob, '<to_entity_name>' || relationship_rec.to_entity_name || '</to_entity_name>' || chr(10));
			add_to_clob(l_xml_clob, '<to_entity_plural>' || relationship_rec.to_entity_plural || '</to_entity_plural>' || chr(10));

            add_to_clob(l_xml_clob, chr(9) || chr(9) || chr(9) || chr(9) || '<description>');
            add_to_clob(l_xml_clob, '<![CDATA[');
   			add_to_clob(l_xml_clob, nvl(get_text(relationship_rec.irid, 'CDIDSC'), 'N/A'));
            add_to_clob(l_xml_clob, ']]>');
            add_to_clob(l_xml_clob, '</description>' || chr(10));

 
            add_to_clob(l_xml_clob, chr(9) || chr(9) || chr(9) || chr(9) || '<remark>' || relationship_rec.remark || '</remark>' || chr(10));
            add_to_clob(l_xml_clob, chr(9) || chr(9) || chr(9) || chr(9) || '<notes>' || nvl(get_text(relationship_rec.irid, 'CDINOT'), 'N/A') || '</notes>' || chr(10));

			add_to_clob(l_xml_clob, '</relationship>');		
		end loop;

		add_to_clob(l_xml_clob, '</relationships>' || chr(10));

		return l_xml_clob;

	end;

	-- Display the xml data for a given set of table apis in the
	-- browser.  Utilizes 'get_table_apis_xml'
	procedure display_tables_apis_xml(in_table_irids varchar2)
	is
	begin
		owa_util.mime_header('text/xml');
		owa_util.http_header_close;

		--appl_html_pkg.display_in_browser(get_table_apis_xml(in_table_irids));
	end;
	
	-- Returns a clob containing the xml representation of the table
	-- apis for the given set of tables.
	-- Utilizes 'get_text'
	function get_tables_apis_xml(in_table_irids varchar2)
	return clob
	is
	   tables_cur   ref_cur_type;  -- declare cursor variable
	
	   selectString 				varchar2(4000);
	
	   l_tab_irid 					number;
	   l_tab_name 					varchar2(32);
	
	   l_tmp_str					varchar2(32767);
	   l_xml_clob clob;
	begin
		dbms_lob.createTemporary(l_xml_clob,
                                 true,
                                 dbms_lob.session);

		selectString := 'select 	tab.irid				table_irid, ' || chr(10) ||
						'           tab.name				table_name' || chr(10) ||
						'  from 	ci_table_definitions 	tab,' || chr(10) ||
						'			sdd_folder_members 		mem,' || chr(10) ||
						'			sdd_folders 			fld' || chr(10) ||
						' where 	mem.member_object		= tab.irid' || chr(10) ||
						'   and  mem.folder_reference	= fld.irid' || chr(10) ||
						'   and  mem.ownership_flag 		= ''Y''' || chr(10) ||
						'   and  tab.irid				in(' || in_table_irids ||')' || chr(10) ||
						' order' || chr(10) ||
						'    by  tab.name';
	
		add_to_clob(l_xml_clob, '<tables>' || chr(10));

		begin
			open tables_cur for selectString;
			loop
			   fetch tables_cur into l_tab_irid, l_tab_name;
			   exit when tables_cur%notfound;
				add_to_clob(l_xml_clob, '<table irid="' || l_tab_irid || '" name="' || l_tab_name || '">');
				
				add_to_clob(l_xml_clob, get_table_apis_xml(l_tab_irid));
	
				add_to_clob(l_xml_clob, '</table>');		
			
			end loop;
			close tables_cur;
		exception
			when others then
				add_to_clob(l_xml_clob, sqlerrm);
		end;

		add_to_clob(l_xml_clob, '		</tables>' || chr(10));

		return l_xml_clob;
	end;
	
	
	-- Returns a clob containing the xml representation of the table
	-- apis for the given table
	function get_table_apis_xml(in_table_irid number)
	return clob
	is
		l_xml_clob 	clob;
		
		l_prev_evt_name varchar2(60) := '';
	begin
		dbms_lob.createTemporary(l_xml_clob,
                                 true,
                                 dbms_lob.session);

		add_to_clob(l_xml_clob, '<api>' || chr(10));

		for api_rec in table_apis_cur(in_table_irid) loop
			if l_prev_evt_name != api_rec.al_evt_name then
				if l_prev_evt_name = '' then
					add_to_clob(l_xml_clob,
											  '	<event name = "' || api_rec.al_evt_name ||
											  '">' || chr(10));
				else
					add_to_clob(l_xml_clob,
											  '	</event>' || chr(10));
					add_to_clob(l_xml_clob,
											  '	<event name = "' || api_rec.al_evt_name ||
											  '">' || chr(10));
				end if;				
			end if;

			add_to_clob(l_xml_clob, '		<event_block short_description="' || api_rec.al_evt_short_description || '" >' || chr(10));				
            add_to_clob(l_xml_clob, '<![CDATA[');
			add_to_clob(l_xml_clob, api_rec.txt_text || chr(10));				
            add_to_clob(l_xml_clob, ']]>');
			add_to_clob(l_xml_clob, '		</event_block>' || chr(10));				

			l_prev_evt_name := api_rec.al_evt_name;			
		end loop;

		add_to_clob(l_xml_clob, '</api>' || chr(10));

		return l_xml_clob;

	end;
	
		
	-- Returns a varchar2 containing the text stored in the designer
	-- repository for a given object(in_owner_irid) and text type(in_text_type)
	-- This is really just a thin wrapper over designer's rmotext.read_all function
	function get_text(in_owner_irid number,
					  in_text_type	varchar2)
	return varchar2
	is
		l_max_text_length			integer		:= 32767;
		l_returned_text_length		integer;
		l_text						varchar2(32767);
	begin
		rmotext.readall(in_owner_irid,
						in_text_type,
						l_text,
						l_max_text_length,
						l_returned_text_length);
						
		return l_text;
	end;

BEGIN
	-- Main
	dbms_lob.createTemporary(l_xml_clob,
                         true,
                         dbms_lob.session);
	
	l_entity_irids := '';
	for ent_irid_rec in entity_irids_cur('PACE') loop
		l_entity_irids := l_entity_irids || ent_irid_rec.irid || ', ';
	end loop;
	
	l_entity_irids := substr(l_entity_irids,
							 1,
							 length(l_entity_irids) -2);
							 
	add_to_clob(l_xml_clob, get_entities_xml(l_entity_irids));
	
	prnt(l_xml_clob);
END;
