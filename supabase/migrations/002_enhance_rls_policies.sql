-- Migration: 002_enhance_rls_policies.sql
-- Description: Enhanced Row Level Security policies with improved granular access control
-- Created: 2025-08-12
-- Depends on: 001_init.sql

-- ============================================================================
-- STORAGE BUCKET POLICIES
-- ============================================================================

-- Create storage buckets if they don't exist
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES 
  ('profile-media', 'profile-media', false, 52428800, ARRAY['image/jpeg', 'image/png', 'image/gif', 'image/webp']),
  ('care-documents', 'care-documents', false, 104857600, ARRAY['application/pdf', 'image/jpeg', 'image/png', 'text/plain'])
ON CONFLICT (id) DO NOTHING;

-- Storage bucket policies for profile-media
CREATE POLICY "profile_members_view_media" ON storage.objects
  FOR SELECT USING (
    bucket_id = 'profile-media' AND
    auth.uid() IS NOT NULL AND
    (storage.foldername(name))[1] IN (
      SELECT profile_id::text FROM members WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "profile_admins_upload_media" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'profile-media' AND
    auth.uid() IS NOT NULL AND
    (storage.foldername(name))[1] IN (
      SELECT profile_id::text FROM members 
      WHERE user_id = auth.uid() AND role IN ('admin', 'owner')
    )
  );

CREATE POLICY "profile_admins_update_media" ON storage.objects
  FOR UPDATE USING (
    bucket_id = 'profile-media' AND
    auth.uid() IS NOT NULL AND
    (storage.foldername(name))[1] IN (
      SELECT profile_id::text FROM members 
      WHERE user_id = auth.uid() AND role IN ('admin', 'owner')
    )
  );

CREATE POLICY "profile_admins_delete_media" ON storage.objects
  FOR DELETE USING (
    bucket_id = 'profile-media' AND
    auth.uid() IS NOT NULL AND
    (storage.foldername(name))[1] IN (
      SELECT profile_id::text FROM members 
      WHERE user_id = auth.uid() AND role IN ('admin', 'owner')
    )
  );

-- Storage bucket policies for care-documents
CREATE POLICY "profile_members_view_documents" ON storage.objects
  FOR SELECT USING (
    bucket_id = 'care-documents' AND
    auth.uid() IS NOT NULL AND
    (storage.foldername(name))[1] IN (
      SELECT profile_id::text FROM members WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "caregivers_upload_documents" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'care-documents' AND
    auth.uid() IS NOT NULL AND
    (storage.foldername(name))[1] IN (
      SELECT profile_id::text FROM members 
      WHERE user_id = auth.uid() AND role IN ('caregiver', 'admin', 'owner')
    )
  );

CREATE POLICY "caregivers_update_documents" ON storage.objects
  FOR UPDATE USING (
    bucket_id = 'care-documents' AND
    auth.uid() IS NOT NULL AND
    (storage.foldername(name))[1] IN (
      SELECT profile_id::text FROM members 
      WHERE user_id = auth.uid() AND role IN ('caregiver', 'admin', 'owner')
    )
  );

CREATE POLICY "admins_delete_documents" ON storage.objects
  FOR DELETE USING (
    bucket_id = 'care-documents' AND
    auth.uid() IS NOT NULL AND
    (storage.foldername(name))[1] IN (
      SELECT profile_id::text FROM members 
      WHERE user_id = auth.uid() AND role IN ('admin', 'owner')
    )
  );

-- ============================================================================
-- ENHANCED TABLE POLICIES
-- ============================================================================

-- Drop existing policies to replace with enhanced versions
DROP POLICY IF EXISTS "admin_access_profiles" ON profiles;
DROP POLICY IF EXISTS "admin_update_profiles" ON profiles;
DROP POLICY IF EXISTS "admin_read_members" ON members;
DROP POLICY IF EXISTS "caregiver_access_members" ON members;
DROP POLICY IF EXISTS "viewer_read_members" ON members;
DROP POLICY IF EXISTS "profile_members_access_qr_codes" ON qr_codes;
DROP POLICY IF EXISTS "admin_modify_qr_codes" ON qr_codes;
DROP POLICY IF EXISTS "profile_members_read_care_instructions" ON care_instructions;
DROP POLICY IF EXISTS "caregiver_write_care_instructions" ON care_instructions;
DROP POLICY IF EXISTS "profile_members_read_audit_logs" ON audit_logs;

-- Enhanced profiles table policies
CREATE POLICY "profile_members_read_profiles" ON profiles
  FOR SELECT USING (
    auth.uid() IS NOT NULL AND (
      -- Owner has full access
      owner_id = auth.uid() OR
      -- Members can read their assigned profiles
      id IN (
        SELECT profile_id FROM members 
        WHERE user_id = auth.uid()
      ) OR
      -- Public profiles are readable by anyone
      visibility = 'public' OR
      -- Shared profiles are readable by authenticated users
      (visibility = 'shared' AND auth.uid() IS NOT NULL)
    )
  );

CREATE POLICY "profile_admins_update_profiles" ON profiles
  FOR UPDATE USING (
    auth.uid() IS NOT NULL AND
    id IN (
      SELECT profile_id FROM members 
      WHERE user_id = auth.uid() AND role IN ('admin', 'owner')
    )
  ) WITH CHECK (
    auth.uid() IS NOT NULL AND
    id IN (
      SELECT profile_id FROM members 
      WHERE user_id = auth.uid() AND role IN ('admin', 'owner')
    )
  );

CREATE POLICY "profile_owners_delete_profiles" ON profiles
  FOR DELETE USING (
    auth.uid() IS NOT NULL AND
    owner_id = auth.uid()
  );

-- Enhanced members table policies
CREATE POLICY "profile_members_read_members" ON members
  FOR SELECT USING (
    auth.uid() IS NOT NULL AND
    profile_id IN (
      SELECT profile_id FROM members 
      WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "profile_admins_manage_members" ON members
  FOR ALL USING (
    auth.uid() IS NOT NULL AND
    profile_id IN (
      SELECT profile_id FROM members 
      WHERE user_id = auth.uid() AND role IN ('admin', 'owner')
    )
  ) WITH CHECK (
    auth.uid() IS NOT NULL AND
    profile_id IN (
      SELECT profile_id FROM members 
      WHERE user_id = auth.uid() AND role IN ('admin', 'owner')
    )
  );

-- Users can only modify their own member record (limited fields)
CREATE POLICY "users_update_own_member_record" ON members
  FOR UPDATE USING (
    auth.uid() IS NOT NULL AND
    user_id = auth.uid()
  ) WITH CHECK (
    auth.uid() IS NOT NULL AND
    user_id = auth.uid() AND
    -- Only allow updating permissions, not role or profile_id
    OLD.role = NEW.role AND
    OLD.profile_id = NEW.profile_id AND
    OLD.user_id = NEW.user_id
  );

-- Enhanced QR codes table policies
CREATE POLICY "profile_members_read_qr_codes" ON qr_codes
  FOR SELECT USING (
    auth.uid() IS NOT NULL AND
    profile_id IN (
      SELECT profile_id FROM members 
      WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "profile_admins_manage_qr_codes" ON qr_codes
  FOR ALL USING (
    auth.uid() IS NOT NULL AND
    profile_id IN (
      SELECT profile_id FROM members 
      WHERE user_id = auth.uid() AND role IN ('admin', 'owner')
    )
  ) WITH CHECK (
    auth.uid() IS NOT NULL AND
    profile_id IN (
      SELECT profile_id FROM members 
      WHERE user_id = auth.uid() AND role IN ('admin', 'owner')
    )
  );

-- Enhanced care instructions table policies
CREATE POLICY "profile_members_read_care_instructions" ON care_instructions
  FOR SELECT USING (
    auth.uid() IS NOT NULL AND
    profile_id IN (
      SELECT profile_id FROM members 
      WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "caregivers_manage_care_instructions" ON care_instructions
  FOR ALL USING (
    auth.uid() IS NOT NULL AND
    profile_id IN (
      SELECT profile_id FROM members 
      WHERE user_id = auth.uid() AND role IN ('caregiver', 'admin', 'owner')
    )
  ) WITH CHECK (
    auth.uid() IS NOT NULL AND
    profile_id IN (
      SELECT profile_id FROM members 
      WHERE user_id = auth.uid() AND role IN ('caregiver', 'admin', 'owner')
    )
  );

-- Enhanced audit logs table policies
CREATE POLICY "profile_members_read_audit_logs" ON audit_logs
  FOR SELECT USING (
    auth.uid() IS NOT NULL AND (
      profile_id IN (
        SELECT profile_id FROM members 
        WHERE user_id = auth.uid()
      ) OR
      -- Users can see audit logs for records they have access to
      (table_name = 'profiles' AND record_id::uuid IN (
        SELECT id FROM profiles WHERE 
        owner_id = auth.uid() OR
        id IN (SELECT profile_id FROM members WHERE user_id = auth.uid())
      ))
    )
  );

-- System and authenticated users can insert audit logs
CREATE POLICY "authenticated_users_insert_audit_logs" ON audit_logs
  FOR INSERT WITH CHECK (
    auth.uid() IS NOT NULL
  );

-- ============================================================================
-- SECURITY FUNCTIONS
-- ============================================================================

-- Function to check if user has specific role on profile
CREATE OR REPLACE FUNCTION auth.has_profile_role(profile_uuid UUID, required_role role_enum)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM members 
    WHERE profile_id = profile_uuid 
    AND user_id = auth.uid() 
    AND role >= required_role
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get user's highest role on profile
CREATE OR REPLACE FUNCTION auth.get_user_profile_role(profile_uuid UUID)
RETURNS role_enum AS $$
DECLARE
  user_role role_enum;
BEGIN
  SELECT role INTO user_role
  FROM members 
  WHERE profile_id = profile_uuid 
  AND user_id = auth.uid()
  ORDER BY 
    CASE role 
      WHEN 'owner' THEN 4
      WHEN 'admin' THEN 3
      WHEN 'caregiver' THEN 2
      WHEN 'viewer' THEN 1
    END DESC
  LIMIT 1;
  
  RETURN COALESCE(user_role, 'viewer'::role_enum);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to audit table changes
CREATE OR REPLACE FUNCTION audit.log_changes()
RETURNS TRIGGER AS $$
DECLARE
  profile_uuid UUID;
BEGIN
  -- Try to extract profile_id from the record
  CASE TG_TABLE_NAME
    WHEN 'profiles' THEN
      profile_uuid := COALESCE(NEW.id, OLD.id);
    WHEN 'members', 'qr_codes', 'care_instructions' THEN
      profile_uuid := COALESCE(NEW.profile_id, OLD.profile_id);
    ELSE
      profile_uuid := NULL;
  END CASE;

  INSERT INTO audit_logs (
    table_name,
    record_id,
    action,
    old_values,
    new_values,
    user_id,
    profile_id
  ) VALUES (
    TG_TABLE_NAME,
    COALESCE(NEW.id, OLD.id),
    TG_OP,
    CASE WHEN TG_OP = 'DELETE' THEN to_jsonb(OLD) ELSE NULL END,
    CASE WHEN TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN to_jsonb(NEW) ELSE NULL END,
    auth.uid(),
    profile_uuid
  );

  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- AUDIT TRIGGERS
-- ============================================================================

-- Create audit triggers for all tables
CREATE TRIGGER audit_profiles_changes
  AFTER INSERT OR UPDATE OR DELETE ON profiles
  FOR EACH ROW EXECUTE FUNCTION audit.log_changes();

CREATE TRIGGER audit_members_changes
  AFTER INSERT OR UPDATE OR DELETE ON members
  FOR EACH ROW EXECUTE FUNCTION audit.log_changes();

CREATE TRIGGER audit_qr_codes_changes
  AFTER INSERT OR UPDATE OR DELETE ON qr_codes
  FOR EACH ROW EXECUTE FUNCTION audit.log_changes();

CREATE TRIGGER audit_care_instructions_changes
  AFTER INSERT OR UPDATE OR DELETE ON care_instructions
  FOR EACH ROW EXECUTE FUNCTION audit.log_changes();

-- ============================================================================
-- ADDITIONAL SECURITY MEASURES
-- ============================================================================

-- Create index for performance on auth queries
CREATE INDEX IF NOT EXISTS idx_members_user_role ON members(user_id, role);
CREATE INDEX IF NOT EXISTS idx_members_profile_role ON members(profile_id, role);

-- Grant necessary permissions
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT EXECUTE ON FUNCTION auth.has_profile_role(UUID, role_enum) TO authenticated;
GRANT EXECUTE ON FUNCTION auth.get_user_profile_role(UUID) TO authenticated;

-- Create audit schema if it doesn't exist
CREATE SCHEMA IF NOT EXISTS audit;
GRANT USAGE ON SCHEMA audit TO service_role;
GRANT EXECUTE ON FUNCTION audit.log_changes() TO service_role;

-- ============================================================================
-- COMMENTS FOR DOCUMENTATION
-- ============================================================================

COMMENT ON FUNCTION auth.has_profile_role(UUID, role_enum) IS 
'Checks if the current authenticated user has at least the specified role on the given profile';

COMMENT ON FUNCTION auth.get_user_profile_role(UUID) IS 
'Returns the highest role the current authenticated user has on the given profile';

COMMENT ON FUNCTION audit.log_changes() IS 
'Trigger function that logs all changes to audited tables with user and profile context';

-- End of migration
