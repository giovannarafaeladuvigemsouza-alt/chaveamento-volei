-- Shared state for the public Mesa Pro championship.
-- The application currently has no authentication, so anyone with the anon key
-- can read and update the championship. Do not put a service-role key in the browser.
create table if not exists public.championship_state (
  id text primary key check (id = 'default'),
  payload jsonb not null default '{"teams":[],"matches":[],"bo":3,"pts":11}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.championship_state enable row level security;

create policy "Public can read championship state"
  on public.championship_state for select to anon using (true);

create policy "Public can create championship state"
  on public.championship_state for insert to anon with check (id = 'default');

create policy "Public can update championship state"
  on public.championship_state for update to anon using (id = 'default') with check (id = 'default');

grant select, insert, update on public.championship_state to anon;

insert into public.championship_state (id)
values ('default')
on conflict (id) do nothing;
