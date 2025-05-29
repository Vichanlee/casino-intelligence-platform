-- Casino Intelligence Platform Database Schema
-- Optimized for high-performance SEO and competitive intelligence

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
CREATE EXTENSION IF NOT EXISTS "btree_gin";

-- Create main tables

-- Casinos table - Core casino data
CREATE TABLE casinos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    website_url VARCHAR(500) NOT NULL,
    license_authority VARCHAR(255),
    license_number VARCHAR(255),
    established_year INTEGER,
    country VARCHAR(100),
    languages JSONB DEFAULT '[]',
    currencies JSONB DEFAULT '[]',
    payment_methods JSONB DEFAULT '[]',
    game_providers JSONB DEFAULT '[]',
    bonus_data JSONB DEFAULT '{}',
    trust_score DECIMAL(3,2) DEFAULT 0.0,
    affiliate_program VARCHAR(255),
    contact_info JSONB DEFAULT '{}',
    status VARCHAR(50) DEFAULT 'active',
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Reviews table - AI-generated and human-reviewed content
CREATE TABLE reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    casino_id UUID REFERENCES casinos(id) ON DELETE CASCADE,
    title VARCHAR(500) NOT NULL,
    slug VARCHAR(500) UNIQUE NOT NULL,
    content TEXT NOT NULL,
    excerpt VARCHAR(1000),
    meta_description VARCHAR(300),
    meta_keywords TEXT,
    overall_rating DECIMAL(3,2),
    game_variety_rating DECIMAL(3,2),
    bonus_rating DECIMAL(3,2),
    banking_rating DECIMAL(3,2),
    support_rating DECIMAL(3,2),
    mobile_rating DECIMAL(3,2),
    word_count INTEGER,
    readability_score DECIMAL(5,2),
    seo_score DECIMAL(5,2),
    ai_generated BOOLEAN DEFAULT false,
    human_reviewed BOOLEAN DEFAULT false,
    reviewer_name VARCHAR(255),
    reviewer_bio TEXT,
    review_type VARCHAR(50) DEFAULT 'full_review',
    language VARCHAR(10) DEFAULT 'en',
    target_keywords JSONB DEFAULT '[]',
    internal_links JSONB DEFAULT '[]',
    external_links JSONB DEFAULT '[]',
    schema_markup JSONB DEFAULT '{}',
    featured_image VARCHAR(500),
    status VARCHAR(50) DEFAULT 'draft',
    published_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Competitors table - Track competitor sites
