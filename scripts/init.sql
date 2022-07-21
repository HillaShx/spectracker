CREATE TYPE role AS ENUM ('manager', 'therapist', 'parent');



CREATE TABLE "users" (
  "id" int PRIMARY KEY,
  "fullName" varchar NOT NULL,
  "email" varchar UNIQUE NOT NULL,
  "role" role,
  "createdAt" timestamp,
  "updatedAt" timestamp
);

CREATE TABLE "patients" (
  "id" int PRIMARY KEY,
  "fullName" varchar NOT NULL,
  "birthDate" timestamp NOT NULL,
  "createdAt" timestamp,
  "updatedAt" timestamp
);

CREATE TABLE "user_patient" (
  "userId" int,
  "patientId" int
);

CREATE TABLE "goals" (
  "id" int PRIMARY KEY,
  "serialNum" int NOT NULL,
  "description" text NOT NULL,
  "patientId" int NOT NULL,
  "skillType" int,
  "minTherapists" int NOT NULL,
  "minConsecutiveDays" int NOT NULL,
  "archived" bool NOT NULL DEFAULT false,
  "createdAt" timestamp,
  "updatedAt" timestamp
);

CREATE TABLE "subGoals" (
  "id" int PRIMARY KEY,
  "serialNum" int NOT NULL,
  "description" text NOT NULL,
  "goalId" int NOT NULL,
  "doneAt" timestamp,
  "createdAt" timestamp,
  "updatedAt" timestamp
);

CREATE TABLE "environments" (
  "id" int PRIMARY KEY,
  "title" varchar UNIQUE NOT NULL,
  "createdAt" timestamp,
  "updatedAt" timestamp
);

CREATE TABLE "activities" (
  "id" int PRIMARY KEY,
  "title" varchar UNIQUE,
  "description" text,
  "patientId" int,
  "colorId" int,
  "createdAt" timestamp,
  "updatedAt" timestamp
);

CREATE TABLE "colors" (
  "id" int PRIMARY KEY,
  "hexaCode" varchar,
  "createdAt" timestamp,
  "updatedAt" timestamp
);

CREATE TABLE "assistances" (
  "id" int PRIMARY KEY,
  "title" varchar UNIQUE,
  "createdAt" timestamp,
  "updatedAt" timestamp
);

CREATE TABLE "activity_assistance" (
  "activityId" int,
  "assistanceId" int,
  "priority" int NOT NULL
);

CREATE TABLE "activity_environment" (
  "activityId" int,
  "environmentId" int,
  "default" bool NOT NULL DEFAULT false
);

CREATE TABLE "goal_activity" (
  "goalId" int,
  "activityId" int
);

CREATE TABLE "sessions" (
  "id" int PRIMARY KEY,
  "patientId" int NOT NULL,
  "therapistId" int NOT NULL,
  "scheduledAt" timestamp,
  "duration" float,
  "sessionPlanMessage" text,
  "sessionSummaryMessage" text,
  "createdAt" timestamp,
  "updatedAt" timestamp
);

CREATE TABLE "session_activities" (
  "sessionId" int,
  "activityId" int,
  "recommended" bool DEFAULT false
);

CREATE TABLE "attempts" (
  "id" int PRIMARY KEY,
  "sessionId" int,
  "activityId" int,
  "environmentId" int,
  "subGoalId" int,
  "successful" bool NOT NULL,
  "createdAt" timestamp,
  "updatedAt" timestamp
);

CREATE TABLE "attempt_assistances" (
  "attemptId" int,
  "assistanceId" int
);

CREATE TABLE "session_goal" (
  "sessionId" int,
  "goalId" int,
  "priority" int
);

CREATE TABLE "items" (
  "id" int PRIMARY KEY,
  "title" varchar,
  "patientId" int,
  "createdAt" timestamp,
  "updatedAt" timestamp
);

CREATE TABLE "activity_items" (
  "itemId" int,
  "goalId" int
);

CREATE TABLE "words" (
  "id" int PRIMARY KEY,
  "title" varchar,
  "createdAt" timestamp,
  "updatedAt" timestamp
);

CREATE TABLE "patient_word" (
  "patientId" int,
  "wordId" int
);

CREATE TABLE "goal_word" (
  "goalId" int,
  "wordId" int
);

CREATE TABLE "skills" (
  "id" int PRIMARY KEY,
  "title" varchar,
  "patientId" int,
  "skillType" int,
  "acquired" bool,
  "createdAt" timestamp,
  "updatedAt" timestamp
);

CREATE TABLE "skill_types" (
  "id" int PRIMARY KEY,
  "title" varchar,
  "level" int,
  "createdAt" timestamp,
  "updatedAt" timestamp
);

