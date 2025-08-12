-- Migration: 001_init.sql
-- Description: Initial database setup with enums, tables, and RLS policies
-- Created: 2025-08-11

-- Create enums
CREATE TYPE role_enum AS ENUM ('owner', 'admin', 'caregiver', 'viewer');
CREATE TYPE visibility_enum AS ENUM ('private', 'shared', 'public');

-- Create profiles table
CREATE TABLE profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID NOT NULL,
  household_id UUID,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  visibility visibility_enum DEFAULT 'private',
  settings JSONB DEFAULT '{}',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create members table
CREATE TABLE members (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  user_id UUID NOT NULL,
  role role_enum NOT NULL DEFAULT 'viewer',
  permissions JSONB DEFAULT '{}',
  assigned_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  assigned_by UUID,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(profile_id, user_id)
);

-- Create qr_codes table
CREATE TABLE qr_codes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  code VARCHAR(255) UNIQUE NOT NULL,
  link_url TEXT NOT NULL,
  settings JSONB DEFAULT '{}',
  preferences JSONB DEFAULT '{}',
  is_active BOOLEAN DEFAULT true,
  expires_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create care_instructions table
CREATE TABLE care_instructions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  content JSONB NOT NULL, -- Supports localization with structure: {"en": "...", "es": "...", etc.}
  category VARCHAR(100),
  priority INTEGER DEFAULT 1, -- 1 = low, 2 = medium, 3 = high
  is_active BOOLEAN DEFAULT true,
  created_by UUID,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create audit_logs table
CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  table_name VARCHAR(50) NOT NULL,
  record_id UUID NOT NULL,
  action VARCHAR(20) NOT NULL, -- INSERT, UPDATE, DELETE
  old_values JSONB,
  new_values JSONB,
  user_id UUID,
  profile_id UUID REFERENCES profiles(id),
  timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for performance
CREATE INDEX idx_profiles_owner_id ON profiles(owner_id);
CREATE INDEX idx_profiles_household_id ON profiles(household_id);
CREATE INDEX idx_members_profile_id ON members(profile_id);
CREATE INDEX idx_members_user_id ON members(user_id);
CREATE INDEX idx_qr_codes_profile_id ON qr_codes(profile_id);
CREATE INDEX idx_qr_codes_code ON qr_codes(code);
CREATE INDEX idx_care_instructions_profile_id ON care_instructions(profile_id);
CREATE INDEX idx_audit_logs_table_record ON audit_logs(table_name, record_id);
CREATE INDEX idx_audit_logs_profile_id ON audit_logs(profile_id);
CREATE INDEX idx_audit_logs_timestamp ON audit_logs(timestamp);

-- Enable Row Level Security (RLS)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE members ENABLE ROW LEVEL SECURITY;
ALTER TABLE qr_codes ENABLE ROW LEVEL SECURITY;
ALTER TABLE care_instructions ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;

-- RLS Policies for profiles table
-- Owner: full access on their own profile
CREATE POLICY "owners_full_access_profiles" ON profiles
  FOR ALL USING (owner_id = auth.uid());

-- Admin: limited write within assigned profile
CREATE POLICY "admin_access_profiles" ON profiles
  FOR SELECT USING (
    id IN (
      SELECT profile_id FROM members 
      WHERE user_id = auth.uid() AND role IN ('admin', 'owner')
    )
  );

CREATE POLICY "admin_update_profiles" ON profiles
  FOR UPDATE USING (
    id IN (
      SELECT profile_id FROM members 
      WHERE user_id = auth.uid() AND role IN ('admin', 'owner')
    )
  );

-- RLS Policies for members table
-- Owner: full access on their profile's members
CREATE POLICY "owners_full_access_members" ON members
  FOR ALL USING (
    profile_id IN (
      SELECT id FROM profiles WHERE owner_id = auth.uid()
    )
  );

-- Admin: limited access within assigned profile
CREATE POLICY "admin_read_members" ON members
  FOR SELECT USING (
    profile_id IN (
      SELECT profile_id FROM members 
      WHERE user_id = auth.uid() AND role IN ('admin', 'owner')
    )
  );

-- Caregiver: write access only on assigned member data
CREATE POLICY "caregiver_access_members" ON members
  FOR SELECT USING (
    profile_id IN (
      SELECT profile_id FROM members 
      WHERE user_id = auth.uid() AND role IN ('caregiver', 'admin', 'owner')
    )
  );

-- Viewer: read-only access
CREATE POLICY "viewer_read_members" ON members
  FOR SELECT USING (
    profile_id IN (
      SELECT profile_id FROM members 
      WHERE user_id = auth.uid()
    )
  );

-- RLS Policies for qr_codes table
CREATE POLICY "profile_members_access_qr_codes" ON qr_codes
  FOR SELECT USING (
    profile_id IN (
      SELECT profile_id FROM members 
      WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "admin_modify_qr_codes" ON qr_codes
  FOR ALL USING (
    profile_id IN (
      SELECT profile_id FROM members 
      WHERE user_id = auth.uid() AND role IN ('admin', 'owner')
    )
  );

-- RLS Policies for care_instructions table
CREATE POLICY "profile_members_read_care_instructions" ON care_instructions
  FOR SELECT USING (
    profile_id IN (
      SELECT profile_id FROM members 
      WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "caregiver_write_care_instructions" ON care_instructions
  FOR ALL USING (
    profile_id IN (
      SELECT profile_id FROM members 
      WHERE user_id = auth.uid() AND role IN ('caregiver', 'admin', 'owner')
    )
  );

-- RLS Policies for audit_logs table
CREATE POLICY "profile_members_read_audit_logs" ON audit_logs
  FOR SELECT USING (
    profile_id IN (
      SELECT profile_id FROM members 
      WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "system_insert_audit_logs" ON audit_logs
  FOR INSERT WITH CHECK (true); -- Allow system to insert audit logs

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_qr_codes_updated_at BEFORE UPDATE ON qr_codes
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_care_instructions_updated_at BEFORE UPDATE ON care_instructions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
