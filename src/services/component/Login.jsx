import React, { useState } from 'react';
// CORRECTED PATH: ../api (Moves up from 'component' to 'services' folder)
import { loginUser } from '../api'; 

const Login = ({ onLoginSuccess }) => {
// ... (rest of the Login component code is unchanged)
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState(null);
  
  const handleSubmit = async (e) => {
    e.preventDefault();
    setError(null);
    try {
      await loginUser(email, password);
      onLoginSuccess(); 
    } catch (err) {
      setError(err.message || 'Login failed. Check server status.');
    }
  };

  return (
    <form onSubmit={handleSubmit} style={{ margin: '50px', padding: '20px', border: '1px solid #ccc', maxWidth: '400px' }}>
      <h2>Project Manager Login</h2>
      {error && <p style={{ color: 'red' }}>{error}</p>}
      
      <div style={{ marginBottom: '10px' }}>
        <label style={{ display: 'block' }}>Email:</label>
        <input 
          type="email" 
          value={email} 
          onChange={(e) => setEmail(e.target.value)} 
          required 
        />
      </div>
      
      <div style={{ marginBottom: '20px' }}>
        <label style={{ display: 'block' }}>Password:</label>
        <input 
          type="password" 
          value={password} 
          onChange={(e) => setPassword(e.target.value)} 
          required 
        />
      </div>
      
      <button type="submit">Log In</button>
    </form>
  );
};

export default Login;