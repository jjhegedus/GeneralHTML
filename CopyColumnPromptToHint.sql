-- set environment variables
set serveroutput on size 1000000
set lines 10000
set long 10000
set linesize 150

DECLARE
	errStr VARCHAR2(2000) := '';
	genericError EXCEPTION;
	app_name ci_application_systems.name%TYPE;
	
	repositoryInitialized BOOLEAN;
	act_status	cdapi.activity_status%TYPE;
	act_warnings	cdapi.activity_warnings%TYPE;
	
	debug_mode BOOLEAN := TRUE;
	
     CURSOR app_col_cur IS
        select  tab1.name as tableName,
                col.name as columnName,
                col.irid as columnId
          from  ci_columns col,
                ci_table_definitions tab1,
                sdd_folder_members mem,
                sdd_folders fld 
         where  mem.member_object=tab1.irid 
           and  mem.folder_reference=fld.irid 
           and  mem.ownership_flag = 'Y' 
           and  col.table_reference = tab1.irid
           and  fld.name = 'XML Utilities'
         order
            by  tab1.name, col.sequence_number;
            
	PROCEDURE output_big_string(str IN VARCHAR2)
		IS
			pos NUMBER(10);
			endPos NUMBER(10);
			replLength NUMBER(10);
		BEGIN
			pos := 1;
			endPos := pos + 254;
			replLength := 255;
			
			WHILE pos < length(str)
			LOOP
				IF endPos > length(str) THEN
					replLength := length(str) - pos + 1;
				END IF;
				
				dbms_output.put_line(substr(str, pos, replLength));
				
				pos := endPos + 1;
				endPos := pos + 254;
				replLength := 255;
			END LOOP;
		EXCEPTION
			WHEN OTHERS THEN
				dbms_output.put_line('Error in output_big_string');
				dbms_output.put_line('ERROR:CODE: ' || SQLCODE || ':' || SQLERRM);
				RAISE genericError;
		END;
		
	PROCEDURE display_d2k_errors
		IS
			-- Local Variables
			CURSOR errors_cur IS
				SELECT *
				  FROM ci_violations;
		BEGIN
			-- first get the error information
			FOR error_rec IN errors_cur
			LOOP
				output_big_string(cdapi.instantiate_message(
					error_rec.facility, error_rec.code, error_rec.p0, error_rec.p1, error_rec.p2,
					error_rec.p3, error_rec.p4, error_rec.p5, error_rec.p6, error_rec.p7));
			END LOOP;
			
			-- then get the warnings
			WHILE cdapi.stacksize > 0 LOOP
				output_big_string('ERROR:' || cdapi.pop_instantiated_message);
			END LOOP;
			
			CLOSE errors_cur;
		EXCEPTION
			WHEN OTHERS THEN
				RAISE;
		END;
		
	PROCEDURE process_error(fatal IN BOOLEAN := false)
		IS
		BEGIN
			errStr := errStr || 'ERROR:CODE: ' || SQLCODE || ':' || SQLERRM;
			errStr := 'ERROR:' || chr(10) || errStr;
			
			output_big_string(errStr);
			errStr := ' ';
			
			display_d2k_errors();
			
			IF fatal THEN
				output_big_string('Fatal error encountered');
				RAISE genericError; -- raise an error to test error handling
			END IF;
		EXCEPTION
			WHEN OTHERS THEN
				output_big_string(SQLCODE || ':' || SQLERRM);
				IF fatal THEN
					RAISE genericError;
				END IF;
		END;
	
	
	FUNCTION smartReplace(string_buf in VARCHAR2, searchString in VARCHAR2, replaceString in VARCHAR2) RETURN VARCHAR2
		IS
			-- Local Variables
			procName VARCHAR2(100);
			
			upper_string_buf VARCHAR2(2000);
			upper_searchString VARCHAR2(2000);
			upper_replaceString VARCHAR2(2000);
			x NUMBER(2);
			result VARCHAR2(2000);

			position NUMBER;
		BEGIN
			-- set the procedure name and parameter info for debugging information
			procName := 'smartReplace';
			errStr := errStr || chr(10) || '***** ' || procName || ' *********' || chr(10);
			errStr := errStr || 'string_buf: ' || string_buf || chr(10);
			errStr := errStr || 'searchString: ' || searchString || chr(10);
			errStr := errStr || 'replaceString: ' || replaceString || chr(10);

			result := string_buf;
			upper_string_buf := upper(string_buf);
			upper_searchString := upper(searchString);
			upper_replaceString := upper(replaceString);
			position := instr(upper_string_buf, upper_searchString);

			x := 0;
			WHILE (position > 0)  AND (x < 10) LOOP
				x := x + 1;
				result := substr(result, 1, position - 1) || replaceString || substr(result, position + length(replaceString) - 1, length(result));				

				upper_string_buf := upper(result);
				position := instr(upper_string_buf, upper_searchString, (position + length(replaceString) - 1));
				--errStr := errStr || 'position:' || position || chr(10);
			END LOOP;

			--errStr := errStr || 'result:' || result || chr(10);
			--errStr := errStr || 'x:' || x || chr(10);
			return result;			
			
			IF debug_mode THEN
				output_big_string(errStr);
				errStr := '';
			END IF;
		EXCEPTION	
			WHEN OTHERS THEN
				process_error(true); -- optional parameter indicating fatality
		END;

		
	PROCEDURE validate_d2k_activity
		IS
			-- Local Variables
			procName VARCHAR2(100);
		BEGIN
			-- set the procedure name and parameter info for debugging information
			
			cdapi.validate_activity(act_status, act_warnings);
			
			IF act_status != 'Y' THEN
				process_error();
				IF NOT cdapi.activity IS NULL THEN
					cdapi.abort_activity;
				END IF;
				RAISE genericError;
			ELSE
				IF act_warnings != 'N' THEN
					process_error();
				END IF;
				IF NOT cdapi.activity IS NULL THEN
					cdapi.close_activity(act_status);
				END IF;
			END IF;
		END;
	
	
	PROCEDURE prepare_repository(applicationName VARCHAR2, applicationVersion NUMBER := 0)
		IS
			-- Local Variables
			procName VARCHAR2(100);
		BEGIN
			-- set the procedure name and parameter info for debugging information
			procName := 'prepare_repository';
			errStr := errStr || chr(10) || '***** ' || procName || ' *********' || chr(10);
			errStr := errStr || 'applicationName: ' || applicationName || chr(10);
			errStr := errStr || 'applicationVersion: ' || applicationVersion || chr(10);

			IF NOT cdapi.initialized THEN
				IF applicationVersion != 0 THEN
					cdapi.initialize(applicationName, applicationVersion);
				ELSE
					cdapi.initialize(applicationName);
				END IF;
				IF NOT cdapi.initialized THEN
					repositoryInitialized := false;
				ELSE
					repositoryInitialized := true;
				END IF;
			ELSE
				IF applicationVersion != 0 THEN
					cdapi.set_context_appsys(applicationName, applicationVersion);
				ELSE
					cdapi.set_context_appsys(applicationName);
				END IF;
				
				repositoryInitialized := true;
			END IF;

			IF debug_mode THEN
				output_big_string(errStr);
				errStr := '';
			END IF;
		EXCEPTION	
			WHEN OTHERS THEN
				process_error(true);
		END;
	

	PROCEDURE update_table_name(table_id NUMBER, new_name VARCHAR2)
		-- table_id 		The Designer 2000 Repository ID for the table
		-- new_name 		The new name for the column
		IS
			-- Local Variables
			procName VARCHAR2(100);
			
			tblData ciotable_definition.data;
		BEGIN
			-- set the procedure name and parameter info for debugging information
			procName := 'update_table_name';
			errStr := errStr || chr(10) || '***** ' || procName || ' *********' || chr(10);
			errStr := errStr || 'table_id: ' || table_id || chr(10);
			errStr := errStr || 'new_name: ' || new_name || chr(10);
			
			-- always must open an activity before performing any action
			cdapi.open_activity;
			tblData.i.name := TRUE;
			tblData.v.name := new_name;
			ciotable_definition.lck(table_id);
			ciotable_definition.upd(table_id, tblData);
			validate_d2k_activity();
			
			IF debug_mode THEN
				output_big_string(errStr);
				errStr := '';
			END IF;
			
		EXCEPTION	
			WHEN OTHERS THEN
				process_error();
				validate_d2k_activity();
		END;
		
		
	PROCEDURE update_column_name(column_id NUMBER, new_name VARCHAR2)
		-- column_id 		The Designer 2000 Repository ID for the column
		-- new_name 		The new name for the column
		IS
			-- Local Variables
			procName VARCHAR2(100);
			
			colData ciocolumn.data;
		BEGIN
			-- set the procedure name and parameter info for debugging information
			procName := 'update_column_name';
			errStr := errStr || chr(10) || '***** ' || procName || ' *********' || chr(10);
			errStr := errStr || 'column_id: ' || column_id || chr(10);
			errStr := errStr || 'new_name: ' || new_name || chr(10);
			
			-- always must open an activity before performing any action
			cdapi.open_activity;
			colData.i.name := TRUE;
			colData.v.name := new_name;
			ciocolumn.lck(column_id);
			ciocolumn.upd(column_id, colData);
			validate_d2k_activity();
			
			IF debug_mode THEN
				output_big_string(errStr);
				errStr := '';
			END IF;
		EXCEPTION	
			WHEN OTHERS THEN
				process_error();
				validate_d2k_activity();
		END;
		
		
	PROCEDURE update_primary_key_name(primary_key_id IN NUMBER, primary_key_name IN VARCHAR2)
		IS
			-- Local Variables
			procName VARCHAR2(100);
			pkdata cioprimary_key_constraint.data;
	BEGIN
			-- set the procedure name and parameter info for debugging information
			procName := 'update_primary_key_name';
			errStr := errStr || chr(10) || '***** ' || procName || ' *********' || chr(10);
			errStr := errStr || 'primary_key_id: ' || primary_key_id || chr(10);
			errStr := errStr || 'primary_key_name: ' || primary_key_name || chr(10);
			
			cdapi.open_activity;
			pkdata.i.name := TRUE;
			pkdata.v.name := primary_key_name;
			cioprimary_key_constraint.lck(primary_key_id);
			cioprimary_key_constraint.upd(primary_key_id, pkdata);
			validate_d2k_activity();

			IF debug_mode THEN
				output_big_string(errStr);
				errStr := '';
			END IF;
		EXCEPTION	
			WHEN OTHERS THEN
				process_error();
				validate_d2k_activity();
		END;
	
	
	PROCEDURE update_unique_key_name(unique_key_id IN NUMBER, new_name IN VARCHAR2)
		IS
			-- Local Variables
			procName VARCHAR2(100);
			ukData ciounique_key_constraint.data;
		BEGIN
			-- set the procedure name and parameter info for debugging information
			procName := 'update_unique_key_name';
			errStr := errStr || chr(10) || '***** ' || procName || ' *********' || chr(10);
			errStr := errStr || 'unique_key_id: ' || unique_key_id || chr(10);
			errStr := errStr || 'new_name: ' || new_name || chr(10);
			
			cdapi.open_activity;
			
			ukData.i.name := TRUE;
			ukData.v.name := new_name;
			ciounique_key_constraint.lck(unique_key_id);
			ciounique_key_constraint.upd(unique_key_id, ukData);	
			
			validate_d2k_activity();

			IF debug_mode THEN
				output_big_string(errStr);
				errStr := '';
			END IF;
		EXCEPTION	
			WHEN OTHERS THEN
				process_error();
				validate_d2k_activity();
		END;
		

		
	PROCEDURE update_foreign_key_name(foreign_key_id IN NUMBER, new_name IN VARCHAR2)
		IS
			-- Local Variables
			procName VARCHAR2(100);
			fkData cioforeign_key_constraint.data;
		BEGIN
			-- set the procedure name and parameter info for debugging information
			procName := 'update_foreign_key_name';
			errStr := errStr || chr(10) || '***** ' || procName || ' *********' || chr(10);
			errStr := errStr || 'foreign_key_id: ' || foreign_key_id || chr(10);
			errStr := errStr || 'new_name: ' || new_name || chr(10);
			
			cdapi.open_activity;
			
			fkData.i.name := TRUE;
			fkData.v.name := new_name;
			cioforeign_key_constraint.lck(foreign_key_id);
			cioforeign_key_constraint.upd(foreign_key_id, fkData);	
			
			validate_d2k_activity();

			IF debug_mode THEN
				output_big_string(errStr);
				errStr := '';
			END IF;
		EXCEPTION	
			WHEN OTHERS THEN
				process_error();
				validate_d2k_activity();
		END;
		
		
	PROCEDURE add_component_to_key(key_id IN NUMBER, column_id IN NUMBER)
		IS
			-- Local Variables
			procName VARCHAR2(100);
			kcdata ciokey_component.data;	-- Property list for key_component;
		BEGIN
			-- set the procedure name and parameter info for debugging information
			procName := 'add_component_to_key';
			errStr := errStr || chr(10) || '***** ' || procName || ' *********' || chr(10);
			errStr := errStr || 'key_id: ' || key_id || chr(10);
			errStr := errStr || 'column_id: ' || column_id || chr(10);
			
			cdapi.open_activity;
			kcdata.i.column_reference := TRUE;
			kcdata.v.column_reference := column_id;
			kcdata.i.constraint_reference := TRUE;
			kcdata.v.constraint_reference := key_id;
			
			ciokey_component.ins(null, kcdata);
			
			validate_d2k_activity();

			IF debug_mode THEN
				output_big_string(errStr);
				errStr := '';
			END IF;
		EXCEPTION	
			WHEN OTHERS THEN
				process_error(); -- optional parameter indicating fatality
				validate_d2k_activity();
		END;
		


	PROCEDURE remove_component_from_key(key_id IN NUMBER, column_id IN NUMBER)
		IS
			-- Local Variables
			procName VARCHAR2(100);
			kcdata ciokey_component.data;	-- Property list for key_component;
			
			CURSOR key_component_cur(cur_key_id NUMBER, cur_column_id NUMBER) IS
				SELECT kc.id
				  FROM ci_key_components kc
				 WHERE kc.constraint_reference = cur_key_id
				   AND kc.column_reference = column_id;
			kc_rec key_component_cur%ROWTYPE;
		BEGIN
			-- set the procedure name and parameter info for debugging information
			procName := 'remove_component_from_key';
			errStr := errStr || chr(10) || '***** ' || procName || ' *********' || chr(10);
			errStr := errStr || 'key_id: ' || key_id || chr(10);
			errStr := errStr || 'column_id: ' || column_id || chr(10);
			
			OPEN key_component_cur(key_id, column_id);
			FETCH key_component_cur INTO kc_rec;
			
			CLOSE key_component_cur;
			
			cdapi.open_activity;
			ciokey_component.del(kc_rec.id);
			validate_d2k_activity();
			
			IF debug_mode THEN
				output_big_string(errStr);
				errStr := '';
			END IF;
		EXCEPTION	
			WHEN OTHERS THEN
				process_error(); -- optional parameter indicating fatality
				validate_d2k_activity();
		END;
		


	PROCEDURE update_index_name(index_id IN NUMBER, new_name IN VARCHAR2)
		IS
			-- Local Variables
			procName VARCHAR2(100);
			ixData ciorelation_index.data;
		BEGIN
			-- set the procedure name and parameter info for debugging information
			procName := 'update_index_name';
			errStr := errStr || chr(10) || '***** ' || procName || ' *********' || chr(10);
			errStr := errStr || 'index_id: ' || index_id || chr(10);
			errStr := errStr || 'new_name: ' || new_name || chr(10);
			
			cdapi.open_activity;
			
			ixData.i.name := TRUE;
			ixData.v.name := new_name;
			ciorelation_index.lck(index_id);
			ciorelation_index.upd(index_id, ixData);
			
			
			validate_d2k_activity();

			IF debug_mode THEN
				output_big_string(errStr);
				errStr := '';
			END IF;
		EXCEPTION	
			WHEN OTHERS THEN
				process_error();
				validate_d2k_activity();
		END;
		
		
	PROCEDURE update_check_constraint_name(check_constraint_id IN NUMBER, new_name IN VARCHAR2)
		IS
			-- Local Variables
			procName VARCHAR2(100);
			ck_cons_Data ciocheck_constraint.data;
		BEGIN
			-- set the procedure name and parameter info for debugging information
			procName := 'update_check_constraint_name';
			errStr := errStr || chr(10) || '***** ' || procName || ' *********' || chr(10);
			errStr := errStr || 'check_constraint_id: ' || check_constraint_id || chr(10);
			errStr := errStr || 'new_name: ' || new_name || chr(10);
			
			cdapi.open_activity;
			
			ck_cons_Data.i.name := TRUE;
			ck_cons_Data.v.name := new_name;
			ciocheck_constraint.lck(check_constraint_id);
			ciocheck_constraint.upd(check_constraint_id, ck_cons_Data);	
			
			validate_d2k_activity();

			IF debug_mode THEN
				output_big_string(errStr);
				errStr := '';
			END IF;
		EXCEPTION	
			WHEN OTHERS THEN
				process_error();
				validate_d2k_activity();
		END;
		
		

	PROCEDURE update_sequence_name(sequence_id IN NUMBER, new_name IN VARCHAR2)
		IS
			-- Local Variables
			procName VARCHAR2(100);
			seqData ciosequence.data;
		BEGIN
			-- set the procedure name and parameter info for debugging information
			procName := 'update_sequence_name';
			errStr := errStr || chr(10) || '***** ' || procName || ' *********' || chr(10);
			errStr := errStr || 'sequence_id: ' || sequence_id || chr(10);
			errStr := errStr || 'new_name: ' || new_name || chr(10);
			
			cdapi.open_activity;
			
			seqData.i.name := TRUE;
			seqData.v.name := new_name;
			ciosequence.lck(sequence_id);
			ciosequence.upd(sequence_id, seqData);	
			
			validate_d2k_activity();

			IF debug_mode THEN
				output_big_string(errStr);
				errStr := '';
			END IF;
		EXCEPTION	
			WHEN OTHERS THEN
				process_error();
				validate_d2k_activity();
		END;
		
		
	FUNCTION get_pk_id_from_table_id(table_id IN NUMBER) RETURN NUMBER
		IS
			-- Local Variables
			procName VARCHAR2(100);
			
			CURSOR pk_cur(cur_table_id NUMBER) IS
				SELECT pk.id
				  FROM ci_primary_key_constraints pk
				 WHERE pk.table_reference = cur_table_id;
			pk_rec pk_cur%ROWTYPE;
		BEGIN
			-- set the procedure name and parameter info for debugging information
			procName := 'get_pk_id_from_table_id';
			errStr := errStr || chr(10) || '***** ' || procName || ' *********' || chr(10);
			errStr := errStr || 'table_id: ' || table_id || chr(10);
			
			OPEN pk_cur(table_id);
			FETCH pk_cur INTO pk_rec;
			
			IF pk_cur%FOUND THEN
				errStr := errStr || 'pk_id: ' || pk_rec.id || chr(10);
			ELSE
				errStr := errStr || 'WARNING:No primary key found for table';
				RAISE genericError;
			END IF;
			CLOSE pk_cur;
			

			IF debug_mode THEN
				output_big_string(errStr);
				errStr := '';
			END IF;
			
			return pk_rec.id;
		EXCEPTION	
			WHEN OTHERS THEN
				process_error();
				validate_d2k_activity();
		END;
		
		
		

		
	-- "_LY" functions and procedures incorporate Lilly Naming Standards
	PROCEDURE update_unique_key_names_ly(table_id NUMBER)
		-- table_id 		The Designer 2000 Repository ID for the table
		IS
			-- Local Variables
			procName VARCHAR2(100);
			CURSOR uk_cur(cur_table_id NUMBER) IS
				SELECT uk.id, uk.name
				  FROM ci_unique_key_constraints uk
				 WHERE uk.table_reference = cur_table_id;
			uk_rec uk_cur%ROWTYPE;
			uk_number NUMBER(2);
			uk_number_string VARCHAR(2);
			
			tblData ciotable_definition.data;
		BEGIN
			-- set the procedure name and parameter info for debugging information
			procName := 'update_unique_key_names_ly';
			errStr := errStr || chr(10) || '***** ' || procName || ' *********' || chr(10);
			errStr := errStr || 'table_id: ' || table_id || chr(10);
			
			cdapi.open_activity;
			ciotable_definition.sel(table_id, tblData);
			validate_d2k_activity();

			OPEN uk_cur(table_id);
			FETCH uk_cur INTO uk_rec;
			uk_number := 1;
			
			WHILE uk_cur%FOUND
			LOOP
				uk_number_string := to_char(uk_number);
				uk_number_string := lpad(uk_number_string, 2, '0');
				
				update_unique_key_name(uk_rec.id, tblData.v.name || '_UK' || uk_number_string);
				
				uk_number := uk_number + 1;
				FETCH uk_cur INTO uk_rec;
			END LOOP;
			CLOSE uk_cur;
			
			IF debug_mode THEN
				output_big_string(errStr);
				errStr := '';
			END IF;
		EXCEPTION	
			WHEN OTHERS THEN
				process_error();
				validate_d2k_activity();
		END;
		
		

	-- "_LY" functions and procedures incorporate Lilly Naming Standards
	PROCEDURE update_foreign_key_names_ly(table_id NUMBER)
		-- table_id 		The Designer 2000 Repository ID for the table
		IS
			-- Local Variables
			procName VARCHAR2(100);
			CURSOR fk_cur(cur_table_id NUMBER) IS
				SELECT fk.id, fk.name
				  FROM ci_foreign_key_constraints fk
				 WHERE fk.table_reference = cur_table_id;
			fk_rec fk_cur%ROWTYPE;
			fk_number NUMBER(2);
			fk_number_string VARCHAR(2);
			
			tblData ciotable_definition.data;
		BEGIN
			-- set the procedure name and parameter info for debugging information
			procName := 'update_foreign_key_names_ly';
			errStr := errStr || chr(10) || '***** ' || procName || ' *********' || chr(10);
			errStr := errStr || 'table_id: ' || table_id || chr(10);
			
			cdapi.open_activity;
			ciotable_definition.sel(table_id, tblData);
			validate_d2k_activity();

			OPEN fk_cur(table_id);
			FETCH fk_cur INTO fk_rec;
			fk_number := 1;
			
			WHILE fk_cur%FOUND
			LOOP
				fk_number_string := to_char(fk_number);
				fk_number_string := lpad(fk_number_string, 2, '0');
				
				update_foreign_key_name(fk_rec.id, tblData.v.name || '_FK' || fk_number_string);
				
				fk_number := fk_number + 1;
				FETCH fk_cur INTO fk_rec;
			END LOOP;
			CLOSE fk_cur;
			
			IF debug_mode THEN
				output_big_string(errStr);
				errStr := '';
			END IF;
		EXCEPTION	
			WHEN OTHERS THEN
				process_error();
				validate_d2k_activity();
		END;
		
		
	-- "_LY" functions and procedures incorporate Lilly Naming Standards
	PROCEDURE update_index_names_ly(table_id NUMBER)
		-- table_id 		The Designer 2000 Repository ID for the table
		IS
			-- Local Variables
			procName VARCHAR2(100);
			CURSOR ix_cur(cur_table_id NUMBER) IS
				SELECT ix.id, ix.name
				  FROM ci_relation_indexes ix
				 WHERE ix.table_definition_reference = cur_table_id;
			ix_rec ix_cur%ROWTYPE;
			ix_number NUMBER(2);
			ix_number_string VARCHAR(2);
			
			tblData ciotable_definition.data;
		BEGIN
			-- set the procedure name and parameter info for debugging information
			procName := 'update_index_names_ly';
			errStr := errStr || chr(10) || '***** ' || procName || ' *********' || chr(10);
			errStr := errStr || 'table_id: ' || table_id || chr(10);
			
			cdapi.open_activity;
			ciotable_definition.sel(table_id, tblData);
			validate_d2k_activity();

			OPEN ix_cur(table_id);
			FETCH ix_cur INTO ix_rec;
			ix_number := 1;
			
			WHILE ix_cur%FOUND
			LOOP
				ix_number_string := to_char(ix_number);
				ix_number_string := lpad(ix_number_string, 2, '0');
				
				update_index_name(ix_rec.id, tblData.v.name || '_A' || ix_number_string);
				
				ix_number := ix_number + 1;
				FETCH ix_cur INTO ix_rec;
			END LOOP;			
			CLOSE ix_cur;
			
			IF debug_mode THEN
				output_big_string(errStr);
				errStr := '';
			END IF;
		EXCEPTION	
			WHEN OTHERS THEN
				process_error();
				validate_d2k_activity();
		END;
		
		
	-- "_LY" functions and procedures incorporate Lilly Naming Standards
	PROCEDURE update_ck_names_ly(table_id NUMBER)
		-- table_id 		The Designer 2000 Repository ID for the table
		IS
			-- Local Variables
			procName VARCHAR2(100);
			CURSOR ck_cur(cur_table_id NUMBER) IS
				SELECT ck.id, ck.name
				  FROM ci_check_constraints ck
				 WHERE ck.table_reference = cur_table_id;
			ck_rec ck_cur%ROWTYPE;
			ck_number NUMBER(2);
			ck_number_string VARCHAR(2);
			
			tblData ciotable_definition.data;
		BEGIN
			-- set the procedure name and parameter info for debugging information
			procName := 'update_ck_names_ly';
			errStr := errStr || chr(10) || '***** ' || procName || ' *********' || chr(10);
			errStr := errStr || 'table_id: ' || table_id || chr(10);
			
			cdapi.open_activity;
			ciotable_definition.sel(table_id, tblData);
			validate_d2k_activity();

			OPEN ck_cur(table_id);
			FETCH ck_cur INTO ck_rec;
			ck_number := 1;
			
			WHILE ck_cur%FOUND
			LOOP
				ck_number_string := to_char(ck_number);
				ck_number_string := lpad(ck_number_string, 2, '0');
	
				update_check_constraint_name(ck_rec.id, tblData.v.name || '_CK' || ck_number_string);
				
				ck_number := ck_number + 1;
				FETCH ck_cur INTO ck_rec;
			END LOOP;			
			CLOSE ck_cur;
			
			IF debug_mode THEN
				output_big_string(errStr);
				errStr := '';
			END IF;
		EXCEPTION	
			WHEN OTHERS THEN
				process_error();
				validate_d2k_activity();
		END;
		
		

	PROCEDURE update_column_name_ly(column_id NUMBER, new_name VARCHAR2)
		-- column_id 		The Designer 2000 Repository ID for the column
		-- new_name 		The new name for the column
		IS
			-- Local Variables
			procName VARCHAR2(100);
			
			CURSOR fk_column_cur(cur_column_id NUMBER) IS
				SELECT	c.id
				  FROM	ci_table_definitions t,
       					ci_columns c,
					ci_key_components kc,
					ci_foreign_key_constraints fk
				 WHERE	t.id = c.table_reference
				   AND	c.id = kc.column_reference
				   AND	kc.constraint_reference = fk.id
				   AND	kc.foreign_column_reference = cur_column_id;
   			fk_col_rec fk_column_cur%ROWTYPE;
		BEGIN
			-- set the procedure name and parameter info for debugging information
			procName := 'update_column_name_ly';
			errStr := errStr || chr(10) || '***** ' || procName || ' *********' || chr(10);
			errStr := errStr || 'column_id: ' || column_id || chr(10);
			errStr := errStr || 'new_name: ' || new_name || chr(10);
			
			-- Lilly data naming standards require renaming all foreign keyed columns in foreign tables
			update_column_name(column_id, new_name);
			
			OPEN fk_column_cur(column_id);
			FETCH fk_column_cur INTO fk_col_rec;
			
			WHILE fk_column_cur%FOUND
			LOOP
				update_column_name(fk_col_rec.id, new_name);
				FETCH fk_column_cur INTO fk_col_rec;
			END LOOP;
			CLOSE fk_column_cur;
			
			IF debug_mode THEN
				output_big_string(errStr);
				errStr := '';
			END IF;
		EXCEPTION	
			WHEN OTHERS THEN
				process_error();
				validate_d2k_activity();
		END;
		
		

