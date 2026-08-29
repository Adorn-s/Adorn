-- 1) Create the table
create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  description text default '',
  price text default '',
  image_url text default '',
  storage_path text default '',
  created_at timestamptz not null default now()
);

-- 2) Turn on Row Level Security
alter table public.products enable row level security;

-- PUBLIC can read products
create policy "Public can view products"
on public.products for select
using (true);

-- IMPORTANT: replace YOUR_EMAIL@example.com with the exact Owner email
create policy "Owner can insert products"
on public.products for insert to authenticated
with check (lower((auth.jwt() ->> 'email')) = lower('YOUR_EMAIL@example.com'));

create policy "Owner can update products"
on public.products for update to authenticated
using (lower((auth.jwt() ->> 'email')) = lower('YOUR_EMAIL@example.com'))
with check (lower((auth.jwt() ->> 'email')) = lower('YOUR_EMAIL@example.com'));

create policy "Owner can delete products"
on public.products for delete to authenticated
using (lower((auth.jwt() ->> 'email')) = lower('YOUR_EMAIL@example.com'));

-- 3) Create a public storage bucket named product-images in Storage.
-- In Supabase Dashboard: Storage -> New bucket -> Name: product-images -> Public: ON
-- Then add these Storage policies in SQL editor, replacing the email as above.

create policy "Owner can upload product images"
on storage.objects for insert to authenticated
with check (bucket_id = 'product-images' and lower((auth.jwt() ->> 'email')) = lower('YOUR_EMAIL@example.com'));

create policy "Owner can update product images"
on storage.objects for update to authenticated
using (bucket_id = 'product-images' and lower((auth.jwt() ->> 'email')) = lower('YOUR_EMAIL@example.com'))
with check (bucket_id = 'product-images' and lower((auth.jwt() ->> 'email')) = lower('YOUR_EMAIL@example.com'));

create policy "Owner can delete product images"
on storage.objects for delete to authenticated
using (bucket_id = 'product-images' and lower((auth.jwt() ->> 'email')) = lower('YOUR_EMAIL@example.com'));
