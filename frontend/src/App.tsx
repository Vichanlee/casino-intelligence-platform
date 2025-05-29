import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { QueryClient, QueryClientProvider } from 'react-query';
import { Toaster } from 'react-hot-toast';
import { Navbar } from './components/Navbar';
import { Sidebar } from './components/Sidebar';
import { Dashboard } from './pages/Dashboard';
import { CasinoReviews } from './pages/CasinoReviews';
import { CompetitorIntelligence } from './pages/CompetitorIntelligence';
import { SEOAnalytics } from './pages/SEOAnalytics';
import { ContentGeneration } from './pages/ContentGeneration';
import { WorkflowStatus } from './pages/WorkflowStatus';
import './index.css';

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 5 * 60 * 1000, // 5 minutes
      cacheTime: 10 * 60 * 1000, // 10 minutes
    },
  },
});

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <Router>
        <div className="min-h-screen bg-gray-50">
          <Navbar />
          <div className="flex">
            <Sidebar />
            <main className="flex-1 ml-64 p-8">
              <Routes>
                <Route path="/" element={<Dashboard />} />
                <Route path="/reviews" element={<CasinoReviews />} />
                <Route path="/competitors" element={<CompetitorIntelligence />} />
                <Route path="/seo" element={<SEOAnalytics />} />
                <Route path="/content" element={<ContentGeneration />} />
                <Route path="/workflows" element={<WorkflowStatus />} />
              </Routes>
            </main>
          </div>
          <Toaster position="top-right" />
        </div>  
      </Router>
    </QueryClientProvider>
  );
}

export default App;