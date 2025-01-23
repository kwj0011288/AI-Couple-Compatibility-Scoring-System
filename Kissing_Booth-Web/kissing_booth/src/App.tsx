import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import { HelmetProvider } from "react-helmet-async"; // HelmetProvider 추가
import HomePage from "./pages/HomePage"; 
import ResultPage from "./pages/ResultPage";
import NicknamePage from "./pages/NicknamePage";
import RankingPage from "./pages/RankingPage"; 
import RankingTotalPage from "./pages/RankingTotalPage";

function App() {
  return (
    <HelmetProvider>
      <Router>
        <Routes>
          <Route path="/" element={<HomePage />} />
          <Route path="/result" element={<ResultPage />} />
          <Route path="/nickname" element={<NicknamePage />} />
          <Route path="/ranking" element={<RankingPage />} />
          <Route path="/rankingTotal" element={<RankingTotalPage />} />
        </Routes>
      </Router>
    </HelmetProvider>
  );
}

export default App;
