-- Seed Data: supabase/seed.sql
-- Description: Minimal seed data for initial database setup
-- Created: 2025-08-11
-- Note: Replace UUIDs and auth.uid() references with your actual user IDs in production

-- Sample data assumes these user IDs exist (replace with actual values)
-- User IDs should be valid Supabase Auth user UUIDs
-- For development, you can use: gen_random_uuid() or actual auth user IDs

-- Insert sample profiles
INSERT INTO profiles (id, owner_id, household_id, name, description, visibility, settings) VALUES
(
  '11111111-1111-1111-1111-111111111111',
  '22222222-2222-2222-2222-222222222222', -- Replace with actual owner auth user ID
  '33333333-3333-3333-3333-333333333333',
  'Smith Family Care Profile',
  'Primary care profile for the Smith household with medical information and emergency contacts.',
  'private',
  '{"emergency_contacts": ["Dr. Johnson: 555-0123"], "medical_alerts": ["Diabetes", "Penicillin allergy"]}'
),
(
  '44444444-4444-4444-4444-444444444444',
  '55555555-5555-5555-5555-555555555555', -- Replace with actual owner auth user ID
  '66666666-6666-6666-6666-666666666666',
  'Johnson Senior Care',
  'Care profile for elderly parent with detailed medication schedules and care instructions.',
  'shared',
  '{"care_level": "assisted_living", "primary_doctor": "Dr. Williams"}'
);

-- Insert sample members (users linked to profiles with roles)
INSERT INTO members (id, profile_id, user_id, role, permissions, assigned_by) VALUES
(
  '77777777-7777-7777-7777-777777777777',
  '11111111-1111-1111-1111-111111111111',
  '22222222-2222-2222-2222-222222222222', -- Profile owner
  'owner',
  '{"full_access": true, "can_modify_members": true, "can_delete_profile": true}',
  '22222222-2222-2222-2222-222222222222'
),
(
  '88888888-8888-8888-8888-888888888888',
  '11111111-1111-1111-1111-111111111111',
  '99999999-9999-9999-9999-999999999999', -- Replace with actual admin user ID
  'admin',
  '{"can_edit_instructions": true, "can_manage_qr_codes": true, "can_view_audit_logs": true}',
  '22222222-2222-2222-2222-222222222222'
),
(
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  '11111111-1111-1111-1111-111111111111',
  'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', -- Replace with actual caregiver user ID
  'caregiver',
  '{"can_update_care_instructions": true, "can_add_notes": true}',
  '22222222-2222-2222-2222-222222222222'
),
(
  'cccccccc-cccc-cccc-cccc-cccccccccccc',
  '44444444-4444-4444-4444-444444444444',
  '55555555-5555-5555-5555-555555555555', -- Profile owner
  'owner',
  '{"full_access": true, "can_modify_members": true, "can_delete_profile": true}',
  '55555555-5555-5555-5555-555555555555'
);

-- Insert sample QR codes
INSERT INTO qr_codes (id, profile_id, code, link_url, settings, preferences, is_active, expires_at) VALUES
(
  'dddddddd-dddd-dddd-dddd-dddddddddddd',
  '11111111-1111-1111-1111-111111111111',
  'SMITH_CARE_001',
  'https://your-app-domain.com/care/smith-family',
  '{"scan_tracking": true, "location_logging": false}',
  '{"default_view": "emergency_info", "show_medical_alerts": true}',
  true,
  '2026-08-11 00:00:00+00' -- Expires in 1 year
),
(
  'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
  '44444444-4444-4444-4444-444444444444',
  'JOHNSON_SENIOR_002',
  'https://your-app-domain.com/care/johnson-senior',
  '{"scan_tracking": true, "location_logging": true, "emergency_mode": true}',
  '{"default_view": "medication_schedule", "show_emergency_contacts": true}',
  true,
  '2026-08-11 00:00:00+00'
);

