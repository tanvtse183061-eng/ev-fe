
import './App.css'
import Home from './Component/Nvabar/Home';
import Login from './Pages/Login/Login';
import Nvar from './Component/Nvabar/Nvar';
import Picture from './Component/Nvabar/picture';
import { BrowserRouter, Routes, Route } from "react-router-dom";
function App() {

  return (
    <>

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


    </>
  )
}

export default App
