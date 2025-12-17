import React, { useState } from 'react';

import Login from './services/component/Login';
import ProjectList from './services/component/ProjectList';


const App = () => {
  // Check localStorage for a token on load to determine if the user is authenticated
  const [isAuthenticated, setIsAuthenticated] = useState(!!localStorage.getItem('authToken'));

  // Handler passed to the Login component upon successful login
  const handleLoginSuccess = () => {
    setIsAuthenticated(true);
  };
  
  // Handler passed to the ProjectsList component upon logout or token error
  const handleLogout = () => {
    setIsAuthenticated(false);
  };

  return (
    <div>
      {isAuthenticated ? (
        <ProjectList onLogout={handleLogout} />
      ) : (
        <Login onLoginSuccess={handleLoginSuccess} />
      )}
    </div>
  );
};

export default App;