-- Insert sample care instructions
INSERT INTO care_instructions (id, profile_id, title, content, category, priority, is_active, created_by) VALUES
(
  'ffffffff-ffff-ffff-ffff-ffffffffffff',
  '11111111-1111-1111-1111-111111111111',
  'Daily Medication Schedule',
  '{
    "en": "Take diabetes medication (Metformin 500mg) twice daily with meals. Morning dose at 8 AM, evening dose at 6 PM. Monitor blood sugar before each dose.",
    "es": "Tomar medicamento para diabetes (Metformina 500mg) dos veces al día con las comidas. Dosis matutina a las 8 AM, dosis nocturna a las 6 PM. Monitorear azúcar en sangre antes de cada dosis."
  }',
  'medication',
  3, -- High priority
  true,
  '22222222-2222-2222-2222-222222222222'
),
(
  '10101010-1010-1010-1010-101010101010',
  '11111111-1111-1111-1111-111111111111',
  'Emergency Contact Information',
  '{
    "en": "In case of emergency, contact: Dr. Johnson at 555-0123 (Primary), Jane Smith at 555-0456 (Daughter), or call 911. Patient has diabetes and is allergic to penicillin.",
    "es": "En caso de emergencia, contactar: Dr. Johnson al 555-0123 (Primario), Jane Smith al 555-0456 (Hija), o llamar al 911. El paciente tiene diabetes y es alérgico a la penicilina."
  }',
  'emergency',
  3, -- High priority
  true,
  '22222222-2222-2222-2222-222222222222'
),
(
  '20202020-2020-2020-2020-202020202020',
  '44444444-4444-4444-4444-444444444444',
  'Physical Therapy Routine',
  '{
    "en": "Daily gentle exercises: 10 minutes of walking, 5 minutes of arm stretches, 10 minutes of leg exercises. Avoid overexertion. If experiencing pain, stop immediately and rest.",
    "es": "Ejercicios diarios suaves: 10 minutos de caminar, 5 minutos de estiramientos de brazo, 10 minutos de ejercicios de piernas. Evitar el exceso. Si experimenta dolor, pare inmediatamente y descanse."
  }',
  'therapy',
  2, -- Medium priority
  true,
  '55555555-5555-5555-5555-555555555555'
),
(
  '30303030-3030-3030-3030-303030303030',
  '44444444-4444-4444-4444-444444444444',
  'Dietary Restrictions',
  '{
    "en": "Low sodium diet required. Avoid processed foods, limit salt intake to 2g per day. Increase intake of fresh fruits and vegetables. Preferred meal times: 7 AM, 12 PM, 6 PM.",
    "es": "Se requiere dieta baja en sodio. Evitar alimentos procesados, limitar la ingesta de sal a 2g por día. Aumentar la ingesta de frutas y verduras frescas. Horarios de comida preferidos: 7 AM, 12 PM, 6 PM."
  }',
  'nutrition',
  2, -- Medium priority
  true,
  '55555555-5555-5555-5555-555555555555'
);

-- Insert sample audit log entries (these would typically be created by triggers or application code)
INSERT INTO audit_logs (id, table_name, record_id, action, old_values, new_values, user_id, profile_id) VALUES
(
  '40404040-4040-4040-4040-404040404040',
  'profiles',
  '11111111-1111-1111-1111-111111111111',
  'INSERT',
  null,
  '{"name": "Smith Family Care Profile", "visibility": "private"}',
  '22222222-2222-2222-2222-222222222222',
  '11111111-1111-1111-1111-111111111111'
),
(
  '50505050-5050-5050-5050-505050505050',
  'care_instructions',
  'ffffffff-ffff-ffff-ffff-ffffffffffff',
  'INSERT',
  null,
  '{"title": "Daily Medication Schedule", "category": "medication", "priority": 3}',
  '22222222-2222-2222-2222-222222222222',
  '11111111-1111-1111-1111-111111111111'
),
(
  '60606060-6060-6060-6060-606060606060',
  'members',
  '88888888-8888-8888-8888-888888888888',
  'INSERT',
  null,
  '{"user_id": "99999999-9999-9999-9999-999999999999", "role": "admin"}',
  '22222222-2222-2222-2222-222222222222',
  '11111111-1111-1111-1111-111111111111'
);

-- Add comments for guidance
-- Note: In a real application, you would:
-- 1. Replace all placeholder UUIDs with actual Supabase Auth user IDs
-- 2. Ensure proper user authentication is in place before running seeds
-- 3. Consider using environment variables for sensitive data
-- 4. Validate that all referenced user IDs exist in auth.users
-- 5. Set up proper RLS policies to protect this data
-- 6. Use transactions to ensure data consistency during seeding
