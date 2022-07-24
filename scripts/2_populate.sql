INSERT INTO "users" ("fullName", "email", "role")
VALUES
('full name', 'a@dm.in', 'admin'),
('an even fuller name', 'case@mana.ger', 'case_manager'),
('full name2', 'ther@ap.ist', 'therapist'),
('full name3', 'th@era.pist', 'therapist'),
('fullest name', 'pa@re.nt', 'parent');

INSERT INTO "patients" ("fullName", "birthDate")
VALUES
('patient name', '1992-04-24'),
('an even patienter name', '2002-07-24'),
('patient name2', '2012-01-24');

INSERT INTO "user_patient" ("userId", "patientId")
VALUES
((SELECT "id" FROM "users" WHERE "email" = 'case@mana.ger'), (SELECT "id" FROM "patients" WHERE "fullName" = 'patient name' AND "birthDate" = '1992-04-24')),
((SELECT "id" FROM "users" WHERE "email" = 'ther@ap.ist'), (SELECT "id" FROM "patients" WHERE "fullName" = 'patient name' AND "birthDate" = '1992-04-24')),
((SELECT "id" FROM "users" WHERE "email" = 'ther@ap.ist'), (SELECT "id" FROM "patients" WHERE "fullName" = 'an even patienter name' AND "birthDate" = '2002-07-24')),
((SELECT "id" FROM "users" WHERE "email" = 'th@era.pist'), (SELECT "id" FROM "patients" WHERE "fullName" = 'patient name2' AND "birthDate" = '2012-01-24'));

INSERT INTO "skillTypes" ("title", "level")
VALUES
('skillType1', 3),
('skillType2', 1);

INSERT INTO "goals" ("serialNum", "description", "patientId", "skillTypeId", "minTherapists", "minConsecutiveDays", "archived")
VALUES
(3, 'goal description', (SELECT "id" FROM "patients" WHERE "fullName" = 'patient name' AND "birthDate" = '1992-04-24'), (SELECT "id" FROM "skillTypes" WHERE "title" = 'skillType1'), 3, 4, 'true'),
(2, 'another goal description', (SELECT "id" FROM "patients" WHERE "fullName" = 'patient name2' AND "birthDate" = '2012-01-24'), (SELECT "id" FROM "skillTypes" WHERE "title" = 'skillType2'), 4, 2, 'false');

INSERT INTO "subGoals" ("serialNum", "description", "goalId", "completedAt")
VALUES
(4, 'description of a subgoal', (SELECT "id" FROM "goals" WHERE "description" = 'goal description'), '1999-09-19'),
(4, 'another description of a subgoal', (SELECT "id" FROM "goals" WHERE "description" = 'another goal description'), '1949-09-19');

INSERT INTO "environments" ("title")
VALUES
('environment title'),
('environment title2'),
('environment title3');

INSERT INTO "activities" ("title", "description", "patientId")
VALUES
('activity title', 'activity description', (SELECT "id" FROM "patients" WHERE "fullName" = 'patient name' AND "birthDate" = '1992-04-24')),
('activity title2', 'activity description2', (SELECT "id" FROM "patients" WHERE "fullName" = 'patient name2' AND "birthDate" = '2012-01-24'));

INSERT INTO "assistances" ("title")
VALUES
('assistance title'),
('assistance title2');

INSERT INTO "activity_assistance" ("activityId", "assistanceId", "priority")
VALUES
((SELECT "id" FROM "activities" WHERE "title" = 'activity title'), (SELECT "id" FROM "assistances" WHERE "title" = 'assistance title'), 3),
((SELECT "id" FROM "activities" WHERE "title" = 'activity title2'), (SELECT "id" FROM "assistances" WHERE "title" = 'assistance title'), 2),
((SELECT "id" FROM "activities" WHERE "title" = 'activity title2'), (SELECT "id" FROM "assistances" WHERE "title" = 'assistance title'), 3);

