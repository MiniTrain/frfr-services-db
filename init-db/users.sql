create user frfr_services_app_user with password 'frfr_services_app_user';
grant usage on schema frfr to frfr_services_app_user;
grant SELECT, INSERT, UPDATE, DELETE, TRIGGER on all tables in schema frfr to frfr_services_app_user;
grant USAGE, SELECT on all sequences in schema frfr to frfr_services_app_user;
grant EXECUTE on all functions in schema frfr to frfr_services_app_user;