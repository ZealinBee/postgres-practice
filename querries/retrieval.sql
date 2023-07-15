-- Retrieve the team names and their corresponding project count.

SELECT t.team_name, COUNT(tp.project_id) AS project_count
FROM application.teams AS t
LEFT JOIN application.team_project AS tp  ON t.team_id = tp.team_id
GROUP BY t.team_name;

-- Retrieve the projects managed by the managers whose first name starts with "J" or "D".
SELECT p.name AS project_name, m.first_name AS manager_name
FROM application.projects AS p
LEFT JOIN application.employees AS m 
WHERE manager_name LIKE 'J%' OR manager_name LIKE 'D%';
GROUP BY p.name;

-- Retrieve all the employees (both directly and indirectly) working under Andrew Martin
SELECT e.*
FROM application.employees AS e
JOIN application.employees AS manager ON manager.employee_id = e.manager_id
WHERE manager.first_name = 'Andrew' AND manager.last_name = 'Martin';

-- Retrieve all the employees (both directly and indirectly) working under Andrew Martin
SELECT e.*
FROM application.employees AS e
JOIN application.employees AS manager ON manager.employee_id = e.manager_id
WHERE manager.first_name = 'Robert' AND manager.last_name = 'Brown';

-- Retrieve the average hourly salary for each title.
SELECT t.title_name, AVG(e.hourly_salary) AS average_hourly_salary
FROM application.employees AS e 
JOIN application.titles AS t ON e.title_id = t.title_id
GROUP BY t.title_name;

-- Retrieve the employees who have a higher hourly salary than their respective team's average hourly salary.
SELECT e.employee_id, e.hourly_salary, e.team_id
FROM application.employees AS e 
JOIN ( SELECT t.team_id, AVG(e.hourly_salary) as average_hourly_salary
  FROM application.teams AS t 
  JOIN application.employees AS e ON t.team_id = e.team_id
  GROUP BY t.team_id
) AS t ON t.team_id = e.team_id 
WHERE e.hourly_salary > t.average_hourly_salary;

-- Retrieve the projects that have more than 3 teams assigned to them.

SELECT p.name
FROM application.projects AS p
JOIN application.team_project AS tp ON p.project_id = tp.project_id
GROUP BY p.name
HAVING COUNT(tp.team_id) > 3;

-- Retrieve the total hourly salary expense for each team.
SELECT t.team_name, SUM(e.hourly_salary) AS total_salary
FROM application.teams AS t
JOIN application.employees e ON e.team_id = t.team_id
GROUP BY t.team_name;