CREATE TABLE competitors (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    domain VARCHAR(255) UNIQUE NOT NULL,
    category VARCHAR(100),
    monthly_traffic BIGINT,
    domain_authority INTEGER,
    trust_flow INTEGER,
    citation_flow INTEGER,
    organic_keywords INTEGER,
    paid_keywords INTEGER,
    backlinks_count BIGINT,
    referring_domains INTEGER,
    country VARCHAR(100),
    language VARCHAR(10) DEFAULT 'en',
    last_monitored TIMESTAMP WITH TIME ZONE,
    monitoring_frequency VARCHAR(50) DEFAULT 'daily',
    status VARCHAR(50) DEFAULT 'active',
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Keywords table - SEO keyword tracking
CREATE TABLE keywords (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    keyword VARCHAR(500) NOT NULL,
    search_volume INTEGER DEFAULT 0,
    keyword_difficulty INTEGER DEFAULT 0,
    cpc DECIMAL(8,2) DEFAULT 0.0,
    competition_level VARCHAR(50),
    search_intent VARCHAR(50),
    category VARCHAR(100),
    country VARCHAR(100) DEFAULT 'US',
    language VARCHAR(10) DEFAULT 'en',
    related_keywords JSONB DEFAULT '[]',
    serp_features JSONB DEFAULT '[]',
    opportunity_score DECIMAL(5,2) DEFAULT 0.0,
    target_url VARCHAR(500),
    current_position INTEGER,
    best_position INTEGER,
    worst_position INTEGER,
    last_checked TIMESTAMP WITH TIME ZONE,
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Competitor monitoring table - Historical competitor data
CREATE TABLE competitor_monitoring (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    competitor_id UUID REFERENCES competitors(id) ON DELETE CASCADE,
    check_date DATE NOT NULL,
    content_changes JSONB DEFAULT '{}',
    new_content JSONB DEFAULT '[]',
    removed_content JSONB DEFAULT '[]',
    ranking_changes JSONB DEFAULT '{}',
    backlink_changes JSONB DEFAULT '{}',
    technical_changes JSONB DEFAULT '{}',
    bonus_changes JSONB DEFAULT '{}',
    alert_triggered BOOLEAN DEFAULT false,
    alert_type VARCHAR(100),
    alert_message TEXT,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- SEO metrics table - Track SEO performance over time
CREATE TABLE seo_metrics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    entity_type VARCHAR(50) NOT NULL, -- 'casino', 'review', 'keyword', 'competitor'
    entity_id UUID NOT NULL,
    metric_date DATE NOT NULL,
    organic_traffic INTEGER DEFAULT 0,
    organic_keywords INTEGER DEFAULT 0,
    avg_position DECIMAL(5,2) DEFAULT 0.0,
    click_through_rate DECIMAL(5,4) DEFAULT 0.0,
    impressions BIGINT DEFAULT 0,
    clicks INTEGER DEFAULT 0,
    bounce_rate DECIMAL(5,4) DEFAULT 0.0,
    time_on_page INTEGER DEFAULT 0,
    core_web_vitals JSONB DEFAULT '{}',
    page_speed_score INTEGER DEFAULT 0,
    mobile_usability_score INTEGER DEFAULT 0,
    schema_markup_score INTEGER DEFAULT 0,
    backlinks_count INTEGER DEFAULT 0,
    referring_domains INTEGER DEFAULT 0,
    social_signals JSONB DEFAULT '{}',
    conversions INTEGER DEFAULT 0,
    conversion_rate DECIMAL(5,4) DEFAULT 0.0,
    revenue DECIMAL(10,2) DEFAULT 0.0,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Content queue table - Manage AI content generation pipeline
CREATE TABLE content_queue (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    casino_id UUID REFERENCES casinos(id) ON DELETE CASCADE,
    content_type VARCHAR(100) NOT NULL, -- 'review', 'comparison', 'guide', 'bonus_analysis'
    priority INTEGER DEFAULT 5,
    target_keywords JSONB DEFAULT '[]',
    content_brief TEXT,
    ai_model VARCHAR(100) DEFAULT 'gpt-4',
    generation_status VARCHAR(50) DEFAULT 'pending',
    generated_content TEXT,
    quality_score DECIMAL(5,2),
    compliance_score DECIMAL(5,2),
    seo_score DECIMAL(5,2),
    human_review_required BOOLEAN DEFAULT true,
    reviewer_assigned VARCHAR(255),
    review_notes TEXT,
    retry_count INTEGER DEFAULT 0,
    error_message TEXT,
    scheduled_for TIMESTAMP WITH TIME ZONE,
    started_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    published_at TIMESTAMP WITH TIME ZONE,
    workflow_id VARCHAR(255),
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Workflow logs table - n8n workflow execution tracking
CREATE TABLE workflow_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    workflow_name VARCHAR(255) NOT NULL,
    workflow_id VARCHAR(255),
    execution_id VARCHAR(255),
    status VARCHAR(50) NOT NULL, -- 'running', 'success', 'error', 'cancelled'
    trigger_type VARCHAR(100),
    input_data JSONB DEFAULT '{}',
    output_data JSONB DEFAULT '{}',
    error_message TEXT,
    execution_time_ms INTEGER,
    started_at TIMESTAMP WITH TIME ZONE NOT NULL,
    finished_at TIMESTAMP WITH TIME ZONE,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for optimal performance

-- Casinos indexes
CREATE INDEX idx_casinos_slug ON casinos(slug);
CREATE INDEX idx_casinos_status ON casinos(status);
CREATE INDEX idx_casinos_country ON casinos(country);
CREATE INDEX idx_casinos_trust_score ON casinos(trust_score DESC);
CREATE INDEX idx_casinos_created_at ON casinos(created_at DESC);

-- Reviews indexes
CREATE INDEX idx_reviews_casino_id ON reviews(casino_id);
CREATE INDEX idx_reviews_slug ON reviews(slug);
CREATE INDEX idx_reviews_status ON reviews(status);
CREATE INDEX idx_reviews_published_at ON reviews(published_at DESC);
CREATE INDEX idx_reviews_language ON reviews(language);
CREATE INDEX idx_reviews_overall_rating ON reviews(overall_rating DESC);
CREATE INDEX idx_reviews_ai_generated ON reviews(ai_generated);
CREATE INDEX idx_reviews_target_keywords ON reviews USING GIN(target_keywords);

-- Competitors indexes
CREATE INDEX idx_competitors_domain ON competitors(domain);
CREATE INDEX idx_competitors_category ON competitors(category);
CREATE INDEX idx_competitors_monthly_traffic ON competitors(monthly_traffic DESC);
CREATE INDEX idx_competitors_last_monitored ON competitors(last_monitored DESC);
CREATE INDEX idx_competitors_status ON competitors(status);

-- Keywords indexes
CREATE INDEX idx_keywords_keyword ON keywords(keyword);
CREATE INDEX idx_keywords_search_volume ON keywords(search_volume DESC);
CREATE INDEX idx_keywords_opportunity_score ON keywords(opportunity_score DESC);
CREATE INDEX idx_keywords_category ON keywords(category);
CREATE INDEX idx_keywords_country ON keywords(country);
CREATE INDEX idx_keywords_current_position ON keywords(current_position);
CREATE INDEX idx_keywords_last_checked ON keywords(last_checked DESC);

-- Competitor monitoring indexes
CREATE INDEX idx_competitor_monitoring_competitor_id ON competitor_monitoring(competitor_id);
CREATE INDEX idx_competitor_monitoring_check_date ON competitor_monitoring(check_date DESC);
CREATE INDEX idx_competitor_monitoring_alert_triggered ON competitor_monitoring(alert_triggered);
CREATE UNIQUE INDEX idx_competitor_monitoring_unique ON competitor_monitoring(competitor_id, check_date);

-- SEO metrics indexes
CREATE INDEX idx_seo_metrics_entity ON seo_metrics(entity_type, entity_id);
CREATE INDEX idx_seo_metrics_date ON seo_metrics(metric_date DESC);
CREATE INDEX idx_seo_metrics_organic_traffic ON seo_metrics(organic_traffic DESC);
CREATE UNIQUE INDEX idx_seo_metrics_unique ON seo_metrics(entity_type, entity_id, metric_date);

-- Content queue indexes
CREATE INDEX idx_content_queue_casino_id ON content_queue(casino_id);
CREATE INDEX idx_content_queue_status ON content_queue(generation_status);
CREATE INDEX idx_content_queue_priority ON content_queue(priority DESC);
CREATE INDEX idx_content_queue_scheduled ON content_queue(scheduled_for);
CREATE INDEX idx_content_queue_workflow_id ON content_queue(workflow_id);

-- Workflow logs indexes
CREATE INDEX idx_workflow_logs_workflow_name ON workflow_logs(workflow_name);
CREATE INDEX idx_workflow_logs_status ON workflow_logs(status);
CREATE INDEX idx_workflow_logs_started_at ON workflow_logs(started_at DESC);
CREATE INDEX idx_workflow_logs_execution_id ON workflow_logs(execution_id);

-- Full text search indexes
CREATE INDEX idx_casinos_name_fts ON casinos USING GIN(to_tsvector('english', name));
CREATE INDEX idx_reviews_content_fts ON reviews USING GIN(to_tsvector('english', content));
CREATE INDEX idx_keywords_keyword_fts ON keywords USING GIN(to_tsvector('english', keyword));

-- Functions for automatic timestamp updates
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply updated_at triggers
CREATE TRIGGER update_casinos_updated_at BEFORE UPDATE ON casinos FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_reviews_updated_at BEFORE UPDATE ON reviews FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_competitors_updated_at BEFORE UPDATE ON competitors FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_keywords_updated_at BEFORE UPDATE ON keywords FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_content_queue_updated_at BEFORE UPDATE ON content_queue FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert sample data for demonstration
INSERT INTO casinos (name, slug, website_url, license_authority, license_number, established_year, country, trust_score) VALUES
('Betway Casino', 'betway-casino', 'https://betway.com', 'Malta Gaming Authority', 'MGA/B2C/102/2000', 2006, 'Malta', 8.5),
('888 Casino', '888-casino', 'https://888casino.com', 'UK Gambling Commission', '39575', 1997, 'Gibraltar', 8.8),
('LeoVegas', 'leovegas', 'https://leovegas.com', 'Malta Gaming Authority', 'MGA/B2C/313/2012', 2012, 'Sweden', 9.1),
('Casumo', 'casumo', 'https://casumo.com', 'Malta Gaming Authority', 'MGA/B2C/470/2018', 2012, 'Malta', 8.7),
('Mr Green', 'mr-green', 'https://mrgreen.com', 'Malta Gaming Authority', 'MGA/B2C/188/2010', 2008, 'Malta', 8.9);

INSERT INTO competitors (name, domain, category, monthly_traffic, domain_authority) VALUES
('Casino Guru', 'casino.guru', 'Review Site', 3250000, 68),
('AskGamblers', 'askgamblers.com', 'Review Site', 2100000, 71),
('Mr. Gamble', 'mrgamble.com', 'Review Site', 890000, 58),
('Wizard of Odds', 'wizardofodds.com', 'Strategy Site', 1200000, 74),
('Gambling.com', 'gambling.com', 'Review Site', 1850000, 69);

INSERT INTO keywords (keyword, search_volume, keyword_difficulty, category, opportunity_score) VALUES
('best online casino', 50000, 85, 'General', 7.5),
('casino bonus no deposit', 25000, 78, 'Bonuses', 8.2),
('live dealer casino', 18000, 65, 'Live Games', 9.1),
('mobile casino apps', 12000, 58, 'Mobile', 8.8),
('crypto casino reviews', 8500, 45, 'Cryptocurrency', 9.5);

-- Views for common queries
CREATE VIEW casino_reviews_summary AS
SELECT 
    c.name as casino_name,
    c.slug as casino_slug,
    c.trust_score,
    COUNT(r.id) as review_count,
    AVG(r.overall_rating) as avg_rating,
    MAX(r.published_at) as latest_review_date
FROM casinos c
LEFT JOIN reviews r ON c.id = r.casino_id AND r.status = 'published'
GROUP BY c.id, c.name, c.slug, c.trust_score;

CREATE VIEW competitor_performance AS
SELECT 
    c.name,
    c.domain,
    c.monthly_traffic,
    c.domain_authority,
    COUNT(cm.id) as monitoring_records,
    MAX(cm.check_date) as last_monitored
FROM competitors c
LEFT JOIN competitor_monitoring cm ON c.id = cm.competitor_id
GROUP BY c.id, c.name, c.domain, c.monthly_traffic, c.domain_authority;

CREATE VIEW content_generation_stats AS
SELECT 
    content_type,
    generation_status,
    COUNT(*) as count,
    AVG(quality_score) as avg_quality_score,
    AVG(seo_score) as avg_seo_score
FROM content_queue
GROUP BY content_type, generation_status;

-- Grant permissions (adjust as needed for your security requirements)
-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO casino_user;
-- GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO casino_user;
-- GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO casino_user;

COMMIT;