INSERT INTO "activity_environment" ("activityId", "environmentId", "default")
VALUES
((SELECT "id" FROM "activities" WHERE "title" = 'activity title'), (SELECT "id" FROM "environments" WHERE "title" = 'environment title'), 'true'),
((SELECT "id" FROM "activities" WHERE "title" = 'activity title2'), (SELECT "id" FROM "environments" WHERE "title" = 'environment title2'), 'false'),
((SELECT "id" FROM "activities" WHERE "title" = 'activity title2'), (SELECT "id" FROM "environments" WHERE "title" = 'environment title'), 'true');

INSERT INTO "goal_activity" ("goalId", "activityId")
VALUES
((SELECT "id" FROM "goals" WHERE "serialNum" = 3 AND "patientId" = (SELECT "id" FROM "patients" WHERE "fullName" = 'patient name' AND "birthDate" = '1992-04-24')), (SELECT "id" FROM "activities" WHERE "title" = 'activity title')),
((SELECT "id" FROM "goals" WHERE "serialNum" = 2 AND "patientId" = (SELECT "id" FROM "patients" WHERE "fullName" = 'patient name2' AND "birthDate" = '2012-01-24')), (SELECT "id" FROM "activities" WHERE "title" = 'activity title2')),
((SELECT "id" FROM "goals" WHERE "serialNum" = 3 AND "patientId" = (SELECT "id" FROM "patients" WHERE "fullName" = 'patient name' AND "birthDate" = '1992-04-24')), (SELECT "id" FROM "activities" WHERE "title" = 'activity title2'));

INSERT INTO "sessions" ("patientId", "therapistId", "scheduledAt", "durationHr", "sessionPlanMessage", "sessionSummaryMessage")
VALUES
((SELECT "id" FROM "patients" WHERE "fullName" = 'patient name' AND "birthDate" = '1992-04-24'), (SELECT "id" FROM "users" WHERE "email" = 'ther@ap.ist'), '2002-10-19 10:23:54+02', 2, 'plan message', 'summary message'),
((SELECT "id" FROM "patients" WHERE "fullName" = 'patient name2' AND "birthDate" = '2012-01-24'), (SELECT "id" FROM "users" WHERE "email" = 'th@era.pist'), '2004-11-19 10:23:54+02', 2.5, 'plan message', 'summary message'),
((SELECT "id" FROM "patients" WHERE "fullName" = 'patient name' AND "birthDate" = '1992-04-24'), (SELECT "id" FROM "users" WHERE "email" = 'ther@ap.ist'), '2004-10-19 10:23:54+02', 2, 'plan message', 'summary message');

INSERT INTO "session_activity" ("sessionId", "activityId", "recommended")
VALUES
((SELECT "id" FROM "sessions" WHERE "therapistId" = (SELECT "id" FROM "users" WHERE "email" = 'ther@ap.ist') AND "scheduledAt" = '2002-10-19 10:23:54+02'), (SELECT "id" FROM "activities" WHERE "title" = 'activity title'), 'true'),
((SELECT "id" FROM "sessions" WHERE "therapistId" = (SELECT "id" FROM "users" WHERE "email" = 'ther@ap.ist') AND "scheduledAt" = '2002-10-19 10:23:54+02'), (SELECT "id" FROM "activities" WHERE "title" = 'activity title2'), 'false');

INSERT INTO "attempts" ("sessionId", "activityId", "environmentId", "subGoalId", "successful")
VALUES
((SELECT "id" FROM "sessions" WHERE "therapistId" = (SELECT "id" FROM "users" WHERE "email" = 'ther@ap.ist') AND "scheduledAt" = '2002-10-19 10:23:54+02'), (SELECT "id" FROM "activities" WHERE "title" = 'activity title'), (SELECT "id" FROM "environments" WHERE "title" = 'environment title'), (SELECT "id" FROM "subGoals" WHERE "serialNum" = 4 AND "goalId" = (SELECT "id" FROM "goals" WHERE "description" = 'goal description')), 'true'),
((SELECT "id" FROM "sessions" WHERE "therapistId" = (SELECT "id" FROM "users" WHERE "email" = 'ther@ap.ist') AND "scheduledAt" = '2002-10-19 10:23:54+02'), (SELECT "id" FROM "activities" WHERE "title" = 'activity title'), (SELECT "id" FROM "environments" WHERE "title" = 'environment title'), (SELECT "id" FROM "subGoals" WHERE "serialNum" = 4 AND "goalId" = (SELECT "id" FROM "goals" WHERE "description" = 'goal description')), 'false');

