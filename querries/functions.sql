CREATE OR REPLACE FUNCTION track_working_hours(employee_id INTEGER, project_id INTEGER, total_hours NUMERIC) 
    RETURNS VOID
    LANGUAGE plpgsql
AS $$
BEGIN 
    IF employee_id IS NULL THEN
        RAISE EXCEPTION 'Employee ID cannot be NULL.';
    END IF;
    
    IF project_id IS NULL THEN
        RAISE EXCEPTION 'Project ID cannot be NULL.';
    END IF;
    
    IF total_hours IS NULL OR total_hours <= 0 THEN
        RAISE EXCEPTION 'Total hours must be a positive value.';
    END IF;

    INSERT INTO application.hour_tracking(employee_id, project_id, total_hours)
    VALUES(employee_id, project_id, total_hours);
END;
$$;



CREATE OR REPLACE FUNCTION create_project_with_teams(name TEXT, client TEXT, start_date TIMESTAMP, deadline TIMESTAMP, team_ids INTEGER[])
    RETURNS VOID 
    LANGUAGE plpgsql
AS $$
#variable_conflict use_column
DECLARE 
    project_id INTEGER;
    team_id INTEGER;
BEGIN
    INSERT INTO application.projects(name, client, start_date, deadline)
    VALUES(name, client, start_date, deadline)
    RETURNING project_id INTO project_id;
    
    FOREACH team_id IN ARRAY team_ids
    LOOP
        INSERT INTO application.team_project(project_id, team_id)
        VALUES(project_id, team_id);
    END LOOP;
END;
$$;