BEGIN

/* ------------------------------------------------------------------------------------------------ */
/* ------------------------------------- Make function calls -------------------------------------- */
/* --------------------------------------- in area below ------------------------------------------ */
/* ------------------------------------------------------------------------------------------------ */

	-- begin execution
	-- first set the application name
	-- required variable set command
	app_name := 'XML Utilities';

	-- set debug mode for verbose processing messages
	-- optional - defaults to false
	debug_mode := true;

	-- prepare/initialize the repository - required call
	prepare_repository(app_name);
	dbms_output.put_line(to_char(cdapi.app_sys_ref));

    FOR app_col_rec IN app_col_cur LOOP
        DECLARE
			-- Local Variables
			procName VARCHAR2(100);
			bytes_written NUMBER(5);
			
			colData ciocolumn.data;
            currentColData ciocolumn.data;
		BEGIN
			-- set the procedure name and parameter info for debugging information
			procName := 'copy_column_prompt_to_column_hint';
			errStr := errStr || chr(10) || '***** ' || procName || ' *********' || chr(10);

			--prepare_repository_for_col(column_id);
			cdapi.open_activity;
            ciocolumn.sel(app_col_rec.columnId, currentColData);

            errStr := errStr || '*** columnName = ' || currentColData.v.name || chr(10);
            errStr := errStr || '*** columnName = ' || nvl(currentColData.v.prompt, null) || chr(10);
            
            
            IF currentColData.v.datatype = 'TIMESTAMP' THEN
                dbms_output.put_line('TIMESTAMP encountered.  No update made.');
            ELSE
    			ciocolumn.lck(app_col_rec.columnId);
       
    			colData.i.help_text := TRUE;
    			colData.v.help_text := nvl(currentColData.v.prompt, 'null');
       
    			ciocolumn.upd(app_col_rec.columnId, colData);
            END IF;
            
            
			validate_d2k_activity();
   
            errStr := errStr || '*** activity validated  ***' || chr(10);
			
			IF debug_mode THEN
				output_big_string(errStr);
				errStr := '';
			END IF;
		EXCEPTION	
			WHEN OTHERS THEN
				process_error(); -- optional parameter indicating fatality
   		END;
    END LOOP;
END;

