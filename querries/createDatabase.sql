-- Table: application.teams

-- DROP TABLE IF EXISTS application.teams;

CREATE TABLE IF NOT EXISTS application.teams
(
    team_id serial,
    team_name character varying(30) COLLATE pg_catalog."default" NOT NULL,
    location character varying(30) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT teams_pkey PRIMARY KEY (team_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS application.teams
    OWNER to admin;
-- Table: application.titles

-- DROP TABLE IF EXISTS application.titles;

CREATE TABLE IF NOT EXISTS application.titles
(
    title_id serial,
    title_name character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT titles_pkey PRIMARY KEY (title_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS application.titles
    OWNER to admin;

-- Table: application.employees

-- DROP TABLE IF EXISTS application.employees;

CREATE TABLE IF NOT EXISTS application.employees
(
    employee_id serial,
    first_name character varying(30) COLLATE pg_catalog."default" NOT NULL,
    last_name character varying(30) COLLATE pg_catalog."default" NOT NULL,
    hire_date date NOT NULL,
    hourly_salary numeric(5,2) NOT NULL,
    title_id integer NOT NULL,
    manager_id integer,
    team_id integer,
    CONSTRAINT employees_pkey PRIMARY KEY (employee_id),
    CONSTRAINT team_id FOREIGN KEY (team_id)
        REFERENCES application.teams (team_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        NOT VALID,
    CONSTRAINT title_id FOREIGN KEY (title_id)
        REFERENCES application.titles (title_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS application.employees
    OWNER to admin;

COMMENT ON CONSTRAINT team_id ON application.employees
    IS 'team_id foreign key';
COMMENT ON CONSTRAINT title_id ON application.employees
    IS 'title_id_FK';
-- Index: fki_team_id

-- DROP INDEX IF EXISTS application.fki_team_id;

CREATE INDEX IF NOT EXISTS fki_team_id
    ON application.employees USING btree
    (team_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: fki_title_id

-- DROP INDEX IF EXISTS application.fki_title_id;

CREATE INDEX IF NOT EXISTS fki_title_id
    ON application.employees USING btree
    (title_id ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: application.hour_tracking

-- DROP TABLE IF EXISTS application.hour_tracking;


-- Table: application.projects

-- DROP TABLE IF EXISTS application.projects;

CREATE TABLE IF NOT EXISTS application.projects
(
    project_id serial,
    name character varying(30) COLLATE pg_catalog."default" NOT NULL,
    client character varying(30) COLLATE pg_catalog."default" NOT NULL,
    start_date date NOT NULL,
    deadline date NOT NULL,
    CONSTRAINT projects_pkey PRIMARY KEY (project_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS application.projects
    OWNER to admin;

-- Table: application.team_project

-- DROP TABLE IF EXISTS application.team_project;

CREATE TABLE IF NOT EXISTS application.team_project
(
    team_project_id serial,
    team_id integer NOT NULL,
    project_id integer NOT NULL,
    CONSTRAINT team_project_pkey PRIMARY KEY (team_project_id),
    CONSTRAINT project_id FOREIGN KEY (project_id)
        REFERENCES application.projects (project_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT team_id FOREIGN KEY (team_id)
        REFERENCES application.teams (team_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS application.team_project
    OWNER to admin;

COMMENT ON CONSTRAINT project_id ON application.team_project
    IS 'project_id foreign key';
COMMENT ON CONSTRAINT team_id ON application.team_project
    IS 'team_id foreign key';


CREATE TABLE IF NOT EXISTS application.hour_tracking
(
    hour_id serial,
    employee_id integer,
    project_id integer,
    total_hours numeric(5,3),
    CONSTRAINT hour_tracking_pkey PRIMARY KEY (hour_id),
    CONSTRAINT project_id FOREIGN KEY (project_id)
        REFERENCES application.projects (project_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS application.hour_tracking
    OWNER to admin;

COMMENT ON CONSTRAINT project_id ON application.hour_tracking
    IS 'project_id foreign key';
-- Index: fki_project_id

-- DROP INDEX IF EXISTS application.fki_project_id;

CREATE INDEX IF NOT EXISTS fki_project_id
    ON application.hour_tracking USING btree
    (project_id ASC NULLS LAST)
    TABLESPACE pg_default;