ALTER TABLE "user_patient" ADD FOREIGN KEY ("userId") REFERENCES "users" ("id");

ALTER TABLE "user_patient" ADD FOREIGN KEY ("patientId") REFERENCES "patients" ("id");

ALTER TABLE "goals" ADD FOREIGN KEY ("patientId") REFERENCES "patients" ("id");

ALTER TABLE "goals" ADD FOREIGN KEY ("skillType") REFERENCES "skill_types" ("id");

ALTER TABLE "subGoals" ADD FOREIGN KEY ("goalId") REFERENCES "goals" ("id");

ALTER TABLE "subGoals" ADD FOREIGN KEY ("id") REFERENCES "goals" ("id") ON DELETE CASCADE;

ALTER TABLE "activities" ADD FOREIGN KEY ("patientId") REFERENCES "patients" ("id");

ALTER TABLE "activities" ADD FOREIGN KEY ("colorId") REFERENCES "colors" ("id");

ALTER TABLE "activity_assistance" ADD FOREIGN KEY ("activityId") REFERENCES "activities" ("id");

ALTER TABLE "activity_assistance" ADD FOREIGN KEY ("assistanceId") REFERENCES "assistances" ("id");

ALTER TABLE "activity_environment" ADD FOREIGN KEY ("activityId") REFERENCES "activities" ("id");

ALTER TABLE "activity_environment" ADD FOREIGN KEY ("environmentId") REFERENCES "environments" ("id");

ALTER TABLE "goal_activity" ADD FOREIGN KEY ("goalId") REFERENCES "goals" ("id");

ALTER TABLE "goal_activity" ADD FOREIGN KEY ("activityId") REFERENCES "activities" ("id");

ALTER TABLE "sessions" ADD FOREIGN KEY ("patientId") REFERENCES "patients" ("id");

ALTER TABLE "sessions" ADD FOREIGN KEY ("therapistId") REFERENCES "users" ("id");

ALTER TABLE "session_activities" ADD FOREIGN KEY ("sessionId") REFERENCES "sessions" ("id");

ALTER TABLE "session_activities" ADD FOREIGN KEY ("activityId") REFERENCES "activities" ("id");

ALTER TABLE "attempts" ADD FOREIGN KEY ("sessionId") REFERENCES "sessions" ("id");

ALTER TABLE "attempts" ADD FOREIGN KEY ("activityId") REFERENCES "activities" ("id");

ALTER TABLE "attempts" ADD FOREIGN KEY ("environmentId") REFERENCES "environments" ("id");

ALTER TABLE "attempts" ADD FOREIGN KEY ("subGoalId") REFERENCES "subGoals" ("id");

ALTER TABLE "attempt_assistances" ADD FOREIGN KEY ("attemptId") REFERENCES "attempts" ("id");

ALTER TABLE "attempt_assistances" ADD FOREIGN KEY ("assistanceId") REFERENCES "assistances" ("id");

ALTER TABLE "session_goal" ADD FOREIGN KEY ("sessionId") REFERENCES "sessions" ("id");

ALTER TABLE "session_goal" ADD FOREIGN KEY ("goalId") REFERENCES "goals" ("id");

ALTER TABLE "items" ADD FOREIGN KEY ("patientId") REFERENCES "patients" ("id");

ALTER TABLE "activity_items" ADD FOREIGN KEY ("itemId") REFERENCES "items" ("id");

ALTER TABLE "activity_items" ADD FOREIGN KEY ("goalId") REFERENCES "goals" ("id");

ALTER TABLE "patient_word" ADD FOREIGN KEY ("patientId") REFERENCES "patients" ("id");

ALTER TABLE "patient_word" ADD FOREIGN KEY ("wordId") REFERENCES "words" ("id");

ALTER TABLE "goal_word" ADD FOREIGN KEY ("goalId") REFERENCES "goals" ("id");

ALTER TABLE "goal_word" ADD FOREIGN KEY ("wordId") REFERENCES "words" ("id");

ALTER TABLE "skills" ADD FOREIGN KEY ("patientId") REFERENCES "patients" ("id");

ALTER TABLE "skills" ADD FOREIGN KEY ("skillType") REFERENCES "skill_types" ("id");

CREATE UNIQUE INDEX ON "patients" ("fullName", "birthDate");

CREATE UNIQUE INDEX ON "goals" ("serialNum", "patientId");

CREATE UNIQUE INDEX ON "subGoals" ("serialNum", "goalId");

CREATE UNIQUE INDEX ON "activity_assistance" ("assistanceId", "activityId", "priority");

CREATE UNIQUE INDEX ON "items" ("title", "patientId");

CREATE UNIQUE INDEX ON "skill_types" ("title", "level");
