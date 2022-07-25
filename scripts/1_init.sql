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
  "userId" int NOT NULL,
  "patientId" int NOT NULL
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
  "patientId" int NOT NULL,
  "skillTypeId" int,
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
  "goalId" int NOT NULL,
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
  "patientId" int,
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
  "activityId" int NOT NULL,
  "assistanceId" int NOT NULL,
  "priority" int NOT NULL
);

CREATE TABLE "activity_environment" (
  "activityId" int NOT NULL,
  "environmentId" int NOT NULL,
  "default" bool NOT NULL DEFAULT false
);

CREATE TABLE "goal_activity" (
  "goalId" int NOT NULL,
  "activityId" int NOT NULL
);

CREATE TABLE "sessions" (
  "id" SERIAL PRIMARY KEY,
  "patientId" int NOT NULL,
  "therapistId" int NOT NULL,
  "scheduledAt" timestamp with time zone,
  "durationHr" float,
  "sessionPlanMessage" text,
  "sessionSummaryMessage" text,
  "createdAt" timestamp NOT NULL DEFAULT NOW(),
  "updatedAt" timestamp NOT NULL DEFAULT NOW()
);

CREATE TABLE "session_activity" (
  "sessionId" int NOT NULL,
  "activityId" int NOT NULL,
  "recommended" bool DEFAULT false
);

CREATE TABLE "attempts" (
  "id" SERIAL PRIMARY KEY,
  "sessionId" int,
  "activityId" int,
  "environmentId" int,
  "subGoalId" int,
  "successful" bool NOT NULL,
  "createdAt" timestamp NOT NULL DEFAULT NOW(),
  "updatedAt" timestamp NOT NULL DEFAULT NOW()
);

CREATE TABLE "attempt_assistance" (
  "attemptId" int NOT NULL,
  "assistanceId" int NOT NULL
);

CREATE TABLE "session_goal" (
  "sessionId" int NOT NULL,
  "goalId" int NOT NULL,
  "priority" int NOT NULL
);

CREATE TABLE "items" (
  "id" SMALLSERIAL PRIMARY KEY,
  "title" varchar,
  "patientId" int,
  "createdAt" timestamp NOT NULL DEFAULT NOW(),
  "updatedAt" timestamp NOT NULL DEFAULT NOW()
);

CREATE TABLE "activity_item" (
  "activityId" int NOT NULL,
  "itemId" int NOT NULL
);

CREATE TABLE "words" (
  "id" SMALLSERIAL PRIMARY KEY,
  "body" varchar UNIQUE,
  "createdAt" timestamp NOT NULL DEFAULT NOW(),
  "updatedAt" timestamp NOT NULL DEFAULT NOW()
);

CREATE TABLE "patient_word" (
  "patientId" int NOT NULL,
  "wordId" int NOT NULL
);

CREATE TABLE "goal_word" (
  "goalId" int NOT NULL,
  "wordId" int NOT NULL
);

