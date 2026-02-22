-- ═══════════════════════════════════════════════════════════════════
-- NOMIS — Fitness Schema + Seed Data
-- Run this entire file in Supabase SQL Editor
-- ═══════════════════════════════════════════════════════════════════

-- ── Programs ──────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS programs (
  id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  name        text        NOT NULL,
  description text,
  active      boolean     NOT NULL DEFAULT false,
  created_at  timestamptz NOT NULL DEFAULT now()
);

-- ── Exercises ─────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS exercises (
  id           uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  name         text        NOT NULL,
  muscle_group text        NOT NULL,
  equipment    text,
  difficulty   text        DEFAULT 'intermediate',
  created_at   timestamptz NOT NULL DEFAULT now()
);

-- ── Workout Plans (days inside a program) ─────────────────────────
CREATE TABLE IF NOT EXISTS workout_plans (
  id           uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  program_id   uuid        NOT NULL REFERENCES programs(id)  ON DELETE CASCADE,
  day_of_week  text        NOT NULL,
  muscle_group text,
  notes        text,
  created_at   timestamptz NOT NULL DEFAULT now()
);

-- ── Workout Plan Exercises ────────────────────────────────────────
CREATE TABLE IF NOT EXISTS workout_plan_exercises (
  id             uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  plan_id        uuid        NOT NULL REFERENCES workout_plans(id) ON DELETE CASCADE,
  exercise_id    uuid        NOT NULL REFERENCES exercises(id)     ON DELETE CASCADE,
  order_index    int         NOT NULL DEFAULT 0,
  target_sets    int,
  target_reps    text,
  target_weight  decimal,
  notes          text,
  created_at     timestamptz NOT NULL DEFAULT now()
);

-- ── Indexes ───────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_workout_plans_program    ON workout_plans(program_id);
CREATE INDEX IF NOT EXISTS idx_wpe_plan                 ON workout_plan_exercises(plan_id);
CREATE INDEX IF NOT EXISTS idx_wpe_exercise             ON workout_plan_exercises(exercise_id);
CREATE INDEX IF NOT EXISTS idx_exercises_muscle         ON exercises(muscle_group);

-- ═══════════════════════════════════════════════════════════════════
-- SEED: 53 Common Exercises
-- Only run once — check if exercises table is empty first
-- ═══════════════════════════════════════════════════════════════════
INSERT INTO exercises (name, muscle_group, equipment, difficulty) VALUES

-- Chest (11)
('Bench Press',              'chest',     'barbell',    'intermediate'),
('Incline Bench Press',      'chest',     'barbell',    'intermediate'),
('Decline Bench Press',      'chest',     'barbell',    'intermediate'),
('Dumbbell Press',           'chest',     'dumbbell',   'beginner'),
('Incline Dumbbell Press',   'chest',     'dumbbell',   'beginner'),
('Dumbbell Flyes',           'chest',     'dumbbell',   'beginner'),
('Cable Flyes',              'chest',     'cable',      'intermediate'),
('Push-ups',                 'chest',     'bodyweight', 'beginner'),
('Dips',                     'chest',     'bodyweight', 'intermediate'),
('Pec Deck',                 'chest',     'machine',    'beginner'),
('Chest Dips',               'chest',     'bodyweight', 'intermediate'),

-- Back (8)
('Deadlift',                 'back',      'barbell',    'advanced'),
('Barbell Row',              'back',      'barbell',    'intermediate'),
('Dumbbell Row',             'back',      'dumbbell',   'beginner'),
('Pull-ups',                 'back',      'bodyweight', 'intermediate'),
('Lat Pulldown',             'back',      'cable',      'beginner'),
('Seated Cable Row',         'back',      'cable',      'beginner'),
('T-Bar Row',                'back',      'barbell',    'intermediate'),
('Face Pulls',               'back',      'cable',      'beginner'),

-- Legs (10)
('Squat',                    'legs',      'barbell',    'intermediate'),
('Front Squat',              'legs',      'barbell',    'advanced'),
('Romanian Deadlift',        'legs',      'barbell',    'intermediate'),
('Leg Press',                'legs',      'machine',    'beginner'),
('Hack Squat',               'legs',      'machine',    'intermediate'),
('Leg Curl',                 'legs',      'machine',    'beginner'),
('Leg Extension',            'legs',      'machine',    'beginner'),
('Lunges',                   'legs',      'bodyweight', 'beginner'),
('Bulgarian Split Squat',    'legs',      'dumbbell',   'intermediate'),
('Calf Raises',              'legs',      'bodyweight', 'beginner'),

-- Shoulders (6)
('Overhead Press',           'shoulders', 'barbell',    'intermediate'),
('Dumbbell Shoulder Press',  'shoulders', 'dumbbell',   'beginner'),
('Lateral Raises',           'shoulders', 'dumbbell',   'beginner'),
('Front Raises',             'shoulders', 'dumbbell',   'beginner'),
('Rear Delt Flyes',          'shoulders', 'dumbbell',   'beginner'),
('Arnold Press',             'shoulders', 'dumbbell',   'intermediate'),

-- Arms (9)
('Barbell Curl',             'arms',      'barbell',    'beginner'),
('Dumbbell Curl',            'arms',      'dumbbell',   'beginner'),
('Hammer Curl',              'arms',      'dumbbell',   'beginner'),
('Preacher Curl',            'arms',      'barbell',    'beginner'),
('Cable Curl',               'arms',      'cable',      'beginner'),
('Tricep Pushdown',          'arms',      'cable',      'beginner'),
('Overhead Tricep Extension','arms',      'cable',      'beginner'),
('Skull Crushers',           'arms',      'barbell',    'intermediate'),
('Close-Grip Bench Press',   'arms',      'barbell',    'intermediate'),

-- Core (7)
('Planks',                   'core',      'bodyweight', 'beginner'),
('Crunches',                 'core',      'bodyweight', 'beginner'),
('Russian Twists',           'core',      'bodyweight', 'beginner'),
('Leg Raises',               'core',      'bodyweight', 'beginner'),
('Ab Wheel',                 'core',      'bodyweight', 'intermediate'),
('Cable Crunches',           'core',      'cable',      'intermediate'),
('Hanging Leg Raises',       'core',      'bodyweight', 'intermediate');
