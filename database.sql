-- drop table if exists expenses cascade;
-- drop table if exists reports cascade;
-- drop table if exists customers cascade;
-- drop table if exists users cascade;


create table if not exists users (
    id uuid primary key,
    name text not null,
    last_name text not null,
    email text not null unique,
    phone_number text not null,
    role text not null check (role in ('admin','user','accountant')),
    created_at timestamp with time zone default now()
);

create table if not exists customers (
    id uuid primary key default gen_random_uuid(),
    name text not null,
    phone_number text not null,
    email text not null,
    created_at timestamp with time zone default now()
);

create table if not exists reports (
    id uuid primary key default gen_random_uuid(),
    author text not null,
    customer_id uuid not null references customers(id) on delete cascade,
    detail text not null,
    price numeric not null,
    is_pending boolean not null default true,
    is_paid boolean not null default false,
    created_at timestamp with time zone default now()
);

create index if not exists idx_reports_customer_id on reports(customer_id);

create table if not exists expenses (
    id uuid primary key default gen_random_uuid(),
    name text not null,
    detail text not null,
    quantity integer not null,
    price numeric not null,
    created_at timestamp with time zone default now()
);

insert into users (id, name, last_name, email, phone_number, role)
values (
    '280ed459-f54e-4af3-b6d5',  -- id that Supabase Auth returns
    'Juan Manuel',             -- name
    'Velázquez',               -- last name
    'itzjuanmadev@proton.me', -- email
    '+595900000000',           -- phone number
    'admin'                    -- role
);
