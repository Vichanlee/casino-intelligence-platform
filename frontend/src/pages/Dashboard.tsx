import React from 'react';
import { useQuery } from 'react-query';
import { 
  TrendingUp, 
  Target, 
  Zap, 
  Eye,
  BarChart3,
  Users,
  Clock,
  CheckCircle2
} from 'lucide-react';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer,
         BarChart, Bar, PieChart, Pie, Cell } from 'recharts';
import { MetricCard } from '../components/MetricCard';
import { CompetitorAlert } from '../components/CompetitorAlert';
import { WorkflowStatus } from '../components/WorkflowStatus';

// Mock data for demonstration
const mockAnalytics = {
  totalReviews: 247,
  aiGenerated: 189,
  avgQualityScore: 8.7,
  competitorsMonitored: 52,
  alertsToday: 7,
  keywordsTracked: 1847,
  organicTraffic: 125000,
  contentInQueue: 23
};

const trafficData = [
  { month: 'Jan', organic: 95000, competitors: 87000 },
  { month: 'Feb', organic: 108000, competitors: 89000 },
  { month: 'Mar', organic: 115000, competitors: 91000 },
  { month: 'Apr', organic: 125000, competitors: 88000 },
];

const competitorAlerts = [
  {
    id: 1,
    competitor: 'Casino Guru',
    type: 'New Bonus Content',
    message: 'Added 15 new casino bonus reviews',
    timestamp: '2 hours ago',
    priority: 'high'
  },
  {
    id: 2,
    competitor: 'AskGamblers',
    type: 'Ranking Change',
    message: 'Moved up 3 positions for "best casino"',
    timestamp: '4 hours ago',
    priority: 'medium'
  }
];

const workflowStats = [
  { name: 'Content Generation', status: 'running', completed: 45, total: 50 },
  { name: 'Competitor Monitoring', status: 'completed', completed: 52, total: 52 },
  { name: 'SEO Analysis', status: 'pending', completed: 0, total: 25 }
];