INSERT INTO "attempt_assistance" ("attemptId", "assistanceId")
VALUES
(1, (SELECT "id" FROM "activities" WHERE "title" = 'activity title')),
(2, (SELECT "id" FROM "activities" WHERE "title" = 'activity title'));

INSERT INTO "session_goal" ("sessionId", "goalId", "priority")
VALUES
((SELECT "id" FROM "sessions" WHERE "therapistId" = (SELECT "id" FROM "users" WHERE "email" = 'ther@ap.ist') AND "scheduledAt" = '2002-10-19 10:23:54+02'), (SELECT "id" FROM "goals" WHERE "description" = 'goal description'), 1),
((SELECT "id" FROM "sessions" WHERE "therapistId" = (SELECT "id" FROM "users" WHERE "email" = 'ther@ap.ist') AND "scheduledAt" = '2002-10-19 10:23:54+02'), (SELECT "id" FROM "goals" WHERE "description" = 'another goal description'), 2);

INSERT INTO "items" ("title", "patientId")
VALUES
('item title', (SELECT "id" FROM "patients" WHERE "fullName" = 'patient name' AND "birthDate" = '1992-04-24')),
('item title2', (SELECT "id" FROM "patients" WHERE "fullName" = 'patient name' AND "birthDate" = '1992-04-24')),
('item title3', (SELECT "id" FROM "patients" WHERE "fullName" = 'patient name' AND "birthDate" = '1992-04-24')),
('item title4', (SELECT "id" FROM "patients" WHERE "fullName" = 'patient name' AND "birthDate" = '1992-04-24')),
('item title', (SELECT "id" FROM "patients" WHERE "fullName" = 'an even patienter name' AND "birthDate" = '2002-07-24')),
('item title2', (SELECT "id" FROM "patients" WHERE "fullName" = 'an even patienter name' AND "birthDate" = '2002-07-24'));

INSERT INTO "activity_item" ("activityId", "itemId")
VALUES
((SELECT "id" FROM "activities" WHERE "title" = 'activity title'), (SELECT "id" FROM "items" WHERE "title" = 'item title' AND "patientId" = (SELECT "id" FROM "patients" WHERE "fullName" = 'patient name' AND "birthDate" = '1992-04-24'))),
((SELECT "id" FROM "activities" WHERE "title" = 'activity title'), (SELECT "id" FROM "items" WHERE "title" = 'item title2' AND "patientId" = (SELECT "id" FROM "patients" WHERE "fullName" = 'patient name' AND "birthDate" = '1992-04-24')));

INSERT INTO "words" ("body")
VALUES
('word1'),
('word2'),
('word3');

INSERT INTO "patient_word" ("patientId", "wordId")
VALUES
((SELECT "id" FROM "patients" WHERE "fullName" = 'patient name' AND "birthDate" = '1992-04-24'), (SELECT "id" FROM "words" WHERE "body" = 'word1')),
((SELECT "id" FROM "patients" WHERE "fullName" = 'patient name' AND "birthDate" = '1992-04-24'), (SELECT "id" FROM "words" WHERE "body" = 'word2'));

INSERT INTO "goal_word" ("goalId", "wordId")
VALUES
((SELECT "id" FROM "goals" WHERE "description" = 'goal description'), (SELECT "id" FROM "words" WHERE "body" = 'word1')),
((SELECT "id" FROM "goals" WHERE "description" = 'goal description'), (SELECT "id" FROM "words" WHERE "body" = 'word2'));

INSERT INTO "skills" ("title", "patientId", "skillTypeId", "acquired")
VALUES
('skill title', (SELECT "id" FROM "patients" WHERE "fullName" = 'patient name' AND "birthDate" = '1992-04-24'), (SELECT "id" FROM "skillTypes" WHERE "title" = 'skillType1'), 'true'),
('skill title', (SELECT "id" FROM "patients" WHERE "fullName" = 'patient name' AND "birthDate" = '1992-04-24'), (SELECT "id" FROM "skillTypes" WHERE "title" = 'skillType2'), 'false');
