
import './App.css'
import Home from './Component/Nvabar/Home';
import Login from './Pages/Login/Login';
import Nvar from './Component/Nvabar/Nvar';
import Picture from './Component/Nvabar/Picture';
import { BrowserRouter, Routes, Route } from "react-router-dom";
function App() {

  return (
    <div className="app">
      <BrowserRouter>
        <Routes>
          <Route path="/login" element={<Login />} />
          
          <Route path="/" element={
            <>
              <Nvar />
              <Picture />
            </>
          } />
          <Route path="/home" element={<Home />} />
        </Routes>
      </BrowserRouter>
    </div>
  )
}

export default App
