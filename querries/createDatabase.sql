-- Table: public.employees

-- DROP TABLE IF EXISTS public.employees;

CREATE TABLE IF NOT EXISTS public.employees
(
    employee_id integer NOT NULL DEFAULT nextval('employees_id_seq'::regclass),
    first_name character varying(30) COLLATE pg_catalog."default" NOT NULL,
    last_name character varying(30) COLLATE pg_catalog."default" NOT NULL,
    hire_date date NOT NULL,
    hourly_salary numeric(5,2) NOT NULL,
    title_id integer NOT NULL,
    manager_id integer,
    team_id integer,
    CONSTRAINT employees_pkey PRIMARY KEY (employee_id),
    CONSTRAINT team_id FOREIGN KEY (team_id)
        REFERENCES public.teams (team_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        NOT VALID,
    CONSTRAINT title_id FOREIGN KEY (title_id)
        REFERENCES public.titles (title_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.employees
    OWNER to admin;

COMMENT ON CONSTRAINT team_id ON public.employees
    IS 'team_id foreign key';
COMMENT ON CONSTRAINT title_id ON public.employees
    IS 'title_id_FK';
-- Index: fki_team_id

-- DROP INDEX IF EXISTS public.fki_team_id;

CREATE INDEX IF NOT EXISTS fki_team_id
    ON public.employees USING btree
    (team_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: fki_title_id

-- DROP INDEX IF EXISTS public.fki_title_id;

CREATE INDEX IF NOT EXISTS fki_title_id
    ON public.employees USING btree
    (title_id ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.hour_tracking

-- DROP TABLE IF EXISTS public.hour_tracking;

CREATE TABLE IF NOT EXISTS public.hour_tracking
(
    hour_id integer NOT NULL DEFAULT nextval('hour_tracking_hour_id_seq'::regclass),
    employee_id integer,
    project_id integer,
    total_hours numeric(5,3),
    CONSTRAINT hour_tracking_pkey PRIMARY KEY (hour_id),
    CONSTRAINT project_id FOREIGN KEY (project_id)
        REFERENCES public.projects (project_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.hour_tracking
    OWNER to postgres;

COMMENT ON CONSTRAINT project_id ON public.hour_tracking
    IS 'project_id foreign key';
-- Index: fki_project_id

-- DROP INDEX IF EXISTS public.fki_project_id;

CREATE INDEX IF NOT EXISTS fki_project_id
    ON public.hour_tracking USING btree
    (project_id ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.projects

-- DROP TABLE IF EXISTS public.projects;

CREATE TABLE IF NOT EXISTS public.projects
(
    project_id integer NOT NULL DEFAULT nextval('projects_project_id_seq'::regclass),
    name character varying(30) COLLATE pg_catalog."default" NOT NULL,
    client character varying(30) COLLATE pg_catalog."default" NOT NULL,
    start_date date NOT NULL,
    deadline date NOT NULL,
    CONSTRAINT projects_pkey PRIMARY KEY (project_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.projects
    OWNER to postgres;

-- Table: public.team_project

-- DROP TABLE IF EXISTS public.team_project;

CREATE TABLE IF NOT EXISTS public.team_project
(
    team_project_id integer NOT NULL DEFAULT nextval('team_project_team_project_id_seq'::regclass),
    team_id integer NOT NULL,
    project_id integer NOT NULL,
    CONSTRAINT team_project_pkey PRIMARY KEY (team_project_id),
    CONSTRAINT project_id FOREIGN KEY (project_id)
        REFERENCES public.projects (project_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT team_id FOREIGN KEY (team_id)
        REFERENCES public.teams (team_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.team_project
    OWNER to postgres;

COMMENT ON CONSTRAINT project_id ON public.team_project
    IS 'project_id foreign key';
COMMENT ON CONSTRAINT team_id ON public.team_project
    IS 'team_id foreign key';

-- Table: public.teams

-- DROP TABLE IF EXISTS public.teams;

CREATE TABLE IF NOT EXISTS public.teams
(
    team_id integer NOT NULL DEFAULT nextval('teams_team_id_seq'::regclass),
    team_name character varying(30) COLLATE pg_catalog."default" NOT NULL,
    location character varying(30) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT teams_pkey PRIMARY KEY (team_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.teams
    OWNER to postgres;

-- Table: public.titles

-- DROP TABLE IF EXISTS public.titles;

CREATE TABLE IF NOT EXISTS public.titles
(
    title_id integer NOT NULL DEFAULT nextval('titles_title_id_seq'::regclass),
    title_name character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT titles_pkey PRIMARY KEY (title_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.titles
    OWNER to postgres;