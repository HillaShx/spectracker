CREATE TYPE role AS ENUM ('admin', 'case_manager', 'therapist', 'parent');

CREATE TABLE "users" (
  "id" SERIAL PRIMARY KEY,
  "fullName" varchar NOT NULL,
  "email" varchar UNIQUE NOT NULL,
  "role" role DEFAULT 'therapist',
  "createdAt" timestamp NOT NULL DEFAULT NOW(),
  "updatedAt" timestamp NOT NULL DEFAULT NOW()
);

CREATE TABLE "patients" (
  "id" SERIAL PRIMARY KEY,
  "fullName" varchar NOT NULL,
  "birthDate" date NOT NULL,
  "createdAt" timestamp NOT NULL DEFAULT NOW(),
  "updatedAt" timestamp NOT NULL DEFAULT NOW()
);

CREATE TABLE "user_patient" (
  "userId" int NOT NULL REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "patientId" int NOT NULL REFERENCES patients(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE "skillTypes" (
  "id" SMALLSERIAL PRIMARY KEY,
  "title" varchar,
  "level" int,
  "createdAt" timestamp NOT NULL DEFAULT NOW(),
  "updatedAt" timestamp NOT NULL DEFAULT NOW()
);

CREATE TABLE "goals" (
  "id" SMALLSERIAL PRIMARY KEY,
  "serialNum" int NOT NULL,
  "description" text NOT NULL,
  "patientId" int NOT NULL REFERENCES patients(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "skillTypeId" int REFERENCES "skillTypes"(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "minTherapists" int NOT NULL,
  "minConsecutiveDays" int NOT NULL,
  "archived" bool NOT NULL DEFAULT false,
  "createdAt" timestamp NOT NULL DEFAULT NOW(),
  "updatedAt" timestamp NOT NULL DEFAULT NOW()
);

CREATE TABLE "subGoals" (
  "id" SMALLSERIAL PRIMARY KEY,
  "serialNum" int NOT NULL,
  "description" text NOT NULL,
  "goalId" int NOT NULL REFERENCES goals(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "completedAt" date,
  "createdAt" timestamp NOT NULL DEFAULT NOW(),
  "updatedAt" timestamp NOT NULL DEFAULT NOW()
);

CREATE TABLE "environments" (
  "id" SMALLSERIAL PRIMARY KEY,
  "title" varchar UNIQUE NOT NULL,
  "createdAt" timestamp NOT NULL DEFAULT NOW(),
  "updatedAt" timestamp NOT NULL DEFAULT NOW()
);

CREATE TABLE "activities" (
  "id" SMALLSERIAL PRIMARY KEY,
  "title" varchar UNIQUE,
  "description" text,
  "patientId" int REFERENCES patients(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "createdAt" timestamp NOT NULL DEFAULT NOW(),
  "updatedAt" timestamp NOT NULL DEFAULT NOW()
);

CREATE TABLE "assistances" (
  "id" SMALLSERIAL PRIMARY KEY,
  "title" varchar UNIQUE,
  "createdAt" timestamp NOT NULL DEFAULT NOW(),
  "updatedAt" timestamp NOT NULL DEFAULT NOW()
);

CREATE TABLE "activity_assistance" (
  "activityId" int NOT NULL REFERENCES activities(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "assistanceId" int NOT NULL REFERENCES assistances(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "priority" int NOT NULL
);

CREATE TABLE "activity_environment" (
  "activityId" int NOT NULL REFERENCES activities(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "environmentId" int NOT NULL REFERENCES environments(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "default" bool NOT NULL DEFAULT false
);

CREATE TABLE "goal_activity" (
  "goalId" int NOT NULL REFERENCES goals(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "activityId" int NOT NULL REFERENCES activities(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE "sessions" (
  "id" SERIAL PRIMARY KEY,
  "patientId" int NOT NULL REFERENCES patients(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "therapistId" int NOT NULL REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "scheduledAt" timestamp with time zone,
  "durationHr" float,
  "sessionPlanMessage" text,
  "sessionSummaryMessage" text,
  "createdAt" timestamp NOT NULL DEFAULT NOW(),
  "updatedAt" timestamp NOT NULL DEFAULT NOW()
);

CREATE TABLE "session_activity" (
  "sessionId" int NOT NULL REFERENCES sessions(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "activityId" int NOT NULL REFERENCES activities(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "recommended" bool DEFAULT false
);

CREATE TABLE "attempts" (
  "id" SERIAL PRIMARY KEY,
  "sessionId" int NOT NULL REFERENCES sessions(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "activityId" int NOT NULL REFERENCES activities(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "environmentId" int NOT NULL REFERENCES environments(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "subGoalId" int NOT NULL REFERENCES "subGoals"(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "successful" bool NOT NULL,
  "createdAt" timestamp NOT NULL DEFAULT NOW(),
  "updatedAt" timestamp NOT NULL DEFAULT NOW()
);

CREATE TABLE "attempt_assistance" (
  "attemptId" int NOT NULL REFERENCES attempts(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "assistanceId" int NOT NULL REFERENCES assistances(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE "session_goal" (
  "sessionId" int NOT NULL REFERENCES sessions(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "goalId" int NOT NULL REFERENCES goals(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "priority" int NOT NULL
);

CREATE TABLE "items" (
  "id" SMALLSERIAL PRIMARY KEY,
  "title" varchar,
  "patientId" int NOT NULL REFERENCES patients(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "createdAt" timestamp NOT NULL DEFAULT NOW(),
  "updatedAt" timestamp NOT NULL DEFAULT NOW()
);

CREATE TABLE "activity_item" (
  "activityId" int NOT NULL REFERENCES activities(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "itemId" int NOT NULL REFERENCES items(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE "words" (
  "id" SMALLSERIAL PRIMARY KEY,
  "body" varchar UNIQUE,
  "createdAt" timestamp NOT NULL DEFAULT NOW(),
  "updatedAt" timestamp NOT NULL DEFAULT NOW()
);

CREATE TABLE "patient_word" (
  "patientId" int NOT NULL REFERENCES patients(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "wordId" int NOT NULL REFERENCES words(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE "goal_word" (
  "goalId" int NOT NULL REFERENCES goals(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "wordId" int NOT NULL REFERENCES words(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE "skills" (
  "id" SMALLSERIAL PRIMARY KEY,
  "title" varchar,
  "patientId" int NOT NULL REFERENCES patients(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "skillTypeId" int NOT NULL REFERENCES "skillTypes"(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "acquired" bool,
  "createdAt" timestamp NOT NULL DEFAULT NOW(),
  "updatedAt" timestamp NOT NULL DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_set_ts_now
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER patients_set_ts_now
BEFORE UPDATE ON patients
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER goals_set_ts_now
BEFORE UPDATE ON goals
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER subGoals_set_ts_now
BEFORE UPDATE ON "subGoals"
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER environments_set_ts_now
BEFORE UPDATE ON environments
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER activities_set_ts_now
BEFORE UPDATE ON activities
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER assistances_set_ts_now
BEFORE UPDATE ON assistances
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER sessions_set_ts_now
BEFORE UPDATE ON sessions
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER attempts_set_ts_now
BEFORE UPDATE ON attempts
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER items_set_ts_now
BEFORE UPDATE ON items
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER words_set_ts_now
BEFORE UPDATE ON words
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER skills_set_ts_now
BEFORE UPDATE ON skills
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER skillTypes_set_ts_now
BEFORE UPDATE ON "skillTypes"
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE UNIQUE INDEX ON "patients" ("fullName", "birthDate");

CREATE UNIQUE INDEX ON "goals" ("serialNum", "patientId");

CREATE UNIQUE INDEX ON "subGoals" ("serialNum", "goalId");

CREATE UNIQUE INDEX ON "sessions" ("therapistId", "scheduledAt");

CREATE UNIQUE INDEX ON "items" ("title", "patientId");

CREATE UNIQUE INDEX ON "skillTypes" ("title", "level");

CREATE UNIQUE INDEX ON "activity_environment" ("activityId") WHERE "default" = 'true';
