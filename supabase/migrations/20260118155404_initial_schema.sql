-- Create properties table
CREATE TABLE properties (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    owner_id UUID REFERENCES auth.users(id) NOT NULL,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    price NUMERIC NOT NULL,
    address TEXT NOT NULL,
    property_type TEXT NOT NULL, -- Apartment, House, Duplex, Commercial, Villa, Studio, Penthouse
    category TEXT NOT NULL DEFAULT 'Rent', -- Rent, Sale, Short-let
    bedrooms INTEGER NOT NULL,
    bathrooms INTEGER NOT NULL,
    area TEXT,
    images TEXT[] DEFAULT '{}',
    amenities TEXT[] DEFAULT '{}',
    average_rating NUMERIC DEFAULT 0.0,
    reviews JSONB DEFAULT '[]',
    rating_breakdown JSONB DEFAULT '{"1": 0, "2": 0, "3": 0, "4": 0, "5": 0}',
    latitude NUMERIC NOT NULL,
    longitude NUMERIC NOT NULL,
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Enable RLS
ALTER TABLE properties ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Properties are viewable by everyone" 
ON properties FOR SELECT 
USING (true);

CREATE POLICY "Users can insert their own properties" 
ON properties FOR INSERT 
WITH CHECK (auth.uid() = owner_id);

CREATE POLICY "Users can update their own properties" 
ON properties FOR UPDATE 
USING (auth.uid() = owner_id);

CREATE POLICY "Users can delete their own properties" 
ON properties FOR DELETE 
USING (auth.uid() = owner_id);
