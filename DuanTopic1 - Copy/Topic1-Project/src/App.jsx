
import './styles/globals.css'
import HomePage from './pages/HomePage';
import Login from './pages/Login';
import MainLayout from './layouts/MainLayout';
import { BrowserRouter, Routes, Route } from "react-router-dom";

function App() {
  return (
    <div className="app">
      <BrowserRouter>
        <Routes>
          <Route path="/login" element={<Login />} />
          
          <Route path="/" element={
            <MainLayout>
              <HomePage />
            </MainLayout>
          } />
          
          <Route path="/home" element={
            <MainLayout>
              <HomePage />
            </MainLayout>
          } />
        </Routes>
      </BrowserRouter>
    </div>
  )
}

export default App