export function Dashboard() {
  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="bg-gradient-to-r from-blue-600 to-purple-600 rounded-lg p-8 text-white">
        <h1 className="text-3xl font-bold mb-2">🎯 Casino Intelligence Platform</h1>
        <p className="text-blue-100 text-lg">
          Real-time competitive intelligence powered by n8n workflow automation
        </p>
        <div className="mt-4 flex items-center space-x-6 text-sm">
          <div className="flex items-center">
            <CheckCircle2 className="w-4 h-4 mr-2" />
            Last update: 3 minutes ago
          </div>
          <div className="flex items-center">
            <Zap className="w-4 h-4 mr-2" />
            95% automation rate
          </div>
        </div>
      </div>

      {/* Key Metrics */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <MetricCard
          title="Total Reviews"
          value={mockAnalytics.totalReviews.toLocaleString()}
          change="+23%"
          icon={<BarChart3 className="w-6 h-6" />}
          trend="up"
        />
        <MetricCard
          title="AI Generated"
          value={`${mockAnalytics.aiGenerated} (${Math.round(mockAnalytics.aiGenerated/mockAnalytics.totalReviews*100)}%)`}
          change="+45%"
          icon={<Zap className="w-6 h-6" />}
          trend="up"
        />
        <MetricCard
          title="Avg Quality Score"
          value={`${mockAnalytics.avgQualityScore}/10`}
          change="+0.3"
          icon={<Target className="w-6 h-6" />}
          trend="up"
        />
        <MetricCard
          title="Organic Traffic"
          value={mockAnalytics.organicTraffic.toLocaleString()}
          change="+18%"
          icon={<TrendingUp className="w-6 h-6" />}
          trend="up"
        />
      </div>
      {/* Charts Row */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Traffic Comparison */}
        <div className="bg-white rounded-lg p-6 shadow-sm">
          <h3 className="text-lg font-semibold mb-4">Traffic vs Competitors</h3>
          <ResponsiveContainer width="100%" height={300}>
            <LineChart data={trafficData}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="month" />
              <YAxis />
              <Tooltip />
              <Line 
                type="monotone" 
                dataKey="organic" 
                stroke="#3B82F6" 
                strokeWidth={3}
                name="Our Traffic"
              />
              <Line 
                type="monotone" 
                dataKey="competitors" 
                stroke="#EF4444" 
                strokeWidth={2}
                strokeDasharray="5 5"
                name="Competitor Avg"
              />
            </LineChart>
          </ResponsiveContainer>
        </div>

        {/* Workflow Status */}
        <div className="bg-white rounded-lg p-6 shadow-sm">
          <h3 className="text-lg font-semibold mb-4">Active Workflows</h3>
          <div className="space-y-4">
            {workflowStats.map((workflow, index) => (
              <div key={index} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                <div className="flex items-center space-x-3">
                  <div className={`w-3 h-3 rounded-full ${
                    workflow.status === 'running' ? 'bg-blue-500 animate-pulse' :
                    workflow.status === 'completed' ? 'bg-green-500' :
                    'bg-gray-400'
                  }`} />
                  <span className="font-medium">{workflow.name}</span>
                </div>
                <div className="text-sm text-gray-600">
                  {workflow.completed}/{workflow.total}
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Alerts and Intelligence */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Competitor Alerts */}
        <div className="lg:col-span-2 bg-white rounded-lg p-6 shadow-sm">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-lg font-semibold">🚨 Competitor Alerts</h3>
            <span className="text-sm text-gray-500">{competitorAlerts.length} active</span>
          </div>
          <div className="space-y-3">
            {competitorAlerts.map((alert) => (
              <div key={alert.id} className={`p-4 rounded-lg border-l-4 ${
                alert.priority === 'high' ? 'border-red-500 bg-red-50' :
                alert.priority === 'medium' ? 'border-yellow-500 bg-yellow-50' :
                'border-blue-500 bg-blue-50'
              }`}>
                <div className="flex justify-between items-start">
                  <div>
                    <h4 className="font-medium">{alert.competitor}</h4>
                    <p className="text-sm text-gray-600 mt-1">{alert.message}</p>
                  </div>
                  <span className="text-xs text-gray-500">{alert.timestamp}</span>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Quick Stats */}
        <div className="bg-white rounded-lg p-6 shadow-sm">
          <h3 className="text-lg font-semibold mb-4">Intelligence Summary</h3>
          <div className="space-y-4">
            <div className="flex justify-between items-center">
              <span className="text-gray-600">Competitors Monitored</span>
              <span className="font-semibold">{mockAnalytics.competitorsMonitored}</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-gray-600">Keywords Tracked</span>
              <span className="font-semibold">{mockAnalytics.keywordsTracked.toLocaleString()}</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-gray-600">Content in Queue</span>
              <span className="font-semibold">{mockAnalytics.contentInQueue}</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-gray-600">Alerts Today</span>
              <span className="font-semibold text-red-600">{mockAnalytics.alertsToday}</span>
            </div>
          </div>
        </div>
      </div>

      {/* ROI Showcase */}
      <div className="bg-gradient-to-r from-green-500 to-emerald-600 rounded-lg p-6 text-white">
        <h3 className="text-xl font-bold mb-4">📈 Automation ROI Impact</h3>
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
          <div className="text-center">
            <div className="text-2xl font-bold">10x</div>
            <div className="text-sm text-green-100">Content Production Speed</div>
          </div>
          <div className="text-center">
            <div className="text-2xl font-bold">95%</div>
            <div className="text-sm text-green-100">Task Automation Rate</div>
          </div>
          <div className="text-center">
            <div className="text-2xl font-bold">30hrs</div>
            <div className="text-sm text-green-100">Weekly Time Savings</div>
          </div>
          <div className="text-center">
            <div className="text-2xl font-bold">400%</div>
            <div className="text-sm text-green-100">Projected 12mo ROI</div>
          </div>
        </div>
      </div>
    </div>
  );
}