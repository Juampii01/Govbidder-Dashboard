-- Centro Operativo: los SOPs/documentos guardan su contenido markdown en la
-- misma tabla resources. Hasta ahora la vista editaba `content` contra un
-- endpoint y columna inexistentes (solo funcionaba con datos mock en memoria).
-- Además, un SOP tipo "doc" no siempre tiene URL externa → url pasa a nullable.

alter table public.resources add column if not exists content text;
alter table public.resources alter column url drop not null;