CREATE TABLE "skills" (
  "id" SMALLSERIAL PRIMARY KEY,
  "title" varchar,
  "patientId" int,
  "skillTypeId" int,
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

ALTER TABLE "user_patient" ADD FOREIGN KEY ("userId") REFERENCES "users" ("id");

ALTER TABLE "user_patient" ADD FOREIGN KEY ("patientId") REFERENCES "patients" ("id");

ALTER TABLE "goals" ADD FOREIGN KEY ("patientId") REFERENCES "patients" ("id");

ALTER TABLE "goals" ADD FOREIGN KEY ("skillTypeId") REFERENCES "skillTypes" ("id");

ALTER TABLE "subGoals" ADD FOREIGN KEY ("goalId") REFERENCES "goals" ("id");

ALTER TABLE "subGoals" ADD FOREIGN KEY ("id") REFERENCES "goals" ("id") ON DELETE CASCADE;

ALTER TABLE "activities" ADD FOREIGN KEY ("patientId") REFERENCES "patients" ("id");

ALTER TABLE "activity_assistance" ADD FOREIGN KEY ("activityId") REFERENCES "activities" ("id");

ALTER TABLE "activity_assistance" ADD FOREIGN KEY ("assistanceId") REFERENCES "assistances" ("id");

ALTER TABLE "activity_environment" ADD FOREIGN KEY ("activityId") REFERENCES "activities" ("id");

ALTER TABLE "activity_environment" ADD FOREIGN KEY ("environmentId") REFERENCES "environments" ("id");

ALTER TABLE "goal_activity" ADD FOREIGN KEY ("goalId") REFERENCES "goals" ("id");

ALTER TABLE "goal_activity" ADD FOREIGN KEY ("activityId") REFERENCES "activities" ("id");

ALTER TABLE "sessions" ADD FOREIGN KEY ("patientId") REFERENCES "patients" ("id");

ALTER TABLE "sessions" ADD FOREIGN KEY ("therapistId") REFERENCES "users" ("id");

ALTER TABLE "session_activity" ADD FOREIGN KEY ("sessionId") REFERENCES "sessions" ("id");

ALTER TABLE "session_activity" ADD FOREIGN KEY ("activityId") REFERENCES "activities" ("id");

ALTER TABLE "attempts" ADD FOREIGN KEY ("sessionId") REFERENCES "sessions" ("id");

ALTER TABLE "attempts" ADD FOREIGN KEY ("activityId") REFERENCES "activities" ("id");

ALTER TABLE "attempts" ADD FOREIGN KEY ("environmentId") REFERENCES "environments" ("id");

ALTER TABLE "attempts" ADD FOREIGN KEY ("subGoalId") REFERENCES "subGoals" ("id");

ALTER TABLE "attempt_assistance" ADD FOREIGN KEY ("attemptId") REFERENCES "attempts" ("id");

ALTER TABLE "attempt_assistance" ADD FOREIGN KEY ("assistanceId") REFERENCES "assistances" ("id");

ALTER TABLE "session_goal" ADD FOREIGN KEY ("sessionId") REFERENCES "sessions" ("id");

ALTER TABLE "session_goal" ADD FOREIGN KEY ("goalId") REFERENCES "goals" ("id");

ALTER TABLE "items" ADD FOREIGN KEY ("patientId") REFERENCES "patients" ("id");

ALTER TABLE "activity_item" ADD FOREIGN KEY ("activityId") REFERENCES "activities" ("id");

ALTER TABLE "activity_item" ADD FOREIGN KEY ("itemId") REFERENCES "items" ("id");

ALTER TABLE "patient_word" ADD FOREIGN KEY ("patientId") REFERENCES "patients" ("id");

ALTER TABLE "patient_word" ADD FOREIGN KEY ("wordId") REFERENCES "words" ("id");

ALTER TABLE "goal_word" ADD FOREIGN KEY ("goalId") REFERENCES "goals" ("id");

ALTER TABLE "goal_word" ADD FOREIGN KEY ("wordId") REFERENCES "words" ("id");

ALTER TABLE "skills" ADD FOREIGN KEY ("patientId") REFERENCES "patients" ("id");

ALTER TABLE "skills" ADD FOREIGN KEY ("skillTypeId") REFERENCES "skillTypes" ("id");

CREATE UNIQUE INDEX ON "patients" ("fullName", "birthDate");

CREATE UNIQUE INDEX ON "goals" ("serialNum", "patientId");

CREATE UNIQUE INDEX ON "subGoals" ("serialNum", "goalId");

CREATE UNIQUE INDEX ON "sessions" ("therapistId", "scheduledAt");

CREATE UNIQUE INDEX ON "items" ("title", "patientId");

CREATE UNIQUE INDEX ON "skillTypes" ("title", "level");

CREATE UNIQUE INDEX ON "activity_environment" ("activityId") WHERE "default" = 'true';
