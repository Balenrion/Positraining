-- PosiTraining — table de synchro cloud (une ligne par utilisateur)
-- À exécuter une fois dans Supabase : SQL Editor → New query → coller → Run.

create table if not exists public.state (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.state enable row level security;

create policy "select own state" on public.state
  for select using (auth.uid() = user_id);

create policy "insert own state" on public.state
  for insert with check (auth.uid() = user_id);

create policy "update own state" on public.state
  for update using (auth.uid() = user_id);
